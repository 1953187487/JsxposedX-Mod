package com.jsxposed.xmod.core.bridge.dhizuku_native

import android.content.Context
import com.jsxposed.xmod.xposed.DhizukuModule
import com.jsxposed.xmod.xposed.XposedHelper
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/**
 * Dhizuku 桥接层：只做线程切换和类型映射，业务逻辑位于 [XposedHelper]。
 */
class DhizukuNativeImpl(context: Context) : DhizukuNative {

    private val appContext = context.applicationContext
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)

    override fun getStatus(callback: (Result<DhizukuStatus>) -> Unit) {
        scope.launch {
            val result = runCatching {
                val state = XposedHelper.getDhizukuState(appContext)
                DhizukuStatus(
                    installed = state.installed,
                    activated = state.activated,
                    permissionGranted = state.permissionGranted,
                    ownerPackage = state.ownerPackage,
                    serverVersionName = state.serverVersionName,
                    serverVersionCode = state.serverVersionCode.toLong(),
                )
            }
            withContext(Dispatchers.Main.immediate) { callback(result) }
        }
    }

    override fun requestPermission(callback: (Result<Boolean>) -> Unit) {
        scope.launch {
            val result = runCatching {
                XposedHelper.requestDhizukuPermission(appContext)
            }
            withContext(Dispatchers.Main.immediate) { callback(result) }
        }
    }

    override fun openDhizuku(): Boolean {
        return DhizukuModule.openDhizuku(appContext)
    }

    override fun openDownloadPage(): Boolean {
        return DhizukuModule.openDownloadPage(appContext)
    }

    fun dispose() {
        scope.cancel()
    }
}
