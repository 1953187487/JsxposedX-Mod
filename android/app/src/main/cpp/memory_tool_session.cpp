#include "memory_tool_session.h"

namespace memory_tool {

void SearchSession::Clear() {
    has_active_session = false;
    pid = 0;
    type = SearchValueType::kI32;
    mode = SearchRuntimeMode::kStandard;
    fuzzy_compare_mode = FuzzyCompareMode::kUnknown;
    exact_mode = true;
    little_endian = true;
    bytes_display_encoding = BytesDisplayEncoding::kHex;
    value_size = 0;
    current_value_bytes.clear();
    current_display_value.clear();
    group_plan.items.clear();
    group_plan.window = 0;
    group_plan.display_value.clear();
    regions.clear();
    fuzzy_initial_regions.reset();
    fuzzy_candidates.reset();
    group_anchor_results.clear();
    results.clear();
}

void PointerScanSession::Clear() {
    has_active_session = false;
    pid = 0;
    target_address = 0;
    pointer_width = 0;
    max_offset = 0;
    alignment = 0;
    regions.clear();
    results.clear();
}

void PointerAutoChaseSession::Clear() {
    has_active_session = false;
    pid = 0;
    pointer_width = 0;
    max_offset = 0;
    alignment = 0;
    max_depth = 0;
    range_section_keys.clear();
    scan_all_readable_regions = true;
    layers.clear();
}

}  // namespace memory_tool
