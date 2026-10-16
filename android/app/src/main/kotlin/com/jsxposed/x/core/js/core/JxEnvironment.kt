package com.jsxposed.xmod.core.js.core

import com.whl.quickjs.wrapper.QuickJSContext
import com.jsxposed.xmod.core.js.bridge.JxNativeBridge
import com.jsxposed.xmod.core.utils.log.LogX

/**
 * JS 环境配置中心
 */
object JxEnvironment {
    
    fun setup(context: QuickJSContext) {
        // 使用原生的 QuickJS Context 提供一个本地函数回调，不依赖高级服务层，避免死循环！
        context.globalObject.setProperty("logToNative") { args ->
            if (args != null && args.size >= 2) {
                val level = args[0]?.toString() ?: "DEBUG"
                val msg = args[1]?.toString() ?: ""
                JxNativeBridge().log(level, "JS", msg)
            }
            null
        }

        // 2. 注入基础 Jx 环境和 console 转发
        val initScript = """
            (function() {
                // 1. 核心 Jx 命名空间
                globalThis.Jx = {
                    _modules: {},
                    register: function(name, obj) { 
                        globalThis.Jx._modules[name] = obj; 
                    }
                };

                globalThis.console = {
                    log: function(m) { logToNative("DEBUG", String(m)); },
                    info: function(m) { logToNative("INFO", String(m)); },
                    warn: function(m) { logToNative("INFO", String(m)); },
                    error: function(m) { logToNative("ERROR", String(m)); }
                };

                return "Jx QuickJs Runtime Ready";
            })();
        """.trimIndent()

        try {
            val result = context.evaluate(initScript, "jx_init.js")
            LogX.d("JxEnvironment", "初始化结果: " + result?.toString())
        } catch (e: Exception) {
            LogX.e("JxEnvironment", "初始化崩溃: ${e.message}")
        }
    }
}
