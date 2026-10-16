package com.jsxposed.xmod.xposed

import android.content.Context
import android.util.Log
import com.jsxposed.xmod.R
import java.io.File

/**
 * Xposed 模块辅助类
 * 
 * 统一管理 Xposed 模块的安装、卸载和状态查询。
 * 支持通过 Dhizuku 权限进行模块管理（无需 root）。
 */
object XposedHelper {

    private const val TAG = "XposedHelper"
    
    // 模块存储路径（Dhizuku 模式）
    private const val DHIZUKU_MODULES_PATH = "/data/data/xyz.dhiyan.dhizuku/files/modules"
    
    // 本地模块缓存路径
    private const val LOCAL_MODULES_CACHE = "modules_cache"

    /**
     * 模块信息数据类
     */
    data class ModuleInfo(
        val name: String,
        val path: String,
        val size: Long,
        val lastModified: Long,
        val isInstalled: Boolean,
        val installMethod: String // "dhizuku" or "local"
    )

    /**
     * 检查 Dhizuku 是否可用
     *
     * @param context 应用上下文
     * @return true 如果 Dhizuku 已安装
     */
    fun isDhizukuAvailable(context: Context): Boolean {
        return DhizukuModule.checkDhizukuInstalled(context).isInstalled
    }

    /**
     * 安装模块（通过 Dhizuku）
     *
     * @param context 应用上下文
     * @param moduleFilePath 模块文件路径
     * @param moduleName 模块名称
     * @param callback 安装结果回调
     */
    fun installModuleViaDhizuku(
        context: Context,
        moduleFilePath: String,
        moduleName: String,
        callback: InstallCallback?
    ) {
        if (!isDhizukuAvailable(context)) {
            callback?.onFailed("Dhizuku is not installed. Please install Dhizuku first.")
            return
        }

        // 请求 Dhizuku 授权
        DhizukuModule.requestAuthorization(context, 2001)

        // 复制模块到 Dhizuku 目录
        DhizukuModule.copyModuleToDhizuku(context, moduleFilePath, moduleName, object : DhizukuModule.ShellExecutionCallback {
            override fun onExecutionSuccess(output: String) {
                Log.d(TAG, "Module $moduleName installed via Dhizuku successfully")
                callback?.onSuccess("Module $moduleName installed successfully via Dhizuku")
            }

            override fun onExecutionFailed(error: String) {
                Log.e(TAG, "Failed to install module via Dhizuku: $error")
                callback?.onFailed("Failed to install module: $error")
            }
        })
    }

    /**
     * 卸载模块
     *
     * @param context 应用上下文
     * @param moduleName 模块名称
     * @param callback 卸载结果回调
     */
    fun uninstallModule(context: Context, moduleName: String, callback: UninstallCallback?) {
        DhizukuModule.deleteModule(context, moduleName, object : DhizukuModule.ShellExecutionCallback {
            override fun onExecutionSuccess(output: String) {
                Log.d(TAG, "Module $moduleName uninstalled successfully")
                callback?.onSuccess("Module $moduleName uninstalled successfully")
            }

            override fun onExecutionFailed(error: String) {
                Log.e(TAG, "Failed to uninstall module: $error")
                callback?.onFailed("Failed to uninstall module: $error")
            }
        })
    }

    /**
     * 获取已安装模块列表
     *
     * @param context 应用上下文
     * @param callback 列表结果回调
     */
    fun getInstalledModules(context: Context, callback: ModulesListCallback?) {
        DhizukuModule.listModules(context, object : DhizukuModule.ShellExecutionCallback {
            override fun onExecutionSuccess(output: String) {
                if (output.trim().isEmpty()) {
                    callback?.onSuccess(emptyList())
                    return
                }

                val modules = output.trim().split("\n").map { line ->
                    ModuleInfo(
                        name = line.trim(),
                        path = "$DHIZUKU_MODULES_PATH/${line.trim()}",
                        size = 0, // 需要额外查询
                        lastModified = 0, // 需要额外查询
                        isInstalled = true,
                        installMethod = "dhizuku"
                    )
                }
                callback?.onSuccess(modules)
            }

            override fun onExecutionFailed(error: String) {
                callback?.onFailed("Failed to get module list: $error")
            }
        })
    }

    /**
     * 检查模块是否已安装
     *
     * @param context 应用上下文
     * @param moduleName 模块名称
     * @param callback 检查结果回调
     */
    fun isModuleInstalled(context: Context, moduleName: String, callback: BooleanCallback?) {
        DhizukuModule.isModuleInstalled(context, moduleName, object : DhizukuModule.ShellExecutionCallback {
            override fun onExecutionSuccess(output: String) {
                val installed = output.trim() == "installed"
                callback?.onSuccess(installed)
            }

            override fun onExecutionFailed(error: String) {
                callback?.onFailed("Failed to check module status: $error")
            }
        })
    }

    /**
     * 获取模块详情
     *
     * @param context 应用上下文
     * @param moduleName 模块名称
     * @param callback 详情结果回调
     */
    fun getModuleInfo(context: Context, moduleName: String, callback: ModuleInfoCallback?) {
        val command = "ls -la $DHIZUKU_MODULES_PATH/$moduleName 2>/dev/null || echo 'not_found'"
        DhizukuModule.requestShellExecution(context, command, 2002, object : DhizukuModule.ShellExecutionCallback {
            override fun onExecutionSuccess(output: String) {
                if (output.contains("not_found")) {
                    callback?.onFailed("Module not found: $moduleName")
                    return
                }
                // 解析输出获取模块信息
                val moduleInfo = ModuleInfo(
                    name = moduleName,
                    path = "$DHIZUKU_MODULES_PATH/$moduleName",
                    size = 0,
                    lastModified = 0,
                    isInstalled = true,
                    installMethod = "dhizuku"
                )
                callback?.onSuccess(moduleInfo)
            }

            override fun onExecutionFailed(error: String) {
                callback?.onFailed("Failed to get module info: $error")
            }
        })
    }

    /**
     * 安装回调接口
     */
    interface InstallCallback {
        fun onSuccess(message: String)
        fun onFailed(error: String)
    }

    /**
     * 卸载回调接口
     */
    interface UninstallCallback {
        fun onSuccess(message: String)
        fun onFailed(error: String)
    }

    /**
     * 模块列表回调接口
     */
    interface ModulesListCallback {
        fun onSuccess(modules: List<ModuleInfo>)
        fun onFailed(error: String)
    }

    /**
     * 布尔回调接口
     */
    interface BooleanCallback {
        fun onSuccess(result: Boolean)
        fun onFailed(error: String)
    }

    /**
     * 模块信息回调接口
     */
    interface ModuleInfoCallback {
        fun onSuccess(info: ModuleInfo)
        fun onFailed(error: String)
    }
}