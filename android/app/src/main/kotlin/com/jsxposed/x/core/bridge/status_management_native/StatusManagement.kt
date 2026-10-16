package com.jsxposed.xmod.core.bridge.status_management_native

import android.content.Context
import android.os.Build
import androidx.annotation.RequiresApi
import com.jsxposed.xmod.core.bridge.lsposed_native.LSPosed
import com.jsxposed.xmod.core.bridge.zygisk_frida_native.ZygiskFrida
import com.jsxposed.xmod.core.constants.PathConstant
import com.jsxposed.xmod.core.utils.log.LogX
import com.jsxposed.xmod.core.utils.shell.Shell
import io.flutter.FlutterInjector
import java.util.concurrent.TimeUnit
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.withContext

class StatusManagement(private val context: Context? = null) {

    companion object {
        private const val TAG = "StatusManagement"
    }

    fun isHook(): Boolean {
        if (!LSPosed.isServiceConnected()) {
            context?.applicationContext?.let { LSPosed.initService(it) }
        }
        return LSPosed.isServiceConnected()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun isRoot(): Boolean {
        return try {
            val process = Runtime.getRuntime().exec(arrayOf("su", "-c", "id")).apply {
                waitFor(1500, TimeUnit.MILLISECONDS)
            }
            process.exitValue() == 0
        } catch (e: Exception) {
            LogX.e(tag = TAG, "isRoot", e)
            false
        }
    }

    fun isFrida(): FridaStatusData {
        return try {
            val zygiskFrida = ZygiskFrida()
            val moduleInstalled = zygiskFrida.isModuleInstalled()
            val moduleReady = if (moduleInstalled) zygiskFrida.isModuleReady() else false

            FridaStatusData(
                status = moduleReady,
                type = when {
                    moduleInstalled && moduleReady -> 1
                    moduleInstalled -> 0
                    else -> -1
                },
            )
        } catch (e: Exception) {
            LogX.e(TAG, "isFrida", e)
            FridaStatusData(status = false, type = -1)
        }
    }

}


