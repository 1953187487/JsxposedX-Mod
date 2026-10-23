package com.jsxposed.xmod.xposed

import android.content.Context

/**
 * Xposed 模块环境辅助入口。
 *
 * 模块的加载、作用域管理由 libxposed / LSPosed 服务负责；
 * 这里只统一暴露 Dhizuku 免 root 权限链路的状态，供桥接层调用。
 */
object XposedHelper {

    /** 读取 Dhizuku 状态，包含安装、激活与授权信息。 */
    fun getDhizukuState(context: Context): DhizukuModule.DhizukuState {
        return DhizukuModule.getState(context)
    }

    /** Dhizuku 是否已激活并可用。 */
    fun isDhizukuAvailable(context: Context): Boolean {
        return DhizukuModule.getState(context).activated
    }

    /** 请求 Dhizuku 授权。 */
    suspend fun requestDhizukuPermission(context: Context): Boolean {
        return DhizukuModule.requestPermission(context)
    }
}
