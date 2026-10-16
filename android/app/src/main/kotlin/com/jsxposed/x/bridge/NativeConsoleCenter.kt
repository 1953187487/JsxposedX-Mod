package com.jsxposed.xmod.bridge

import android.util.Log
import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.URLDecoder
import java.util.concurrent.atomic.AtomicInteger
import java.util.concurrent.atomic.AtomicReference

/**
 * 控制台实时日志（纯原生，不依赖 Flutter 引擎）。
 * 数据源为 logcat 缓冲，通过 su 起 logcat 子进程流式读取，
 * 解析 JXCONSOLE v2 协议并转发为 log.entry / console.state 事件推送。
 * 协议对齐 lib/core/transport/android_desktop_bridge_server.dart + desktop_console_service.dart。
 */
class NativeConsoleCenter(
    private val broadcast: (event: String, payload: Any?) -> Unit
) {
    private val TAG = "NativeConsoleCenter"

    // 状态机（与日志页 DesktopLogsNotifier 一致）
    private val running = AtomicBoolean(false)
    private val starting = AtomicBoolean(false)
    private val paused = AtomicBoolean(false)
    private val autoScroll = AtomicBoolean(true)
    @Volatile private var searchQuery: String = ""
    @Volatile private var filterLevel: String = "V" // V/D/I/W/E，V 表示全部
    @Volatile private var filterSource: String = "" // session/frida/xposed/app/framework/system，空表示全部
    @Volatile private var targetPackage: String = ""
    @Volatile private var sessionId: String = ""
    @Volatile private var sessionConversationId: String = ""

    // 日志计数（当前会话内可见条目数，简化：累计已推送的协议条目数）
    private val entryCount = AtomicInteger(0)

    @Volatile private var process: Process? = null
    @Volatile private var readerThread: Thread? = null

    // ---------- 对外命令 ----------

    fun start(packageName: String): Map<String, Any?> {
        stop() // 先停旧的
        entryCount.set(0)
        paused.set(false)
        autoScroll.set(true)
        searchQuery = ""
        filterLevel = "V" // 重置为全部
        filterSource = "" // 重置为全部
        targetPackage = packageName
        sessionId = System.currentTimeMillis().toString()
        sessionConversationId = "standalone:$packageName:${System.currentTimeMillis()}"
        starting.set(true)
        emitState()

        return try {
            val proc = ProcessBuilder("su", "-c", "logcat -v threadtime -T 1").start()
            process = proc
            starting.set(false)
            running.set(true)
            // 状态栏会话条目
            pushEntry(
                rawLine = "JsxposedX Console connected to $packageName",
                level = "I", tag = "JsxposedX-Console", message = "Console connected to $packageName",
                timestampSec = System.currentTimeMillis() / 1000, pid = 0, tid = 0,
                source = null, scriptName = null, runId = null,
            )
            emitState()
            startReading(proc)
            mapOf("started" to true)
        } catch (e: Exception) {
            starting.set(false)
            running.set(false)
            emitState()
            Log.e(TAG, "start failed", e)
            mapOf("started" to false, "error" to (e.message ?: ""))
        }
    }

    fun stop(): Map<String, Any?> {
        running.set(false)
        starting.set(false)
        val proc = process
        process = null
        if (proc != null) {
            try { proc.destroy() } catch (e: Exception) { Log.w(TAG, "destroy error", e) }
        }
        readerThread?.interrupt()
        readerThread = null
        emitState()
        return mapOf("stopped" to true)
    }

    fun getState(): Map<String, Any?> = state()

    fun setPaused(value: Boolean): Map<String, Any?> {
        paused.set(value)
        emitState()
        return mapOf("paused" to value)
    }

    fun setAutoScroll(value: Boolean): Map<String, Any?> {
        autoScroll.set(value)
        emitState()
        return mapOf("autoScroll" to value)
    }

    fun setSearch(query: String): Map<String, Any?> {
        searchQuery = query
        emitState()
        return mapOf("query" to query)
    }

    fun setLevel(level: String): Map<String, Any?> {
        filterLevel = level.uppercase().takeIf { it in setOf("V", "D", "I", "W", "E") } ?: "V"
        emitState()
        return mapOf("level" to filterLevel)
    }

    fun setSource(source: String): Map<String, Any?> {
        filterSource = source.takeIf { it in setOf("session", "frida", "xposed", "app", "framework", "system") } ?: ""
        emitState()
        return mapOf("source" to filterSource)
    }

    fun clear(): Map<String, Any?> {
        entryCount.set(0)
        emitState()
        return mapOf("cleared" to true)
    }

    // ---------- 状态 ----------

    private fun state(): Map<String, Any?> = mapOf(
        "isRunning" to running.get(),
        "isStarting" to starting.get(),
        "isPaused" to paused.get(),
        "autoScroll" to autoScroll.get(),
        "searchQuery" to searchQuery,
        "filterLevel" to filterLevel,
        "filterSource" to filterSource,
        "sessionId" to sessionId,
        "sessionConversationId" to sessionConversationId,
        "targetPackage" to targetPackage,
        "entryCount" to entryCount.get(),
    )

    private fun emitState() {
        broadcast("console.state", state())
    }

    // ---------- logcat 读取 ----------

    private fun startReading(proc: Process) {
        val thread = Thread(readerRunnable(proc), "ConsoleLogcatReader")
        readerThread = thread
        thread.isDaemon = true
        thread.start()
    }

    private fun readerRunnable(proc: Process): Runnable = Runnable {
        try {
            val reader = BufferedReader(InputStreamReader(proc.inputStream, Charsets.UTF_8))
            var line: String?
            while (!Thread.currentThread().isInterrupted && proc.isAlive) {
                line = reader.readLine() ?: break
                if (!running.get()) break
                processLine(line, proc)
            }
        } catch (e: Exception) {
            Log.d(TAG, "reader ended: ${e.message}")
        }
        // 进程退出
        if (process === proc) {
            val exit = try { proc.waitFor() } catch (e: Exception) { -1 }
            process = null
            running.set(false)
            emitState()
        }
    }

    private fun processLine(rawLine: String, proc: Process) {
        // 1) 解析 threadtime 行
        val parsed = parseThreadtime(rawLine) ?: return
        val content = parsed.content

        // 2) 尝试 JXCONSOLE 协议解析
        var source: String? = null
        var scriptName: String? = null
        var runId: String? = null
        var level = parsed.level
        var message = content
        var stackTrace: String? = null

        if (content.startsWith("JXCONSOLE|")) {
            val jx = parseJxConsole(content)
            if (jx != null) {
                source = jx.source
                scriptName = jx.scriptName
                runId = jx.runId
                level = jx.level.ifEmpty { parsed.level }
                message = jx.message
                stackTrace = jx.stackTrace
            }
        }

        // 3) 过滤：targetPackage 匹配（协议条目或普通行里含包名）。
        //    JXCONSOLE 协议条目总是被收集（即便不含包名，因为脚本日志目标确定）。
        val isProtocol = content.startsWith("JXCONSOLE|")
        if (targetPackage.isNotEmpty()) {
            val matchesPackage = content.contains(targetPackage) || rawLine.contains(targetPackage)
            if (!isProtocol && !matchesPackage) return
        }

        // 4) 级别过滤：V=显示全部，D=Debug及以上，I=Info及以上，W=Warn及以上，E=Error及以上
        if (filterLevel != "V") {
            val levelPriority = mapOf("V" to 0, "D" to 1, "I" to 2, "W" to 3, "E" to 4, "F" to 5)
            val minPriority = levelPriority[filterLevel] ?: 0
            // 统一转大写（JXCONSOLE 协议是小写 info/warn/error/debug）
            val normalizedLevel = when (level.uppercase()) {
                "VERBOSE" -> "V"
                "DEBUG" -> "D"
                "INFO" -> "I"
                "WARN", "WARNING" -> "W"
                "ERROR" -> "E"
                "FATAL", "ASSERT" -> "F"
                else -> level.uppercase().take(1)
            }
            val currentPriority = levelPriority[normalizedLevel] ?: 0
            if (currentPriority < minPriority) return
        }

        // 5) 来源过滤：空表示全部，非空则必须匹配
        if (filterSource.isNotEmpty() && source != filterSource) return

        // 6) 搜索过滤（仅作用于展示；这里保持简单，未命中仍推送，由 PC 端过滤）：
        //    为对齐，若设置了 searchQuery 且 content 不含，则跳过推送（模拟 PC 端过滤逻辑）。
        if (searchQuery.isNotEmpty() && !content.contains(searchQuery)) return

        entryCount.incrementAndGet()
        pushEntry(
            rawLine = rawLine, level = level, tag = parsed.tag, message = message,
            timestampSec = parsed.timestampSec, pid = parsed.pid, tid = parsed.tid,
            source = source, scriptName = scriptName, runId = runId,
            stackTrace = stackTrace,
        )
    }

    private fun pushEntry(
        rawLine: String, level: String, tag: String, message: String,
        timestampSec: Long, pid: Int, tid: Int,
        source: String?, scriptName: String?, runId: String?,
        stackTrace: String? = null,
    ) {
        val payload = mapOf(
            "rawLine" to rawLine,
            "level" to level,
            "tag" to tag,
            "message" to message,
            "timestamp" to iso(timestampSec * 1000L),
            "source" to (source ?: ""),
            "scriptName" to (scriptName ?: ""),
            "runId" to (runId ?: ""),
            "sessionId" to sessionId,
            "pid" to pid.toString(),
            "tid" to tid.toString(),
            "stackTrace" to (stackTrace ?: ""),
        )
        broadcast("log.entry", payload)
    }

    // ---------- 行解析 ----------

    private data class ParsedLine(
        val timestampSec: Long, val pid: Int, val tid: Int,
        val level: String, val tag: String, val content: String,
    )

    private val threadtimeRegex = Regex(
        "^\\s*(\\d{2}-\\d{2}\\s+\\d{2}:\\d{2}:\\d{2}\\.\\d+)\\s+(\\d+)\\s+(\\d+)\\s+([VDIWEF])\\s+([^:]*?):\\s*(.*)$"
    )

    private fun parseThreadtime(line: String): ParsedLine? {
        val m = threadtimeRegex.find(line) ?: return null
        val time = m.groupValues[1]
        val pid = m.groupValues[2].toIntOrNull() ?: 0
        val tid = m.groupValues[3].toIntOrNull() ?: 0
        val level = m.groupValues[4].ifEmpty { "I" }
        val tag = m.groupValues[5]
        val content = m.groupValues[6]
        val tsSec = parseLogcatTime(time) ?: (System.currentTimeMillis() / 1000)
        return ParsedLine(tsSec, pid, tid, level, tag, content)
    }

    /** 解析 "MM-dd HH:mm:ss.SSS" 为 unix 秒（近似当年）。 */
    private fun parseLogcatTime(time: String): Long? {
        return try {
            val arr = time.split(" ")
            val date = arr[0].split("-")
            val t = arr[1].split(":")
            val sec = t[2].split(".")
            val now = java.time.ZonedDateTime.now(java.time.ZoneId.systemDefault())
            val year = now.year
            val zdt = java.time.ZonedDateTime.of(
                year, date[0].toInt(), date[1].toInt(),
                t[0].toInt(), t[1].toInt(), sec[0].toInt(), 0,
                java.time.ZoneId.systemDefault()
            )
            zdt.toEpochSecond()
        } catch (e: Exception) {
            null
        }
    }

    // ---------- JXCONSOLE 协议解析 ----------

    private data class JxConsole(
        val source: String, val runId: String, val scriptName: String,
        val level: String, val message: String, val stackTrace: String,
    )

    private fun parseJxConsole(text: String): JxConsole? {
        // 形如 JXCONSOLE|v2|<source>|<runId>|<scriptName>|<level>|<message...>
        // 或 JXCONSOLE|v1|<source>|<scriptName>|<level>|<message...>
        val parts = text.split("|")
        if (parts.size < 4) return null
        val version = parts.getOrNull(1) ?: return null
        return when {
            version == "v2" && parts.size >= 7 -> {
                val payloadRaw = parts.subList(6, parts.size).joinToString("|")
                val (msg, stack) = splitStack(decode(payloadRaw))
                JxConsole(
                    source = decode(parts[2]), runId = decode(parts[3]),
                    scriptName = decode(parts[4]), level = parts[5],
                    message = msg, stackTrace = stack,
                )
            }
            version == "v1" && parts.size >= 6 -> {
                val payloadRaw = parts.subList(5, parts.size).joinToString("|")
                val (msg, stack) = splitStack(decode(payloadRaw))
                JxConsole(
                    source = decode(parts[2]), runId = "", scriptName = decode(parts[3]),
                    level = parts[4], message = msg, stackTrace = stack,
                )
            }
            else -> null
        }
    }

    private fun splitStack(decoded: String): Pair<String, String> {
        val sep = "\n--STACK--\n"
        val idx = decoded.indexOf(sep)
        return if (idx >= 0) {
            decoded.substring(0, idx) to decoded.substring(idx + sep.length)
        } else {
            decoded to ""
        }
    }

    private fun decode(value: String): String {
        // 与 Dart Uri.decodeComponent 对齐：+ 应保留为字面加号，空格由 %20 解码得到。
        // URLDecoder 会把 + 当作空格，因此先把 + 保护为 %2B 再解码。
        return try {
            URLDecoder.decode(value.replace("+", "%2B"), "UTF-8")
                .replace("%2B", "+")
        } catch (e: Exception) {
            value
        }
    }

    // ---------- 工具 ----------
    private class AtomicBoolean(initial: Boolean) {
        private val v = java.util.concurrent.atomic.AtomicBoolean(initial)
        fun get(): Boolean = v.get()
        fun set(x: Boolean) { v.set(x) }
    }

    private val isoFmt = java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", java.util.Locale.US).apply {
        timeZone = java.util.TimeZone.getTimeZone("UTC")
    }

    private fun iso(epochMillis: Long): String = isoFmt.format(java.util.Date(epochMillis))

    fun destroy() {
        stop()
    }
}
