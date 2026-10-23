package com.jsxposed.xmod.core.bridge.shizuku_native

import android.content.Context
import com.jsxposed.xmod.xposed.ShizukuModule
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class ShizukuNativeImpl(context: Context) : ShizukuNative {

    private val appContext = context.applicationContext
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)

    override fun getStatus(callback: (Result<ShizukuStatus>) -> Unit) {
        scope.launch {
            val result = runCatching {
                val state = ShizukuModule.getState(appContext)
                ShizukuStatus(
                    running = state.running,
                    permissionGranted = state.permissionGranted,
                    isPreV11 = state.isPreV11,
                    version = state.version.toLong(),
                    selinuxContext = state.selinuxContext,
                    installed = ShizukuModule.isShizukuInstalled(appContext),
                )
            }
            withContext(Dispatchers.Main.immediate) { callback(result) }
        }
    }

    override fun requestPermission(callback: (Result<Boolean>) -> Unit) {
        scope.launch {
            val result = runCatching {
                ShizukuModule.requestPermission(appContext)
            }
            withContext(Dispatchers.Main.immediate) { callback(result) }
        }
    }

    override fun openShizuku(): Boolean {
        return ShizukuModule.openShizuku(appContext)
    }

    override fun openDownloadPage(): Boolean {
        return ShizukuModule.openDownloadPage(appContext)
    }

    fun dispose() {
        scope.cancel()
    }
}
