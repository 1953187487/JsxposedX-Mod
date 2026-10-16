package com.jsxposed.xmod.bridge

import android.util.Log
import io.flutter.plugin.common.BinaryMessenger

/**
 * 持有主 Flutter 引擎的 BinaryMessenger。
 * 前台服务在 App 处于前台时，用它把 script.run/console/log 等需完整运行态的请求
 * 通过 Pigeon 转发给 Dart handler 执行（打开目标应用 / 注入 Frida 等）。
 */
object DesktopBridgeMessengerHolder {
    private const val TAG = "DesktopBridgeMessenger"
    private var messenger: BinaryMessenger? = null

    @Synchronized
    fun attach(m: BinaryMessenger) {
        messenger = m
        Log.d(TAG, "Attached main engine messenger")
    }

    @Synchronized
    fun messenger(): BinaryMessenger? = messenger
}
