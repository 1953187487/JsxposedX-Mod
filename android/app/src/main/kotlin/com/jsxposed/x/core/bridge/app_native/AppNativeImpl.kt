package com.jsxposed.xmod.core.bridge.app_native

import android.content.Context
import kotlinx.coroutines.*

class AppNativeImpl(context: Context) : AppNative {
    private val app = App(context.applicationContext)
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)

    override fun getAppCount(includeSystemApps: Boolean, query: String): Long {
        return app.getAppCount(includeSystemApps, query).toLong()
    }

    override fun getInstalledApps(
        includeSystemApps: Boolean,
        offset: Long,
        limit: Long,
        query: String,
        callback: (Result<List<AppInfo>>) -> Unit
    ) {
        // 使用协程在 IO 线程执行查询，避免 UI 卡顿
        scope.launch {
            val result = try {
                val apps = app.getInstalledApps(
                    includeSystemApps,
                    offset.toInt(),
                    limit.toInt(),
                    query
                )
                Result.success(apps)
            } catch (e: Exception) {
                Result.failure(e)
            }
            withContext(Dispatchers.Main.immediate) { callback(result) }
        }
    }

    override fun getAppByPackageName(packageName: String, callback: (Result<AppInfo?>) -> Unit) {
        scope.launch {
            val result = try {
                val app = app.getAppByPackageName(packageName)
                Result.success(app)
            } catch (e: Exception) {
                Result.failure(e)
            }
            withContext(Dispatchers.Main.immediate) { callback(result) }
        }
    }

    override fun openAppX(
        packageName: String,
        callback: (Result<Unit>) -> Unit
    ) {
        scope.launch {
            val result: Result<Unit> = try {
                app.openAppX(packageName)
                Result.success(Unit)
            } catch (e: Exception) {
                Result.failure(e)
            }
            withContext(Dispatchers.Main.immediate) { callback(result) }
        }
    }

    fun dispose() {
        scope.cancel()
    }
}
