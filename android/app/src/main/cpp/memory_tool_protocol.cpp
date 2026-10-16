#include "memory_tool_protocol.h"

#include <sstream>

#include "memory_tool_utils.h"

namespace memory_tool::protocol {

namespace {

const char* ToJsonBool(bool value) {
    return value ? "true" : "false";
}

int ToRawType(SearchValueType type) {
    return static_cast<int>(type);
}

int ToRawTaskStatus(SearchTaskStatus status) {
    return static_cast<int>(status);
}

int ToRawBreakpointAccessType(MemoryBreakpointAccessType type) {
    return static_cast<int>(type);
}

}  // namespace

std::string SerializeMemoryRegions(const std::vector<MemoryRegion>& regions) {
    std::ostringstream stream;
    stream << '[';
    for (size_t index = 0; index < regions.size(); ++index) {
        const MemoryRegion& region = regions[index];
        if (index > 0) {
            stream << ',';
        }
        stream << '{'
               << "\"startAddress\":" << region.start_address << ','
               << "\"endAddress\":" << region.end_address << ','
               << "\"perms\":\"" << utils::JsonEscape(region.perms) << "\","
               << "\"size\":" << region.size << ','
               << "\"path\":\"" << utils::JsonEscape(region.path) << "\","
               << "\"isAnonymous\":" << ToJsonBool(region.is_anonymous)
               << '}';
    }
    stream << ']';
    return stream.str();
}

std::string SerializeSearchSessionState(const SearchSessionStateView& state) {
    std::ostringstream stream;
    stream << '{'
           << "\"hasActiveSession\":" << ToJsonBool(state.has_active_session) << ','
           << "\"pid\":" << state.pid << ','
           << "\"type\":" << ToRawType(state.type) << ','
           << "\"regionCount\":" << state.region_count << ','
           << "\"resultCount\":" << state.result_count << ','
           << "\"exactMode\":" << ToJsonBool(state.exact_mode) << ','
           << "\"littleEndian\":" << ToJsonBool(state.little_endian)
           << '}';
    return stream.str();
}

std::string SerializeSearchTaskState(const SearchTaskStateView& state) {
    std::ostringstream stream;
    stream << '{'
           << "\"status\":" << ToRawTaskStatus(state.status) << ','
           << "\"isFirstScan\":" << ToJsonBool(state.is_first_scan) << ','
           << "\"pid\":" << state.pid << ','
           << "\"processedRegions\":" << state.processed_region_count << ','
           << "\"totalRegions\":" << state.total_region_count << ','
           << "\"processedEntries\":" << state.processed_entry_count << ','
           << "\"totalEntries\":" << state.total_entry_count << ','
           << "\"processedBytes\":" << state.processed_byte_count << ','
           << "\"totalBytes\":" << state.total_byte_count << ','
           << "\"resultCount\":" << state.result_count << ','
           << "\"elapsedMilliseconds\":" << state.elapsed_milliseconds << ','
           << "\"canCancel\":" << ToJsonBool(state.can_cancel) << ','
           << "\"message\":\"" << utils::JsonEscape(state.message) << "\""
           << '}';
    return stream.str();
}

std::string SerializeSearchResults(const std::vector<SearchResultView>& results) {
    std::ostringstream stream;
    stream << '[';
    for (size_t index = 0; index < results.size(); ++index) {
        const SearchResultView& result = results[index];
        if (index > 0) {
            stream << ',';
        }
        stream << '{'
               << "\"address\":" << result.address << ','
               << "\"regionStart\":" << result.region_start << ','
               << "\"regionTypeKey\":\"" << utils::JsonEscape(result.region_type_key) << "\","
               << "\"type\":" << ToRawType(result.type) << ','
               << "\"rawBytesHex\":\"" << utils::HexEncode(result.raw_bytes) << "\","
               << "\"displayValue\":\"" << utils::JsonEscape(result.display_value) << "\""
               << '}';
    }
    stream << ']';
    return stream.str();
}

std::string SerializePointerScanSessionState(const PointerScanSessionStateView& state) {
    std::ostringstream stream;
    stream << '{'
           << "\"hasActiveSession\":" << ToJsonBool(state.has_active_session) << ','
           << "\"pid\":" << state.pid << ','
           << "\"targetAddress\":" << state.target_address << ','
           << "\"pointerWidth\":" << state.pointer_width << ','
           << "\"maxOffset\":" << state.max_offset << ','
           << "\"alignment\":" << state.alignment << ','
           << "\"regionCount\":" << state.region_count << ','
           << "\"resultCount\":" << state.result_count
           << '}';
    return stream.str();
}

std::string SerializePointerScanTaskState(const PointerScanTaskStateView& state) {
    std::ostringstream stream;
    stream << '{'
           << "\"status\":" << ToRawTaskStatus(state.status) << ','
           << "\"pid\":" << state.pid << ','
           << "\"processedRegions\":" << state.processed_region_count << ','
           << "\"totalRegions\":" << state.total_region_count << ','
           << "\"processedEntries\":" << state.processed_entry_count << ','
           << "\"totalEntries\":" << state.total_entry_count << ','
           << "\"processedBytes\":" << state.processed_byte_count << ','
           << "\"totalBytes\":" << state.total_byte_count << ','
           << "\"resultCount\":" << state.result_count << ','
           << "\"elapsedMilliseconds\":" << state.elapsed_milliseconds << ','
           << "\"canCancel\":" << ToJsonBool(state.can_cancel) << ','
           << "\"message\":\"" << utils::JsonEscape(state.message) << "\""
           << '}';
    return stream.str();
}

std::string SerializePointerScanResults(const std::vector<PointerScanResultEntry>& results) {
    std::ostringstream stream;
    stream << '[';
    for (size_t index = 0; index < results.size(); ++index) {
        const PointerScanResultEntry& result = results[index];
        if (index > 0) {
            stream << ',';
        }
        stream << '{'
               << "\"pointerAddress\":" << result.pointer_address << ','
               << "\"baseAddress\":" << result.base_address << ','
               << "\"targetAddress\":" << result.target_address << ','
               << "\"offset\":" << result.offset << ','
               << "\"regionStart\":" << result.region_start << ','
               << "\"regionTypeKey\":\"" << utils::JsonEscape(result.region_type_key) << "\""
               << '}';
    }
    stream << ']';
    return stream.str();
}

std::string SerializePointerScanChaseHint(const PointerScanChaseHintView& hint) {
    std::ostringstream stream;
    stream << '{'
           << "\"result\":";
    if (hint.has_result) {
        stream << '{'
               << "\"pointerAddress\":" << hint.result.pointer_address << ','
               << "\"baseAddress\":" << hint.result.base_address << ','
               << "\"targetAddress\":" << hint.result.target_address << ','
               << "\"offset\":" << hint.result.offset << ','
               << "\"regionStart\":" << hint.result.region_start << ','
               << "\"regionTypeKey\":\"" << utils::JsonEscape(hint.result.region_type_key) << "\""
               << '}';
    } else {
        stream << "null";
    }
    stream << ','
           << "\"isTerminalStaticCandidate\":"
           << ToJsonBool(hint.is_terminal_static_candidate) << ','
           << "\"stopReasonKey\":\"" << utils::JsonEscape(hint.stop_reason_key) << "\""
           << '}';
    return stream.str();
}

std::string SerializePointerAutoChaseState(const PointerAutoChaseStateView& state) {
    std::ostringstream stream;
    stream << '{'
           << "\"isRunning\":" << ToJsonBool(state.is_running) << ','
           << "\"pid\":" << state.pid << ','
           << "\"maxDepth\":" << state.max_depth << ','
           << "\"currentDepth\":" << state.current_depth << ','
           << "\"layers\":[";
    for (size_t index = 0; index < state.layers.size(); ++index) {
        const PointerAutoChaseLayerStateView& layer = state.layers[index];
        if (index > 0) {
            stream << ',';
        }
        stream << '{'
               << "\"layerIndex\":" << layer.layer_index << ','
               << "\"targetAddress\":" << layer.target_address << ','
               << "\"selectedPointerAddress\":";
        if (layer.has_selected_pointer_address) {
            stream << layer.selected_pointer_address;
        } else {
            stream << "null";
        }
        stream << ','
               << "\"selectedResult\":";
        if (layer.has_selected_result) {
            stream << '{'
                   << "\"pointerAddress\":" << layer.selected_result.pointer_address << ','
                   << "\"baseAddress\":" << layer.selected_result.base_address << ','
                   << "\"targetAddress\":" << layer.selected_result.target_address << ','
                   << "\"offset\":" << layer.selected_result.offset << ','
                   << "\"regionStart\":" << layer.selected_result.region_start << ','
                   << "\"regionTypeKey\":\""
                   << utils::JsonEscape(layer.selected_result.region_type_key) << "\""
                   << '}';
        } else {
            stream << "null";
        }
        stream << ','
               << "\"resultCount\":" << layer.result_count << ','
               << "\"hasMore\":" << ToJsonBool(layer.has_more) << ','
               << "\"isTerminalLayer\":" << ToJsonBool(layer.is_terminal_layer) << ','
               << "\"stopReasonKey\":\"" << utils::JsonEscape(layer.stop_reason_key)
               << "\","
               << "\"initialResults\":"
               << SerializePointerScanResults(layer.initial_results)
               << '}';
    }
    stream << "],"
           << "\"message\":\"" << utils::JsonEscape(state.message) << "\""
           << '}';
    return stream.str();
}

std::string SerializeMemoryBreakpoints(const std::vector<MemoryBreakpointView>& breakpoints) {
    std::ostringstream stream;
    stream << '[';
    for (size_t index = 0; index < breakpoints.size(); ++index) {
        const MemoryBreakpointView& breakpoint = breakpoints[index];
        if (index > 0) {
            stream << ',';
        }
        stream << '{'
               << "\"id\":\"" << utils::JsonEscape(breakpoint.id) << "\","
               << "\"pid\":" << breakpoint.pid << ','
               << "\"address\":" << breakpoint.address << ','
               << "\"type\":" << ToRawType(breakpoint.type) << ','
               << "\"length\":" << breakpoint.length << ','
               << "\"accessType\":" << ToRawBreakpointAccessType(breakpoint.access_type) << ','
               << "\"enabled\":" << ToJsonBool(breakpoint.enabled) << ','
               << "\"pauseProcessOnHit\":"
               << ToJsonBool(breakpoint.pause_process_on_hit) << ','
               << "\"hitCount\":" << breakpoint.hit_count << ','
               << "\"createdAtMillis\":" << breakpoint.created_at_millis << ','
               << "\"lastHitAtMillis\":";
        if (breakpoint.has_last_hit_at) {
            stream << breakpoint.last_hit_at_millis;
        } else {
            stream << "null";
        }
        stream << ','
               << "\"lastError\":\"" << utils::JsonEscape(breakpoint.last_error) << "\""
               << '}';
    }
    stream << ']';
    return stream.str();
}

std::string SerializeMemoryBreakpointState(const MemoryBreakpointStateView& state) {
    std::ostringstream stream;
    stream << '{'
           << "\"isSupported\":" << ToJsonBool(state.is_supported) << ','
           << "\"isProcessPaused\":" << ToJsonBool(state.is_process_paused) << ','
           << "\"activeBreakpointCount\":" << state.active_breakpoint_count << ','
           << "\"pendingHitCount\":" << state.pending_hit_count << ','
           << "\"architecture\":\"" << utils::JsonEscape(state.architecture) << "\","
           << "\"lastError\":\"" << utils::JsonEscape(state.last_error) << "\""
           << '}';
    return stream.str();
}

std::string SerializeMemoryBreakpointHits(const std::vector<MemoryBreakpointHitView>& hits) {
    std::ostringstream stream;
    stream << '[';
    for (size_t index = 0; index < hits.size(); ++index) {
        const MemoryBreakpointHitView& hit = hits[index];
        if (index > 0) {
            stream << ',';
        }
        stream << '{'
               << "\"breakpointId\":\"" << utils::JsonEscape(hit.breakpoint_id) << "\","
               << "\"pid\":" << hit.pid << ','
               << "\"address\":" << hit.address << ','
               << "\"accessType\":" << ToRawBreakpointAccessType(hit.access_type) << ','
               << "\"threadId\":" << hit.thread_id << ','
               << "\"timestampMillis\":" << hit.timestamp_millis << ','
               << "\"oldValueHex\":\"" << utils::HexEncode(hit.old_value) << "\","
               << "\"newValueHex\":\"" << utils::HexEncode(hit.new_value) << "\","
               << "\"pc\":" << hit.pc << ','
               << "\"moduleName\":\"" << utils::JsonEscape(hit.module_name) << "\","
               << "\"moduleBase\":" << hit.module_base << ','
               << "\"moduleOffset\":" << hit.module_offset << ','
               << "\"instructionText\":\"" << utils::JsonEscape(hit.instruction_text) << "\""
               << '}';
    }
    stream << ']';
    return stream.str();
}

std::string SerializeInstructionPatchResult(const InstructionPatchResultView& result) {
    std::ostringstream stream;
    stream << '{'
           << "\"address\":" << result.address << ','
           << "\"architecture\":\"" << utils::JsonEscape(result.architecture) << "\","
           << "\"instructionSize\":" << result.instruction_size << ','
           << "\"beforeBytesHex\":\"" << utils::HexEncode(result.before_bytes) << "\","
           << "\"afterBytesHex\":\"" << utils::HexEncode(result.after_bytes) << "\","
           << "\"instructionText\":\"" << utils::JsonEscape(result.instruction_text) << "\""
           << '}';
    return stream.str();
}

std::string SerializeMemoryInstructions(const std::vector<MemoryInstructionView>& instructions) {
    std::ostringstream stream;
    stream << '[';
    for (size_t index = 0; index < instructions.size(); ++index) {
        const MemoryInstructionView& instruction = instructions[index];
        if (index > 0) {
            stream << ',';
        }
        stream << '{'
               << "\"address\":" << instruction.address << ','
               << "\"architecture\":\"" << utils::JsonEscape(instruction.architecture) << "\","
               << "\"instructionSize\":" << instruction.instruction_size << ','
               << "\"rawBytesHex\":\"" << utils::HexEncode(instruction.raw_bytes) << "\","
               << "\"instructionText\":\"" << utils::JsonEscape(instruction.instruction_text)
               << "\""
               << '}';
    }
    stream << ']';
    return stream.str();
}

std::string SerializeMemoryValuePreviews(const std::vector<MemoryValuePreview>& previews) {
    std::ostringstream stream;
    stream << '[';
    for (size_t index = 0; index < previews.size(); ++index) {
        const MemoryValuePreview& preview = previews[index];
        if (index > 0) {
            stream << ',';
        }
        stream << '{'
               << "\"address\":" << preview.address << ','
               << "\"type\":" << ToRawType(preview.type) << ','
               << "\"rawBytesHex\":\"" << utils::HexEncode(preview.raw_bytes) << "\","
               << "\"displayValue\":\"" << utils::JsonEscape(preview.display_value) << "\""
               << '}';
    }
    stream << ']';
    return stream.str();
}

std::string SerializeFrozenMemoryValues(const std::vector<FrozenMemoryValueView>& values) {
    std::ostringstream stream;
    stream << '[';
    for (size_t index = 0; index < values.size(); ++index) {
        const FrozenMemoryValueView& value = values[index];
        if (index > 0) {
            stream << ',';
        }
        stream << '{'
               << "\"pid\":" << value.pid << ','
               << "\"address\":" << value.address << ','
               << "\"type\":" << ToRawType(value.type) << ','
               << "\"rawBytesHex\":\"" << utils::HexEncode(value.raw_bytes) << "\","
               << "\"displayValue\":\"" << utils::JsonEscape(value.display_value) << "\""
               << '}';
    }
    stream << ']';
    return stream.str();
}

}  // namespace memory_tool::protocol
