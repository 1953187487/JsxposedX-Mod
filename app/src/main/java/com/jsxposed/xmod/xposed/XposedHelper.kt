package com.jsxposed.xmod.xposed

import android.content.Context
import com.jsxposed.xmod.util.Prefs

/**
 * 统一的 Xposed 模块管理能力（基于 JsxposedX 二改）。
 *
 * 核心特性：
 * - 无需 root / 面具 / 授权
 * - 仅依赖 Dhizuku 辅助权限
 * - 模块注入路径：/data/data/xyz.dhiyan.dhizuku/files/modules/<模块名>/
 * - 目标进程重启后自动加载
 *
 * 当前可用的模块：
 * | 模块名 | 说明 |
 * |---|---|
 * | jsxposedx_core | JsxposedX 核心 hook 模块 |
 * | jsxposedx_frida | Frida 桥接模块 |
 * | jsxposedx_ai | AI 辅助模块 |
 */
object XposedHelper {

    /** 模块定义 */
    data class Module(
        val id: String,
        val name: String,
        val desc: String,
        val required: Boolean
    )

    /** JsxposedX 自带模块列表 */
    val MODULES = listOf(
        Module("jsxposedx_core", "JsxposedX 核心", "提供 Xposed/LSPosed 服务集成与 hook 核心", true),
        Module("jsxposedx_frida", "Frida 桥接", "Frida 脚本注入与 RPC 桥", false),
        Module("jsxposedx_ai", "AI 辅助", "内置 AI 分析辅助", false)
    )

    /** 获取已安装模块 */
    fun installedModules(ctx: Context): List<Module> {
        return MODULES.filter { Prefs.getBool(ctx, "module_${it.id}_installed", false) }
    }

    /** 安装指定模块 */
    fun installModule(ctx: Context, module: Module): Boolean {
        if (!DhizukuModule.isInstalled(ctx)) {
            DhizukuModule.promptInstall(ctx)
            return false
        }
        if (!DhizukuModule.isAuthorized(ctx)) {
            DhizukuModule.requestAuthorization(ctx)
        }

        val success = DhizukuModule.installModule(ctx, module.id, module.id)
        if (success) {
            Prefs.putBool(ctx, "module_${module.id}_installed", true)
        }
        return success
    }

    /** 卸载模块 */
    fun uninstallModule(ctx: Context, module: Module) {
        if (DhizukuModule.isInstalled(ctx)) {
            DhizukuModule.uninstallModule(ctx, module.id)
        }
        Prefs.putBool(ctx, "module_${module.id}_installed", false)
    }
}
