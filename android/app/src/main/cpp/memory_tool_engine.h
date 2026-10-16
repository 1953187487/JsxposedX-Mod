#ifndef JSXPOSEDX_MEMORY_TOOL_ENGINE_H
#define JSXPOSEDX_MEMORY_TOOL_ENGINE_H

#include <atomic>
#include <chrono>
#include <condition_variable>
#include <memory>
#include <mutex>
#include <string>
#include <vector>

#include "memory_tool_breakpoint.h"
#include "memory_tool_scanner.h"
#include "memory_tool_session.h"

namespace memory_tool {

class MemoryToolEngine {
public:
    static MemoryToolEngine& Instance();

    std::vector<MemoryRegion> GetMemoryRegions(int pid,
                                               int offset,
                                               int limit,
                                               bool readable_only,
                                               bool include_anonymous,
                                               bool include_file_backed);

    SearchSessionStateView GetSearchSessionState();

    SearchTaskStateView GetSearchTaskState();

    std::vector<SearchResultView> GetSearchResults(int offset, int limit);

    PointerScanSessionStateView GetPointerScanSessionState();

    PointerScanTaskStateView GetPointerScanTaskState();

    std::vector<PointerScanResultEntry> GetPointerScanResults(int offset, int limit);

    PointerScanChaseHintView GetPointerScanChaseHint();

    PointerAutoChaseStateView GetPointerAutoChaseState();

    std::vector<PointerScanResultEntry> GetPointerAutoChaseLayerResults(int layer_index,
                                                                        int offset,
                                                                        int limit);

    MemoryBreakpointView AddMemoryBreakpoint(const AddMemoryBreakpointRequest& request);

    void RemoveMemoryBreakpoint(const std::string& breakpoint_id);

    void SetMemoryBreakpointEnabled(const std::string& breakpoint_id, bool enabled);

    std::vector<MemoryBreakpointView> ListMemoryBreakpoints(int pid);

    MemoryBreakpointStateView GetMemoryBreakpointState(int pid);

    std::vector<MemoryBreakpointHitView> GetMemoryBreakpointHits(int pid, int offset, int limit);

    void ClearMemoryBreakpointHits(int pid);

    void ResumeAfterBreakpoint(int pid);

    InstructionPatchResultView PatchMemoryInstruction(int pid,
                                                      uint64_t address,
                                                      const std::string& input_text);

    std::vector<MemoryInstructionView> DisassembleMemory(
        int pid,
        const std::vector<uint64_t>& addresses);

    std::vector<MemoryValuePreview> ReadMemoryValues(const std::vector<MemoryReadRequest>& requests);

    void WriteMemoryValue(const MemoryWriteRequest& request);

    void SetMemoryFreeze(const MemoryFreezeRequest& request);

    std::vector<FrozenMemoryValueView> GetFrozenMemoryValues();

    void FirstScan(int pid,
                   const SearchValue& value,
                   SearchMatchMode match_mode,
                   const std::vector<std::string>& range_section_keys,
                   bool scan_all_readable_regions);

    void NextScan(const SearchValue& value, SearchMatchMode match_mode);

    void CancelSearch();

    void ResetSearchSession();

    void StartPointerScan(int pid,
                          uint64_t target_address,
                          size_t pointer_width,
                          uint64_t max_offset,
                          size_t alignment,
                          const std::vector<std::string>& range_section_keys,
                          bool scan_all_readable_regions);

    void StartPointerAutoChase(int pid,
                               uint64_t target_address,
                               size_t pointer_width,
                               uint64_t max_offset,
                               size_t alignment,
                               size_t max_depth,
                               const std::vector<std::string>& range_section_keys,
                               bool scan_all_readable_regions);

    void CancelPointerScan();

    void CancelPointerAutoChase();

    void ResetPointerScanSession();

    void ResetPointerAutoChase();

private:
    MemoryToolEngine() = default;

    struct SearchTaskRuntime {
        uint64_t generation = 0;
        std::chrono::steady_clock::time_point started_at{};
        std::chrono::steady_clock::time_point last_progress_published_at{};
        std::shared_ptr<std::atomic_bool> cancel_flag;
        SearchTaskStateView view;
    };

    struct PointerTaskRuntime {
        uint64_t generation = 0;
        std::chrono::steady_clock::time_point started_at{};
        std::chrono::steady_clock::time_point last_progress_published_at{};
        std::shared_ptr<std::atomic_bool> cancel_flag;
        PointerScanTaskStateView view;
    };

    struct PointerAutoChaseTaskRuntime {
        uint64_t generation = 0;
        std::chrono::steady_clock::time_point started_at{};
        std::shared_ptr<std::atomic_bool> cancel_flag;
        PointerAutoChaseStateView view;
    };

    SearchSessionStateView BuildSessionStateLocked() const;

    SearchTaskStateView BuildTaskStateLocked() const;

    SearchResultView BuildSearchResultViewLocked(const SearchResultEntry& entry) const;

    PointerScanSessionStateView BuildPointerSessionStateLocked() const;

    PointerScanTaskStateView BuildPointerTaskStateLocked() const;

    PointerAutoChaseStateView BuildPointerAutoChaseStateLocked() const;

    void EnsureActiveSessionLocked() const;

    void EnsureTaskNotRunningLocked() const;

    void EnsureActivePointerSessionLocked() const;

    void EnsurePointerTaskNotRunningLocked() const;

    uint64_t StartTaskLocked(bool is_first_scan, int pid);

    bool UpdateTaskProgress(uint64_t generation, const SearchScanProgress& progress);

    void FinishTaskSuccess(uint64_t generation, SearchSession&& next_session, size_t result_count);

    void FinishTaskFailure(uint64_t generation, const std::string& message);

    uint64_t StartPointerTaskLocked(int pid);

    bool UpdatePointerTaskProgress(uint64_t generation,
                                   const PointerScanTaskStateView& progress_view);

    void FinishPointerTaskSuccess(uint64_t generation, PointerScanSession&& next_session);

    void FinishPointerTaskFailure(uint64_t generation, const std::string& message);

    void EnsureFreezeWorkerLocked();

    void NotifyFreezeWorkerLocked();

    void FreezeWorkerLoop();

    struct FrozenWriteEntry {
        int pid = 0;
        uint64_t address = 0;
        SearchValueType type = SearchValueType::kI32;
        std::vector<uint8_t> value_bytes;
        bool little_endian = true;
        BytesDisplayEncoding bytes_display_encoding = BytesDisplayEncoding::kHex;
    };

    SearchSession session_;
    SearchTaskRuntime task_;
    PointerScanSession pointer_session_;
    PointerTaskRuntime pointer_task_;
    PointerAutoChaseSession pointer_auto_chase_session_;
    PointerAutoChaseTaskRuntime pointer_auto_chase_task_;
    std::vector<FrozenWriteEntry> frozen_entries_;
    MemoryToolBreakpointController breakpoint_controller_;
    std::condition_variable freeze_condition_;
    bool freeze_worker_started_ = false;
    uint64_t task_generation_counter_ = 0;
    uint64_t pointer_task_generation_counter_ = 0;
    uint64_t pointer_auto_chase_generation_counter_ = 0;
    mutable std::mutex mutex_;
};

}  // namespace memory_tool

#endif  // JSXPOSEDX_MEMORY_TOOL_ENGINE_H
