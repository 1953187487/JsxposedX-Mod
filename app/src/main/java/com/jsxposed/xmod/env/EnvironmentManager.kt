package com.jsxposed.xmod.env

import android.content.Context
import android.os.Build
import androidx.lifecycle.MutableLiveData
import com.jsxposed.xmod.util.Prefs
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.Request
import java.io.File
import java.security.MessageDigest
import java.util.concurrent.TimeUnit

class EnvironmentManager private constructor() {

    enum class State { NOT_INSTALLED, INSTALLING, READY, RUNNING }

    val state = MutableLiveData(State.NOT_INSTALLED)
    val log = MutableLiveData("")
    val progress = MutableLiveData<Pair<Int, String>?>(null)

    private val client = OkHttpClient.Builder()
        .connectTimeout(30, TimeUnit.SECONDS)
        .readTimeout(300, TimeUnit.SECONDS)
        .followRedirects(true)
        .build()

    companion object {
        @Volatile private var instance: EnvironmentManager? = null
        fun get(): EnvironmentManager =
            instance ?: synchronized(this) { instance ?: EnvironmentManager().also { instance = it } }

        // 每个条目: (baseUrl, 名称)。baseUrl 必须能直接拼 /v3.21/releases/<arch>/alpine-minirootfs-...tar.gz
        val ALPINE_MIRRORS = listOf(
            "https://mirrors.aliyun.com/alpine" to "阿里云",
            "https://mirrors.tuna.tsinghua.edu.cn/alpine" to "清华 TUNA",
            "https://mirrors.huaweicloud.com/alpine" to "华为云",
            "https://mirrors.cernet.edu.cn/alpine" to "CERNET",
            "https://mirrors.bfsu.edu.cn/alpine" to "北外",
            "https://mirror.clarkson.edu/alpine" to "Clarkson",
            "https://dl-cdn.alpinelinux.org/alpine" to "Alpine 官方 CDN"
        )

        val ALPINE_VERSIONS = listOf("3.21.8", "3.20.9", "3.19.9")
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

    fun alpineVersion(ctx: Context): String = Prefs.getStr(ctx, "alpine_version", "3.21")

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

    /** 测试单个镜像是否能拿到当前架构的最新 minirootfs，返回 true/false */
    suspend fun testMirror(ctx: Context, mirror: String): Boolean = withContext(Dispatchers.IO) {
        val arch = arch()
        val v = ALPINE_VERSIONS.first()
        val branch = v.substringBeforeLast('.')
        val url = "$mirror/v$branch/releases/$arch/alpine-minirootfs-$v-$arch.tar.gz"
        try {
            val r = client.newCall(Request.Builder().url(url).head().build()).execute()
            r.use {
                if (!it.isSuccessful) { appendLog(ctx, "[mirror] ${mirror} 不可用 (HTTP ${it.code})"); false }
                else { appendLog(ctx, "[mirror] ${mirror} 可用"); true }
            }
        } catch (e: Exception) {
            appendLog(ctx, "[mirror] ${mirror} 连接失败: ${e.message}"); false
        }
    }

    suspend fun install(ctx: Context): Unit = withContext(Dispatchers.IO) {
        state.postValue(State.INSTALLING)
        val logFn = { line: String -> appendLog(ctx, line) }
        try {
            if (!prootBin(ctx).exists()) throw IllegalStateException("内置 proot 缺失，请重新安装应用")
            val arch = arch()
            logFn("[install] 设备架构: $arch")

            // 选择已手动指定的镜像优先
            val pinned = Prefs.getStr(ctx, "alpine_mirror").takeIf { it.isNotBlank() }
            val orderedMirrors = if (pinned != null)
                ALPINE_MIRRORS.filter { it.first == pinned } + ALPINE_MIRRORS.filter { it.first != pinned }
            else
                ALPINE_MIRRORS

            val rootfs = rootfsDir(ctx)
            val tarFile = File(tmpDir(ctx), "rootfs.tar.gz")

            var downloaded = false
            outer@ for ((mirrorUrl, mirrorName) in orderedMirrors) {
                for (version in ALPINE_VERSIONS) {
                    val branch = version.substringBeforeLast('.')
                    val url = "$mirrorUrl/v$branch/releases/$arch/alpine-minirootfs-$version-$arch.tar.gz"
                    try {
                        logFn("[install] 下载 Alpine: $mirrorName ($mirrorUrl) 版本 $version")
                        downloadWithProgress(ctx, url, tarFile)
                        verifySha256(ctx, mirrorUrl, branch, version, arch, tarFile)
                        logFn("[install] 解压根文件系统…")
                        rootfs.deleteRecursively()
                        rootfs.mkdirs()
                        val p = ProcessBuilder("tar", "-xzf", tarFile.absolutePath, "-C", rootfs.absolutePath)
                            .redirectErrorStream(true).start()
                        val out = p.inputStream.bufferedReader().readText()
                        val code = p.waitFor()
                        if (code != 0 || !File(rootfs, "bin/busybox").exists()) {
                            throw IllegalStateException("解压失败 code=$code: ${out.take(300)}")
                        }
                        Prefs.putStr(ctx, "alpine_version", branch)
                        Prefs.putStr(ctx, "alpine_mirror", mirrorUrl)
                        logFn("[install] 下载完成，来自 $mirrorName，大小 ${tarFile.length() / 1024} KB")
                        downloaded = true
                        break@outer
                    } catch (e: Exception) {
                        logFn("[install] $mirrorName / $version 失败: ${e.message}")
                    }
                }
            }
            if (!downloaded) throw IllegalStateException("所有镜像下载失败，请到设置里手动选一个可用的镜像再重试")
            tarFile.delete()

            // apk 源镜像跟随已选下载镜像，避免 apk add 时被 dl-cdn 卡死
            val branch = alpineVersion(ctx)
            val mirrorBase = Prefs.getStr(ctx, "alpine_mirror", ALPINE_MIRRORS.first().first)
            File(rootfs, "etc/resolv.conf").writeText("nameserver 223.5.5.5\nnameserver 8.8.8.8\n")
            File(rootfs, "etc/apk/repositories").writeText(
                "$mirrorBase/v$branch/main\n$mirrorBase/v$branch/community\n"
            )
            logFn("[install] 已写入 apk repositories (镜像: $mirrorBase, 分支: $branch)")

            progress.postValue(Pair(70, "安装基础依赖 python3 / bash / curl …"))
            logFn("[install] 安装基础依赖（python3 bash curl）…")
            runCapture(
                ctx,
                "apk update && apk add --no-cache python3 bash curl tar gzip unzip zip",
                streamLog = { appendLog(ctx, it) }
            )

            progress.postValue(Pair(95, "完成"))
            logFn("[install] 环境安装完成")
            state.postValue(State.READY)
            progress.postValue(null)
        } catch (e: Exception) {
            logFn("[install] 失败: ${e.message}")
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
                val buf = ByteArray(256 * 1024)
                var read = 0L
                var last = 0L
                while (true) {
                    val n = body.byteStream().read(buf)
                    if (n <= 0) break
                    out.write(buf, 0, n)
                    read += n
                    if (total > 0) {
                        val pct = (read * 100 / total).toInt()
                        val mb = (read / 1048576.0)
                        val tot = (total / 1048576.0)
                        val msg = "下载中 ${"%.1f".format(mb)} / ${"%.1f".format(tot)} MB"
                        if (read - last > 64L * 1024 || read >= total) {
                            last = read
                            progress.postValue(Pair(pct, msg))
                        }
                    }
                }
            }
        }
    }

    private fun verifySha256(ctx: Context, mirror: String, branch: String, version: String, arch: String, file: File) {
        val sumFile = "$mirror/v$branch/releases/$arch/alpine-minirootfs-$version-$arch.tar.gz.sha256"
        try {
            val resp = client.newCall(Request.Builder().url(sumFile).build()).execute()
            resp.use {
                if (!it.isSuccessful) { ctxLog(ctx, "[install] 校验和不可用，跳过 (HTTP ${it.code})"); return }
                val text = it.body?.string() ?: return
                val expected = text.trim().split(' ').firstOrNull()?.lowercase()
                if (expected.isNullOrBlank()) { ctxLog(ctx, "[install] 校验和为空，跳过"); return }
                val actual = sha256Hex(file)
                if (actual != expected) {
                    throw IllegalStateException("SHA256 校验失败: 期望 $expected，实际 $actual")
                }
                ctxLog(ctx, "[install] SHA256 校验通过: $actual")
            }
        } catch (e: Exception) {
            if (e.message?.startsWith("SHA256 校验失败") == true) throw e
            ctxLog(ctx, "[install] 校验和请求失败: ${e.message}，跳过校验")
        }
    }

    private fun ctxLog(ctx: Context, line: String) = appendLog(ctx, line)

    private fun sha256Hex(file: File): String {
        val d = MessageDigest.getInstance("SHA-256")
        file.inputStream().use { ins ->
            val buf = ByteArray(64 * 1024)
            while (true) {
                val n = ins.read(buf)
                if (n <= 0) break
                d.update(buf, 0, n)
            }
        }
        return d.digest().joinToString("") { "%02x".format(it) }
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