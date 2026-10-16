package com.jsxposed.xmod.bridge

import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/**
 * 把原生 WebSocket 服务器的活跃连接数上报给 Flutter（MethodChannel）。
 * 手机端首页据此显示电脑端是否已连接。attach 需在主线程调用。
 */
object DesktopConnectionReporter {
    private const val CHANNEL = "com.jsxposed.xmod/desktop_connection"
    private const val TAG = "DesktopConnectionReporter"
    private var channel: MethodChannel? = null
    private val mainHandler = Handler(Looper.getMainLooper())

    fun attach(messenger: BinaryMessenger) {
        channel = MethodChannel(messenger, CHANNEL)
        Log.d(TAG, "Attached to Flutter messenger")
    }

    fun report(count: Int) {
        mainHandler.post {
            channel?.invokeMethod("onConnectionCountChange", count)
        }
    }
}
