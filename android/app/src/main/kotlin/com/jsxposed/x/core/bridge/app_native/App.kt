package com.jsxposed.xmod.core.bridge.app_native

import android.content.Context
import android.content.pm.ApplicationInfo
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import com.jsxposed.xmod.core.utils.ApkUtils
import com.jsxposed.xmod.core.utils.shell.Shell
import java.io.ByteArrayOutputStream

/**
 * 核心逻辑类 (Worker)
 */
class App(private val context: Context) {
    private val pm = context.packageManager

    /**
     * Pigeon 接口调用：获取总数
     */
    fun getAppCount(includeSystemApps: Boolean, query: String): Int {
        val packages = pm.getInstalledPackages(0)
        return packages.count { pkg ->
            val appInfo = pkg.applicationInfo ?: return@count false
            val isSystem = (appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0
            if (!includeSystemApps && isSystem) return@count false

            if (query.isNotEmpty()) {
                val name = appInfo.loadLabel(pm).toString().lowercase()
                val pName = appInfo.packageName.lowercase()
                val q = query.lowercase()
                name.contains(q) || pName.contains(q)
            } else {
                true
            }
        }
    }

    /**
     * 获取应用列表 (供 Bridge 层调用并转换为 Pigeon 模型)
     */
    fun getInstalledApps(
        includeSystemApps: Boolean,
        offset: Int,
        limit: Int,
        query: String
    ): List<AppInfo> {
        val packages = pm.getInstalledPackages(0)
        val resultList = mutableListOf<AppInfo>()
        var currentCount = 0
        var sentCount = 0

        for (pkg in packages) {
            val app = pkg.applicationInfo ?: continue

            val isSystemApp = (app.flags and ApplicationInfo.FLAG_SYSTEM) != 0
            if (!includeSystemApps && isSystemApp) continue

            val appName = app.loadLabel(pm).toString()
            val packageName = app.packageName

            if (query.isNotEmpty()) {
                val lowerQuery = query.lowercase()
                if (!appName.lowercase().contains(lowerQuery) &&
                    !packageName.lowercase().contains(lowerQuery)
                ) {
                    continue
                }
            }

            if (currentCount < offset) {
                currentCount++
                continue
            }

            if (sentCount >= limit) break

            var versionName: String
            var versionCode: Long
            try {
                val pInfo = pm.getPackageInfo(app.packageName, 0)
                versionName = pInfo.versionName ?: ""
                versionCode =
                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.P) {
                        pInfo.longVersionCode
                    } else {
                        @Suppress("DEPRECATION")
                        pInfo.versionCode.toLong()
                    }
            } catch (e: Exception) {
                versionName = ""
                versionCode = 0
            }

            val iconBytes = try {
                val icon = app.loadIcon(pm)
                drawableToByteArray(icon)
            } catch (e: Exception) {
                null
            }

            resultList.add(
                AppInfo(
                    name = appName,
                    packageName = packageName,
                    versionName = versionName,
                    versionCode = versionCode,
                    isSystemApp = isSystemApp,
                    icon = iconBytes
                )
            )
            sentCount++
        }
        return resultList
    }

    private fun drawableToByteArray(drawable: Drawable): ByteArray {
        val width = if (drawable.intrinsicWidth > 0) drawable.intrinsicWidth else 100
        val height = if (drawable.intrinsicHeight > 0) drawable.intrinsicHeight else 100
        val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        drawable.setBounds(0, 0, canvas.width, canvas.height)
        drawable.draw(canvas)

        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
        val result = stream.toByteArray()
        bitmap.recycle()
        return result
    }

    fun getAppByPackageName(packageName: String): AppInfo? {
        return try {
            val pkg = pm.getPackageInfo(packageName, 0)
            val app = pkg.applicationInfo ?: return null
            val isSystemApp = (app.flags and ApplicationInfo.FLAG_SYSTEM) != 0
            val appName = app.loadLabel(pm).toString()

            val versionName = pkg.versionName ?: ""
            val versionCode =
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.P) {
                    pkg.longVersionCode
                } else {
                    @Suppress("DEPRECATION")
                    pkg.versionCode.toLong()
                }

            val iconBytes = try {
                val icon = app.loadIcon(pm)
                drawableToByteArray(icon)
            } catch (e: Exception) {
                null
            }

            AppInfo(
                name = appName,
                packageName = packageName,
                versionName = versionName,
                versionCode = versionCode,
                isSystemApp = isSystemApp,
                icon = iconBytes
            )
        } catch (e: Exception) {
            null
        }
    }

    fun openAppX(packageName: String) {
        Shell(su = true).execute("pkill -f $packageName")
        ApkUtils.openAppX(context, packageName)
    }
}
