#ifndef JSXPOSEDX_MEMORY_TOOL_SESSION_H
#define JSXPOSEDX_MEMORY_TOOL_SESSION_H

#include <cstddef>
#include <cstdint>
#include <memory>
#include <string>
#include <vector>

namespace memory_tool {

enum class SearchValueType : int {
    kI8 = 0,
    kI16 = 1,
    kI32 = 2,
    kI64 = 3,
    kF32 = 4,
    kF64 = 5,
    kBytes = 6,
};

enum class SearchMatchMode : int {
    kExact = 0,
};

enum class SearchTaskStatus : int {
    kIdle = 0,
    kRunning = 1,
    kCompleted = 2,
    kCancelled = 3,
    kFailed = 4,
};

enum class MemoryBreakpointAccessType : int {
    kRead = 0,
    kWrite = 1,
    kReadWrite = 2,
};

enum class SearchRuntimeMode : int {
    kStandard = 0,
    kXor = 1,
    kAuto = 2,
    kFuzzy = 3,
    kGroup = 4,
};

enum class FuzzyCompareMode : int {
    kUnknown = 0,
    kUnchanged = 1,
    kChanged = 2,
    kIncreased = 3,
    kDecreased = 4,
};

enum class BytesDisplayEncoding : int {
    kHex = 0,
    kUtf8 = 1,
    kUtf16Le = 2,
};

struct SearchValue {
    SearchValueType type = SearchValueType::kI32;
    std::string text_value;
    std::vector<uint8_t> bytes_value;
    bool little_endian = true;
};

struct MemoryRegion {
    uint64_t start_address = 0;
    uint64_t end_address = 0;
    std::string perms;
    uint64_t size = 0;
    std::string path;
    bool is_anonymous = false;
};

struct SearchResultEntry {
    uint64_t address = 0;
    uint64_t region_start = 0;
    SearchValueType matched_type = SearchValueType::kI32;
    std::vector<uint8_t> raw_bytes;
    std::string display_value;
    bool has_display_override = false;
    uint64_t group_anchor_address = 0;
};

struct SearchResultView {
    uint64_t address = 0;
    uint64_t region_start = 0;
    std::string region_type_key;
    SearchValueType type = SearchValueType::kI32;
    std::vector<uint8_t> raw_bytes;
    std::string display_value;
};

struct PointerScanResultEntry {
    uint64_t pointer_address = 0;
    uint64_t base_address = 0;
    uint64_t target_address = 0;
    uint64_t offset = 0;
    uint64_t region_start = 0;
    std::string region_type_key;
};

struct PointerScanChaseHintView {
    bool has_result = false;
    PointerScanResultEntry result;
    bool is_terminal_static_candidate = false;
    std::string stop_reason_key;
};

struct MemoryReadRequest {
    int pid = 0;
    uint64_t address = 0;
    SearchValueType type = SearchValueType::kI32;
    size_t length = 0;
};

struct MemoryValuePreview {
    uint64_t address = 0;
    SearchValueType type = SearchValueType::kI32;
    std::vector<uint8_t> raw_bytes;
    std::string display_value;
};

struct MemoryWriteRequest {
    uint64_t address = 0;
    SearchValue value;
};

struct MemoryFreezeRequest {
    uint64_t address = 0;
    SearchValue value;
    bool enabled = false;
};

struct FrozenMemoryValueView {
    int pid = 0;
    uint64_t address = 0;
    SearchValueType type = SearchValueType::kI32;
    std::vector<uint8_t> raw_bytes;
    std::string display_value;
};

struct SearchSessionStateView {
    bool has_active_session = false;
    int pid = 0;
    SearchValueType type = SearchValueType::kI32;
    size_t region_count = 0;
    size_t result_count = 0;
    bool exact_mode = true;
    bool little_endian = true;
};

struct SearchTaskStateView {
    SearchTaskStatus status = SearchTaskStatus::kIdle;
    bool is_first_scan = true;
    int pid = 0;
    size_t processed_region_count = 0;
    size_t total_region_count = 0;
    size_t processed_entry_count = 0;
    size_t total_entry_count = 0;
    uint64_t processed_byte_count = 0;
    uint64_t total_byte_count = 0;
    size_t result_count = 0;
    uint64_t elapsed_milliseconds = 0;
    bool can_cancel = false;
    std::string message;
};

struct PointerScanSessionStateView {
    bool has_active_session = false;
    int pid = 0;
    uint64_t target_address = 0;
    size_t pointer_width = 0;
    uint64_t max_offset = 0;
    size_t alignment = 0;
    size_t region_count = 0;
    size_t result_count = 0;
};

struct PointerScanTaskStateView {
    SearchTaskStatus status = SearchTaskStatus::kIdle;
    int pid = 0;
    size_t processed_region_count = 0;
    size_t total_region_count = 0;
    size_t processed_entry_count = 0;
    size_t total_entry_count = 0;
    uint64_t processed_byte_count = 0;
    uint64_t total_byte_count = 0;
    size_t result_count = 0;
    uint64_t elapsed_milliseconds = 0;
    bool can_cancel = false;
    std::string message;
};

struct GroupSearchItem {
    SearchValueType type = SearchValueType::kI32;
    std::vector<uint8_t> pattern;
    std::string display_value;
    std::string result_display_value;
    bool has_offset = false;
    size_t offset = 0;
};

struct GroupSearchPlan {
    std::vector<GroupSearchItem> items;
    size_t window = 0;
    std::string display_value;
};

struct AddMemoryBreakpointRequest {
    int pid = 0;
    uint64_t address = 0;
    SearchValueType type = SearchValueType::kI32;
    size_t length = 0;
    MemoryBreakpointAccessType access_type = MemoryBreakpointAccessType::kWrite;
    bool enabled = true;
    bool pause_process_on_hit = true;
};

struct MemoryBreakpointView {
    std::string id;
    int pid = 0;
    uint64_t address = 0;
    SearchValueType type = SearchValueType::kI32;
    size_t length = 0;
    MemoryBreakpointAccessType access_type = MemoryBreakpointAccessType::kWrite;
    bool enabled = false;
    bool pause_process_on_hit = true;
    uint64_t hit_count = 0;
    uint64_t created_at_millis = 0;
    bool has_last_hit_at = false;
    uint64_t last_hit_at_millis = 0;
    std::string last_error;
};

struct MemoryBreakpointHitView {
    std::string breakpoint_id;
    int pid = 0;
    uint64_t address = 0;
    MemoryBreakpointAccessType access_type = MemoryBreakpointAccessType::kWrite;
    int thread_id = 0;
    uint64_t timestamp_millis = 0;
    std::vector<uint8_t> old_value;
    std::vector<uint8_t> new_value;
    uint64_t pc = 0;
    std::string module_name;
    uint64_t module_base = 0;
    uint64_t module_offset = 0;
    std::string instruction_text;
};

struct MemoryBreakpointStateView {
    bool is_supported = false;
    bool is_process_paused = false;
    size_t active_breakpoint_count = 0;
    size_t pending_hit_count = 0;
    std::string architecture;
    std::string last_error;
};

struct InstructionPatchResultView {
    uint64_t address = 0;
    std::string architecture;
    size_t instruction_size = 0;
    std::vector<uint8_t> before_bytes;
    std::vector<uint8_t> after_bytes;
    std::string instruction_text;
};

struct MemoryInstructionView {
    uint64_t address = 0;
    std::string architecture;
    size_t instruction_size = 0;
    std::vector<uint8_t> raw_bytes;
    std::string instruction_text;
};

struct PointerAutoChaseLayerStateView {
    size_t layer_index = 0;
    uint64_t target_address = 0;
    bool has_selected_pointer_address = false;
    uint64_t selected_pointer_address = 0;
    bool has_selected_result = false;
    PointerScanResultEntry selected_result;
    size_t result_count = 0;
    bool has_more = false;
    bool is_terminal_layer = false;
    std::string stop_reason_key;
    std::vector<PointerScanResultEntry> initial_results;
    std::vector<PointerScanResultEntry> results;
};

struct PointerAutoChaseStateView {
    bool is_running = false;
    int pid = 0;
    size_t max_depth = 0;
    size_t current_depth = 0;
    std::vector<PointerAutoChaseLayerStateView> layers;
    std::string message;
};

struct FuzzyCandidate {
    uint64_t address = 0;
    uint64_t region_start = 0;
    uint64_t previous_value_bits = 0;
};

struct FuzzyInitialRegion {
    uint64_t region_start = 0;
    size_t slot_count = 0;
    std::vector<uint8_t> snapshot_bytes;
};

struct SearchSession {
    bool has_active_session = false;
    int pid = 0;
    SearchValueType type = SearchValueType::kI32;
    SearchRuntimeMode mode = SearchRuntimeMode::kStandard;
    FuzzyCompareMode fuzzy_compare_mode = FuzzyCompareMode::kUnknown;
    bool exact_mode = true;
    bool little_endian = true;
    BytesDisplayEncoding bytes_display_encoding = BytesDisplayEncoding::kHex;
    size_t value_size = 0;
    std::vector<uint8_t> current_value_bytes;
    std::string current_display_value;
    GroupSearchPlan group_plan;
    std::vector<MemoryRegion> regions;
    std::shared_ptr<std::vector<FuzzyInitialRegion>> fuzzy_initial_regions;
    std::shared_ptr<std::vector<FuzzyCandidate>> fuzzy_candidates;
    std::vector<SearchResultEntry> group_anchor_results;
    std::vector<SearchResultEntry> results;

    void Clear();
};

struct PointerScanSession {
    bool has_active_session = false;
    int pid = 0;
    uint64_t target_address = 0;
    size_t pointer_width = 0;
    uint64_t max_offset = 0;
    size_t alignment = 0;
    std::vector<MemoryRegion> regions;
    std::vector<PointerScanResultEntry> results;

    void Clear();
};

struct PointerAutoChaseSession {
    bool has_active_session = false;
    int pid = 0;
    size_t pointer_width = 0;
    uint64_t max_offset = 0;
    size_t alignment = 0;
    size_t max_depth = 0;
    std::vector<std::string> range_section_keys;
    bool scan_all_readable_regions = true;
    std::vector<PointerAutoChaseLayerStateView> layers;

    void Clear();
};

}  // namespace memory_tool

#endif  // JSXPOSEDX_MEMORY_TOOL_SESSION_H
