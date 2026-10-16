package com.jsxposed.xmod.core.js

import com.whl.quickjs.wrapper.QuickJSContext
import com.jsxposed.xmod.core.js.core.ZiplineEngine
import com.jsxposed.xmod.core.js.core.JxEnvironment
import com.jsxposed.xmod.core.utils.log.LogX
import com.google.gson.Gson

/**
 * Zipline/QuickJS 管理门面
 * 回归纯 QuickJS 模式，确保 Xposed 环境极致稳定
 */
object ZiplineManager {
    private val TAG = "ZiplineManager"
    private val engine = ZiplineEngine()
    private val gson = Gson()

    /**
     * 在 JS 引擎线程同步执行任务并返回结果
     */
    fun <T> runInEngine(task: (QuickJSContext) -> T): T {
        return engine.submit { task(it) }
    }

    /**
     * 同步加载脚本
     */
    fun loadScript(script: String, name: String) {
        engine.execute { q ->
            try {
                LogX.d(TAG, "同步加载脚本: $name")
                q.evaluate(script, name)
            } catch (e: Exception) {
                LogX.e(TAG, "加载失败 ($name): ${e.message}")
            }
        }
    }

    fun evaluateSync(script: String, name: String = "eval"): Any? {
        return engine.submit { it.evaluate(script, name) }
    }

    fun release() {
        engine.shutDown()
    }

    /**
     * 初始化全局环境
     */
    private fun setupEnvironment(q: QuickJSContext) {
        LogX.d(TAG, "开始初始化 JS 运行环境...")
        JxEnvironment.setup(q)
    }

    init {
        LogX.d(TAG, "ZiplineManager 初始化...")
        // 预热环境
        engine.execute { setupEnvironment(it) }
    }
}
