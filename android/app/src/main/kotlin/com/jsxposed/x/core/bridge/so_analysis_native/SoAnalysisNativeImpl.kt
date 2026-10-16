package com.jsxposed.xmod.core.bridge.so_analysis_native

import android.content.Context
import com.jsxposed.xmod.core.bridge.apk_analysis_native.ApkSession

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class SoAnalysisNativeImpl(private val context: Context, private val sharedSession: ApkSession) : SoAnalysisNative {
    private val soAnalysis = SoAnalysis(context)
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)

    private fun ensureSession(sessionId: String) {
        val path = try {
            sharedSession.getLocalPath(sessionId)
        } catch (_: Exception) {
            soAnalysis.clearSession(sessionId)
            return
        }
        soAnalysis.registerSession(sessionId, path)
    }

    override fun parseSoHeader(sessionId: String, soPath: String, callback: (Result<SoElfHeader>) -> Unit) {
        scope.launch {
            try {
                ensureSession(sessionId)
                val result = soAnalysis.parseSoHeader(sessionId, soPath)
                withContext(Dispatchers.Main) { callback(Result.success(result)) }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) { callback(Result.failure(e)) }
            }
        }
    }

    override fun getSoSections(sessionId: String, soPath: String, callback: (Result<List<SoSection>>) -> Unit) {
        scope.launch {
            try {
                ensureSession(sessionId)
                val result = soAnalysis.getSoSections(sessionId, soPath)
                withContext(Dispatchers.Main) { callback(Result.success(result)) }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) { callback(Result.failure(e)) }
            }
        }
    }

    override fun getExportedSymbols(sessionId: String, soPath: String, callback: (Result<List<SoSymbol>>) -> Unit) {
        scope.launch {
            try {
                ensureSession(sessionId)
                val result = soAnalysis.getExportedSymbols(sessionId, soPath)
                withContext(Dispatchers.Main) { callback(Result.success(result)) }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) { callback(Result.failure(e)) }
            }
        }
    }

    override fun getImportedSymbols(sessionId: String, soPath: String, callback: (Result<List<SoSymbol>>) -> Unit) {
        scope.launch {
            try {
                ensureSession(sessionId)
                val result = soAnalysis.getImportedSymbols(sessionId, soPath)
                withContext(Dispatchers.Main) { callback(Result.success(result)) }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) { callback(Result.failure(e)) }
            }
        }
    }

    override fun getDependencies(sessionId: String, soPath: String, callback: (Result<List<SoDependency>>) -> Unit) {
        scope.launch {
            try {
                ensureSession(sessionId)
                val result = soAnalysis.getDependencies(sessionId, soPath)
                withContext(Dispatchers.Main) { callback(Result.success(result)) }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) { callback(Result.failure(e)) }
            }
        }
    }

    override fun getJniFunctions(sessionId: String, soPath: String, callback: (Result<List<SoJniFunction>>) -> Unit) {
        scope.launch {
            try {
                ensureSession(sessionId)
                val result = soAnalysis.getJniFunctions(sessionId, soPath)
                withContext(Dispatchers.Main) { callback(Result.success(result)) }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) { callback(Result.failure(e)) }
            }
        }
    }

    override fun getSoStrings(sessionId: String, soPath: String, callback: (Result<List<SoString>>) -> Unit) {
        scope.launch {
            try {
                ensureSession(sessionId)
                val result = soAnalysis.getSoStrings(sessionId, soPath)
                withContext(Dispatchers.Main) { callback(Result.success(result)) }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) { callback(Result.failure(e)) }
            }
        }
    }

    override fun generateFridaHook(sessionId: String, soPath: String, symbolName: String, address: Long, callback: (Result<String>) -> Unit) {
        scope.launch {
            try {
                ensureSession(sessionId)
                val result = soAnalysis.generateFridaHook(sessionId, soPath, symbolName, address)
                withContext(Dispatchers.Main) { callback(Result.success(result)) }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) { callback(Result.failure(e)) }
            }
        }
    }

    fun cleanup() {
        scope.cancel()
        soAnalysis.clearAll()
    }
}
