#ifndef JSXPOSEDX_MEMORY_TOOL_REGIONS_H
#define JSXPOSEDX_MEMORY_TOOL_REGIONS_H

#include <vector>

#include "memory_tool_session.h"

namespace memory_tool {

std::vector<MemoryRegion> ReadProcessRegions(int pid,
                                             bool readable_only,
                                             bool include_anonymous,
                                             bool include_file_backed);

std::string ClassifyMemoryRegion(const MemoryRegion& region);

}  // namespace memory_tool

#endif  // JSXPOSEDX_MEMORY_TOOL_REGIONS_H
