package com.pocket.server.env

import android.content.Context
import android.os.Build
import androidx.lifecycle.MutableLiveData
import com.pocket.server.util.Prefs
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.Request
import java.io.File
import java.util.concurrent.TimeUnit

class EnvironmentManager private constructor() {

    enum class State { NOT_INSTALLED, INSTALLING, READY, RUNNING }

    val state = MutableLiveData(State.NOT_INSTALLED)
    val log = MutableLiveData("")
    val progress = MutableLiveData<Pair<Int, String>?>(null)

    private val client = OkHttpClient.Builder()
        .connectTimeout(30, TimeUnit.SECONDS)
        .readTimeout(120, TimeUnit.SECONDS)
        .build()

    companion object {
        @Volatile private var instance: EnvironmentManager? = null
        fun get(): EnvironmentManager =
            instance ?: synchronized(this) { instance ?: EnvironmentManager().also { instance = it } }

        val ALPINE_MIRRORS = listOf(
            "https://dl-cdn.alpinelinux.org/alpine",
            "https://mirrors.tuna.tsinghua.edu.cn/alpine",
            "https://mirrors.ustc.edu.cn/alpine"
        )
    }

    fun rootfsDir(ctx: Context) = File(ctx.filesDir, "rootfs")
    fun workspaceDir(ctx: Context) = File(ctx.filesDir, "workspace").apply { mkdirs() }
    fun serverDataDir(ctx: Context) = File(ctx.filesDir, "serverdata").apply { mkdirs() }
    fun builtinDir(ctx: Context) = File(ctx.filesDir, "builtin").apply { mkdirs() }
    fun toolsDir(ctx: Context) = File(ctx.filesDir, "tools").apply { mkdirs() }
    fun tmpDir(ctx: Context) = File(ctx.filesDir, "tmp").apply { mkdirs() }
    fun apkDir(ctx: Context) = File(workspaceDir(ctx), "apk_analysis").apply { mkdirs() }
    fun onlinePackDir(ctx: Context) = File(workspaceDir(ctx), "onlinepack").apply { mkdirs() }
    fun serverPackDir(ctx: Context) = File(workspaceDir(ctx), "serverpack").apply { mkdirs() }
    fun outputDir(ctx: Context) = File(workspaceDir(ctx), "output").apply { mkdirs() }

    fun prootBin(ctx: Context): File = File(ctx.applicationInfo.nativeLibraryDir, "libproot.so")

    fun isInstalled(ctx: Context): Boolean =
        File(rootfsDir(ctx), "bin/busybox").exists() && prootBin(ctx).exists()

    fun alpineVersion(ctx: Context): String = Prefs.getStr(ctx, "alpine_version", "3.20")

    fun appendLog(ctx: Context, line: String) {
        val cur = log.value ?: ""
        val next = (cur + line + "\n").split("\n").takeLast(500).joinToString("\n")
        log.postValue(next)
    }

    fun refreshState(ctx: Context) {
        if (state.value == State.INSTALLING) return
        state.postValue(if (ServerManager.get().isRunning()) State.RUNNING else if (isInstalled(ctx)) State.READY else State.NOT_INSTALLED)
    }

    fun arch(): String = when (Build.SUPPORTED_ABIS.firstOrNull()) {
        "arm64-v8a" -> "aarch64"
        "armeabi-v7a" -> "armhf"
        "x86_64" -> "x86_64"
        else -> "x86"
    }

    suspend fun install(ctx: Context): Unit = withContext(Dispatchers.IO) {
        state.postValue(State.INSTALLING)
        try {
            if (!prootBin(ctx).exists()) throw IllegalStateException("内置 proot 缺失，请重新安装应用")
            val arch = arch()
            appendLog(ctx, "[install] 设备架构: $arch")
            val rootfs = rootfsDir(ctx)
            val tarFile = File(tmpDir(ctx), "rootfs.tar.gz")

            var downloaded = false
            outer@ for (mirror in ALPINE_MIRRORS) {
                for (version in listOf("3.20.3", "3.19.4")) {
                    val branch = version.substringBeforeLast('.')
                    val url = "$mirror/v$branch/releases/$arch/alpine-minirootfs-$version-$arch.tar.gz"
                    try {
                        appendLog(ctx, "[install] 下载 Alpine 根文件系统: $url")
                        downloadWithProgress(ctx, url, tarFile)
                        appendLog(ctx, "[install] 解压根文件系统…")
                        rootfs.mkdirs()
                        val p = ProcessBuilder("tar", "-xzf", tarFile.absolutePath, "-C", rootfs.absolutePath)
                            .redirectErrorStream(true).start()
                        val out = p.inputStream.bufferedReader().readText()
                        p.waitFor()
                        if (!File(rootfs, "bin/busybox").exists()) {
                            throw IllegalStateException("解压失败: ${out.take(300)}")
                        }
                        Prefs.putStr(ctx, "alpine_version", branch)
                        downloaded = true
                        break@outer
                    } catch (e: Exception) {
                        appendLog(ctx, "[install] 源失败: ${e.message}，尝试下一个…")
                    }
                }
            }
            if (!downloaded) throw IllegalStateException("所有镜像下载失败，请检查网络后重试")
            tarFile.delete()

            File(rootfs, "etc/resolv.conf").writeText("nameserver 223.5.5.5\nnameserver 8.8.8.8\n")
            val branch = alpineVersion(ctx)
            File(rootfs, "etc/apk/repositories").writeText(
                "https://dl-cdn.alpinelinux.org/alpine/v$branch/main\n" +
                "https://dl-cdn.alpinelinux.org/alpine/v$branch/community\n"
            )

            progress.postValue(Pair(70, "安装基础依赖 python3 / bash / curl …"))
            appendLog(ctx, "[install] 安装基础依赖（python3 bash curl）…")
            runCapture(
                ctx,
                "apk update && apk add --no-cache python3 bash curl tar gzip unzip zip",
                streamLog = { appendLog(ctx, it) }
            )

            progress.postValue(Pair(95, "完成"))
            appendLog(ctx, "[install] 环境安装完成")
            state.postValue(State.READY)
            progress.postValue(null)
        } catch (e: Exception) {
            appendLog(ctx, "[install] 失败: ${e.message}")
            state.postValue(if (isInstalled(ctx)) State.READY else State.NOT_INSTALLED)
            progress.postValue(null)
            throw e
        }
    }

    private fun downloadWithProgress(ctx: Context, url: String, dest: File) {
        val req = Request.Builder().url(url).build()
        client.newCall(req).execute().use { resp ->
            if (!resp.isSuccessful) throw IllegalStateException("HTTP ${resp.code}")
            val body = resp.body ?: throw IllegalStateException("空响应")
            val total = body.contentLength()
            dest.outputStream().use { out ->
                val buf = ByteArray(64 * 1024)
                var read = 0L
                while (true) {
                    val n = body.byteStream().read(buf)
                    if (n <= 0) break
                    out.write(buf, 0, n)
                    read += n
                    if (total > 0) {
                        val pct = (read * 60 / total).toInt()
                        progress.postValue(Pair(pct, "下载中 ${(read / 1048576)}MB / ${(total / 1048576)}MB"))
                    }
                }
            }
        }
    }

    fun buildProotCmd(
        ctx: Context,
        command: String,
        workdir: String = "/root",
        extraBinds: List<Pair<String, String>> = emptyList()
    ): List<String> {
        val rootfs = rootfsDir(ctx).absolutePath
        val args = mutableListOf(
            prootBin(ctx).absolutePath,
            "--kill-on-exit",
            "-0",
            "-r", rootfs,
            "-b", "/dev",
            "-b", "/proc",
            "-b", "/sys",
            "-b", "${ctx.getExternalFilesDir(null)?.absolutePath}:/sdcard",
            "-b", "${workspaceDir(ctx).absolutePath}:/root/workspace",
            "-b", "${serverDataDir(ctx).absolutePath}:/srv/data",
            "-b", "${builtinDir(ctx).absolutePath}:/srv/builtin",
            "-b", "${toolsDir(ctx).absolutePath}:/srv/tools"
        )
        for ((host, guest) in extraBinds) args += listOf("-b", "$host:$guest")
        args += listOf("-w", workdir, "/bin/sh", "-c", command)
        return args
    }

    private fun processEnv(pb: ProcessBuilder, ctx: Context) {
        val env = pb.environment()
        val libDir = ctx.applicationInfo.nativeLibraryDir
        env["PROOT_TMP_DIR"] = tmpDir(ctx).absolutePath
        env["PROOT_NO_SECCOMP"] = "1"
        env["PROOT_LOADER"] = File(libDir, "libproot_loader.so").absolutePath
        val loader32 = File(libDir, "libproot_loader32.so")
        if (loader32.exists()) env["PROOT_LOADER32"] = loader32.absolutePath
        env["PATH"] = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
        env["HOME"] = "/root"
        env["TERM"] = "xterm-256color"
        env["LANG"] = "C.UTF-8"
    }

    suspend fun runCapture(
        ctx: Context,
        command: String,
        workdir: String = "/root",
        extraBinds: List<Pair<String, String>> = emptyList(),
        streamLog: ((String) -> Unit)? = null
    ): String = withContext(Dispatchers.IO) {
        val pb = ProcessBuilder(buildProotCmd(ctx, command, workdir, extraBinds))
            .redirectErrorStream(true)
        processEnv(pb, ctx)
        val p = pb.start()
        val sb = StringBuilder()
        p.inputStream.bufferedReader().use { r ->
            while (true) {
                val line = r.readLine() ?: break
                sb.appendLine(line)
                streamLog?.invoke(line)
            }
        }
        val code = p.waitFor()
        if (code != 0) throw IllegalStateException("命令退出码 $code: ${sb.toString().take(400)}")
        sb.toString()
    }

    fun runDetached(
        ctx: Context,
        command: String,
        workdir: String = "/root",
        extraBinds: List<Pair<String, String>> = emptyList(),
        onLine: ((String) -> Unit)? = null
    ): Process {
        val pb = ProcessBuilder(buildProotCmd(ctx, command, workdir, extraBinds))
            .redirectErrorStream(true)
        processEnv(pb, ctx)
        val p = pb.start()
        Thread {
            try {
                p.inputStream.bufferedReader().use { r ->
                    while (true) {
                        val line = r.readLine() ?: break
                        onLine?.invoke(line)
                    }
                }
            } catch (_: Exception) { }
        }.start()
        return p
    }
}
