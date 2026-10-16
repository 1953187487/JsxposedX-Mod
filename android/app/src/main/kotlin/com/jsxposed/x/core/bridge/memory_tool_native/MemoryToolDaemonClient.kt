package com.jsxposed.xmod.core.bridge.memory_tool_native

import android.net.LocalSocket
import android.net.LocalSocketAddress
import org.json.JSONArray
import org.json.JSONObject
import java.io.BufferedReader
import java.io.BufferedWriter
import java.io.Closeable
import java.util.concurrent.atomic.AtomicLong

class MemoryToolDaemonClient(
    private val helperManager: MemoryToolHelperManager
) : Closeable {
    companion object {
        private const val SOCKET_TIMEOUT_MS = 15_000
        private const val METHOD_PING = "ping"
        private const val METHOD_GET_MEMORY_REGIONS = "getMemoryRegions"
        private const val METHOD_GET_SEARCH_SESSION_STATE = "getSearchSessionState"
        private const val METHOD_GET_SEARCH_TASK_STATE = "getSearchTaskState"
        private const val METHOD_GET_SEARCH_RESULTS = "getSearchResults"
        private const val METHOD_GET_POINTER_SCAN_SESSION_STATE = "getPointerScanSessionState"
        private const val METHOD_GET_POINTER_SCAN_TASK_STATE = "getPointerScanTaskState"
        private const val METHOD_GET_POINTER_SCAN_RESULTS = "getPointerScanResults"
        private const val METHOD_GET_POINTER_SCAN_CHASE_HINT = "getPointerScanChaseHint"
        private const val METHOD_GET_POINTER_AUTO_CHASE_STATE = "getPointerAutoChaseState"
        private const val METHOD_GET_POINTER_AUTO_CHASE_LAYER_RESULTS = "getPointerAutoChaseLayerResults"
        private const val METHOD_ADD_MEMORY_BREAKPOINT = "addMemoryBreakpoint"
        private const val METHOD_REMOVE_MEMORY_BREAKPOINT = "removeMemoryBreakpoint"
        private const val METHOD_SET_MEMORY_BREAKPOINT_ENABLED = "setMemoryBreakpointEnabled"
        private const val METHOD_LIST_MEMORY_BREAKPOINTS = "listMemoryBreakpoints"
        private const val METHOD_GET_MEMORY_BREAKPOINT_STATE = "getMemoryBreakpointState"
        private const val METHOD_GET_MEMORY_BREAKPOINT_HITS = "getMemoryBreakpointHits"
        private const val METHOD_CLEAR_MEMORY_BREAKPOINT_HITS = "clearMemoryBreakpointHits"
        private const val METHOD_RESUME_AFTER_BREAKPOINT = "resumeAfterBreakpoint"
        private const val METHOD_PATCH_MEMORY_INSTRUCTION = "patchMemoryInstruction"
        private const val METHOD_DISASSEMBLE_MEMORY = "disassembleMemory"
        private const val METHOD_READ_MEMORY_VALUES = "readMemoryValues"
        private const val METHOD_WRITE_MEMORY_VALUE = "writeMemoryValue"
        private const val METHOD_SET_MEMORY_FREEZE = "setMemoryFreeze"
        private const val METHOD_GET_FROZEN_MEMORY_VALUES = "getFrozenMemoryValues"
        private const val METHOD_FIRST_SCAN = "firstScan"
        private const val METHOD_NEXT_SCAN = "nextScan"
        private const val METHOD_CANCEL_SEARCH = "cancelSearch"
        private const val METHOD_RESET_SEARCH_SESSION = "resetSearchSession"
        private const val METHOD_START_POINTER_SCAN = "startPointerScan"
        private const val METHOD_START_POINTER_AUTO_CHASE = "startPointerAutoChase"
        private const val METHOD_CANCEL_POINTER_SCAN = "cancelPointerScan"
        private const val METHOD_CANCEL_POINTER_AUTO_CHASE = "cancelPointerAutoChase"
        private const val METHOD_RESET_POINTER_SCAN_SESSION = "resetPointerScanSession"
        private const val METHOD_RESET_POINTER_AUTO_CHASE = "resetPointerAutoChase"

        fun ping(socketName: String): Boolean {
            return try {
                val response = sendRequest(socketName, METHOD_PING, null)
                response.optBoolean("ok", false)
            } catch (_: Exception) {
                false
            }
        }

        private fun sendRequest(
            socketName: String,
            method: String,
            params: JSONObject?
        ): JSONObject {
            val socket = LocalSocket()
            socket.connect(LocalSocketAddress(socketName, LocalSocketAddress.Namespace.ABSTRACT))
            socket.soTimeout = SOCKET_TIMEOUT_MS
            socket.use { localSocket ->
                val writer = localSocket.outputStream.bufferedWriter()
                val reader = localSocket.inputStream.bufferedReader()
                val request = JSONObject().apply {
                    put("method", method)
                    if (params != null) {
                        put("params", params)
                    }
                }
                writer.write(request.toString())
                writer.newLine()
                writer.flush()

                val responseText = reader.readLine()
                    ?: throw IllegalStateException("Empty response from memory helper.")
                return JSONObject(responseText)
            }
        }

        private fun decodeHex(hex: String?): ByteArray {
            if (hex.isNullOrBlank()) {
                return ByteArray(0)
            }

            val normalized = hex.trim()
            require(normalized.length % 2 == 0) { "Invalid hex length." }
            return ByteArray(normalized.length / 2) { index ->
                normalized.substring(index * 2, index * 2 + 2).toInt(16).toByte()
            }
        }

        private fun encodeHex(bytes: ByteArray?): String? {
            if (bytes == null) {
                return null
            }

            return bytes.joinToString(separator = "") { byte ->
                "%02x".format(byte.toInt() and 0xFF)
            }
        }
    }

    private val connectionLock = Any()
    private val requestId = AtomicLong(0)
    private var socket: LocalSocket? = null
    private var reader: BufferedReader? = null
    private var writer: BufferedWriter? = null

    override fun close() {
        synchronized(connectionLock) {
            closeConnectionLocked()
        }
    }

    fun getMemoryRegions(query: MemoryRegionQuery): List<MemoryRegion> {
        helperManager.ensureDaemon()
        val result = sendOrThrow(
            METHOD_GET_MEMORY_REGIONS,
            JSONObject().apply {
                put("pid", query.pid)
                put("offset", query.offset)
                put("limit", query.limit)
                put("readableOnly", query.readableOnly)
                put("includeAnonymous", query.includeAnonymous)
                put("includeFileBacked", query.includeFileBacked)
            }
        ).optJSONArray("result") ?: JSONArray()

        return List(result.length()) { index ->
            val item = result.getJSONObject(index)
            MemoryRegion(
                startAddress = item.getLong("startAddress"),
                endAddress = item.getLong("endAddress"),
                perms = item.getString("perms"),
                size = item.getLong("size"),
                path = item.optString("path").ifBlank { null },
                isAnonymous = item.getBoolean("isAnonymous")
            )
        }
    }

    fun getSearchSessionState(): SearchSessionState {
        if (!helperManager.isDaemonAlive()) {
            return SearchSessionState(
                hasActiveSession = false,
                pid = 0,
                type = SearchValueType.I32,
                regionCount = 0,
                resultCount = 0,
                exactMode = true,
                littleEndian = true
            )
        }

        val item = sendOrThrow(METHOD_GET_SEARCH_SESSION_STATE, null).getJSONObject("result")
        return SearchSessionState(
            hasActiveSession = item.getBoolean("hasActiveSession"),
            pid = item.getLong("pid"),
            type = SearchValueType.entries[item.getInt("type")],
            regionCount = item.getLong("regionCount"),
            resultCount = item.getLong("resultCount"),
            exactMode = item.getBoolean("exactMode"),
            littleEndian = item.optBoolean("littleEndian", true)
        )
    }

    fun getSearchTaskState(): SearchTaskState {
        if (!helperManager.isDaemonAlive()) {
            return SearchTaskState(
                status = SearchTaskStatus.IDLE,
                isFirstScan = true,
                pid = 0,
                processedRegions = 0,
                totalRegions = 0,
                processedEntries = 0,
                totalEntries = 0,
                processedBytes = 0,
                totalBytes = 0,
                resultCount = 0,
                elapsedMilliseconds = 0,
                canCancel = false,
                message = ""
            )
        }

        val item = sendOrThrow(METHOD_GET_SEARCH_TASK_STATE, null).getJSONObject("result")
        return SearchTaskState(
            status = SearchTaskStatus.entries[item.getInt("status")],
            isFirstScan = item.getBoolean("isFirstScan"),
            pid = item.getLong("pid"),
            processedRegions = item.getLong("processedRegions"),
            totalRegions = item.getLong("totalRegions"),
            processedEntries = item.getLong("processedEntries"),
            totalEntries = item.getLong("totalEntries"),
            processedBytes = item.getLong("processedBytes"),
            totalBytes = item.getLong("totalBytes"),
            resultCount = item.getLong("resultCount"),
            elapsedMilliseconds = item.getLong("elapsedMilliseconds"),
            canCancel = item.getBoolean("canCancel"),
            message = item.optString("message")
        )
    }

    fun getSearchResults(offset: Int, limit: Int): List<SearchResult> {
        if (!helperManager.isDaemonAlive()) {
            return emptyList()
        }

        val result = sendOrThrow(
            METHOD_GET_SEARCH_RESULTS,
            JSONObject().apply {
                put("offset", offset)
                put("limit", limit)
            }
        ).optJSONArray("result") ?: JSONArray()

        return List(result.length()) { index ->
            val item = result.getJSONObject(index)
            SearchResult(
                address = item.getLong("address"),
                regionStart = item.getLong("regionStart"),
                regionTypeKey = item.optString("regionTypeKey", "other"),
                type = SearchValueType.entries[item.getInt("type")],
                rawBytes = decodeHex(item.optString("rawBytesHex")),
                displayValue = item.getString("displayValue")
            )
        }
    }

    fun getPointerScanSessionState(): PointerScanSessionState {
        if (!helperManager.isDaemonAlive()) {
            return PointerScanSessionState(
                hasActiveSession = false,
                pid = 0,
                targetAddress = 0,
                pointerWidth = 8,
                maxOffset = 0,
                alignment = 8,
                regionCount = 0,
                resultCount = 0
            )
        }

        val item = sendOrThrow(METHOD_GET_POINTER_SCAN_SESSION_STATE, null).getJSONObject("result")
        return PointerScanSessionState(
            hasActiveSession = item.getBoolean("hasActiveSession"),
            pid = item.getLong("pid"),
            targetAddress = item.getLong("targetAddress"),
            pointerWidth = item.getLong("pointerWidth"),
            maxOffset = item.getLong("maxOffset"),
            alignment = item.getLong("alignment"),
            regionCount = item.getLong("regionCount"),
            resultCount = item.getLong("resultCount")
        )
    }

    fun getPointerScanTaskState(): PointerScanTaskState {
        if (!helperManager.isDaemonAlive()) {
            return PointerScanTaskState(
                status = SearchTaskStatus.IDLE,
                pid = 0,
                processedRegions = 0,
                totalRegions = 0,
                processedEntries = 0,
                totalEntries = 0,
                processedBytes = 0,
                totalBytes = 0,
                resultCount = 0,
                elapsedMilliseconds = 0,
                canCancel = false,
                message = ""
            )
        }

        val item = sendOrThrow(METHOD_GET_POINTER_SCAN_TASK_STATE, null).getJSONObject("result")
        return PointerScanTaskState(
            status = SearchTaskStatus.entries[item.getInt("status")],
            pid = item.getLong("pid"),
            processedRegions = item.getLong("processedRegions"),
            totalRegions = item.getLong("totalRegions"),
            processedEntries = item.getLong("processedEntries"),
            totalEntries = item.getLong("totalEntries"),
            processedBytes = item.getLong("processedBytes"),
            totalBytes = item.getLong("totalBytes"),
            resultCount = item.getLong("resultCount"),
            elapsedMilliseconds = item.getLong("elapsedMilliseconds"),
            canCancel = item.getBoolean("canCancel"),
            message = item.optString("message")
        )
    }

    fun getPointerScanResults(offset: Int, limit: Int): List<PointerScanResult> {
        if (!helperManager.isDaemonAlive()) {
            return emptyList()
        }

        val result = sendOrThrow(
            METHOD_GET_POINTER_SCAN_RESULTS,
            JSONObject().apply {
                put("offset", offset)
                put("limit", limit)
            }
        ).optJSONArray("result") ?: JSONArray()

        return List(result.length()) { index ->
            val item = result.getJSONObject(index)
            PointerScanResult(
                pointerAddress = item.getLong("pointerAddress"),
                baseAddress = item.getLong("baseAddress"),
                targetAddress = item.getLong("targetAddress"),
                offset = item.getLong("offset"),
                regionStart = item.getLong("regionStart"),
                regionTypeKey = item.optString("regionTypeKey", "other")
            )
        }
    }

    fun getPointerScanChaseHint(): PointerScanChaseHint {
        if (!helperManager.isDaemonAlive()) {
            return PointerScanChaseHint(
                result = null,
                isTerminalStaticCandidate = false,
                stopReasonKey = "noSession"
            )
        }

        val item = sendOrThrow(METHOD_GET_POINTER_SCAN_CHASE_HINT, null).getJSONObject("result")
        val resultItem = item.optJSONObject("result")
        return PointerScanChaseHint(
            result = resultItem?.let { result ->
                PointerScanResult(
                    pointerAddress = result.getLong("pointerAddress"),
                    baseAddress = result.getLong("baseAddress"),
                    targetAddress = result.getLong("targetAddress"),
                    offset = result.getLong("offset"),
                    regionStart = result.getLong("regionStart"),
                    regionTypeKey = result.optString("regionTypeKey", "other")
                )
            },
            isTerminalStaticCandidate = item.optBoolean("isTerminalStaticCandidate", false),
            stopReasonKey = item.optString("stopReasonKey")
        )
    }

    fun getPointerAutoChaseState(): PointerAutoChaseState {
        if (!helperManager.isDaemonAlive()) {
            return PointerAutoChaseState(
                isRunning = false,
                pid = 0,
                maxDepth = 0,
                currentDepth = 0,
                layers = emptyList(),
                message = ""
            )
        }

        val item = sendOrThrow(METHOD_GET_POINTER_AUTO_CHASE_STATE, null).getJSONObject("result")
        return PointerAutoChaseState(
            isRunning = item.optBoolean("isRunning", false),
            pid = item.optLong("pid"),
            maxDepth = item.optLong("maxDepth"),
            currentDepth = item.optLong("currentDepth"),
            layers = buildPointerAutoChaseLayers(item.optJSONArray("layers")),
            message = item.optString("message")
        )
    }

    fun getPointerAutoChaseLayerResults(
        layerIndex: Int,
        offset: Int,
        limit: Int
    ): List<PointerScanResult> {
        if (!helperManager.isDaemonAlive()) {
            return emptyList()
        }

        val result = sendOrThrow(
            METHOD_GET_POINTER_AUTO_CHASE_LAYER_RESULTS,
            JSONObject().apply {
                put("layerIndex", layerIndex)
                put("offset", offset)
                put("limit", limit)
            }
        ).optJSONArray("result") ?: JSONArray()
        return List(result.length()) { index ->
            val item = result.getJSONObject(index)
            PointerScanResult(
                pointerAddress = item.getLong("pointerAddress"),
                baseAddress = item.getLong("baseAddress"),
                targetAddress = item.getLong("targetAddress"),
                offset = item.getLong("offset"),
                regionStart = item.getLong("regionStart"),
                regionTypeKey = item.optString("regionTypeKey", "other")
            )
        }
    }

    fun addMemoryBreakpoint(request: AddMemoryBreakpointRequest): MemoryBreakpoint {
        helperManager.ensureDaemon()
        val result = sendOrThrow(
            METHOD_ADD_MEMORY_BREAKPOINT,
            JSONObject().apply {
                put("pid", request.pid)
                put("address", request.address)
                put("type", request.type.ordinal)
                put("length", request.length)
                put("accessType", request.accessType.ordinal)
                put("enabled", request.enabled)
                put("pauseProcessOnHit", request.pauseProcessOnHit)
            }
        ).optJSONArray("result") ?: JSONArray()
        require(result.length() > 0) { "Empty breakpoint result." }
        return buildMemoryBreakpoint(result.getJSONObject(0))
    }

    fun removeMemoryBreakpoint(breakpointId: String) {
        if (!helperManager.isDaemonAlive()) {
            return
        }
        sendOrThrow(
            METHOD_REMOVE_MEMORY_BREAKPOINT,
            JSONObject().apply {
                put("breakpointId", breakpointId)
            }
        )
    }

    fun setMemoryBreakpointEnabled(breakpointId: String, enabled: Boolean) {
        helperManager.ensureDaemon()
        sendOrThrow(
            METHOD_SET_MEMORY_BREAKPOINT_ENABLED,
            JSONObject().apply {
                put("breakpointId", breakpointId)
                put("enabled", enabled)
            }
        )
    }

    fun listMemoryBreakpoints(pid: Int): List<MemoryBreakpoint> {
        if (!helperManager.isDaemonAlive()) {
            return emptyList()
        }
        val result = sendOrThrow(
            METHOD_LIST_MEMORY_BREAKPOINTS,
            JSONObject().apply {
                put("pid", pid)
            }
        ).optJSONArray("result") ?: JSONArray()
        return List(result.length()) { index ->
            buildMemoryBreakpoint(result.getJSONObject(index))
        }
    }

    fun getMemoryBreakpointState(pid: Int): MemoryBreakpointState {
        if (!helperManager.isDaemonAlive()) {
            return MemoryBreakpointState(
                isSupported = false,
                isProcessPaused = false,
                activeBreakpointCount = 0,
                pendingHitCount = 0,
                architecture = "",
                lastError = ""
            )
        }
        val item = sendOrThrow(
            METHOD_GET_MEMORY_BREAKPOINT_STATE,
            JSONObject().apply {
                put("pid", pid)
            }
        ).getJSONObject("result")
        return MemoryBreakpointState(
            isSupported = item.optBoolean("isSupported", false),
            isProcessPaused = item.optBoolean("isProcessPaused", false),
            activeBreakpointCount = item.optLong("activeBreakpointCount"),
            pendingHitCount = item.optLong("pendingHitCount"),
            architecture = item.optString("architecture"),
            lastError = item.optString("lastError")
        )
    }

    fun getMemoryBreakpointHits(pid: Int, offset: Int, limit: Int): List<MemoryBreakpointHit> {
        if (!helperManager.isDaemonAlive()) {
            return emptyList()
        }
        val result = sendOrThrow(
            METHOD_GET_MEMORY_BREAKPOINT_HITS,
            JSONObject().apply {
                put("pid", pid)
                put("offset", offset)
                put("limit", limit)
            }
        ).optJSONArray("result") ?: JSONArray()
        return List(result.length()) { index ->
            buildMemoryBreakpointHit(result.getJSONObject(index))
        }
    }

    fun clearMemoryBreakpointHits(pid: Int) {
        if (!helperManager.isDaemonAlive()) {
            return
        }
        sendOrThrow(
            METHOD_CLEAR_MEMORY_BREAKPOINT_HITS,
            JSONObject().apply {
                put("pid", pid)
            }
        )
    }

    fun resumeAfterBreakpoint(pid: Int) {
        helperManager.ensureDaemon()
        sendOrThrow(
            METHOD_RESUME_AFTER_BREAKPOINT,
            JSONObject().apply {
                put("pid", pid)
            }
        )
    }

    fun patchMemoryInstruction(request: MemoryInstructionPatchRequest): MemoryInstructionPatchResult {
        helperManager.ensureDaemon()
        val item = sendOrThrow(
            METHOD_PATCH_MEMORY_INSTRUCTION,
            JSONObject().apply {
                put("pid", request.pid)
                put("address", request.address)
                put("instruction", request.instruction)
            }
        ).getJSONObject("result")
        return MemoryInstructionPatchResult(
            address = item.getLong("address"),
            architecture = item.optString("architecture"),
            instructionSize = item.optLong("instructionSize"),
            beforeBytes = decodeHex(item.optString("beforeBytesHex")),
            afterBytes = decodeHex(item.optString("afterBytesHex")),
            instructionText = item.optString("instructionText")
        )
    }

    fun disassembleMemory(pid: Int, addresses: List<Long>): List<MemoryInstructionPreview> {
        if (addresses.isEmpty()) {
            return emptyList()
        }

        helperManager.ensureDaemon()
        val result = sendOrThrow(
            METHOD_DISASSEMBLE_MEMORY,
            JSONObject().apply {
                put("pid", pid)
                put(
                    "addresses",
                    JSONArray().apply {
                        addresses.forEach(::put)
                    }
                )
            }
        ).optJSONArray("result") ?: JSONArray()

        return List(result.length()) { index ->
            val item = result.getJSONObject(index)
            MemoryInstructionPreview(
                address = item.getLong("address"),
                architecture = item.optString("architecture"),
                instructionSize = item.optLong("instructionSize"),
                rawBytes = decodeHex(item.optString("rawBytesHex")),
                instructionText = item.optString("instructionText")
            )
        }
    }

    fun readMemoryValues(requests: List<MemoryReadRequest>): List<MemoryValuePreview> {
        if (requests.isEmpty()) {
            return emptyList()
        }

        helperManager.ensureDaemon()
        val result = sendOrThrow(
            METHOD_READ_MEMORY_VALUES,
            JSONObject().apply {
                put(
                    "requests",
                    JSONArray().apply {
                        requests.forEach { request ->
                            put(
                                JSONObject().apply {
                                    put("pid", request.pid)
                                    put("address", request.address)
                                    put("type", request.type.ordinal)
                                    put("length", request.length)
                                }
                            )
                        }
                    }
                )
            }
        ).optJSONArray("result") ?: JSONArray()

        return List(result.length()) { index ->
            val item = result.getJSONObject(index)
            MemoryValuePreview(
                address = item.getLong("address"),
                type = SearchValueType.entries[item.getInt("type")],
                rawBytes = decodeHex(item.optString("rawBytesHex")),
                displayValue = item.getString("displayValue")
            )
        }
    }

    fun writeMemoryValue(request: MemoryWriteRequest) {
        helperManager.ensureDaemon()
        sendOrThrow(
            METHOD_WRITE_MEMORY_VALUE,
            JSONObject().apply {
                put("address", request.address)
                put("value", buildSearchValueJson(request.value))
            }
        )
    }

    fun setMemoryFreeze(request: MemoryFreezeRequest) {
        helperManager.ensureDaemon()
        sendOrThrow(
            METHOD_SET_MEMORY_FREEZE,
            JSONObject().apply {
                put("address", request.address)
                put("value", buildSearchValueJson(request.value))
                put("enabled", request.enabled)
            }
        )
    }

    fun getFrozenMemoryValues(): List<FrozenMemoryValue> {
        if (!helperManager.isDaemonAlive()) {
            return emptyList()
        }

        val result = sendOrThrow(METHOD_GET_FROZEN_MEMORY_VALUES, null)
            .optJSONArray("result") ?: JSONArray()
        return List(result.length()) { index ->
            val item = result.getJSONObject(index)
            FrozenMemoryValue(
                pid = item.getLong("pid"),
                address = item.getLong("address"),
                type = SearchValueType.entries[item.getInt("type")],
                rawBytes = decodeHex(item.optString("rawBytesHex")),
                displayValue = item.getString("displayValue")
            )
        }
    }

    fun firstScan(request: FirstScanRequest) {
        helperManager.ensureDaemon()
        sendOrThrow(
            METHOD_FIRST_SCAN,
            JSONObject().apply {
                put("pid", request.pid)
                put("value", buildSearchValueJson(request.value))
                put("matchMode", request.matchMode.ordinal)
                put(
                    "rangeSectionKeys",
                    JSONArray().apply {
                        request.rangeSectionKeys.forEach(::put)
                    }
                )
                put("scanAllReadableRegions", request.scanAllReadableRegions)
            }
        )
    }

    fun nextScan(request: NextScanRequest) {
        helperManager.ensureDaemon()
        sendOrThrow(
            METHOD_NEXT_SCAN,
            JSONObject().apply {
                put("value", buildSearchValueJson(request.value))
                put("matchMode", request.matchMode.ordinal)
            }
        )
    }

    fun cancelSearch() {
        if (!helperManager.isDaemonAlive()) {
            return
        }

        sendOrThrow(METHOD_CANCEL_SEARCH, null)
    }

    fun resetSearchSession() {
        if (!helperManager.isDaemonAlive()) {
            return
        }

        sendOrThrow(METHOD_RESET_SEARCH_SESSION, null)
    }

    fun startPointerScan(request: PointerScanRequest) {
        helperManager.ensureDaemon()
        sendOrThrow(
            METHOD_START_POINTER_SCAN,
            JSONObject().apply {
                put("pid", request.pid)
                put("targetAddress", request.targetAddress)
                put("pointerWidth", request.pointerWidth)
                put("maxOffset", request.maxOffset)
                put("alignment", request.alignment)
                put(
                    "rangeSectionKeys",
                    JSONArray().apply {
                        request.rangeSectionKeys.forEach(::put)
                    }
                )
                put("scanAllReadableRegions", request.scanAllReadableRegions)
            }
        )
    }

    fun startPointerAutoChase(request: PointerAutoChaseRequest) {
        helperManager.ensureDaemon()
        sendOrThrow(
            METHOD_START_POINTER_AUTO_CHASE,
            JSONObject().apply {
                put("pid", request.pid)
                put("targetAddress", request.targetAddress)
                put("pointerWidth", request.pointerWidth)
                put("maxOffset", request.maxOffset)
                put("alignment", request.alignment)
                put("maxDepth", request.maxDepth)
                put(
                    "rangeSectionKeys",
                    JSONArray().apply {
                        request.rangeSectionKeys.forEach(::put)
                    }
                )
                put("scanAllReadableRegions", request.scanAllReadableRegions)
            }
        )
    }

    fun cancelPointerScan() {
        if (!helperManager.isDaemonAlive()) {
            return
        }

        sendOrThrow(METHOD_CANCEL_POINTER_SCAN, null)
    }

    fun cancelPointerAutoChase() {
        if (!helperManager.isDaemonAlive()) {
            return
        }

        sendOrThrow(METHOD_CANCEL_POINTER_AUTO_CHASE, null)
    }

    fun resetPointerScanSession() {
        if (!helperManager.isDaemonAlive()) {
            return
        }

        sendOrThrow(METHOD_RESET_POINTER_SCAN_SESSION, null)
    }

    fun resetPointerAutoChase() {
        if (!helperManager.isDaemonAlive()) {
            return
        }

        sendOrThrow(METHOD_RESET_POINTER_AUTO_CHASE, null)
    }

    private fun sendOrThrow(method: String, params: JSONObject?): JSONObject {
        val response = synchronized(connectionLock) {
            var lastError: Exception? = null
            repeat(2) { attempt ->
                try {
                    ensureConnectionLocked()
                    val currentRequestId = requestId.incrementAndGet()
                    val request = JSONObject().apply {
                        put("requestId", currentRequestId)
                        put("method", method)
                        if (params != null) put("params", params)
                    }
                    writer!!.apply {
                        write(request.toString())
                        newLine()
                        flush()
                    }
                    val responseText = reader!!.readLine()
                        ?: throw IllegalStateException("Empty response from memory helper.")
                    val candidate = JSONObject(responseText)
                    check(candidate.optLong("requestId", -1L) == currentRequestId) {
                        "Mismatched response from memory helper."
                    }
                    return@synchronized candidate
                } catch (error: Exception) {
                    lastError = error
                    closeConnectionLocked()
                    helperManager.invalidateDaemonState()
                    if (attempt == 0) helperManager.ensureDaemon()
                }
            }
            throw lastError ?: IllegalStateException("Memory helper request failed.")
        }
        if (!response.optBoolean("ok", false)) {
            throw IllegalStateException(response.optString("error", "Unknown memory helper error."))
        }
        return response
    }

    private fun ensureConnectionLocked() {
        if (socket != null && reader != null && writer != null) return
        val nextSocket = LocalSocket()
        try {
            nextSocket.connect(
                LocalSocketAddress(
                    helperManager.socketName(),
                    LocalSocketAddress.Namespace.ABSTRACT,
                ),
            )
            nextSocket.soTimeout = SOCKET_TIMEOUT_MS
            socket = nextSocket
            reader = nextSocket.inputStream.bufferedReader()
            writer = nextSocket.outputStream.bufferedWriter()
        } catch (error: Exception) {
            kotlin.runCatching { nextSocket.close() }
            throw error
        }
    }

    private fun closeConnectionLocked() {
        kotlin.runCatching { reader?.close() }
        kotlin.runCatching { writer?.close() }
        kotlin.runCatching { socket?.close() }
        reader = null
        writer = null
        socket = null
    }

    private fun buildSearchValueJson(value: SearchValue): JSONObject {
        return JSONObject().apply {
            put("type", value.type.ordinal)
            put("textValue", value.textValue)
            put("bytesHex", encodeHex(value.bytesValue))
            put("littleEndian", value.littleEndian)
        }
    }

    private fun buildPointerAutoChaseLayers(items: JSONArray?): List<PointerAutoChaseLayerState> {
        if (items == null) {
            return emptyList()
        }

        return List(items.length()) { index ->
            val item = items.getJSONObject(index)
            PointerAutoChaseLayerState(
                layerIndex = item.getLong("layerIndex"),
                targetAddress = item.getLong("targetAddress"),
                selectedPointerAddress = item.optLong("selectedPointerAddress")
                    .takeIf { item.has("selectedPointerAddress") && !item.isNull("selectedPointerAddress") },
                selectedResult = item.optJSONObject("selectedResult")?.let { result ->
                    PointerScanResult(
                        pointerAddress = result.getLong("pointerAddress"),
                        baseAddress = result.getLong("baseAddress"),
                        targetAddress = result.getLong("targetAddress"),
                        offset = result.getLong("offset"),
                        regionStart = result.getLong("regionStart"),
                        regionTypeKey = result.optString("regionTypeKey", "other")
                    )
                },
                resultCount = item.getLong("resultCount"),
                hasMore = item.optBoolean("hasMore", false),
                isTerminalLayer = item.optBoolean("isTerminalLayer", false),
                stopReasonKey = item.optString("stopReasonKey"),
                initialResults = buildPointerResults(item.optJSONArray("initialResults"))
            )
        }
    }

    private fun buildPointerResults(items: JSONArray?): List<PointerScanResult> {
        if (items == null) {
            return emptyList()
        }

        return List(items.length()) { index ->
            val item = items.getJSONObject(index)
            PointerScanResult(
                pointerAddress = item.getLong("pointerAddress"),
                baseAddress = item.getLong("baseAddress"),
                targetAddress = item.getLong("targetAddress"),
                offset = item.getLong("offset"),
                regionStart = item.getLong("regionStart"),
                regionTypeKey = item.optString("regionTypeKey", "other")
            )
        }
    }

    private fun buildMemoryBreakpoint(item: JSONObject): MemoryBreakpoint {
        return MemoryBreakpoint(
            id = item.getString("id"),
            pid = item.getLong("pid"),
            address = item.getLong("address"),
            type = SearchValueType.entries[item.getInt("type")],
            length = item.getLong("length"),
            accessType = MemoryBreakpointAccessType.entries[item.getInt("accessType")],
            enabled = item.optBoolean("enabled", true),
            pauseProcessOnHit = item.optBoolean("pauseProcessOnHit", true),
            hitCount = item.optLong("hitCount"),
            createdAtMillis = item.optLong("createdAtMillis"),
            lastHitAtMillis = item.optLong("lastHitAtMillis")
                .takeIf { item.has("lastHitAtMillis") && !item.isNull("lastHitAtMillis") },
            lastError = item.optString("lastError")
        )
    }

    private fun buildMemoryBreakpointHit(item: JSONObject): MemoryBreakpointHit {
        return MemoryBreakpointHit(
            breakpointId = item.getString("breakpointId"),
            pid = item.getLong("pid"),
            address = item.getLong("address"),
            accessType = MemoryBreakpointAccessType.entries[item.getInt("accessType")],
            threadId = item.getLong("threadId"),
            timestampMillis = item.getLong("timestampMillis"),
            oldValue = decodeHex(item.optString("oldValueHex")),
            newValue = decodeHex(item.optString("newValueHex")),
            pc = item.optLong("pc"),
            moduleName = item.optString("moduleName"),
            moduleBase = item.optLong("moduleBase"),
            moduleOffset = item.optLong("moduleOffset"),
            instructionText = item.optString("instructionText")
        )
    }
}
