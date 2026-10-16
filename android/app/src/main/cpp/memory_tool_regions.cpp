#include "memory_tool_regions.h"

#include <algorithm>
#include <cctype>
#include <fstream>
#include <sstream>
#include <stdexcept>
#include <string>

namespace memory_tool {

namespace {

bool HasReadPermission(const std::string& perms) {
    return !perms.empty() && perms[0] == 'r';
}

bool IsAnonymousPath(const std::string& path) {
    return path.empty() || path[0] == '[';
}

std::string ToLower(std::string value) {
    std::transform(value.begin(), value.end(), value.begin(), [](unsigned char ch) {
        return static_cast<char>(std::tolower(ch));
    });
    return value;
}

bool Contains(const std::string& text, const std::string& needle) {
    return text.find(needle) != std::string::npos;
}

bool StartsWith(const std::string& text, const std::string& prefix) {
    return text.rfind(prefix, 0) == 0;
}

bool HasExecutePermission(const std::string& perms) {
    return perms.size() > 2 && perms[2] == 'x';
}

}  // namespace

std::vector<MemoryRegion> ReadProcessRegions(int pid,
                                             bool readable_only,
                                             bool include_anonymous,
                                             bool include_file_backed) {
    std::ifstream stream("/proc/" + std::to_string(pid) + "/maps");
    if (!stream.is_open()) {
        throw std::runtime_error("Unable to open process maps.");
    }

    std::vector<MemoryRegion> regions;
    std::string line;
    while (std::getline(stream, line)) {
        if (line.empty()) {
            continue;
        }

        std::istringstream parser(line);
        std::string address_range;
        std::string perms;
        std::string offset;
        std::string dev;
        std::string inode;
        if (!(parser >> address_range >> perms >> offset >> dev >> inode)) {
            continue;
        }

        std::string path;
        std::getline(parser, path);
        if (!path.empty() && path.front() == ' ') {
            path.erase(0, path.find_first_not_of(' '));
        }

        const auto separator = address_range.find('-');
        if (separator == std::string::npos) {
            continue;
        }

        const uint64_t start = std::stoull(address_range.substr(0, separator), nullptr, 16);
        const uint64_t end = std::stoull(address_range.substr(separator + 1), nullptr, 16);
        if (end <= start) {
            continue;
        }

        const bool is_anonymous = IsAnonymousPath(path);
        if (readable_only && !HasReadPermission(perms)) {
            continue;
        }
        if (!include_anonymous && is_anonymous) {
            continue;
        }
        if (!include_file_backed && !is_anonymous) {
            continue;
        }

        MemoryRegion region;
        region.start_address = start;
        region.end_address = end;
        region.perms = perms;
        region.size = end - start;
        region.path = path;
        region.is_anonymous = is_anonymous;
        regions.push_back(region);
    }

    return regions;
}

std::string ClassifyMemoryRegion(const MemoryRegion& region) {
    const std::string lower_path = ToLower(region.path);
    const bool executable = HasExecutePermission(region.perms);

    if (!HasReadPermission(region.perms)) {
        return "bad";
    }

    if (Contains(lower_path, "[stack")) {
        return "stack";
    }

    if (Contains(lower_path, "ashmem")) {
        if (Contains(lower_path, "dalvik")) {
            return "javaHeap";
        }
        return "ashmem";
    }

    if (Contains(lower_path, "dalvik-main space") ||
        Contains(lower_path, "dalvik-allocspace") ||
        Contains(lower_path, "dalvik-large object space") ||
        Contains(lower_path, "dalvik-free list large object space") ||
        Contains(lower_path, "dalvik-non moving space") ||
        Contains(lower_path, "dalvik-zygote space")) {
        return "javaHeap";
    }

    if (Contains(lower_path, "dalvik") ||
        Contains(lower_path, ".art") ||
        Contains(lower_path, ".oat") ||
        Contains(lower_path, ".odex")) {
        return "java";
    }

    if (Contains(lower_path, "[heap]")) {
        return "cHeap";
    }

    if (Contains(lower_path, "malloc") ||
        Contains(lower_path, "scudo:") ||
        Contains(lower_path, "jemalloc") ||
        Contains(lower_path, "[anon:libc_malloc]")) {
        return "cAlloc";
    }

    if (Contains(lower_path, ".bss") || Contains(lower_path, "[anon:.bss")) {
        return "cBss";
    }

    const bool is_app_path =
        StartsWith(lower_path, "/data/app/") ||
        StartsWith(lower_path, "/data/data/") ||
        StartsWith(lower_path, "/mnt/expand/");
    const bool is_system_path =
        StartsWith(lower_path, "/system/") ||
        StartsWith(lower_path, "/apex/") ||
        StartsWith(lower_path, "/vendor/") ||
        StartsWith(lower_path, "/product/");

    if (executable) {
        if (is_app_path) {
            return "codeApp";
        }
        if (is_system_path || !region.is_anonymous) {
            return "codeSys";
        }
    }

    if (!region.is_anonymous) {
        if (is_app_path || is_system_path || Contains(lower_path, ".so")) {
            return "cData";
        }
        return "other";
    }

    if (region.is_anonymous) {
        return "anonymous";
    }

    return "other";
}

}  // namespace memory_tool
