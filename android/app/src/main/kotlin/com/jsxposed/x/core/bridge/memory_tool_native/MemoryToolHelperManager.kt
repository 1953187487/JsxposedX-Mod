package com.jsxposed.xmod.core.bridge.memory_tool_native

import android.content.Context
import android.os.Build
import android.os.Process
import android.os.SystemClock
import com.jsxposed.xmod.core.utils.log.LogX
import com.jsxposed.xmod.core.utils.shell.Shell
import java.io.File
import java.util.zip.ZipFile

class MemoryToolHelperManager(private val context: Context) {
    companion object {
        private const val TAG = "MemoryToolHelperManager"
        private const val STARTUP_RETRY_COUNT = 30
        private const val STARTUP_RETRY_DELAY_MS = 150L
        private const val DAEMON_PING_CACHE_TTL_MS = 1_000L
        private const val HELPER_LOG_FILE_NAME = "memory_tool_helper.log"
        private const val ROOT_RUNTIME_DIR = "/data/local/tmp/JsxposedX/memory_tool"
        private const val ROOT_HELPER_LIBRARY_DIR = "$ROOT_RUNTIME_DIR/helper_libs"
        private const val ROOT_APP_PROCESS_PATH = "$ROOT_RUNTIME_DIR/app_process"
    }

    private val socketName = "jsxposed_memory_tool_${Process.myPid()}"
    @Volatile
    private var lastDaemonPingAtMs = 0L
    @Volatile
    private var lastDaemonPingResult = false
    private val rootShell by lazy { Shell(su = true) }
    private val helperLogFile by lazy {
        val logDirectory = context.externalCacheDir ?: context.cacheDir
        File(logDirectory, HELPER_LOG_FILE_NAME)
    }

    fun socketName(): String = socketName

    fun ensureDaemon() {
        synchronized(this) {
            if (isDaemonAlive()) {
                return
            }

            if (!hasRootAccess()) {
                throw IllegalStateException("Root access is required for memory search.")
            }

            startDaemon()
            waitForDaemonReady()
        }
    }

    fun isDaemonAlive(): Boolean {
        val now = SystemClock.elapsedRealtime()
        if (now - lastDaemonPingAtMs < DAEMON_PING_CACHE_TTL_MS) {
            return lastDaemonPingResult
        }
        return synchronized(this) {
            val checkedAt = SystemClock.elapsedRealtime()
            if (checkedAt - lastDaemonPingAtMs < DAEMON_PING_CACHE_TTL_MS) {
                return@synchronized lastDaemonPingResult
            }
            MemoryToolDaemonClient.ping(socketName).also { alive ->
                lastDaemonPingResult = alive
                lastDaemonPingAtMs = checkedAt
            }
        }
    }

    fun invalidateDaemonState() {
        lastDaemonPingResult = false
        lastDaemonPingAtMs = 0L
    }

    private fun startDaemon() {
        val sourceDir = context.applicationInfo.sourceDir
        val appProcessPath = prepareBypassEnvironment()
        val memoryToolLibPath = extractHelperLibrary()
        val helperLogPath = helperLogFile.absolutePath
        val mainClass = "com.jsxposed.xmod.core.bridge.memory_tool_native.MemoryToolHelperMain"
        helperLogFile.parentFile?.mkdirs()
        helperLogFile.writeText("")
        val command =
            "setenforce 0 >/dev/null 2>&1 || true; " +
                "CLASSPATH=${shellEscape(sourceDir)} " +
                "${shellEscape(appProcessPath)} /system/bin $mainClass " +
                "${shellEscape(memoryToolLibPath)} ${shellEscape(socketName)} " +
                ">${shellEscape(helperLogPath)} 2>&1 &"
        LogX.i(TAG, "start daemon with temporary selinux bypass", socketName)
        Runtime.getRuntime().exec(arrayOf("su", "-c", command))
    }

    private fun prepareBypassEnvironment(): String {
        rootShell.mkdir(ROOT_RUNTIME_DIR)
        rootShell.execute("chmod 0771 ${shellEscape(ROOT_RUNTIME_DIR)}")
        rootShell.execute("setenforce 0 >/dev/null 2>&1 || true")

        val sourceAppProcessPath = resolveAppProcessBinary()
        rootShell.execute(
            "cp ${shellEscape(sourceAppProcessPath)} ${shellEscape(ROOT_APP_PROCESS_PATH)} && " +
                "chmod 0700 ${shellEscape(ROOT_APP_PROCESS_PATH)} && " +
                "restorecon ${shellEscape(ROOT_APP_PROCESS_PATH)} >/dev/null 2>&1 || true",
        )
        return ROOT_APP_PROCESS_PATH
    }

    private fun extractHelperLibrary(): String {
        val apkPath = context.applicationInfo.sourceDir
        val supportedAbis = Build.SUPPORTED_ABIS.toList()
        val helperLibraryPath = "$ROOT_HELPER_LIBRARY_DIR/libmemory_tool.so"

        ZipFile(apkPath).use { zipFile ->
            val abiEntry = supportedAbis.firstNotNullOfOrNull { abi ->
                zipFile.getEntry("lib/$abi/libmemory_tool.so")
            } ?: throw IllegalStateException(
                "libmemory_tool.so not found in APK for supported ABIs: $supportedAbis"
            )

            rootShell.mkdir(ROOT_HELPER_LIBRARY_DIR)
            rootShell.execute("chmod 0771 ${shellEscape(ROOT_HELPER_LIBRARY_DIR)}")

            zipFile.getInputStream(abiEntry).use { input ->
                rootShell.takeStream(input, helperLibraryPath)
            }
        }

        rootShell.execute(
            "chmod 0755 ${shellEscape(helperLibraryPath)}; " +
                "restorecon ${shellEscape(helperLibraryPath)} >/dev/null 2>&1 || true",
        )
        return helperLibraryPath
    }

    private fun waitForDaemonReady() {
        repeat(STARTUP_RETRY_COUNT) {
            if (isDaemonAlive()) {
                return
            }
            Thread.sleep(STARTUP_RETRY_DELAY_MS)
        }

        throw IllegalStateException(buildDaemonStartFailureMessage())
    }

    private fun hasRootAccess(): Boolean {
        val output = rootShell.execute("id")
        return output.contains("uid=0")
    }

    private fun resolveAppProcessBinary(): String {
        val prefers64Bit = Build.SUPPORTED_64_BIT_ABIS.isNotEmpty() &&
            Build.SUPPORTED_ABIS.firstOrNull()?.contains("64") == true
        val candidates = if (prefers64Bit) {
            listOf(
                "/system/bin/app_process64",
                "/system/bin/app_process64_original",
                "/system/bin/app_process64_init",
                "/system/bin/app_process",
            )
        } else {
            listOf(
                "/system/bin/app_process32",
                "/system/bin/app_process32_original",
                "/system/bin/app_process32_init",
                "/system/bin/app_process",
            )
        }

        return candidates.firstOrNull { path ->
            rootShell.execute("[ -f ${shellEscape(path)} ] && echo true") == "true"
        } ?: "/system/bin/app_process"
    }

    private fun shellEscape(value: String): String {
        return "'${value.replace("'", "'\"'\"'")}'"
    }

    private fun buildDaemonStartFailureMessage(): String {
        val helperLog = helperLogFile.takeIf { it.exists() }?.readText().orEmpty().trim()
        if (helperLog.isBlank()) {
            return "Memory tool helper daemon did not start."
        }

        val lines = helperLog.lines()
        val startIndex = (lines.size - 20).coerceAtLeast(0)
        val tail = lines
            .subList(startIndex, lines.size)
            .joinToString(separator = "\n")

        return "Memory tool helper daemon did not start.\n$tail"
    }
}
