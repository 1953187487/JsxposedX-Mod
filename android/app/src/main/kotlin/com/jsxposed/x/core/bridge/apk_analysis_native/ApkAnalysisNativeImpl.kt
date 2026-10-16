package com.jsxposed.xmod.core.bridge.apk_analysis_native

import android.content.Context
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlinx.coroutines.withTimeout

class ApkAnalysisNativeImpl(val context: Context, internal val sharedSession: ApkSession = ApkSession(context)) : ApkAnalysisNative {
    private val apkAnalysis = ApkAnalysis(context, sharedSession)
    // 使用 SupervisorJob 确保一个任务失败不影响其他任务
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)

    override fun openApkSession(packageName: String, callback: (Result<String>) -> Unit) {
        scope.launch {
            try {
                val result = apkAnalysis.openSession(packageName)
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

    override fun closeApkSession(sessionId: String, callback: (Result<Unit>) -> Unit) {
        scope.launch {
            try {
                apkAnalysis.closeSession(sessionId)
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

    override fun getApkAssets(sessionId: String, callback: (Result<List<ApkAsset>>) -> Unit) {
        scope.launch {
            try {
                val result = apkAnalysis.getApkAssets(sessionId)
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

    override fun getApkAssetsAt(sessionId: String, path: String, callback: (Result<List<ApkAsset>>) -> Unit) {
        scope.launch {
            try {
                val result = apkAnalysis.getApkAssetsAt(sessionId, path)
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

    override fun parseManifest(sessionId: String, callback: (Result<ApkManifest>) -> Unit) {
        scope.launch {
            try {
                val result = apkAnalysis.parseManifest(sessionId)
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

    override fun getDexPackages(sessionId: String, dexPaths: List<String>, packagePrefix: String, callback: (Result<List<String>>) -> Unit) {
        scope.launch {
            try {
                val result = apkAnalysis.getDexPackages(sessionId, dexPaths, packagePrefix)
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

    override fun getDexClasses(sessionId: String, dexPaths: List<String>, packageName: String, callback: (Result<List<DexClass>>) -> Unit) {
        scope.launch {
            try {
                val result = apkAnalysis.getDexClasses(sessionId, dexPaths, packageName)
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

    override fun getClassSmali(sessionId: String, dexPaths: List<String>, className: String, callback: (Result<String>) -> Unit) {
        scope.launch {
            try {
                // Smali 生成通常较快，设置 15 秒超时
                val result = withTimeout(15000) {
                    apkAnalysis.getClassSmali(sessionId, dexPaths, className)
                }
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

    override fun decompileClass(sessionId: String, dexPaths: List<String>, className: String, callback: (Result<String>) -> Unit) {
        scope.launch {
            try {
                // Java 反编译可能很慢，设置 30 秒超时
                val result = withTimeout(30000) {
                    apkAnalysis.decompileClass(sessionId, dexPaths, className)
                }
                withContext(Dispatchers.Main) {
                    callback(Result.success(result))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    val errorMsg = when {
                        e.message?.contains("Timed out") == true -> 
                            "反编译超时，DEX文件可能太大或类过于复杂"
                        else -> e.message ?: "反编译失败"
                    }
                    callback(Result.failure(Exception(errorMsg)))
                }
            }
        }
    }

    override fun searchDexClasses(sessionId: String, dexPaths: List<String>, keyword: String, callback: (Result<List<String>>) -> Unit) {
        scope.launch {
            try {
                val result = apkAnalysis.searchDexClasses(sessionId, dexPaths, keyword)
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

    // 清理资源
    fun cleanup() {
        scope.cancel()
        apkAnalysis.clearCaches()
    }
}
