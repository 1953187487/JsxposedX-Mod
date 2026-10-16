package com.jsxposed.xmod.core.bridge.project_native

import com.jsxposed.xmod.core.constants.PathConstant
import com.jsxposed.xmod.feature.frida.FridaInjector
import com.jsxposed.xmod.core.utils.shell.Shell
import com.jsxposed.xmod.core.bridge.app_native.App
import com.jsxposed.xmod.core.models.Encrypt
import com.google.gson.Gson
import android.content.Context
import android.os.Build
import android.util.Base64
import java.io.ByteArrayInputStream
import org.json.JSONObject
import android.util.Log
import androidx.annotation.RequiresApi
import java.io.File
import java.util.Locale
import java.text.SimpleDateFormat
import java.util.Date

class Project(private val context: Context) {

    private val shell = Shell(su = true)
    private val app = App(context)
    private val gson = Gson()

    fun initProject() {
        if (!shell.isFolder(PathConstant.PROJECT_DIR_PATH)) {
            shell.apply {
                mkdir(PathConstant.PROJECT_DIR_PATH)//创建项目根目录文件夹
                mkdir(PathConstant.CONFIG_DIR_PATH)//创建配置文件夹
                mkdir("${PathConstant.TMP_PATH}/JsxposedX")//创建Frida文件夹
            }
        }

    }

    fun projectExists(packageName: String): Boolean {
        return shell.isFolder("${PathConstant.PROJECT_DIR_PATH}/${packageName}")
    }

    fun getProjects(): List<AppInfo> {
        val projects = mutableListOf<AppInfo>()
        val projectDir = File(PathConstant.PROJECT_DIR_PATH)
        if (!projectDir.exists() || !projectDir.isDirectory) return projects

        for (folder in projectDir.listFiles() ?: emptyArray()) {
            if (!folder.isDirectory) continue
            val appJsonFile = File(folder, "app.json")
            if (!appJsonFile.exists()) continue
            try {
                val json = JSONObject(appJsonFile.readText())
                val iconFile = File(folder, "icon.png")
                val iconBytes = if (iconFile.exists()) iconFile.readBytes() else null
                projects.add(
                    AppInfo(
                        name = json.getString("name"),
                        packageName = json.getString("packageName"),
                        versionName = json.getString("versionName"),
                        versionCode = json.getLong("versionCode"),
                        isSystemApp = json.getBoolean("isSystemApp"),
                        icon = iconBytes
                    )
                )
            } catch (e: Exception) {
                Log.e("Project", "Failed to parse ${appJsonFile.path}: ${e.message}")
            }
        }
        return projects
    }

    fun createProject(packageName: String) {
        if (!projectExists(packageName)) {
            shell.apply {
                mkdir("${PathConstant.PROJECT_DIR_PATH}/${packageName}")//创建项目文件夹
                mkdir(PathConstant.jsProjectDirPath(packageName = packageName))//创建JS项目文件夹
                mkdir(PathConstant.fridaProjectDirPath(packageName = packageName))//创建Frida项目文件夹
                mkdir(PathConstant.logDirPath(packageName = packageName) + "/crypto")//创建日志文件夹
            }

            // 写入 app.json 持久化元数据
            val app = app.getAppByPackageName(packageName)
            if (app != null) {
                val json = """
                    {
                        "name": "${app.name}",
                        "packageName": "${app.packageName}",
                        "versionName": "${app.versionName}",
                        "versionCode": ${app.versionCode},
                        "isSystemApp": ${app.isSystemApp}
                    }
                """.trimIndent()
                shell.write(json, "${PathConstant.PROJECT_DIR_PATH}/${packageName}/app.json")
            }

            // 写入 icon.png 持久化图标
            if (app?.icon != null) {
                shell.takeStream(
                    ByteArrayInputStream(app.icon),
                    "${PathConstant.PROJECT_DIR_PATH}/${packageName}/icon.png"
                )
            }
        }
    }

    fun deleteProject(packageName: String) {
        if (projectExists(packageName)) {
            shell.apply {
                remove("${PathConstant.PROJECT_DIR_PATH}/${packageName}")
                remove(PathConstant.fridaProjectDirPath(packageName = packageName))
            }
        }
    }

    fun getFridaScripts(packageName: String): List<String> {
        return filterFridaScripts(
            shell.getFileList(PathConstant.fridaProjectDirPath(packageName = packageName))
        )
    }

    fun createFridaScript(
        packageName: String,
        content: String,
        localPath: String,
        append: Boolean
    ) {
        shell.apply {
            if (!append) {
                write(
                    path = PathConstant.fridaProjectDirPath(packageName = packageName) + "/" + localPath,
                    content = content,
                )
            } else {
                append(
                    path = PathConstant.fridaProjectDirPath(packageName = packageName) + "/" + localPath,
                    content = content,
                )
            }
        }

    }

    fun readFridaScript(packageName: String, localPath: String): String {
        return shell.read(PathConstant.fridaProjectDirPath(packageName = packageName) + "/" + localPath)
    }

    fun deleteFridaScript(packageName: String, localPath: String) {
        shell.apply {
            remove(PathConstant.fridaProjectDirPath(packageName = packageName) + "/" + localPath)
        }
    }

    fun importFridaScripts(packageName: String, localPaths: List<String>) {
        for (localPath in localPaths)
            shell.apply {
                copy(
                    src = localPath,
                    dst = PathConstant.fridaProjectDirPath(packageName = packageName)
                )
            }
    }

    fun bundleFridaHookJs(packageName: String) {
        FridaInjector(context, shell).buildHookScript(packageName)
    }


    fun getJsScripts(packageName: String): List<String> {
        return shell.getFileList(PathConstant.jsProjectDirPath(packageName = packageName))
    }


    fun createJsScript(packageName: String, content: String, localPath: String, append: Boolean) {
        shell.apply {
            if (!append) {
                write(
                    path = PathConstant.jsProjectDirPath(packageName = packageName) + "/" + localPath,
                    content = content,
                )
            } else {
                append(
                    path = PathConstant.jsProjectDirPath(packageName = packageName) + "/" + localPath,
                    content = content,
                )
            }
        }
    }

    fun readJsScript(packageName: String, localPath: String): String {
        return shell.read(PathConstant.jsProjectDirPath(packageName = packageName) + "/" + localPath)
    }

    fun deleteJsScript(packageName: String, localPath: String) {
        shell.apply {
            remove(PathConstant.jsProjectDirPath(packageName = packageName) + "/" + localPath)
        }
    }

    fun importJsScripts(packageName: String, localPaths: List<String>) {
        for (localPath in localPaths)
            shell.apply {
                copy(
                    src = localPath,
                    dst = PathConstant.jsProjectDirPath(packageName = packageName)
                )
            }
    }

    /**
     * 获取历史审计日志 (分页模式) - 支持关键字过滤与多格式预计算
     * @param packageName 目标包名
     * @param limit 获取数量
     * @param offset 偏移量
     * @param keyword 搜索关键字 (可选)
     */
    fun getAuditLogs(
        packageName: String,
        limit: Long,
        offset: Long,
        keyword: String? = null
    ): List<Encrypt> {
        val result = mutableListOf<Encrypt>()
        val logDir = PathConstant.logDirPath(packageName) + "/crypto"

        // 1. 获取所有日志文件并按名称(日期)倒序排序
        val logFiles = shell.getFileList(logDir)
            .filter { it.endsWith(".log") && it.contains("audit_") }
            .sortedDescending()

        if (logFiles.isEmpty()) return result

        var skipped = 0L
        var collected = 0L
        val searchWord = keyword?.takeIf { it.isNotBlank() }?.lowercase()

        // 2. 逐个文件读取并解析
        for (logPath in logFiles) {
            val content = shell.read(logPath)
            if (content.isEmpty() || content.startsWith("ERROR")) continue

            val lines = content.lines().asReversed()

            for (line in lines) {
                if (line.isBlank()) continue

                // 搜索过滤：对原始 JSON 行进行不区分大小写的全匹配
                if (searchWord != null && !line.lowercase().contains(searchWord)) {
                    continue
                }

                // 处理 offset
                if (skipped < offset) {
                    skipped++
                    continue
                }

                try {
                    val json = JSONObject(line)
                    val op = json.opt("operation")
                    if (op is String) {
                        json.put(
                            "operation", when (op.uppercase()) {
                                "ENCRYPT" -> 1
                                "DECRYPT" -> 2
                                else -> 0
                            }
                        )
                    }
                    val entry = gson.fromJson(json.toString(), Encrypt::class.java)
                    result.add(entry)
                    collected++

                    if (collected >= limit) return result
                } catch (e: Exception) {
                    Log.e("Project", "Failed to parse log line from $logPath: ${e.message}")
                }
            }
        }

        return result
    }

    /**
     * 删除单条审计日志
     * @param packageName 目标包名
     * @param timestamp 唯一标识(时间戳)
     */
    fun deleteAuditLog(packageName: String, timestamp: Long) {
        val today = SimpleDateFormat("yyyyMMdd", Locale.getDefault()).format(Date(timestamp))
        val logPath = "${PathConstant.logDirPath(packageName)}/crypto/audit_$today.log"

        val content = shell.read(logPath)
        if (content.isEmpty() || content.startsWith("ERROR")) return

        val newLines = content.lines().filter { line ->
            if (line.isBlank()) return@filter false
            try {
                val obj = JSONObject(line)
                obj.optLong("timestamp") != timestamp
            } catch (e: Exception) {
                true // 无法解析的行保留，不误删
            }
        }

        shell.write(newLines.joinToString("\n"), logPath)
        shell.execute("chmod 777 $logPath")
    }

    /**
     * 修改单条审计日志 (例如修改备注或处理状态)
     * 这里为了通用性，直接传入修改后的完整 Encrypt 对象
     */
    fun updateAuditLog(packageName: String, updatedLog: Encrypt) {
        val today =
            SimpleDateFormat("yyyyMMdd", Locale.getDefault()).format(Date(updatedLog.timestamp))
        val logPath = "${PathConstant.logDirPath(packageName)}/crypto/audit_$today.log"

        val content = shell.read(logPath)
        if (content.isEmpty() || content.startsWith("ERROR")) return

        val newLines = content.lines().map { line ->
            if (line.isBlank()) return@map line
            try {
                val obj = JSONObject(line)
                if (obj.optLong("timestamp") == updatedLog.timestamp) {
                    gson.toJson(updatedLog)
                } else {
                    line
                }
            } catch (e: Exception) {
                line
            }
        }

        shell.write(newLines.joinToString("\n"), logPath)
        shell.execute("chmod 777 $logPath")
    }

    /**
     * 清空所有审计日志
     */
    fun clearAuditLogs(packageName: String) {
        val logDir = "${PathConstant.logDirPath(packageName)}/crypto"
        shell.remove(logDir)
        shell.mkdir(logDir)
    }

    // --- 辅助转换工具 ---

    companion object {
        // 提取公共的脚本过滤逻辑
        fun filterFridaScripts(scripts: List<String>): List<String> {
            return scripts.filter {
                !it.endsWith("/hook.js") && !it.endsWith("hook.js") &&
                !it.endsWith("/loader.js") && !it.endsWith("loader.js")
            }
        }

        private fun hexToBytes(hex: String): ByteArray {
            val s = hex.removePrefix("0x").removePrefix("0X")
            if (s.isEmpty()) return byteArrayOf()
            val len = s.length
            val data = ByteArray(len / 2)
            var i = 0
            while (i < len) {
                data[i / 2] =
                    ((Character.digit(s[i], 16) shl 4) + Character.digit(s[i + 1], 16)).toByte()
                i += 2
            }
            return data
        }

        @RequiresApi(Build.VERSION_CODES.FROYO)
        fun hexToBase64(hex: String?): String {
            if (hex.isNullOrBlank()) return ""
            return try {
                Base64.encodeToString(hexToBytes(hex), Base64.NO_WRAP)
            } catch (e: Exception) {
                ""
            }
        }

        fun hexToPlaintext(hex: String?): String {
            if (hex.isNullOrBlank()) return ""
            return try {
                String(hexToBytes(hex), Charsets.UTF_8)
            } catch (e: Exception) {
                ""
            }
        }
    }
}
