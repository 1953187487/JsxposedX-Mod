#ifndef JSXPOSEDX_MEMORY_TOOL_READER_H
#define JSXPOSEDX_MEMORY_TOOL_READER_H

#include <cstddef>
#include <cstdint>
#include <vector>

namespace memory_tool {

struct FlatReadBatch {
    size_t value_size = 0;
    std::vector<uint8_t> values;
    std::vector<uint8_t> success_flags;

    void Reset(size_t entry_count, size_t entry_size) {
        value_size = entry_size;
        values.resize(entry_count * entry_size);
        success_flags.assign(entry_count, 0);
    }

    [[nodiscard]] bool HasValue(size_t index) const {
        return index < success_flags.size() && success_flags[index] != 0;
    }

    [[nodiscard]] const uint8_t* ValueAt(size_t index) const {
        if (value_size == 0 || index >= success_flags.size()) {
            return nullptr;
        }
        return values.data() + (index * value_size);
    }
};

class ProcessMemoryReader {
public:
    explicit ProcessMemoryReader(int pid);
    ~ProcessMemoryReader();

    ProcessMemoryReader(const ProcessMemoryReader&) = delete;
    ProcessMemoryReader& operator=(const ProcessMemoryReader&) = delete;

    [[nodiscard]] int pid() const { return pid_; }

    bool Read(uint64_t address, size_t size, std::vector<uint8_t>* buffer) const;
    bool ReadInto(uint64_t address, size_t size, uint8_t* buffer) const;
    bool Write(uint64_t address, const std::vector<uint8_t>& buffer) const;
    bool WriteFrom(uint64_t address, const uint8_t* buffer, size_t size) const;
    bool ReadMany(const std::vector<uint64_t>& addresses,
                  size_t size,
                  std::vector<std::vector<uint8_t>>* buffers) const;
    bool ReadManyFlat(const std::vector<uint64_t>& addresses,
                      size_t size,
                      FlatReadBatch* batch) const;

private:
    bool ReadWithProcessVmReadv(uint64_t address, size_t size, void* buffer) const;
    bool ReadWithPread(uint64_t address, size_t size, void* buffer) const;
    bool WriteWithProcessVmWritev(uint64_t address, const void* buffer, size_t size) const;
    bool WriteWithPwrite(uint64_t address, const void* buffer, size_t size) const;

    int pid_ = 0;
    int mem_fd_ = -1;
};

bool IsProcessAlive(int pid);

}  // namespace memory_tool

#endif  // JSXPOSEDX_MEMORY_TOOL_READER_H
