package com.jsxposed.xmod.xposed

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import androidx.core.content.FileProvider
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.IOException
import java.security.MessageDigest

/**
 * Dhizuku 权限适配层
 * 
 * 提供以下功能：
 * - 检测 Dhizuku 是否已安装
 * - 引导用户安装 Dhizuku
 * - 请求 Dhizuku 授权
 * - 执行需要 shell 权限的命令
 * - 管理模块文件
 * 
 * Dhizuku 包名：xyz.dhiyan.dhizuku
 * 模块路径：/data/data/xyz.dhiyan.dhizuku/files/modules/
 */
object DhizukuModule {

    private const val TAG = "DhizukuModule"
    
    // Dhizuku 包名
    const val DHIZUKU_PACKAGE = "xyz.dhiyan.dhizuku"
    
    // Dhizuku Action
    const val ACTION_REQUEST_AUTHORIZATION = "xyz.dhiyan.dhizuku.ACTION_REQUEST_AUTHORIZATION"
    const val ACTION_REQUEST_SHELL_EXECUTION = "xyz.dhiyan.dhizuku.ACTION_REQUEST_SHELL_EXECUTION"
    
    // Dhizuku Extra
    const val EXTRA_PACKAGE = "xyz.dhiyan.dhizuku.EXTRA_PACKAGE"
    const val EXTRA_CMD = "xyz.dhiyan.dhizuku.EXTRA_CMD"
    
    // Dhizuku 模块路径
    const val DHIZUKU_DATA_DIR = "/data/data/xyz.dhiyan.dhizuku/files"
    const val DHIZUKU_MODULES_DIR = "/data/data/xyz.dhiyan.dhizuku/files/modules"
    
    // 模块元数据文件
    private const val MODULE_META_FILE = "module_meta.json"
    
    /**
     * 检测结果数据类
     */
    data class DhizukuCheckResult(
        val isInstalled: Boolean,
        val versionName: String,
        val versionCode: Int,
        val packageName: String
    )

    /**
     * 检测 Dhizuku 是否已安装
     *
     * @param context 应用上下文
     * @return DhizukuCheckResult 包含安装状态和版本信息
     */
    fun checkDhizukuInstalled(context: Context): DhizukuCheckResult {
        return try {
            val packageInfo = context.packageManager.getPackageInfo(DHIZUKU_PACKAGE, 0)
            DhizukuCheckResult(
                isInstalled = true,
                versionName = packageInfo.versionName ?: "",
                versionCode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                    packageInfo.longVersionCode.toInt()
                } else {
                    @Suppress("DEPRECATION")
                    packageInfo.versionCode
                },
                packageName = DHIZUKU_PACKAGE
            )
        } catch (e: PackageManager.NameNotFoundException) {
            DhizukuCheckResult(
                isInstalled = false,
                versionName = "",
                versionCode = 0,
                packageName = DHIZUKU_PACKAGE
            )
        } catch (e: Exception) {
            Log.e(TAG, "Failed to check Dhizuku installation", e)
            DhizukuCheckResult(
                isInstalled = false,
                versionName = "",
                versionCode = 0,
                packageName = DHIZUKU_PACKAGE
            )
        }
    }

    /**
     * 请求 Dhizuku 授权
     * 
     * 此方法会启动 Dhizuku 的授权界面，用户授权后，
     * 本应用将获得 shell 权限执行命令。
     *
     * @param context 应用上下文
     * @param requestCode 请求码，用于 onActivityResult 回调
     */
    fun requestAuthorization(context: Context, requestCode: Int) {
        try {
            val intent = Intent(ACTION_REQUEST_AUTHORIZATION).apply {
                setPackage(DHIZUKU_PACKAGE)
                putExtra(EXTRA_PACKAGE, context.packageName)
            }
            context.startActivityForResult(intent, requestCode)
            Log.d(TAG, "Requested Dhizuku authorization")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to request Dhizuku authorization", e)
        }
    }

    /**
     * 请求执行 Shell 命令
     * 
     * 通过 Dhizuku 执行需要 shell 权限的命令。
     *
     * @param context 应用上下文
     * @param command 要执行的命令
     * @param requestCode 请求码
     * @param callback 命令执行回调
     */
    fun requestShellExecution(
        context: Context,
        command: String,
        requestCode: Int,
        callback: ShellExecutionCallback?
    ) {
        try {
            val intent = Intent(ACTION_REQUEST_SHELL_EXECUTION).apply {
                setPackage(DHIZUKU_PACKAGE)
                putExtra(EXTRA_PACKAGE, context.packageName)
                putExtra(EXTRA_CMD, command)
            }
            context.startActivityForResult(intent, requestCode)
            Log.d(TAG, "Requested shell execution: $command")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to request shell execution", e)
            callback?.onExecutionFailed("Failed to request shell execution: ${e.message}")
        }
    }

    /**
     * 检查模块目录是否存在
     *
     * @return true 如果模块目录存在
     */
    fun checkModuleDirectoryExists(): Boolean {
        return File(DHIZUKU_MODULES_DIR).exists()
    }

    /**
     * 创建模块目录（需要 Dhizuku shell 权限）
     *
     * @param context 应用上下文
     * @param callback 创建结果回调
     */
    fun createModuleDirectory(context: Context, callback: ShellExecutionCallback?) {
        val command = "mkdir -p $DHIZUKU_MODULES_DIR"
        requestShellExecution(context, command, 1001, callback)
    }

    /**
     * 复制模块文件到 Dhizuku 模块目录
     * 
     * 将本地模块文件复制到 Dhizuku 的模块目录，
     * 目标进程重启后会自动加载。
     *
     * @param context 应用上下文
     * @param localModulePath 本地模块文件路径
     * @param moduleName 模块名称
     * @param callback 复制结果回调
     */
    fun copyModuleToDhizuku(
        context: Context,
        localModulePath: String,
        moduleName: String,
        callback: ShellExecutionCallback?
    ) {
        try {
            val localFile = File(localModulePath)
            if (!localFile.exists()) {
                callback?.onExecutionFailed("Module file not found: $localModulePath")
                return
            }

            // 计算模块文件哈希
            val fileHash = calculateFileHash(localFile)
            
            // 创建模块目录
            val moduleDir = "$DHIZUKU_MODULES_DIR/$moduleName"
            val command = "mkdir -p $moduleDir"
            requestShellExecution(context, command, 1002, object : ShellExecutionCallback {
                override fun onExecutionSuccess(output: String) {
                    // 复制模块文件
                    val copyCommand = "cp $localModulePath $moduleDir/"
                    requestShellExecution(context, copyCommand, 1003, object : ShellExecutionCallback {
                        override fun onExecutionSuccess(output: String) {
                            // 写入元数据
                            val metaCommand = "echo '{\"name\":\"$moduleName\",\"hash\":\"$fileHash\",\"time\":${System.currentTimeMillis()}}' > $moduleDir/$MODULE_META_FILE"
                            requestShellExecution(context, metaCommand, 1004, callback)
                        }
                        
                        override fun onExecutionFailed(error: String) {
                            callback?.onExecutionFailed("Failed to copy module: $error")
                        }
                    })
                }
                
                override fun onExecutionFailed(error: String) {
                    callback?.onExecutionFailed("Failed to create module directory: $error")
                }
            })
        } catch (e: Exception) {
            Log.e(TAG, "Failed to copy module to Dhizuku", e)
            callback?.onExecutionFailed("Failed to copy module: ${e.message}")
        }
    }

    /**
     * 删除模块
     *
     * @param context 应用上下文
     * @param moduleName 模块名称
     * @param callback 删除结果回调
     */
    fun deleteModule(context: Context, moduleName: String, callback: ShellExecutionCallback?) {
        val command = "rm -rf $DHIZUKU_MODULES_DIR/$moduleName"
        requestShellExecution(context, command, 1005, callback)
    }

    /**
     * 列出已安装的模块
     *
     * @param context 应用上下文
     * @param callback 列表结果回调
     */
    fun listModules(context: Context, callback: ShellExecutionCallback?) {
        val command = "ls -1 $DHIZUKU_MODULES_DIR 2>/dev/null || echo ''"
        requestShellExecution(context, command, 1006, callback)
    }

    /**
     * 检查模块是否已安装
     *
     * @param context 应用上下文
     * @param moduleName 模块名称
     * @param callback 检查结果回调
     */
    fun isModuleInstalled(context: Context, moduleName: String, callback: ShellExecutionCallback?) {
        val command = "test -d $DHIZUKU_MODULES_DIR/$moduleName && echo 'installed' || echo 'not_installed'"
        requestShellExecution(context, command, 1007, callback)
    }

    /**
     * 计算文件哈希值
     *
     * @param file 要计算哈希的文件
     * @return SHA-256 哈希值
     */
    private fun calculateFileHash(file: File): String {
        try {
            val digest = MessageDigest.getInstance("SHA-256")
            val fis = FileInputStream(file)
            val buffer = ByteArray(8192)
            var len: Int
            while (fis.read(buffer).also { len = it } != -1) {
                digest.update(buffer, 0, len)
            }
            fis.close()
            return digest.digest().joinToString("") { "%02x".format(it) }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to calculate file hash", e)
            return ""
        }
    }

    /**
     * 获取 Dhizuku 安装链接
     *
     * @return Dhizuku 官方下载地址
     */
    fun getDhizukuDownloadUrl(): String {
        return "https://github.com/dhiyanrd/dhizuku/releases"
    }

    /**
     * 打开 Dhizuku 应用（如果已安装）
     *
     * @param context 应用上下文
     */
    fun openDhizuku(context: Context) {
        try {
            val intent = context.packageManager.getLaunchIntentForPackage(DHIZUKU_PACKAGE)
            if (intent != null) {
                context.startActivity(intent)
                Log.d(TAG, "Opened Dhizuku app")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to open Dhizuku", e)
        }
    }

    /**
     * Shell 执行回调接口
     */
    interface ShellExecutionCallback {
        fun onExecutionSuccess(output: String)
        fun onExecutionFailed(error: String)
    }
}