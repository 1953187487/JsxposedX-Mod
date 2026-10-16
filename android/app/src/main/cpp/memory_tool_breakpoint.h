#ifndef JSXPOSEDX_MEMORY_TOOL_BREAKPOINT_H
#define JSXPOSEDX_MEMORY_TOOL_BREAKPOINT_H

#include <list>
#include <memory>
#include <mutex>
#include <string>
#include <vector>

#include "memory_tool_session.h"

namespace memory_tool {

class MemoryToolBreakpointController {
public:
    MemoryToolBreakpointController() = default;
    ~MemoryToolBreakpointController();

    MemoryBreakpointView AddBreakpoint(const AddMemoryBreakpointRequest& request);
    void RemoveBreakpoint(const std::string& breakpoint_id);
    void SetBreakpointEnabled(const std::string& breakpoint_id, bool enabled);

    std::vector<MemoryBreakpointView> ListBreakpoints(int pid) const;
    MemoryBreakpointStateView GetState(int pid) const;
    std::vector<MemoryBreakpointHitView> GetHits(int pid, int offset, int limit) const;
    void ClearHits(int pid);
    void ResumeAfterBreakpoint(int pid) const;

private:
    struct BreakpointRuntime;

    static bool SupportsBreakpointLength(size_t length);
    static std::string ResolveArchitectureName();
    static uint64_t ResolveNowMillis();

    std::shared_ptr<BreakpointRuntime> FindRuntimeLocked(const std::string& breakpoint_id) const;
    void StartMonitor(const std::shared_ptr<BreakpointRuntime>& runtime);
    void StopMonitor(const std::shared_ptr<BreakpointRuntime>& runtime);
    void RecordHit(const std::shared_ptr<BreakpointRuntime>& runtime,
                   int thread_id,
                   uint64_t pc,
                   const std::vector<uint8_t>& new_value,
                   const std::string& module_name,
                   uint64_t module_base,
                   uint64_t module_offset,
                   const std::string& instruction_text);

    std::list<std::shared_ptr<BreakpointRuntime>> breakpoints_;
    std::vector<MemoryBreakpointHitView> hits_;
    mutable std::mutex mutex_;
    uint64_t next_breakpoint_id_ = 0;
};

}  // namespace memory_tool

#endif  // JSXPOSEDX_MEMORY_TOOL_BREAKPOINT_H
