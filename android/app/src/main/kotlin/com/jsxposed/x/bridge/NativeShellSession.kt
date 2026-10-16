package com.jsxposed.xmod.bridge

import android.util.Log
import java.io.OutputStream

/**
 * 常驻 shell 交互会话（纯原生，不依赖 Flutter 引擎）。
 * 协议对齐 lib/core/transport/android_desktop_bridge_server.dart 的 _shellOpen/_shellWrite/_shellClose：
 *  - shell.open {useSu} -> {opened:true,useSu}
 *  - shell.write {data} -> {written:n}
 *  - shell.close     -> {closed:true}
 * 事件（经 broadcast 推送）：
 *  - shell.output {stream:stdout|stderr, data}
 *  - shell.exit    {exitCode:n}
 * 同一进程内持续读写，使 cd/export 等状态跨命令保留（非交互模式，提示符与回显由 PC 端维护）。
 */
class NativeShellSession(
    private val broadcast: (event: String, payload: Any?) -> Unit
) {
    private val TAG = "NativeShellSession"

    private var process: Process? = null
    private var writer: OutputStream? = null
    @Volatile private var closed = true

    /**
     * 打开一个常驻 shell。返回 {opened:Boolean, useSu:Boolean, stderr?:String}。
     */
    fun open(useSu: Boolean): Map<String, Any?> {
        close() // 已存在会话先关闭
        return try {
            val pb = if (useSu) {
                ProcessBuilder("su", "-c", "sh")
            } else {
                ProcessBuilder("sh")
            }
            // 合并 stderr 到 stdout，简化事件流（与 Dart 侧分开两个流略有差异，但终端多读 stdout 足够）：
            // 这里保持两个流分开，与协议 shell.output{stream} 对齐。
            val proc = pb.redirectErrorStream(false).start()
            process = proc
            writer = proc.outputStream
            closed = false

            // stdout 读取线程 -> broadcast shell.output {stream:stdout}
            // 按块读取（非按行），避免等待换行符导致 ls 等命令卡住
            Thread {
                try {
                    val buffer = ByteArray(4096)
                    val input = proc.inputStream
                    while (!closed) {
                        val n = input.read(buffer)
                        if (n <= 0) break
                        val data = String(buffer, 0, n, Charsets.UTF_8)
                        broadcast("shell.output", mapOf("stream" to "stdout", "data" to data))
                    }
                } catch (e: Exception) {
                    if (!closed) Log.e(TAG, "stdout read error", e)
                }
            }.start()

            // stderr 读取线程 -> broadcast shell.output {stream:stderr}
            Thread {
                try {
                    val buffer = ByteArray(4096)
                    val input = proc.errorStream
                    while (!closed) {
                        val n = input.read(buffer)
                        if (n <= 0) break
                        val data = String(buffer, 0, n, Charsets.UTF_8)
                        broadcast("shell.output", mapOf("stream" to "stderr", "data" to data))
                    }
                } catch (e: Exception) {
                    if (!closed) Log.e(TAG, "stderr read error", e)
                }
            }.start()

            // 进程结束 -> 清理 + broadcast shell.exit {exitCode}
            Thread {
                try {
                    val code = proc.waitFor()
                    if (!closed) {
                        closed = true
                        process = null
                        writer = null
                        broadcast("shell.exit", mapOf("exitCode" to code))
                    }
                } catch (e: Exception) {
                    Log.w(TAG, "waitFor error", e)
                }
            }.start()

            mapOf("opened" to true, "useSu" to useSu)
        } catch (e: Exception) {
            Log.e(TAG, "open failed", e)
            mapOf("opened" to false, "stderr" to (e.message ?: ""))
        }
    }

    /**
     * 向会话写入一段数据（可含多行）。返回 {written:n}。
     */
    fun write(data: String): Map<String, Any?> {
        val proc = process ?: return mapOf("error" to "Shell session is not open")
        val out = writer ?: return mapOf("error" to "Shell session is not open")
        return try {
            out.write(data.toByteArray(Charsets.UTF_8))
            out.flush()
            mapOf("written" to data.length)
        } catch (e: Exception) {
            Log.e(TAG, "write error", e)
            mapOf("error" to (e.message ?: "Write failed"))
        }
    }

    /**
     * 关闭会话。返回 {closed:true}。
     */
    fun close(): Map<String, Any?> {
        closed = true
        val proc = process
        val out = writer
        process = null
        writer = null
        try {
            out?.flush()
            out?.close()
        } catch (e: Exception) {
            Log.w(TAG, "close writer error", e)
        }
        proc?.destroy()
        return mapOf("closed" to true)
    }
}
