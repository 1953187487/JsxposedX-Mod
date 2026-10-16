package com.jsxposed.xmod.xposed

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.widget.Toast
import com.jsxposed.xmod.util.Prefs

/**
 * Dhizuku 辅助权限适配层。
 *
 * 功能：
 * - 检测 Dhizuku 是否安装
 * - 引导用户安装 Dhizuku（从 F-Droid 或 GitHub）
 * - 请求辅助权限
 * - 通过 Dhizuku 执行模块安装/卸载命令
 */
object DhizukuModule {

    private const val PACKAGE_DHIZUKU = "xyz.dhiyan.dhizuku"
    private const val ACTION_DHIZUKU = "xyz.dhiyan.dhizuku.ACTION_REQUEST_AUTHORIZATION"
    private const val ACTION_DHIZUKU_SHELL = "xyz.dhiyan.dhizuku.ACTION_REQUEST_SHELL_EXECUTION"
    private const val EXTRA_DHIZUKU_PACKAGE = "xyz.dhiyan.dhizuku.EXTRA_PACKAGE"
    private const val EXTRA_DHIZUKU_CMD = "xyz.dhiyan.dhizuku.EXTRA_CMD"

    private const val DHIZUKU_DOWNLOAD_URL = "https://github.com/dhizuku/xyz.dhiyan.dhizuku/releases/latest"

    /** 检查 Dhizuku 是否已安装 */
    fun isInstalled(ctx: Context): Boolean {
        return try {
            ctx.packageManager.getPackageInfo(PACKAGE_DHIZUKU, 0)
            true
        } catch (e: PackageManager.NameNotFoundException) {
            false
        }
    }

    /** 检查是否已获得 Dhizuku 授权 */
    fun isAuthorized(ctx: Context): Boolean =
        Prefs.getBool(ctx, "dhizuku_authorized", false)

    /** 引导用户安装 Dhizuku */
    fun promptInstall(ctx: Context) {
        Toast.makeText(ctx, "请先安装 Dhizuku 应用", Toast.LENGTH_LONG).show()
        openUrl(ctx, DHIZUKU_DOWNLOAD_URL)
    }

    /** 请求 Dhizuku 授权 */
    fun requestAuthorization(ctx: Context): Boolean {
        if (!isInstalled(ctx)) {
            promptInstall(ctx)
            return false
        }
        val intent = Intent(ACTION_DHIZUKU).apply {
            putExtra(EXTRA_DHIZUKU_PACKAGE, ctx.packageName)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        return try {
            ctx.startActivity(intent)
            Prefs.putBool(ctx, "dhizuku_authorized", true)
            true
        } catch (e: Exception) {
            false
        }
    }

    /** 通过 Dhizuku 执行 shell 命令 */
    fun execCommand(ctx: Context, command: String): Boolean {
        if (!isInstalled(ctx)) return false
        val intent = Intent(ACTION_DHIZUKU_SHELL).apply {
            putExtra(EXTRA_DHIZUKU_PACKAGE, ctx.packageName)
            putExtra(EXTRA_DHIZUKU_CMD, command)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        return try {
            ctx.startActivity(intent)
            true
        } catch (e: Exception) {
            false
        }
    }

    /** 安装 Xposed 模块（通过 Dhizuku 推送到模块目录） */
    fun installModule(ctx: Context, modulePath: String, moduleId: String): Boolean {
        if (!isAuthorized(ctx)) return false
        val cmd = "mkdir -p /data/data/xyz.dhiyan.dhizuku/files/modules/$moduleId && " +
            "cp -r $modulePath/* /data/data/xyz.dhiyan.dhizuku/files/modules/$moduleId/"
        return execCommand(ctx, cmd)
    }

    /** 卸载 Xposed 模块 */
    fun uninstallModule(ctx: Context, moduleId: String): Boolean {
        if (!isAuthorized(ctx)) return false
        val cmd = "rm -rf /data/data/xyz.dhiyan.dhizuku/files/modules/$moduleId"
        return execCommand(ctx, cmd)
    }

    /** 打开 Dhizuku 应用设置页 */
    fun openDhizukuApp(ctx: Context) {
        if (!isInstalled(ctx)) {
            promptInstall(ctx)
            return
        }
        val intent = ctx.packageManager.getLaunchIntentForPackage(PACKAGE_DHIZUKU)
        intent?.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        ctx.startActivity(intent)
    }

    private fun openUrl(ctx: Context, url: String) {
        try {
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url)).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            ctx.startActivity(intent)
        } catch (e: Exception) {
            Toast.makeText(ctx, "无法打开浏览器: $url", Toast.LENGTH_LONG).show()
        }
    }
}
