package com.jsxposed.xmod.xposed

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.util.Log
import com.rosan.dhizuku.api.Dhizuku
import com.rosan.dhizuku.api.DhizukuRequestPermissionListener
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.coroutines.withTimeoutOrNull

/**
 * Dhizuku 适配层。
 *
 * Dhizuku 通过设备所有者（Device Owner）身份向普通应用共享受管权限，
 * 官方 SDK 为 `io.github.iamr0s:Dhizuku-API`，包名为 `com.rosan.dhizuku`。
 *
 * 这里只封装官方 API 真实提供的能力：安装检测、服务初始化、授权状态查询与授权请求。
 * 模块的加载与作用域管理仍由 libxposed / LSPosed 服务负责。
 */
object DhizukuModule {

    private const val TAG = "DhizukuModule"

    /** Dhizuku 官方包名。 */
    const val DHIZUKU_PACKAGE = "com.rosan.dhizuku"

    /** Dhizuku 官方下载地址。 */
    const val DOWNLOAD_URL = "https://github.com/iamr0s/Dhizuku/releases"

    /** 等待用户在 Dhizuku 授权页操作的最长时间。 */
    private const val PERMISSION_TIMEOUT_MS = 60_000L

    /**
     * Dhizuku 当前状态。
     *
     * @property installed 设备上是否安装了 Dhizuku
     * @property activated Dhizuku 是否已激活为设备所有者且服务可用
     * @property permissionGranted 本应用是否已获得 Dhizuku 授权
     * @property ownerPackage 当前设备所有者应用包名（可能是 Dhizuku 的兼容实现）
     * @property serverVersionName Dhizuku 服务端 API 版本名
     * @property serverVersionCode Dhizuku 服务端 API 版本号
     */
    data class DhizukuState(
        val installed: Boolean = false,
        val activated: Boolean = false,
        val permissionGranted: Boolean = false,
        val ownerPackage: String = "",
        val serverVersionName: String = "",
        val serverVersionCode: Int = 0,
    )

    @Volatile
    private var initialized = false

    /**
     * 读取 Dhizuku 状态。内部包含跨进程调用，禁止在主线程直接调用。
     */
    fun getState(context: Context): DhizukuState {
        val installed = isInstalled(context)
        if (!installed) return DhizukuState(installed = false)

        val activated = ensureInitialized(context)
        if (!activated) {
            return DhizukuState(installed = true, activated = false)
        }

        val granted = runCatching { Dhizuku.isPermissionGranted() }
            .onFailure { Log.w(TAG, "isPermissionGranted failed: ${it.message}") }
            .getOrDefault(false)
        val ownerPackage = runCatching { Dhizuku.getOwnerPackageName() }
            .getOrDefault("")
        val versionName = runCatching { Dhizuku.getVersionName() }
            .getOrDefault("")
        val versionCode = runCatching { Dhizuku.getVersionCode() }
            .getOrDefault(0)

        return DhizukuState(
            installed = true,
            activated = true,
            permissionGranted = granted,
            ownerPackage = ownerPackage,
            serverVersionName = versionName,
            serverVersionCode = versionCode,
        )
    }

    /**
     * 判断 Dhizuku 是否已安装。Android 11 及以上依赖清单中的 `<queries>` 声明。
     */
    fun isInstalled(context: Context): Boolean {
        return try {
            context.packageManager.getPackageInfo(DHIZUKU_PACKAGE, 0)
            true
        } catch (e: PackageManager.NameNotFoundException) {
            false
        } catch (e: Exception) {
            Log.e(TAG, "Failed to check Dhizuku installation", e)
            false
        }
    }

    /**
     * 初始化 Dhizuku 服务。失败表示 Dhizuku 未安装、未激活或服务不可达。
     */
    fun ensureInitialized(context: Context): Boolean {
        if (initialized) return true
        return synchronized(this) {
            if (initialized) {
                true
            } else {
                val result = runCatching { Dhizuku.init(context.applicationContext) }
                    .onFailure { Log.e(TAG, "Dhizuku.init failed", it) }
                    .getOrDefault(false)
                initialized = result
                result
            }
        }
    }

    /**
     * 请求 Dhizuku 授权，返回用户是否授予权限。
     *
     * 授权结果通过 Dhizuku 服务回调返回，超过 [PERMISSION_TIMEOUT_MS] 视为失败。
     */
    suspend fun requestPermission(context: Context): Boolean {
        if (!ensureInitialized(context)) return false
        if (runCatching { Dhizuku.isPermissionGranted() }.getOrDefault(false)) {
            return true
        }

        val result = CompletableDeferred<Boolean>()
        val listener = object : DhizukuRequestPermissionListener() {
            override fun onRequestPermission(grantResult: Int) {
                result.complete(grantResult == PackageManager.PERMISSION_GRANTED)
            }
        }

        // requestPermission 内部会启动授权 Activity，必须在主线程发起。
        withContext(Dispatchers.Main) {
            runCatching { Dhizuku.requestPermission(listener) }
                .onFailure {
                    Log.e(TAG, "requestPermission failed", it)
                    result.complete(false)
                }
        }

        return withTimeoutOrNull(PERMISSION_TIMEOUT_MS) { result.await() } ?: false
    }

    /** 打开 Dhizuku 应用，未安装时返回 false。 */
    fun openDhizuku(context: Context): Boolean {
        return try {
            val intent = context.packageManager.getLaunchIntentForPackage(DHIZUKU_PACKAGE)
                ?: return false
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
            true
        } catch (e: Exception) {
            Log.e(TAG, "Failed to open Dhizuku", e)
            false
        }
    }

    /** 打开发布页，供用户下载安装 Dhizuku。 */
    fun openDownloadPage(context: Context): Boolean {
        return try {
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(DOWNLOAD_URL))
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
            true
        } catch (e: Exception) {
            Log.e(TAG, "Failed to open Dhizuku download page", e)
            false
        }
    }
}
