package com.jsxposed.xmod.core.utils

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.ActivityInfo
import androidx.core.net.toUri

object ApkUtils {

    fun getResolveInfo(context: Context, packageName: String): ActivityInfo? {
        val packageManager = context.packageManager
        val intent = packageManager.getLaunchIntentForPackage(packageName)
        return intent?.resolveActivityInfo(packageManager, 0)
    }

    fun openAppX(context: Context, packageName: String) {
        try {
            // 方法1：通过包名直接启动
            val intent = context.packageManager.getLaunchIntentForPackage(packageName)?.apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }

            if (intent != null) {
                context.startActivity(intent)
            } else {
                // 方法2：通过隐式Intent启动
                val fallbackIntent = Intent(Intent.ACTION_VIEW).apply {
                    data = "package:$packageName".toUri()
                    setPackage(packageName)
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }
                context.startActivity(fallbackIntent)
            }
        } catch (_: ActivityNotFoundException) {

        }

    }
}
