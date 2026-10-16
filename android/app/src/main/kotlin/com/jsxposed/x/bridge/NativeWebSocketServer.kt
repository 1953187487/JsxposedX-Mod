package com.jsxposed.xmod.bridge

import android.util.Log
import com.google.gson.Gson
import com.google.gson.JsonObject
import fi.iki.elonen.NanoWSD
import java.io.IOException
import java.util.concurrent.CopyOnWriteArraySet

/**
 * 原生 WebSocket 服务器，用于桌面端-设备端桥接通信。
 * 运行在独立线程，不依赖 Flutter Engine 状态。
 */
class NativeWebSocketServer(
    private val port: Int = 8765,
    private val deviceInfo: Map<String, Any>,
    private val requestHandler: (Map<String, Any?>) -> Map<String, Any?>
) : NanoWSD(port) {
    private val TAG = "NativeWebSocketServer"
    private val gson = Gson()
    private val connections = CopyOnWriteArraySet<BridgeWebSocket>()
    // 与 lib/core/transport/jsxposed_protocol.dart 的 jsxposedProtocolVersion = '1.0' 对齐
    private val jsxposedVersion = "1.0"

    override fun openWebSocket(handshake: IHTTPSession): WebSocket {
        return BridgeWebSocket(handshake)
    }

    inner class BridgeWebSocket(handshake: IHTTPSession) : NanoWSD.WebSocket(handshake) {
        override fun onOpen() {
            connections.add(this)
            DesktopConnectionReporter.report(connections.size)
        }

        override fun onClose(
            code: NanoWSD.WebSocketFrame.CloseCode,
            reason: String?,
            initiatedByRemote: Boolean
        ) {
            connections.remove(this)
            DesktopConnectionReporter.report(connections.size)
        }

        override fun onMessage(message: NanoWSD.WebSocketFrame) {
            try {
                val text = message.textPayload
                
                val request = gson.fromJson(text, Map::class.java) as Map<String, Any?>
                val response = handleRequest(request)
                
                val responseJson = gson.toJson(response)
                send(responseJson)
            } catch (e: Exception) {
                Log.e(TAG, "Error handling message", e)
                val errorResponse = mapOf(
                    "success" to false,
                    "error" to (e.message ?: "Unknown error")
                )
                try {
                    send(gson.toJson(errorResponse))
                } catch (sendError: IOException) {
                    Log.e(TAG, "Failed to send error response", sendError)
                }
            }
        }

        override fun onPong(pong: NanoWSD.WebSocketFrame) {
        }

        override fun onException(exception: IOException) {
            Log.e(TAG, "WebSocket exception", exception)
        }
    }

    private fun handleRequest(request: Map<String, Any?>): Map<String, Any?> {
        // 桌面端协议使用 "method" 字段
        val method = (request["method"] ?: request["action"]) as? String
        val requestId = request["id"] as? String
        val params = request["params"] as? Map<String, Any?>
        
        val result = when (method) {
            "handshake" -> {
                mapOf(
                    "protocolVersion" to (params?.get("protocolVersion") ?: "1.0"),
                    "server" to "JsxposedX Android Native",
                    "deviceId" to deviceInfo["deviceId"]
                )
            }
            "heartbeat" -> {
                mapOf("timestamp" to System.currentTimeMillis())
            }
            "device.get_info" -> {
                deviceInfo
            }
            else -> {
                // 业务请求交给前台服务的原生处理器
                val handlerResult = requestHandler(request)
                return mapOf(
                    "type" to "response",
                    "id" to requestId,
                    "success" to handlerResult["success"],
                    "result" to handlerResult["data"],
                    "error" to handlerResult["error"]
                )
            }
        }
        
        return mapOf(
            "type" to "response",
            "id" to requestId,
            "success" to true,
            "result" to result
        )
    }

    /**
     * 主动向所有已连接的桌面端推送事件帧（log.entry / console.state / shell.output / shell.exit）。
     * 协议事件 payload 放在 "result" 字段，与桌面端 JsxposedMessage.event 一致。
     */
    fun broadcast(event: String, payload: Any?) {
        if (connections.isEmpty()) return
        val frame = mapOf(
            "type" to "event",
            "version" to jsxposedVersion,
            "event" to event,
            "deviceId" to deviceInfo["deviceId"],
            "result" to payload
        )
        val json = gson.toJson(frame)
        connections.forEach { ws ->
            try {
                ws.send(json)
            } catch (e: IOException) {
                Log.e(TAG, "broadcast($event) failed", e)
            }
        }
    }

    fun startServer() {
        try {
            // timeout=0 表示不设置读超时，WebSocket 长连接不会被服务器主动断开
            start(0, false)
        } catch (e: IOException) {
            Log.e(TAG, "Failed to start server", e)
            throw e
        }
    }

    fun stopServer() {
        stop()
        connections.forEach { 
            try {
                it.close(NanoWSD.WebSocketFrame.CloseCode.NormalClosure, "Server stopping", false)
            } catch (e: IOException) {
                Log.e(TAG, "Error closing connection", e)
            }
        }
        connections.clear()
    }
}
