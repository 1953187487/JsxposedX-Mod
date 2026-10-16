#include "memory_tool_reader.h"

#include <algorithm>
#include <cerrno>
#include <fcntl.h>
#include <signal.h>
#include <string>
#include <sys/uio.h>
#include <unistd.h>

namespace memory_tool {

namespace {

size_t ResolveReadManyBatchSize() {
    const long raw_iov_max = sysconf(_SC_IOV_MAX);
    if (raw_iov_max <= 0) {
        return 1024;
    }
    return static_cast<size_t>(raw_iov_max);
}

}  // namespace

ProcessMemoryReader::ProcessMemoryReader(int pid) : pid_(pid) {
    mem_fd_ = open(("/proc/" + std::to_string(pid_) + "/mem").c_str(), O_RDWR | O_CLOEXEC);
    if (mem_fd_ < 0) {
        mem_fd_ = open(("/proc/" + std::to_string(pid_) + "/mem").c_str(), O_RDONLY | O_CLOEXEC);
    }
}

ProcessMemoryReader::~ProcessMemoryReader() {
    if (mem_fd_ >= 0) {
        close(mem_fd_);
    }
}

bool ProcessMemoryReader::Read(uint64_t address,
                               size_t size,
                               std::vector<uint8_t>* buffer) const {
    if (buffer == nullptr || size == 0) {
        return false;
    }

    buffer->clear();
    buffer->resize(size);
    if (ReadInto(address, size, buffer->data())) {
        return true;
    }
    buffer->clear();
    return false;
}

bool ProcessMemoryReader::ReadInto(uint64_t address,
                                   size_t size,
                                   uint8_t* buffer) const {
    if (buffer == nullptr || size == 0) {
        return false;
    }

    if (ReadWithProcessVmReadv(address, size, buffer)) {
        return true;
    }
    return ReadWithPread(address, size, buffer);
}

bool ProcessMemoryReader::ReadMany(const std::vector<uint64_t>& addresses,
                                   size_t size,
                                   std::vector<std::vector<uint8_t>>* buffers) const {
    if (buffers == nullptr || size == 0) {
        return false;
    }

    buffers->clear();
    buffers->resize(addresses.size());
    if (addresses.empty()) {
        return true;
    }

    FlatReadBatch batch;
    const bool all_success = ReadManyFlat(addresses, size, &batch);
    for (size_t index = 0; index < addresses.size(); ++index) {
        if (!batch.HasValue(index)) {
            continue;
        }
        const uint8_t* value = batch.ValueAt(index);
        (*buffers)[index].assign(value, value + static_cast<std::ptrdiff_t>(size));
    }
    return all_success;
}

bool ProcessMemoryReader::Write(uint64_t address, const std::vector<uint8_t>& buffer) const {
    if (buffer.empty()) {
        return false;
    }
    return WriteFrom(address, buffer.data(), buffer.size());
}

bool ProcessMemoryReader::WriteFrom(uint64_t address,
                                    const uint8_t* buffer,
                                    size_t size) const {
    if (buffer == nullptr || size == 0) {
        return false;
    }

    if (WriteWithProcessVmWritev(address, buffer, size)) {
        return true;
    }
    return WriteWithPwrite(address, buffer, size);
}

bool ProcessMemoryReader::ReadManyFlat(const std::vector<uint64_t>& addresses,
                                       size_t size,
                                       FlatReadBatch* batch) const {
    if (batch == nullptr || size == 0) {
        return false;
    }

    batch->Reset(addresses.size(), size);
    if (addresses.empty()) {
        return true;
    }

    bool all_success = true;
    const size_t batch_size = ResolveReadManyBatchSize();
    for (size_t start = 0; start < addresses.size(); start += batch_size) {
        const size_t count = std::min(batch_size, addresses.size() - start);
        std::vector<iovec> local_iov(count);
        std::vector<iovec> remote_iov(count);
        for (size_t index = 0; index < count; ++index) {
            local_iov[index] = iovec{
                batch->values.data() + ((start + index) * size),
                size,
            };
            remote_iov[index] = iovec{
                reinterpret_cast<void*>(addresses[start + index]),
                size,
            };
        }

        const size_t expected_size = count * size;
        const ssize_t bytes_read = process_vm_readv(pid_,
                                                    local_iov.data(),
                                                    static_cast<unsigned long>(count),
                                                    remote_iov.data(),
                                                    static_cast<unsigned long>(count),
                                                    0);
        if (bytes_read == static_cast<ssize_t>(expected_size)) {
            std::fill(batch->success_flags.begin() + static_cast<std::ptrdiff_t>(start),
                      batch->success_flags.begin() + static_cast<std::ptrdiff_t>(start + count),
                      static_cast<uint8_t>(1));
            continue;
        }

        all_success = false;
        size_t completed_count = 0;
        if (bytes_read > 0) {
            completed_count = static_cast<size_t>(bytes_read) / size;
            std::fill(batch->success_flags.begin() + static_cast<std::ptrdiff_t>(start),
                      batch->success_flags.begin() +
                          static_cast<std::ptrdiff_t>(start + completed_count),
                      static_cast<uint8_t>(1));
        }

        for (size_t index = completed_count; index < count; ++index) {
            uint8_t* destination = batch->values.data() + ((start + index) * size);
            if (!ReadInto(addresses[start + index], size, destination)) {
                continue;
            }
            batch->success_flags[start + index] = 1;
        }
    }

    return all_success;
}

bool ProcessMemoryReader::ReadWithProcessVmReadv(uint64_t address,
                                                 size_t size,
                                                 void* buffer) const {
    iovec local_iov{buffer, size};
    iovec remote_iov{reinterpret_cast<void*>(address), size};
    const ssize_t bytes_read = process_vm_readv(pid_, &local_iov, 1, &remote_iov, 1, 0);
    return bytes_read == static_cast<ssize_t>(size);
}

bool ProcessMemoryReader::ReadWithPread(uint64_t address,
                                        size_t size,
                                        void* buffer) const {
    if (mem_fd_ < 0) {
        return false;
    }

    const ssize_t bytes_read = pread64(mem_fd_,
                                       buffer,
                                       size,
                                       static_cast<off64_t>(address));
    return bytes_read == static_cast<ssize_t>(size);
}

bool ProcessMemoryReader::WriteWithProcessVmWritev(uint64_t address,
                                                   const void* buffer,
                                                   size_t size) const {
    iovec local_iov{const_cast<void*>(buffer), size};
    iovec remote_iov{reinterpret_cast<void*>(address), size};
    const ssize_t bytes_written = process_vm_writev(pid_, &local_iov, 1, &remote_iov, 1, 0);
    return bytes_written == static_cast<ssize_t>(size);
}

bool ProcessMemoryReader::WriteWithPwrite(uint64_t address,
                                          const void* buffer,
                                          size_t size) const {
    if (mem_fd_ < 0) {
        return false;
    }

    const ssize_t bytes_written = pwrite64(mem_fd_,
                                           buffer,
                                           size,
                                           static_cast<off64_t>(address));
    return bytes_written == static_cast<ssize_t>(size);
}

bool IsProcessAlive(int pid) {
    if (pid <= 0) {
        return false;
    }

    const int result = kill(pid, 0);
    return result == 0 || errno == EPERM;
}

}  // namespace memory_tool
