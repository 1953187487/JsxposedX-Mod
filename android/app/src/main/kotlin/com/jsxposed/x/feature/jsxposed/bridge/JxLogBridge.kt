package com.jsxposed.xmod.feature.jsxposed.bridge

import com.whl.quickjs.wrapper.QuickJSContext
import de.robv.android.xposed.XposedBridge
import java.net.URLEncoder
import java.nio.charset.StandardCharsets

/**
 * Xposed 官方日志能力桥接
 */
class JxLogBridge(private val qjs: QuickJSContext) {

    @Volatile
    private var currentScriptName: String = "<unknown>"

    @Volatile
    private var currentRunId: String = ""

    fun beginScriptScope(scriptKey: String, runId: String) {
        currentScriptName = scriptKey.substringAfterLast('/')
        currentRunId = runId
    }

    fun endScriptScope() {
        currentScriptName = "<unknown>"
        currentRunId = ""
    }

    fun <T> withScriptScope(scriptName: String, runId: String, block: () -> T): T {
        val previousName = currentScriptName
        val previousRunId = currentRunId
        currentScriptName = scriptName.substringAfterLast('/')
        currentRunId = runId
        return try {
            block()
        } finally {
            currentScriptName = previousName
            currentRunId = previousRunId
        }
    }

    fun log(message: String): Any? {
        return log("I", message)
    }

    fun log(level: String, message: String): Any? {
        emit(level, message)
        return null
    }

    fun logException(message: String): Any? {
        return log("E", message)
    }

    private fun emit(level: String, message: String) {
        val encodedRunId = encode(currentRunId)
        val encodedScript = encode(currentScriptName)
        val encodedMessage = encode(message)
        XposedBridge.log("JXCONSOLE|v2|xposed|$encodedRunId|$encodedScript|$level|$encodedMessage")
    }

    private fun encode(value: String): String =
        URLEncoder.encode(value, StandardCharsets.UTF_8.name()).replace("+", "%20")
}
