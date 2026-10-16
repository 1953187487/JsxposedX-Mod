package com.jsxposed.xmod.feature.jsxposed.manager

import android.content.Context
import android.util.Log
import com.jsxposed.xmod.core.utils.log.LogX
import com.jsxposed.xmod.core.js.ZiplineManager
import com.jsxposed.xmod.feature.jsxposed.bridge.JxHookBridge
import com.jsxposed.xmod.feature.jsxposed.loader.ScriptLoader
import com.whl.quickjs.android.QuickJSLoader
import com.jsxposed.xmod.feature.hook.LPParam

/**
 * JS Xposed 业务管理类
 */
object JsXposedManager {

    private const val TAG = "FINDBUGS"

    private fun trace(lpparam: LPParam, stage: String, start: Long? = null) {
        val cost = if (start == null) "" else " cost=${System.currentTimeMillis() - start}ms"
        LogX.d(TAG, "JsXposedManager package=${lpparam.packageName} process=${lpparam.processName} thread=${Thread.currentThread().name} pid=${android.os.Process.myPid()} stage=$stage$cost")
    }

    fun init(context: Context, lpparam: LPParam) {
        val packageName = lpparam.packageName
        val dispatcher = JxSingleThreadDispatcher(
            threadName = "JxQuickJs-${lpparam.packageName}-${lpparam.processName}"
        )

        try {
            dispatcher.submit {
                trace(lpparam, "init-start context=${context.javaClass.name}")
                val quickJsInitStart = System.currentTimeMillis()
                try {
                    QuickJSLoader.init()
                    trace(lpparam, "QuickJSLoader.init", quickJsInitStart)
                } catch (e: Throwable) {
                    LogX.e(TAG, "QuickJSLoader.init failed, trying reflection fallback: ${e.message}")
                    try {
                        val field = QuickJSLoader::class.java.getDeclaredField("sIsInit")
                        field.isAccessible = true
                        field.set(null, true)
                    } catch (t: Throwable) {
                        LogX.e(TAG, "Reflection fallback failed: ${t.message}")
                    }
                }

                val createContextStart = System.currentTimeMillis()
                val qjs = com.whl.quickjs.wrapper.QuickJSContext.create()
                trace(lpparam, "QuickJSContext.create", createContextStart)

                val environmentSetupStart = System.currentTimeMillis()
                com.jsxposed.xmod.core.js.core.JxEnvironment.setup(qjs)
                trace(lpparam, "JxEnvironment.setup", environmentSetupStart)

                val bridgeManager = com.jsxposed.xmod.feature.jsxposed.bridge.JxBridgeManager(
                    qjs,
                    lpparam.classLoader,
                    dispatcher,
                )
                val injectBridgeStart = System.currentTimeMillis()
                bridgeManager.injectToJs()
                trace(lpparam, "JxBridgeManager.injectToJs", injectBridgeStart)

                val sugarStart = System.currentTimeMillis()
                qjs.evaluate(JsSugar.CODE, "jx_sugar.js")
                trace(lpparam, "JsSugar.evaluate", sugarStart)

                val loader = ScriptLoader(context, qjs, packageName, bridgeManager)
                val scriptLoadStart = System.currentTimeMillis()
                loader.loadAndExecute()
                trace(lpparam, "ScriptLoader.loadAndExecute", scriptLoadStart)

                trace(lpparam, "init-finish")
            }
        } catch (e: Exception) {
            LogX.e(TAG, "QuickJS 核心挂载失败: ${e.message}")
        }
    }
}
