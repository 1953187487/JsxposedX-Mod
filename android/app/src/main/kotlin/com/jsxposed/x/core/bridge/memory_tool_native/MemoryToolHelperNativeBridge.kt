package com.jsxposed.xmod.core.bridge.memory_tool_native

object MemoryToolHelperNativeBridge {
    external fun getMemoryRegionsJson(
        pid: Long,
        offset: Int,
        limit: Int,
        readableOnly: Boolean,
        includeAnonymous: Boolean,
        includeFileBacked: Boolean
    ): String

    external fun getSearchSessionStateJson(): String

    external fun getSearchTaskStateJson(): String

    external fun getSearchResultsJson(offset: Int, limit: Int): String

    external fun getPointerScanSessionStateJson(): String

    external fun getPointerScanTaskStateJson(): String

    external fun getPointerScanResultsJson(offset: Int, limit: Int): String

    external fun getPointerScanChaseHintJson(): String

    external fun getPointerAutoChaseStateJson(): String

    external fun getPointerAutoChaseLayerResultsJson(
        layerIndex: Int,
        offset: Int,
        limit: Int
    ): String

    external fun addMemoryBreakpointJson(
        pid: Long,
        address: Long,
        type: Int,
        length: Int,
        accessType: Int,
        enabled: Boolean,
        pauseProcessOnHit: Boolean
    ): String

    external fun removeMemoryBreakpoint(breakpointId: String)

    external fun setMemoryBreakpointEnabled(breakpointId: String, enabled: Boolean)

    external fun listMemoryBreakpointsJson(pid: Long): String

    external fun getMemoryBreakpointStateJson(pid: Long): String

    external fun getMemoryBreakpointHitsJson(pid: Long, offset: Int, limit: Int): String

    external fun clearMemoryBreakpointHits(pid: Long)

    external fun resumeAfterBreakpoint(pid: Long)

    external fun patchMemoryInstructionJson(
        pid: Long,
        address: Long,
        inputText: String
    ): String

    external fun disassembleMemoryJson(pid: Long, addresses: LongArray): String

    external fun readMemoryValuesJson(
        pids: LongArray,
        addresses: LongArray,
        types: IntArray,
        lengths: IntArray
    ): String

    external fun writeMemoryValue(
        address: Long,
        type: Int,
        textValue: String?,
        bytesValue: ByteArray?,
        littleEndian: Boolean
    )

    external fun setMemoryFreeze(
        address: Long,
        type: Int,
        textValue: String?,
        bytesValue: ByteArray?,
        littleEndian: Boolean,
        enabled: Boolean
    )

    external fun getFrozenMemoryValuesJson(): String

    external fun firstScan(
        pid: Long,
        type: Int,
        textValue: String?,
        bytesValue: ByteArray?,
        littleEndian: Boolean,
        matchMode: Int,
        rangeSectionKeys: Array<String>,
        scanAllReadableRegions: Boolean
    )

    external fun nextScan(
        type: Int,
        textValue: String?,
        bytesValue: ByteArray?,
        littleEndian: Boolean,
        matchMode: Int
    )

    external fun cancelSearch()

    external fun resetSearchSession()

    external fun startPointerScan(
        pid: Long,
        targetAddress: Long,
        pointerWidth: Int,
        maxOffset: Long,
        alignment: Int,
        rangeSectionKeys: Array<String>,
        scanAllReadableRegions: Boolean
    )

    external fun startPointerAutoChase(
        pid: Long,
        targetAddress: Long,
        pointerWidth: Int,
        maxOffset: Long,
        alignment: Int,
        maxDepth: Int,
        rangeSectionKeys: Array<String>,
        scanAllReadableRegions: Boolean
    )

    external fun cancelPointerScan()

    external fun cancelPointerAutoChase()

    external fun resetPointerScanSession()

    external fun resetPointerAutoChase()
}
