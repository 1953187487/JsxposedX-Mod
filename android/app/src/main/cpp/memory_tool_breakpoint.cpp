#include "memory_tool_breakpoint.h"

#include <android/log.h>
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <linux/hw_breakpoint.h>
#include <linux/perf_event.h>
#include <poll.h>
#include <signal.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <unistd.h>

#include <algorithm>
#include <atomic>
#include <chrono>
#include <cstdlib>
#include <cstdint>
#include <cstring>
#include <fstream>
#include <sstream>
#include <stdexcept>
#include <thread>
#include <unordered_map>
#include <utility>

#include "memory_tool_instruction.h"
#include "memory_tool_reader.h"
#include "memory_tool_regions.h"
#include "memory_tool_utils.h"

namespace memory_tool {

namespace {

constexpr char kLogTag[] = "MemoryToolBreakpoint";
constexpr int kPollTimeoutMs = 250;
constexpr int kThreadSyncIntervalMs = 1000;

struct PerfWatchHandle {
    int tid = 0;
    int fd = -1;
    void* mmap_base = nullptr;
    size_t mmap_length = 0;
    uint64_t data_tail = 0;
};

struct ModuleLocation {
    std::string module_name;
    uint64_t module_base = 0;
    uint64_t module_offset = 0;
};

struct BreakpointMonitorSnapshot {
    std::string id;
    int pid = 0;
    uint64_t address = 0;
    size_t length = 0;
    MemoryBreakpointAccessType access_type = MemoryBreakpointAccessType::kWrite;
    bool pause_process_on_hit = true;
};

struct PerfSampleEvent {
    uint32_t pid = 0;
    uint32_t tid = 0;
    uint64_t ip = 0;
};

int PerfEventOpen(struct perf_event_attr* attrs, int tid) {
    return static_cast<int>(syscall(__NR_perf_event_open,
                                    attrs,
                                    tid,
                                    -1,
                                    -1,
                                    PERF_FLAG_FD_CLOEXEC));
}

int ResolveRawBreakpointType(MemoryBreakpointAccessType type) {
    switch (type) {
        case MemoryBreakpointAccessType::kRead:
            return HW_BREAKPOINT_R;
        case MemoryBreakpointAccessType::kReadWrite:
            return HW_BREAKPOINT_RW;
        case MemoryBreakpointAccessType::kWrite:
        default:
            return HW_BREAKPOINT_W;
    }
}

void CloseHandle(PerfWatchHandle* handle) {
    if (handle == nullptr) {
        return;
    }
    if (handle->mmap_base != nullptr && handle->mmap_length > 0) {
        munmap(handle->mmap_base, handle->mmap_length);
        handle->mmap_base = nullptr;
        handle->mmap_length = 0;
    }
    if (handle->fd >= 0) {
        close(handle->fd);
        handle->fd = -1;
    }
}

bool ReadRingBytes(const PerfWatchHandle& handle,
                   uint64_t absolute_offset,
                   void* destination,
                   size_t size) {
    if (handle.mmap_base == nullptr || handle.mmap_length == 0 || destination == nullptr) {
        return false;
    }

    auto* metadata = reinterpret_cast<perf_event_mmap_page*>(handle.mmap_base);
    const size_t data_size = static_cast<size_t>(metadata->data_size);
    if (data_size == 0) {
        return false;
    }

    auto* output = static_cast<uint8_t*>(destination);
    auto* data_start =
        static_cast<uint8_t*>(handle.mmap_base) + static_cast<size_t>(metadata->data_offset);
    size_t copied = 0;
    while (copied < size) {
        const size_t ring_offset = static_cast<size_t>((absolute_offset + copied) % data_size);
        const size_t chunk = std::min(size - copied, data_size - ring_offset);
        std::memcpy(output + copied, data_start + ring_offset, chunk);
        copied += chunk;
    }
    return true;
}

std::vector<PerfSampleEvent> ConsumePerfEvents(PerfWatchHandle* handle) {
    std::vector<PerfSampleEvent> events;
    if (handle == nullptr || handle->mmap_base == nullptr) {
        return events;
    }

    auto* metadata = reinterpret_cast<perf_event_mmap_page*>(handle->mmap_base);
    std::atomic_thread_fence(std::memory_order_acquire);
    const uint64_t data_head = metadata->data_head;

    while (handle->data_tail < data_head) {
        perf_event_header header{};
        if (!ReadRingBytes(*handle, handle->data_tail, &header, sizeof(header))) {
            break;
        }
        if (header.size < sizeof(header)) {
            handle->data_tail = data_head;
            break;
        }

        const uint64_t payload_offset = handle->data_tail + sizeof(header);
        if (header.type == PERF_RECORD_SAMPLE) {
            PerfSampleEvent event;
            ReadRingBytes(*handle, payload_offset, &event.ip, sizeof(event.ip));
            ReadRingBytes(*handle, payload_offset + sizeof(event.ip), &event.pid, sizeof(event.pid));
            ReadRingBytes(
                *handle,
                payload_offset + sizeof(event.ip) + sizeof(event.pid),
                &event.tid,
                sizeof(event.tid));
            events.push_back(event);
        }

        handle->data_tail += header.size;
    }

    std::atomic_thread_fence(std::memory_order_release);
    metadata->data_tail = handle->data_tail;
    return events;
}

bool OpenWatchHandle(const BreakpointMonitorSnapshot& snapshot,
                     int tid,
                     PerfWatchHandle* handle,
                     std::string* error) {
    if (handle == nullptr) {
        return false;
    }

    struct perf_event_attr attrs {};
    attrs.size = sizeof(attrs);
    attrs.type = PERF_TYPE_BREAKPOINT;
    attrs.sample_period = 1;
    attrs.wakeup_events = 1;
    attrs.bp_type = ResolveRawBreakpointType(snapshot.access_type);
    attrs.bp_addr = snapshot.address;
    attrs.bp_len = snapshot.length;
    attrs.sample_type = PERF_SAMPLE_IP | PERF_SAMPLE_TID;
    attrs.precise_ip = 2;
    attrs.exclude_kernel = 1;
    attrs.exclude_hv = 1;

    const int fd = PerfEventOpen(&attrs, tid);
    if (fd < 0) {
        if (error != nullptr) {
            *error = std::string("perf_event_open failed: ") + std::strerror(errno);
        }
        return false;
    }

    const size_t page_size = static_cast<size_t>(sysconf(_SC_PAGESIZE));
    const size_t mmap_length = page_size * 2;
    void* mmap_base = mmap(nullptr,
                           mmap_length,
                           PROT_READ | PROT_WRITE,
                           MAP_SHARED,
                           fd,
                           0);
    if (mmap_base == MAP_FAILED) {
        if (error != nullptr) {
            *error = std::string("mmap failed: ") + std::strerror(errno);
        }
        close(fd);
        return false;
    }

    ioctl(fd, PERF_EVENT_IOC_RESET, 0);
    ioctl(fd, PERF_EVENT_IOC_ENABLE, 0);

    handle->tid = tid;
    handle->fd = fd;
    handle->mmap_base = mmap_base;
    handle->mmap_length = mmap_length;
    handle->data_tail = 0;
    return true;
}

std::vector<int> ReadThreadIds(int pid) {
    std::vector<int> tids;
    const std::string task_directory = "/proc/" + std::to_string(pid) + "/task";
    DIR* directory = opendir(task_directory.c_str());
    if (directory == nullptr) {
        return tids;
    }

    while (dirent* entry = readdir(directory)) {
        if (entry->d_name[0] == '.') {
            continue;
        }
        const int tid = std::atoi(entry->d_name);
        if (tid > 0) {
            tids.push_back(tid);
        }
    }
    closedir(directory);
    std::sort(tids.begin(), tids.end());
    return tids;
}

bool IsProcessStopped(int pid) {
    std::ifstream stream("/proc/" + std::to_string(pid) + "/status");
    if (!stream.is_open()) {
        return false;
    }

    std::string line;
    while (std::getline(stream, line)) {
        if (line.rfind("State:", 0) != 0) {
            continue;
        }
        const auto colon = line.find(':');
        if (colon == std::string::npos) {
            return false;
        }
        const std::string trimmed = utils::Trim(line.substr(colon + 1));
        if (trimmed.empty()) {
            return false;
        }
        const char state_code = trimmed.front();
        return state_code == 'T' || state_code == 't';
    }
    return false;
}

ModuleLocation ResolveModuleLocation(int pid, uint64_t address) {
    ModuleLocation location;
    const std::vector<MemoryRegion> regions = ReadProcessRegions(
        pid,
        false,
        true,
        true);
    const MemoryRegion* target_region = nullptr;
    for (const MemoryRegion& region : regions) {
        if (address >= region.start_address && address < region.end_address) {
            target_region = &region;
            break;
        }
    }
    if (target_region == nullptr) {
        location.module_name = "unknown";
        return location;
    }

    uint64_t module_base = target_region->start_address;
    if (!target_region->path.empty() && !target_region->is_anonymous) {
        for (const MemoryRegion& region : regions) {
            if (region.path == target_region->path && region.start_address < module_base) {
                module_base = region.start_address;
            }
        }
        const size_t slash = target_region->path.find_last_of('/');
        location.module_name = slash == std::string::npos
                                   ? target_region->path
                                   : target_region->path.substr(slash + 1);
    } else {
        location.module_name = ClassifyMemoryRegion(*target_region);
    }

    location.module_base = module_base;
    location.module_offset = address >= module_base ? address - module_base : 0;
    return location;
}

std::string DisassembleInstruction(int pid, uint64_t pc) {
    if (pc == 0) {
        return {};
    }
    const MemoryInstructionInfo instruction = ReadMemoryInstruction(pid, pc);
    if (!instruction.text.empty()) {
        return instruction.text;
    }
    return utils::HexEncode(instruction.raw_bytes);
}

}  // namespace

struct MemoryToolBreakpointController::BreakpointRuntime {
    explicit BreakpointRuntime(MemoryBreakpointView initial_view)
        : view(std::move(initial_view)) {}

    MemoryBreakpointView view;
    std::vector<uint8_t> last_value;
    bool has_last_value = false;
    std::atomic_bool stop_requested{false};
    std::thread monitor_thread;
};

MemoryToolBreakpointController::~MemoryToolBreakpointController() {
    std::vector<std::shared_ptr<BreakpointRuntime>> runtimes;
    {
        std::lock_guard<std::mutex> lock(mutex_);
        for (const auto& runtime : breakpoints_) {
            runtimes.push_back(runtime);
        }
    }
    for (const auto& runtime : runtimes) {
        StopMonitor(runtime);
    }
}

bool MemoryToolBreakpointController::SupportsBreakpointLength(size_t length) {
    return length == 1 || length == 2 || length == 4 || length == 8;
}

std::string MemoryToolBreakpointController::ResolveArchitectureName() {
#if defined(__aarch64__)
    return "aarch64";
#elif defined(__arm__)
    return "arm";
#elif defined(__x86_64__)
    return "x86_64";
#elif defined(__i386__)
    return "x86";
#else
    return "unknown";
#endif
}

uint64_t MemoryToolBreakpointController::ResolveNowMillis() {
    return static_cast<uint64_t>(
        std::chrono::duration_cast<std::chrono::milliseconds>(
            std::chrono::system_clock::now().time_since_epoch())
            .count());
}

std::shared_ptr<MemoryToolBreakpointController::BreakpointRuntime>
MemoryToolBreakpointController::FindRuntimeLocked(const std::string& breakpoint_id) const {
    for (const auto& runtime : breakpoints_) {
        if (runtime->view.id == breakpoint_id) {
            return runtime;
        }
    }
    return nullptr;
}

MemoryBreakpointView MemoryToolBreakpointController::AddBreakpoint(
    const AddMemoryBreakpointRequest& request) {
    if (request.pid <= 0) {
        throw std::runtime_error("Invalid breakpoint pid.");
    }
    if (!SupportsBreakpointLength(request.length)) {
        throw std::runtime_error("Watchpoint length must be 1, 2, 4 or 8 bytes.");
    }

    MemoryBreakpointView view;
    {
        std::lock_guard<std::mutex> lock(mutex_);
        view.id = "bp_" + std::to_string(++next_breakpoint_id_);
    }
    view.pid = request.pid;
    view.address = request.address;
    view.type = request.type;
    view.length = request.length;
    view.access_type = request.access_type;
    view.enabled = request.enabled;
    view.pause_process_on_hit = request.pause_process_on_hit;
    view.created_at_millis = ResolveNowMillis();

    auto runtime = std::make_shared<BreakpointRuntime>(view);
    try {
        ProcessMemoryReader reader(request.pid);
        runtime->has_last_value = reader.Read(request.address, request.length, &runtime->last_value);
    } catch (...) {
        runtime->has_last_value = false;
        runtime->last_value.clear();
    }

    {
        std::lock_guard<std::mutex> lock(mutex_);
        breakpoints_.push_back(runtime);
    }

    if (request.enabled) {
        StartMonitor(runtime);
    }

    return runtime->view;
}

void MemoryToolBreakpointController::RemoveBreakpoint(const std::string& breakpoint_id) {
    std::shared_ptr<BreakpointRuntime> runtime;
    {
        std::lock_guard<std::mutex> lock(mutex_);
        runtime = FindRuntimeLocked(breakpoint_id);
    }
    if (runtime == nullptr) {
        return;
    }

    StopMonitor(runtime);
    std::lock_guard<std::mutex> lock(mutex_);
    hits_.erase(
        std::remove_if(hits_.begin(),
                       hits_.end(),
                       [&breakpoint_id](const MemoryBreakpointHitView& hit) {
                           return hit.breakpoint_id == breakpoint_id;
                       }),
        hits_.end());
    breakpoints_.remove_if([&runtime](const std::shared_ptr<BreakpointRuntime>& item) {
        return item == runtime;
    });
}

void MemoryToolBreakpointController::SetBreakpointEnabled(const std::string& breakpoint_id,
                                                          bool enabled) {
    std::shared_ptr<BreakpointRuntime> runtime;
    {
        std::lock_guard<std::mutex> lock(mutex_);
        runtime = FindRuntimeLocked(breakpoint_id);
        if (runtime == nullptr) {
            return;
        }
        runtime->view.enabled = enabled;
        if (enabled) {
            runtime->view.last_error.clear();
        }
    }

    if (enabled) {
        StartMonitor(runtime);
    } else {
        StopMonitor(runtime);
    }
}

std::vector<MemoryBreakpointView> MemoryToolBreakpointController::ListBreakpoints(int pid) const {
    std::lock_guard<std::mutex> lock(mutex_);
    std::vector<MemoryBreakpointView> result;
    for (const auto& runtime : breakpoints_) {
        if (pid > 0 && runtime->view.pid != pid) {
            continue;
        }
        result.push_back(runtime->view);
    }
    std::sort(result.begin(), result.end(), [](const MemoryBreakpointView& left,
                                               const MemoryBreakpointView& right) {
        return left.created_at_millis > right.created_at_millis;
    });
    return result;
}

MemoryBreakpointStateView MemoryToolBreakpointController::GetState(int pid) const {
    MemoryBreakpointStateView state;
    state.is_supported = true;
    state.architecture = ResolveArchitectureName();
    state.is_process_paused = pid > 0 && IsProcessStopped(pid);

    std::lock_guard<std::mutex> lock(mutex_);
    for (const auto& runtime : breakpoints_) {
        if (pid > 0 && runtime->view.pid != pid) {
            continue;
        }
        if (runtime->view.enabled) {
            ++state.active_breakpoint_count;
        }
        if (state.last_error.empty() && !runtime->view.last_error.empty()) {
            state.last_error = runtime->view.last_error;
        }
    }
    for (const auto& hit : hits_) {
        if (pid > 0 && hit.pid != pid) {
            continue;
        }
        ++state.pending_hit_count;
    }
    return state;
}

std::vector<MemoryBreakpointHitView> MemoryToolBreakpointController::GetHits(int pid,
                                                                              int offset,
                                                                              int limit) const {
    std::lock_guard<std::mutex> lock(mutex_);
    std::vector<MemoryBreakpointHitView> filtered;
    for (const auto& hit : hits_) {
        if (pid > 0 && hit.pid != pid) {
            continue;
        }
        filtered.push_back(hit);
    }
    std::sort(filtered.begin(), filtered.end(), [](const MemoryBreakpointHitView& left,
                                                   const MemoryBreakpointHitView& right) {
        return left.timestamp_millis > right.timestamp_millis;
    });

    const size_t safe_offset = offset <= 0 ? 0 : static_cast<size_t>(offset);
    if (safe_offset >= filtered.size() || limit <= 0) {
        return {};
    }
    const size_t safe_limit = static_cast<size_t>(limit);
    const size_t end = std::min(filtered.size(), safe_offset + safe_limit);
    return std::vector<MemoryBreakpointHitView>(
        filtered.begin() + static_cast<std::ptrdiff_t>(safe_offset),
        filtered.begin() + static_cast<std::ptrdiff_t>(end));
}

void MemoryToolBreakpointController::ClearHits(int pid) {
    std::lock_guard<std::mutex> lock(mutex_);
    hits_.erase(
        std::remove_if(hits_.begin(),
                       hits_.end(),
                       [pid](const MemoryBreakpointHitView& hit) {
                           return pid <= 0 || hit.pid == pid;
                       }),
        hits_.end());
}

void MemoryToolBreakpointController::ResumeAfterBreakpoint(int pid) const {
    if (pid <= 0) {
        return;
    }
    if (kill(pid, SIGCONT) != 0) {
        throw std::runtime_error("Failed to resume process.");
    }
}

void MemoryToolBreakpointController::StartMonitor(
    const std::shared_ptr<BreakpointRuntime>& runtime) {
    if (runtime == nullptr) {
        return;
    }

    StopMonitor(runtime);
    runtime->stop_requested.store(false);
    runtime->monitor_thread = std::thread([this, runtime]() {
        std::unordered_map<int, PerfWatchHandle> handles;
        auto last_sync_at = std::chrono::steady_clock::time_point{};

        auto close_all_handles = [&handles]() {
            for (auto& entry : handles) {
                CloseHandle(&entry.second);
            }
            handles.clear();
        };

        try {
            while (!runtime->stop_requested.load()) {
                BreakpointMonitorSnapshot snapshot;
                {
                    std::lock_guard<std::mutex> lock(mutex_);
                    snapshot.id = runtime->view.id;
                    snapshot.pid = runtime->view.pid;
                    snapshot.address = runtime->view.address;
                    snapshot.length = runtime->view.length;
                    snapshot.access_type = runtime->view.access_type;
                    snapshot.pause_process_on_hit = runtime->view.pause_process_on_hit;
                    if (!runtime->view.enabled) {
                        break;
                    }
                }

                if (!IsProcessAlive(snapshot.pid)) {
                    std::lock_guard<std::mutex> lock(mutex_);
                    runtime->view.last_error = "Target process exited.";
                    break;
                }

                const auto now = std::chrono::steady_clock::now();
                if (last_sync_at == std::chrono::steady_clock::time_point{} ||
                    std::chrono::duration_cast<std::chrono::milliseconds>(now - last_sync_at)
                            .count() >= kThreadSyncIntervalMs) {
                    const std::vector<int> tids = ReadThreadIds(snapshot.pid);
                    std::unordered_map<int, bool> active_tids;
                    for (int tid : tids) {
                        active_tids[tid] = true;
                        if (handles.find(tid) != handles.end()) {
                            continue;
                        }
                        PerfWatchHandle handle;
                        std::string error;
                        if (!OpenWatchHandle(snapshot, tid, &handle, &error)) {
                            std::lock_guard<std::mutex> lock(mutex_);
                            runtime->view.last_error = error;
                            continue;
                        }
                        handles.emplace(tid, handle);
                        std::lock_guard<std::mutex> lock(mutex_);
                        runtime->view.last_error.clear();
                    }

                    for (auto iterator = handles.begin(); iterator != handles.end();) {
                        if (active_tids.find(iterator->first) != active_tids.end()) {
                            ++iterator;
                            continue;
                        }
                        CloseHandle(&iterator->second);
                        iterator = handles.erase(iterator);
                    }
                    last_sync_at = now;
                }

                if (handles.empty()) {
                    std::this_thread::sleep_for(std::chrono::milliseconds(kPollTimeoutMs));
                    continue;
                }

                std::vector<pollfd> poll_fds;
                poll_fds.reserve(handles.size());
                std::vector<int> tids;
                tids.reserve(handles.size());
                for (const auto& entry : handles) {
                    poll_fds.push_back(pollfd{entry.second.fd, POLLIN, 0});
                    tids.push_back(entry.first);
                }

                const int poll_result = poll(poll_fds.data(),
                                             static_cast<nfds_t>(poll_fds.size()),
                                             kPollTimeoutMs);
                if (poll_result <= 0) {
                    continue;
                }

                for (size_t index = 0; index < poll_fds.size(); ++index) {
                    if ((poll_fds[index].revents & POLLIN) == 0) {
                        continue;
                    }
                    auto handle_iterator = handles.find(tids[index]);
                    if (handle_iterator == handles.end()) {
                        continue;
                    }
                    const std::vector<PerfSampleEvent> events = ConsumePerfEvents(
                        &handle_iterator->second);
                    for (const PerfSampleEvent& event : events) {
                        std::vector<uint8_t> new_value;
                        try {
                            ProcessMemoryReader reader(snapshot.pid);
                            reader.Read(snapshot.address, snapshot.length, &new_value);
                        } catch (...) {
                            new_value.clear();
                        }
                        const ModuleLocation location = ResolveModuleLocation(snapshot.pid, event.ip);
                        const std::string instruction_text =
                            DisassembleInstruction(snapshot.pid, event.ip);
                        RecordHit(runtime,
                                  static_cast<int>(event.tid),
                                  event.ip,
                                  new_value,
                                  location.module_name,
                                  location.module_base,
                                  location.module_offset,
                                  instruction_text);
                        if (snapshot.pause_process_on_hit) {
                            kill(snapshot.pid, SIGSTOP);
                        }
                    }
                }
            }
        } catch (const std::exception& exception) {
            std::lock_guard<std::mutex> lock(mutex_);
            runtime->view.last_error = exception.what();
        } catch (...) {
            std::lock_guard<std::mutex> lock(mutex_);
            runtime->view.last_error = "Breakpoint monitor crashed.";
        }

        close_all_handles();
    });
}

void MemoryToolBreakpointController::StopMonitor(
    const std::shared_ptr<BreakpointRuntime>& runtime) {
    if (runtime == nullptr) {
        return;
    }
    runtime->stop_requested.store(true);
    if (runtime->monitor_thread.joinable()) {
        runtime->monitor_thread.join();
    }
}

void MemoryToolBreakpointController::RecordHit(
    const std::shared_ptr<BreakpointRuntime>& runtime,
    int thread_id,
    uint64_t pc,
    const std::vector<uint8_t>& new_value,
    const std::string& module_name,
    uint64_t module_base,
    uint64_t module_offset,
    const std::string& instruction_text) {
    if (runtime == nullptr) {
        return;
    }

    MemoryBreakpointHitView hit;
    hit.breakpoint_id = runtime->view.id;
    hit.pid = runtime->view.pid;
    hit.address = runtime->view.address;
    hit.access_type = runtime->view.access_type;
    hit.thread_id = thread_id;
    hit.timestamp_millis = ResolveNowMillis();
    hit.pc = pc;
    hit.module_name = module_name;
    hit.module_base = module_base;
    hit.module_offset = module_offset;
    hit.instruction_text = instruction_text;

    std::lock_guard<std::mutex> lock(mutex_);
    hit.old_value = runtime->has_last_value ? runtime->last_value : std::vector<uint8_t>{};
    hit.new_value = new_value;
    runtime->last_value = new_value;
    runtime->has_last_value = !new_value.empty();
    runtime->view.hit_count += 1;
    runtime->view.has_last_hit_at = true;
    runtime->view.last_hit_at_millis = hit.timestamp_millis;
    hits_.push_back(hit);
    if (hits_.size() > 512) {
        hits_.erase(hits_.begin(), hits_.begin() + static_cast<std::ptrdiff_t>(hits_.size() - 512));
    }
}

}  // namespace memory_tool
