package com.jsxposed.xmod.core.js.bridge

import com.jsxposed.xmod.core.utils.log.LogX

/**
 * 宿主原生接口实现
 */
class JxNativeBridge : JxNativeApi {
    override fun log(level: String, tag: String, msg: String) {
        LogX.d("JxNativeBridge", "收到来自 JS 的日志: level=$level tag=$tag msg=$msg")
        when (level.uppercase()) {
            "ERROR" -> LogX.e(tag, msg)
            "INFO" -> LogX.i(tag, msg)
            else -> LogX.d(tag, msg)
        }
    }
}
