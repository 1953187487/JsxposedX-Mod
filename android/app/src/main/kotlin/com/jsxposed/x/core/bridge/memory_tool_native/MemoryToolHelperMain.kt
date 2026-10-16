package com.jsxposed.xmod.core.bridge.memory_tool_native

import android.net.LocalServerSocket
import android.net.LocalSocket
import org.json.JSONArray
import org.json.JSONObject
import java.io.Closeable
import java.util.concurrent.Executors
import java.util.concurrent.RejectedExecutionException
import java.util.concurrent.atomic.AtomicBoolean

object MemoryToolHelperMain {
    @JvmStatic
    fun main(args: Array<String>) {
        require(args.size >= 2) { "Expected args: <libPath> <socketName>" }
        System.load(args[0])
        MemoryToolDaemonServer(args[1]).run()
    }
}

private class MemoryToolDaemonServer(
    private val socketName: String
) : Closeable {
    companion object {
        private const val MAX_PAGE_SIZE = 1_000
    }
    private val running = AtomicBoolean(true)
    private val serverSocket = LocalServerSocket(socketName)
    private val clientExecutor = Executors.newFixedThreadPool(4) { runnable ->
        Thread(runnable, "memory-tool-client").apply { isDaemon = true }
    }

    fun run() {
        while (running.get()) {
            val client = try {
                serverSocket.accept()
            } catch (_: Exception) {
                break
            }

            try {
                clientExecutor.execute { handleClient(client) }
            } catch (_: RejectedExecutionException) {
                kotlin.runCatching { client.close() }
            }
        }
    }

    override fun close() {
        running.set(false)
        kotlin.runCatching { serverSocket.close() }
        clientExecutor.shutdownNow()
    }

    private fun handleClient(client: LocalSocket) {
        client.use { socket ->
            val reader = socket.inputStream.bufferedReader()
            val writer = socket.outputStream.bufferedWriter()
            while (running.get()) {
                val requestText = reader.readLine() ?: return
                val parsedRequest = runCatching { JSONObject(requestText) }
                if (parsedRequest.isFailure) {
                    val error = parsedRequest.exceptionOrNull()
                    writer.write(
                        JSONObject()
                            .put("ok", false)
                            .put("error", error?.message ?: "Invalid request.")
                            .toString(),
                    )
                    writer.newLine()
                    writer.flush()
                    continue
                }
                val request = parsedRequest.getOrThrow()

                val response = try {
                    handleRequest(request)
                } catch (t: Throwable) {
                    JSONObject().apply {
                        put("ok", false)
                        put("error", t.message ?: t.javaClass.simpleName)
                    }
                }
                if (request.has("requestId")) {
                    response.put("requestId", request.getLong("requestId"))
                }

                writer.write(response.toString())
                writer.newLine()
                writer.flush()
            }
        }
    }

    private fun handleRequest(request: JSONObject): JSONObject {
        val method = request.getString("method")
        val params = request.optJSONObject("params") ?: JSONObject()

        val result = when (method) {
            "ping" -> JSONObject().put("pong", true)
            "getMemoryRegions" -> JSONArray(
                MemoryToolHelperNativeBridge.getMemoryRegionsJson(
                    pid = params.getLong("pid"),
                    offset = params.getInt("offset"),
                    limit = boundedLimit(params),
                    readableOnly = params.optBoolean("readableOnly", true),
                    includeAnonymous = params.optBoolean("includeAnonymous", true),
                    includeFileBacked = params.optBoolean("includeFileBacked", true)
                )
            )

            "getSearchSessionState" -> JSONObject(
                MemoryToolHelperNativeBridge.getSearchSessionStateJson()
            )

            "getSearchTaskState" -> JSONObject(
                MemoryToolHelperNativeBridge.getSearchTaskStateJson()
            )

            "getSearchResults" -> JSONArray(
                MemoryToolHelperNativeBridge.getSearchResultsJson(
                    offset = params.getInt("offset"),
                    limit = boundedLimit(params)
                )
            )

            "getPointerScanSessionState" -> JSONObject(
                MemoryToolHelperNativeBridge.getPointerScanSessionStateJson()
            )

            "getPointerScanTaskState" -> JSONObject(
                MemoryToolHelperNativeBridge.getPointerScanTaskStateJson()
            )

            "getPointerScanResults" -> JSONArray(
                MemoryToolHelperNativeBridge.getPointerScanResultsJson(
                    offset = params.getInt("offset"),
                    limit = boundedLimit(params)
                )
            )

            "getPointerScanChaseHint" -> JSONObject(
                MemoryToolHelperNativeBridge.getPointerScanChaseHintJson()
            )

            "getPointerAutoChaseState" -> JSONObject(
                MemoryToolHelperNativeBridge.getPointerAutoChaseStateJson()
            )

            "getPointerAutoChaseLayerResults" -> JSONArray(
                MemoryToolHelperNativeBridge.getPointerAutoChaseLayerResultsJson(
                    layerIndex = params.getInt("layerIndex"),
                    offset = params.getInt("offset"),
                    limit = boundedLimit(params)
                )
            )

            "addMemoryBreakpoint" -> JSONArray(
                MemoryToolHelperNativeBridge.addMemoryBreakpointJson(
                    pid = params.getLong("pid"),
                    address = params.getLong("address"),
                    type = params.getInt("type"),
                    length = params.getInt("length"),
                    accessType = params.getInt("accessType"),
                    enabled = params.optBoolean("enabled", true),
                    pauseProcessOnHit = params.optBoolean("pauseProcessOnHit", true)
                )
            )

            "removeMemoryBreakpoint" -> {
                MemoryToolHelperNativeBridge.removeMemoryBreakpoint(
                    breakpointId = params.getString("breakpointId")
                )
                JSONObject.NULL
            }

            "setMemoryBreakpointEnabled" -> {
                MemoryToolHelperNativeBridge.setMemoryBreakpointEnabled(
                    breakpointId = params.getString("breakpointId"),
                    enabled = params.getBoolean("enabled")
                )
                JSONObject.NULL
            }

            "listMemoryBreakpoints" -> JSONArray(
                MemoryToolHelperNativeBridge.listMemoryBreakpointsJson(
                    pid = params.getLong("pid")
                )
            )

            "getMemoryBreakpointState" -> JSONObject(
                MemoryToolHelperNativeBridge.getMemoryBreakpointStateJson(
                    pid = params.getLong("pid")
                )
            )

            "getMemoryBreakpointHits" -> JSONArray(
                MemoryToolHelperNativeBridge.getMemoryBreakpointHitsJson(
                    pid = params.getLong("pid"),
                    offset = params.getInt("offset"),
                    limit = boundedLimit(params)
                )
            )

            "clearMemoryBreakpointHits" -> {
                MemoryToolHelperNativeBridge.clearMemoryBreakpointHits(
                    pid = params.getLong("pid")
                )
                JSONObject.NULL
            }

            "resumeAfterBreakpoint" -> {
                MemoryToolHelperNativeBridge.resumeAfterBreakpoint(
                    pid = params.getLong("pid")
                )
                JSONObject.NULL
            }

            "patchMemoryInstruction" -> JSONObject(
                MemoryToolHelperNativeBridge.patchMemoryInstructionJson(
                    pid = params.getLong("pid"),
                    address = params.getLong("address"),
                    inputText = params.getString("instruction")
                )
            )

            "disassembleMemory" -> JSONArray(
                MemoryToolHelperNativeBridge.disassembleMemoryJson(
                    pid = params.getLong("pid"),
                    addresses = extractLongArray(params.getJSONArray("addresses"))
                )
            )

            "readMemoryValues" -> JSONArray(
                MemoryToolHelperNativeBridge.readMemoryValuesJson(
                    pids = extractLongArray(params.getJSONArray("requests"), "pid"),
                    addresses = extractLongArray(params.getJSONArray("requests"), "address"),
                    types = extractIntArray(params.getJSONArray("requests"), "type"),
                    lengths = extractIntArray(params.getJSONArray("requests"), "length")
                )
            )

            "writeMemoryValue" -> {
                val value = params.getJSONObject("value")
                MemoryToolHelperNativeBridge.writeMemoryValue(
                    address = params.getLong("address"),
                    type = value.getInt("type"),
                    textValue = value.optString("textValue").ifBlank { null },
                    bytesValue = decodeHex(value.optString("bytesHex")),
                    littleEndian = value.optBoolean("littleEndian", true)
                )
                JSONObject.NULL
            }

            "setMemoryFreeze" -> {
                val value = params.getJSONObject("value")
                MemoryToolHelperNativeBridge.setMemoryFreeze(
                    address = params.getLong("address"),
                    type = value.getInt("type"),
                    textValue = value.optString("textValue").ifBlank { null },
                    bytesValue = decodeHex(value.optString("bytesHex")),
                    littleEndian = value.optBoolean("littleEndian", true),
                    enabled = params.optBoolean("enabled", false)
                )
                JSONObject.NULL
            }

            "getFrozenMemoryValues" -> JSONArray(
                MemoryToolHelperNativeBridge.getFrozenMemoryValuesJson()
            )

            "firstScan" -> {
                val value = params.getJSONObject("value")
                MemoryToolHelperNativeBridge.firstScan(
                    pid = params.getLong("pid"),
                    type = value.getInt("type"),
                    textValue = value.optString("textValue").ifBlank { null },
                    bytesValue = decodeHex(value.optString("bytesHex")),
                    littleEndian = value.optBoolean("littleEndian", true),
                    matchMode = params.getInt("matchMode"),
                    rangeSectionKeys = extractStringArray(params.optJSONArray("rangeSectionKeys")),
                    scanAllReadableRegions = params.optBoolean("scanAllReadableRegions", true)
                )
                JSONObject.NULL
            }

            "nextScan" -> {
                val value = params.getJSONObject("value")
                MemoryToolHelperNativeBridge.nextScan(
                    type = value.getInt("type"),
                    textValue = value.optString("textValue").ifBlank { null },
                    bytesValue = decodeHex(value.optString("bytesHex")),
                    littleEndian = value.optBoolean("littleEndian", true),
                    matchMode = params.getInt("matchMode")
                )
                JSONObject.NULL
            }

            "resetSearchSession" -> {
                MemoryToolHelperNativeBridge.resetSearchSession()
                JSONObject.NULL
            }

            "cancelSearch" -> {
                MemoryToolHelperNativeBridge.cancelSearch()
                JSONObject.NULL
            }

            "startPointerScan" -> {
                MemoryToolHelperNativeBridge.startPointerScan(
                    pid = params.getLong("pid"),
                    targetAddress = params.getLong("targetAddress"),
                    pointerWidth = params.getInt("pointerWidth"),
                    maxOffset = params.getLong("maxOffset"),
                    alignment = params.getInt("alignment"),
                    rangeSectionKeys = extractStringArray(params.optJSONArray("rangeSectionKeys")),
                    scanAllReadableRegions = params.optBoolean("scanAllReadableRegions", true)
                )
                JSONObject.NULL
            }

            "startPointerAutoChase" -> {
                MemoryToolHelperNativeBridge.startPointerAutoChase(
                    pid = params.getLong("pid"),
                    targetAddress = params.getLong("targetAddress"),
                    pointerWidth = params.getInt("pointerWidth"),
                    maxOffset = params.getLong("maxOffset"),
                    alignment = params.getInt("alignment"),
                    maxDepth = params.getInt("maxDepth"),
                    rangeSectionKeys = extractStringArray(params.optJSONArray("rangeSectionKeys")),
                    scanAllReadableRegions = params.optBoolean("scanAllReadableRegions", true)
                )
                JSONObject.NULL
            }

            "cancelPointerScan" -> {
                MemoryToolHelperNativeBridge.cancelPointerScan()
                JSONObject.NULL
            }

            "cancelPointerAutoChase" -> {
                MemoryToolHelperNativeBridge.cancelPointerAutoChase()
                JSONObject.NULL
            }

            "resetPointerScanSession" -> {
                MemoryToolHelperNativeBridge.resetPointerScanSession()
                JSONObject.NULL
            }

            "resetPointerAutoChase" -> {
                MemoryToolHelperNativeBridge.resetPointerAutoChase()
                JSONObject.NULL
            }

            else -> throw IllegalArgumentException("Unknown method: $method")
        }

        return JSONObject().apply {
            put("ok", true)
            put("result", result)
        }
    }

    private fun extractLongArray(items: JSONArray, fieldName: String): LongArray {
        return LongArray(items.length()) { index ->
            items.getJSONObject(index).getLong(fieldName)
        }
    }

    private fun boundedLimit(params: JSONObject): Int =
        params.optInt("limit", 100).coerceIn(1, MAX_PAGE_SIZE)

    private fun extractLongArray(items: JSONArray): LongArray {
        return LongArray(items.length()) { index ->
            items.getLong(index)
        }
    }

    private fun extractIntArray(items: JSONArray, fieldName: String): IntArray {
        return IntArray(items.length()) { index ->
            items.getJSONObject(index).getInt(fieldName)
        }
    }

    private fun decodeHex(hex: String?): ByteArray? {
        if (hex.isNullOrBlank()) {
            return null
        }

        val normalized = hex.trim()
        require(normalized.length % 2 == 0) { "Invalid hex length." }
        return ByteArray(normalized.length / 2) { index ->
            normalized.substring(index * 2, index * 2 + 2).toInt(16).toByte()
        }
    }

    private fun extractStringArray(items: JSONArray?): Array<String> {
        if (items == null) {
            return emptyArray()
        }

        return Array(items.length()) { index ->
            items.getString(index)
        }
    }
}
