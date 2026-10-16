package com.jsxposed.xmod.core.utils.shell

import android.annotation.SuppressLint
import com.jsxposed.xmod.core.utils.log.LogX
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.io.InputStream
import java.io.OutputStream

/**
 * 标准化 Shell 工具类
 * 所有操作统一通过 execute 执行，确保命令拼接规范一致
 */
class Shell(private val su: Boolean = false) {

    companion object {
        private const val TAG = "Shell"
    }

    /**
     * 唯一标准化执行器
     * 内部处理 su/sh 逻辑，并确保输出流/错误流被正确读取和关闭
     */
    fun execute(command: String): String {
        val finalExecArray = if (su) {
            arrayOf("su", "-c", command)
        } else {
            arrayOf("sh", "-c", command)
        }

        return try {
            val process = Runtime.getRuntime().exec(finalExecArray)

            // 使用 use 确保流正确关闭，防止内存泄漏
            val output = process.inputStream.use { it.bufferedReader().readText() }
            val error = process.errorStream.use { it.bufferedReader().readText() }

            val exitCode = process.waitFor()

            if (exitCode != 0) {
                // 如果报错，返回错误信息以便调试
                val errorMsg = error.trim()
                LogX.e(TAG, "Shell execute ERROR($exitCode): $errorMsg | Command: $command")
                if (errorMsg.isNotEmpty()) "ERROR($exitCode): $errorMsg" else "ERROR($exitCode)"
            } else {
                output.trim()
            }
        } catch (e: Exception) {
            LogX.e(TAG, "Shell exec exception: ${e.message}")
            "EXCEPTION: ${e.message}"
        }
    }

    /**
     * 标准写入：使用 cat 配合重定向，支持多行和大数据量内容
     */
    fun write(content: String, path: String) = write(content, path, append = false)

    /**
     * 标准追加：使用 cat 配合重定向追加内容，规避 echo 转义问题
     */
    fun append(content: String, path: String) = write(content, path, append = true)

    private fun write(content: String, path: String, append: Boolean): Boolean {
        try {
            val redirect = if (append) ">>" else ">"
            val execArray = if (su) arrayOf("su", "-c", "cat $redirect '$path'") else arrayOf(
                "sh",
                "-c",
                "cat $redirect '$path'"
            )
            val process = Runtime.getRuntime().exec(execArray)

            process.outputStream.bufferedWriter().use { writer ->
                writer.write(content)
                writer.flush()
            }

            val exitCode = process.waitFor()
            if (exitCode != 0) {
                LogX.e(TAG, "Write/Append failed to $path, exitCode: $exitCode")
                return false
            }
            // 强制刷新文件系统缓冲区
            if (su) Runtime.getRuntime().exec(arrayOf("su", "-c", "sync"))
            return true
        } catch (e: Exception) {
            LogX.e(TAG, "Write/Append error: $e")
            return false
        }
    }

    /**
     * 接管输入流写入文件：利用 Root 权限写入受限目录
     */
    fun takeStream(input: InputStream, path: String) {
        try {
            val execArray = if (su) arrayOf("su", "-c", "cat > '$path'") else arrayOf(
                "sh",
                "-c",
                "cat > '$path'"
            )
            val process = Runtime.getRuntime().exec(execArray)
            process.outputStream.use { output ->
                input.copyTo(output)
                output.flush()
            }
            val exitCode = process.waitFor()
            if (exitCode != 0) LogX.e(TAG, "takeStream failed to $path, exitCode: $exitCode")
        } catch (e: Exception) {
            LogX.e(TAG, "takeStream error: $e")
        }
    }

    fun readBytes(path: String): ByteArray? {
        val finalExecArray = if (su) {
            arrayOf("su", "-c", "cat '$path'")
        } else {
            arrayOf("sh", "-c", "cat '$path'")
        }

        return try {
            val process = Runtime.getRuntime().exec(finalExecArray)
            val bytes = process.inputStream.readBytes()
            // 消费 errorStream，防止 buffer 满时进程挂起
            process.errorStream.close()
            val exitCode = process.waitFor()
            if (exitCode == 0) bytes else {
                LogX.e(TAG, "readBytes failed for $path, exitCode: $exitCode")
                null
            }
        } catch (e: Exception) {
            LogX.e(TAG, "Shell readBytes exception: ${e.message}")
            null
        }
    }

    // --- 以下所有操作均标准化调用 execute ---

    fun read(path: String): String = execute("cat '$path'")

    fun remove(path: String) = execute("rm -rf '$path'")

    fun copy(src: String, dst: String) = execute("cp -r '$src' '$dst'")

    fun move(src: String, dst: String) = execute("mv '$src' '$dst'")

    fun mkdir(path: String) = execute("mkdir -p '$path'")


    /**
     * 解压文件
     * @param zipPath ZIP文件路径 (例如 base.apk)
     * @param destPath 目标目录
     * @param entryName 指定要解压的文件名 (可选)
     */
    fun unzip(zipPath: String, destPath: String, entryName: String? = null): String {
        return if (entryName != null) {
            execute("unzip -o -d '$destPath' '$zipPath' '$entryName'")
        } else {
            execute("unzip -o -d '$destPath' '$zipPath'")
        }
    }

    fun getFileList(path: String): List<String> {
        val result = execute("ls '$path'")
        if (result.isEmpty() || result.startsWith("ERROR")) return emptyList()

        return result.split("\n")
            .filter { it.isNotBlank() }
            .map { if (path.endsWith("/")) "$path$it" else "$path/$it" }
    }

    fun isFolder(path: String): Boolean {
        return execute("[ -d '$path' ] && echo true").trim() == "true"
    }

    fun isFile(path: String): Boolean {
        return execute("[ -f '$path' ] && echo true").trim() == "true"
    }

    fun getRawTree(path: String): String {
        return execute("find '$path' -type d -o -type f")
    }

    /**
     * 将指定的 XML 文件解析为 Map
     * 利用反射调用系统隐藏类 com.android.internal.util.XmlUtils
     * 适用于 Root 权限下直接读取其他应用的 SharedPreferences XML
     */
    @SuppressLint("PrivateApi")
    fun readXmlAsMap(path: String): Map<String, *> {
        return try {
            // 1. 获取字节流
            val bytes = readBytes(path)
            if (bytes == null) {
                LogX.e(TAG, "readXmlAsMap: readBytes returned null for $path")
                return emptyMap<String, Any>()
            }
            val inputStream: InputStream = ByteArrayInputStream(bytes)

            // 2. 反射调用 XmlUtils.readMapXml
            val xmlUtilsClass = Class.forName("com.android.internal.util.XmlUtils")
            val readMapXmlMethod = xmlUtilsClass.getMethod("readMapXml", InputStream::class.java)

            @Suppress("UNCHECKED_CAST")
            val result = (readMapXmlMethod.invoke(null, inputStream) as? Map<String, *>)
                ?: emptyMap<String, Any>()
            result
        } catch (e: Exception) {
            LogX.e(TAG, "readXmlAsMap error for $path: ${e.message}")
            emptyMap<String, Any>()
        }
    }

    /**
     * 将 Map 写入指定的 XML 文件（标准 SharedPreferences 格式）
     * 利用反射调用系统隐藏类 com.android.internal.util.XmlUtils
     */
    @SuppressLint("PrivateApi")
    fun writeMapAsXml(path: String, map: Map<String, *>) {
        try {
            val xmlUtilsClass = Class.forName("com.android.internal.util.XmlUtils")
            val writeMapXmlMethod =
                xmlUtilsClass.getMethod("writeMapXml", Map::class.java, OutputStream::class.java)

            val bos = ByteArrayOutputStream()
            writeMapXmlMethod.invoke(null, map, bos)
            val content = bos.toString("UTF-8")

            write(content, path)
        } catch (e: Exception) {
            LogX.e(TAG, "writeMapAsXml error for $path: ${e.message}")
        }
    }
}