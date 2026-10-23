package com.jsxposed.xmod.xposed

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.widget.Toast
import rikka.shizuku.Shizuku
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.coroutines.withTimeoutOrNull

object ShizukuModule {

    private const val TAG = "ShizukuModule"
    private const val PERMISSION_REQUEST_CODE = 1000
    private const val PERMISSION_TIMEOUT_MS = 60_000L
    const val SHIZUKU_PACKAGE = "moe.shizuku.privileged.api"
    const val DOWNLOAD_URL = "https://github.com/RikkaApps/Shizuku/releases"

    data class ShizukuState(
        val running: Boolean = false,
        val permissionGranted: Boolean = false,
        val isPreV11: Boolean = false,
        val version: Int = 0,
        val selinuxContext: String = "",
    )

    @Volatile
    private var listenerAdded = false

    fun getState(context: Context): ShizukuState {
        if (Shizuku.isPreV11()) {
            return ShizukuState(isPreV11 = true)
        }

        val running = runCatching { Shizuku.pingBinder() }
            .onFailure { Log.w(TAG, "pingBinder failed: ${it.message}") }
            .getOrDefault(false)

        if (!running) {
            return ShizukuState(running = false, isPreV11 = false)
        }

        val granted = runCatching { Shizuku.checkSelfPermission() }
            .getOrDefault(PackageManager.PERMISSION_DENIED) == PackageManager.PERMISSION_GRANTED
        val version = runCatching { Shizuku.getVersion() }
            .getOrDefault(0)
        val selinuxContext = runCatching { Shizuku.getSELinuxContext() }
            .getOrDefault("")

        return ShizukuState(
            running = true,
            permissionGranted = granted,
            isPreV11 = false,
            version = version,
            selinuxContext = selinuxContext,
        )
    }

    suspend fun requestPermission(context: Context): Boolean {
        if (Shizuku.isPreV11()) return false

        if (runCatching { Shizuku.checkSelfPermission() }
                .getOrDefault(PackageManager.PERMISSION_DENIED) == PackageManager.PERMISSION_GRANTED
        ) {
            return true
        }

        val result = CompletableDeferred<Boolean>()
        val listener = object : Shizuku.OnRequestPermissionResultListener {
            override fun onRequestPermissionResult(requestCode: Int, grantResult: Int) {
                if (requestCode == PERMISSION_REQUEST_CODE) {
                    result.complete(
                        grantResult == PackageManager.PERMISSION_GRANTED
                    )
                }
            }
        }

        ensureListenerAdded(listener, result)

        withContext(Dispatchers.Main) {
            runCatching { Shizuku.requestPermission(PERMISSION_REQUEST_CODE) }
                .onFailure {
                    Log.e(TAG, "requestPermission failed", it)
                    result.complete(false)
                }
        }

        return withTimeoutOrNull(PERMISSION_TIMEOUT_MS) { result.await() } ?: false
    }

    private fun ensureListenerAdded(
        listener: Shizuku.OnRequestPermissionResultListener,
        result: CompletableDeferred<Boolean>,
    ) {
        synchronized(this) {
            if (!listenerAdded) {
                val handler = Handler(Looper.getMainLooper())
                Shizuku.addRequestPermissionResultListener(listener, handler)
                listenerAdded = true
            }
        }
    }

    fun openShizuku(context: Context): Boolean {
        return try {
            val intent = context.packageManager.getLaunchIntentForPackage(SHIZUKU_PACKAGE)
                ?: return false
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
            true
        } catch (e: Exception) {
            Log.e(TAG, "Failed to open Shizuku", e)
            false
        }
    }

    fun openDownloadPage(context: Context): Boolean {
        return try {
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(DOWNLOAD_URL))
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
            true
        } catch (e: Exception) {
            Log.e(TAG, "Failed to open Shizuku download page", e)
            false
        }
    }

    fun isShizukuInstalled(context: Context): Boolean {
        return try {
            context.packageManager.getPackageInfo(SHIZUKU_PACKAGE, 0)
            true
        } catch (e: PackageManager.NameNotFoundException) {
            false
        } catch (e: Exception) {
            Log.e(TAG, "Failed to check Shizuku installation", e)
            false
        }
    }
}
