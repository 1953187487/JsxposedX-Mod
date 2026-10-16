package com.jsxposed.xmod.core.utils.log

import android.util.Log

/**
 * 统一日志管理类
 * 支持多参数拼接、可选换行符，以及标准的日志等级
 */
class LogX {

    companion object {
        private const val TAG = "JsxposedX"

        /**
         * 错误日志
         */
        fun e(tag: String = "", vararg msg: Any, lineBreak: Boolean = false) {
            log(Log.ERROR, tag, lineBreak, *msg)
        }

        /**
         * 警告日志
         */
        fun w(tag: String = "", vararg msg: Any, lineBreak: Boolean = false) {
            log(Log.WARN, tag, lineBreak, *msg)
        }

        /**
         * 信息日志
         */
        fun i(tag: String = "", vararg msg: Any, lineBreak: Boolean = false) {
            log(Log.INFO, tag, lineBreak, *msg)
        }

        /**
         * 调试日志
         */
        fun d(tag: String = "", vararg msg: Any, lineBreak: Boolean = false) {
            log(Log.DEBUG, tag, lineBreak, *msg)
        }

        /**
         * 核心记录逻辑
         */
        private fun log(priority: Int, tag: String, lineBreak: Boolean, vararg msg: Any) {
            val finalTag = if (tag.isEmpty()) TAG else "$TAG-$tag"
            val separator = if (lineBreak) "\n" else " "
            val message = msg.joinToString(separator)
            Log.println(priority, finalTag, message)
        }
    }
}
