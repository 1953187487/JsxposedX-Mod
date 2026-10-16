package com.jsxposed.xmod.core.bridge.memory_tool_native

import android.content.Context
import android.os.Build
import androidx.annotation.RequiresApi
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class MemoryToolNativeImpl(val context: Context) : MemoryToolNative {
    private val memoryTool = MemoryTool(context)
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)

    override fun getPid(packageName: String, callback: (Result<Long>) -> Unit) {
        scope.launch {
            try {
                val result = memoryTool.getPid(packageName)
                withContext(Dispatchers.Main) {
                    callback(Result.success(result))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.P)
    override fun getProcessInfo(offset: Long, limit: Long, callback: (Result<List<ProcessInfo>>) -> Unit) {
        scope.launch {
            try {
                val result = memoryTool.getProcessInfo(offset.toInt(), limit.toInt())
                withContext(Dispatchers.Main) {
                    callback(Result.success(result))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun getMemoryRegions(query: MemoryRegionQuery, callback: (Result<List<MemoryRegion>>) -> Unit) {
        scope.launch {
            try {
                val result = memoryTool.getMemoryRegions(query)
                withContext(Dispatchers.Main) {
                    callback(Result.success(result))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun getSearchSessionState(callback: (Result<SearchSessionState>) -> Unit) {
        scope.launch {
            try {
                val result = memoryTool.getSearchSessionState()
                withContext(Dispatchers.Main) {
                    callback(Result.success(result))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun getSearchTaskState(callback: (Result<SearchTaskState>) -> Unit) {
        scope.launch {
            try {
                val result = memoryTool.getSearchTaskState()
                withContext(Dispatchers.Main) {
                    callback(Result.success(result))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun getSearchResults(offset: Long, limit: Long, callback: (Result<List<SearchResult>>) -> Unit) {
        scope.launch {
            try {
                val result = memoryTool.getSearchResults(offset.toInt(), limit.toInt())
                withContext(Dispatchers.Main) {
                    callback(Result.success(result))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun getPointerScanSessionState(callback: (Result<PointerScanSessionState>) -> Unit) {
        scope.launch {
            try {
                val result = memoryTool.getPointerScanSessionState()
                withContext(Dispatchers.Main) {
                    callback(Result.success(result))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun getPointerScanTaskState(callback: (Result<PointerScanTaskState>) -> Unit) {
        scope.launch {
            try {
                val result = memoryTool.getPointerScanTaskState()
                withContext(Dispatchers.Main) {
                    callback(Result.success(result))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun getPointerScanResults(offset: Long, limit: Long, callback: (Result<List<PointerScanResult>>) -> Unit) {
        scope.launch {
            try {
                val result = memoryTool.getPointerScanResults(offset.toInt(), limit.toInt())
                withContext(Dispatchers.Main) {
                    callback(Result.success(result))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun getPointerScanChaseHint(callback: (Result<PointerScanChaseHint>) -> Unit) {
        scope.launch {
            try {
                val result = memoryTool.getPointerScanChaseHint()
                withContext(Dispatchers.Main) {
                    callback(Result.success(result))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun getPointerAutoChaseState(callback: (Result<PointerAutoChaseState>) -> Unit) {
        scope.launch {
            try {
                val result = memoryTool.getPointerAutoChaseState()
                withContext(Dispatchers.Main) {
                    callback(Result.success(result))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun getPointerAutoChaseLayerResults(
        layerIndex: Long,
        offset: Long,
        limit: Long,
        callback: (Result<List<PointerScanResult>>) -> Unit
    ) {
        scope.launch {
            try {
                val result = memoryTool.getPointerAutoChaseLayerResults(
                    layerIndex.toInt(),
                    offset.toInt(),
                    limit.toInt()
                )
                withContext(Dispatchers.Main) {
                    callback(Result.success(result))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun addMemoryBreakpoint(
        request: AddMemoryBreakpointRequest,
        callback: (Result<MemoryBreakpoint>) -> Unit
    ) {
        scope.launch {
            try {
                val result = memoryTool.addMemoryBreakpoint(request)
                withContext(Dispatchers.Main) {
                    callback(Result.success(result))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun removeMemoryBreakpoint(breakpointId: String, callback: (Result<Unit>) -> Unit) {
        scope.launch {
            try {
                memoryTool.removeMemoryBreakpoint(breakpointId)
                withContext(Dispatchers.Main) {
                    callback(Result.success(Unit))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun setMemoryBreakpointEnabled(
        breakpointId: String,
        enabled: Boolean,
        callback: (Result<Unit>) -> Unit
    ) {
        scope.launch {
            try {
                memoryTool.setMemoryBreakpointEnabled(breakpointId, enabled)
                withContext(Dispatchers.Main) {
                    callback(Result.success(Unit))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun listMemoryBreakpoints(
        pid: Long,
        callback: (Result<List<MemoryBreakpoint>>) -> Unit
    ) {
        scope.launch {
            try {
                val result = memoryTool.listMemoryBreakpoints(pid.toInt())
                withContext(Dispatchers.Main) {
                    callback(Result.success(result))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun getMemoryBreakpointState(
        pid: Long,
        callback: (Result<MemoryBreakpointState>) -> Unit
    ) {
        scope.launch {
            try {
                val result = memoryTool.getMemoryBreakpointState(pid.toInt())
                withContext(Dispatchers.Main) {
                    callback(Result.success(result))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun getMemoryBreakpointHits(
        pid: Long,
        offset: Long,
        limit: Long,
        callback: (Result<List<MemoryBreakpointHit>>) -> Unit
    ) {
        scope.launch {
            try {
                val result = memoryTool.getMemoryBreakpointHits(
                    pid.toInt(),
                    offset.toInt(),
                    limit.toInt()
                )
                withContext(Dispatchers.Main) {
                    callback(Result.success(result))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun clearMemoryBreakpointHits(pid: Long, callback: (Result<Unit>) -> Unit) {
        scope.launch {
            try {
                memoryTool.clearMemoryBreakpointHits(pid.toInt())
                withContext(Dispatchers.Main) {
                    callback(Result.success(Unit))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun resumeAfterBreakpoint(pid: Long, callback: (Result<Unit>) -> Unit) {
        scope.launch {
            try {
                memoryTool.resumeAfterBreakpoint(pid.toInt())
                withContext(Dispatchers.Main) {
                    callback(Result.success(Unit))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun patchMemoryInstruction(
        request: MemoryInstructionPatchRequest,
        callback: (Result<MemoryInstructionPatchResult>) -> Unit
    ) {
        scope.launch {
            try {
                val result = memoryTool.patchMemoryInstruction(request)
                withContext(Dispatchers.Main) {
                    callback(Result.success(result))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun disassembleMemory(
        pid: Long,
        addresses: List<Long>,
        callback: (Result<List<MemoryInstructionPreview>>) -> Unit
    ) {
        scope.launch {
            try {
                val result = memoryTool.disassembleMemory(pid.toInt(), addresses)
                withContext(Dispatchers.Main) {
                    callback(Result.success(result))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun readMemoryValues(requests: List<MemoryReadRequest>, callback: (Result<List<MemoryValuePreview>>) -> Unit) {
        scope.launch {
            try {
                val result = memoryTool.readMemoryValues(requests)
                withContext(Dispatchers.Main) {
                    callback(Result.success(result))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun writeMemoryValue(request: MemoryWriteRequest, callback: (Result<Unit>) -> Unit) {
        scope.launch {
            try {
                memoryTool.writeMemoryValue(request)
                withContext(Dispatchers.Main) {
                    callback(Result.success(Unit))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun setMemoryFreeze(request: MemoryFreezeRequest, callback: (Result<Unit>) -> Unit) {
        scope.launch {
            try {
                memoryTool.setMemoryFreeze(request)
                withContext(Dispatchers.Main) {
                    callback(Result.success(Unit))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun getFrozenMemoryValues(callback: (Result<List<FrozenMemoryValue>>) -> Unit) {
        scope.launch {
            try {
                val result = memoryTool.getFrozenMemoryValues()
                withContext(Dispatchers.Main) {
                    callback(Result.success(result))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun isProcessPaused(pid: Long, callback: (Result<Boolean>) -> Unit) {
        scope.launch {
            try {
                val result = memoryTool.isProcessPaused(pid)
                withContext(Dispatchers.Main) {
                    callback(Result.success(result))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun setProcessPaused(pid: Long, paused: Boolean, callback: (Result<Unit>) -> Unit) {
        scope.launch {
            try {
                memoryTool.setProcessPaused(pid, paused)
                withContext(Dispatchers.Main) {
                    callback(Result.success(Unit))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun firstScan(request: FirstScanRequest, callback: (Result<Unit>) -> Unit) {
        scope.launch {
            try {
                memoryTool.firstScan(request)
                withContext(Dispatchers.Main) {
                    callback(Result.success(Unit))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun nextScan(request: NextScanRequest, callback: (Result<Unit>) -> Unit) {
        scope.launch {
            try {
                memoryTool.nextScan(request)
                withContext(Dispatchers.Main) {
                    callback(Result.success(Unit))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun cancelSearch(callback: (Result<Unit>) -> Unit) {
        scope.launch {
            try {
                memoryTool.cancelSearch()
                withContext(Dispatchers.Main) {
                    callback(Result.success(Unit))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun resetSearchSession(callback: (Result<Unit>) -> Unit) {
        scope.launch {
            try {
                memoryTool.resetSearchSession()
                withContext(Dispatchers.Main) {
                    callback(Result.success(Unit))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun startPointerScan(request: PointerScanRequest, callback: (Result<Unit>) -> Unit) {
        scope.launch {
            try {
                memoryTool.startPointerScan(request)
                withContext(Dispatchers.Main) {
                    callback(Result.success(Unit))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun startPointerAutoChase(
        request: PointerAutoChaseRequest,
        callback: (Result<Unit>) -> Unit
    ) {
        scope.launch {
            try {
                memoryTool.startPointerAutoChase(request)
                withContext(Dispatchers.Main) {
                    callback(Result.success(Unit))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun cancelPointerScan(callback: (Result<Unit>) -> Unit) {
        scope.launch {
            try {
                memoryTool.cancelPointerScan()
                withContext(Dispatchers.Main) {
                    callback(Result.success(Unit))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun cancelPointerAutoChase(callback: (Result<Unit>) -> Unit) {
        scope.launch {
            try {
                memoryTool.cancelPointerAutoChase()
                withContext(Dispatchers.Main) {
                    callback(Result.success(Unit))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun resetPointerScanSession(callback: (Result<Unit>) -> Unit) {
        scope.launch {
            try {
                memoryTool.resetPointerScanSession()
                withContext(Dispatchers.Main) {
                    callback(Result.success(Unit))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun resetPointerAutoChase(callback: (Result<Unit>) -> Unit) {
        scope.launch {
            try {
                memoryTool.resetPointerAutoChase()
                withContext(Dispatchers.Main) {
                    callback(Result.success(Unit))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    fun cleanup() {
        scope.cancel()
        memoryTool.close()
    }
}
