package com.jsxposed.xmod.core.bridge.status_management_native

import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import com.jsxposed.xmod.core.bridge.lsposed_native.LSPosed
import com.jsxposed.xmod.core.bridge.zygisk_frida_native.ZygiskFrida
import com.jsxposed.xmod.core.constants.PathConstant
import com.jsxposed.xmod.core.utils.log.LogX
import com.jsxposed.xmod.core.utils.shell.Shell
import com.jsxposed.xmod.xposed.DhizukuModule
import com.jsxposed.xmod.xposed.ShizukuModule
import com.rosan.dhizuku.api.Dhizuku
import io.flutter.FlutterInjector
import java.util.concurrent.TimeUnit
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.withContext
import rikka.shizuku.Shizuku

class StatusManagement(private val context: Context? = null) {

    companion object {
        private const val TAG = "StatusManagement"
    }

    fun isHook(): Boolean {
        // LSPosed 服务连接
        if (!LSPosed.isServiceConnected()) {
            context?.applicationContext?.let { LSPosed.initService(it) }
        }
        if (LSPosed.isServiceConnected()) return true

        // Dhizuku 授权
        context?.let { ctx ->
            try {
                if (DhizukuModule.isInstalled(ctx) && DhizukuModule.ensureInitialized(ctx)) {
                    if (Dhizuku.isPermissionGranted()) return true
                }
            } catch (e: Exception) {
                Log.d(TAG, "Dhizuku check failed: ${e.message}")
            }
        }

        // Shizuku 授权
        try {
            if (!Shizuku.isPreV11() && Shizuku.checkSelfPermission() == PackageManager.PERMISSION_GRANTED) {
                return true
            }
        } catch (e: Exception) {
            Log.d(TAG, "Shizuku check failed: ${e.message}")
        }

        return false
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


