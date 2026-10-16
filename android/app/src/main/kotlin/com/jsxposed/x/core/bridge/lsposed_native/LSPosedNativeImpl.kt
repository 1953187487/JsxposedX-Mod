package com.jsxposed.xmod.core.bridge.lsposed_native

import android.content.Context
import com.jsxposed.xmod.core.utils.log.LogX

/**
 * LSPosed 桥接层 - 符合项目规范
 * 只负责调用逻辑层，不包含业务逻辑
 */
class LSPosedNativeImpl(val context: Context) : LSPosedNative {
    
    private val lsposed = LSPosed(context)
    
    override fun addModuleScope(
        packageName: String,
        userId: Long,
        callback: (Result<Boolean>) -> Unit
    ) {
        LogX.d("LSPosedNativeImpl", "addModuleScope called for: $packageName")
        
        try {
            val success = lsposed.addScope(packageName)
            callback(Result.success(success))
        } catch (e: Exception) {
            LogX.e("LSPosedNativeImpl", "addModuleScope error: ${e.message}")
            callback(Result.failure(e))
        }
    }
    
    override fun removeModuleScope(
        packageName: String,
        userId: Long,
        callback: (Result<Boolean>) -> Unit
    ) {
        try {
            val success = lsposed.removeScope(packageName)
            callback(Result.success(success))
        } catch (e: Exception) {
            callback(Result.failure(e))
        }
    }
    
    override fun getModuleScope(callback: (Result<List<String>>) -> Unit) {
        try {
            val scopes = lsposed.getScope()
            callback(Result.success(scopes))
        } catch (e: Exception) {
            callback(Result.failure(e))
        }
    }
    
    override fun isLSPosedAvailable(): Boolean {
        return lsposed.isAvailable()
    }
}
