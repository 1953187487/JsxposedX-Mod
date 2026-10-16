package com.jsxposed.xmod.feature.jsxposed.hook

import android.content.Context
import com.jsxposed.xmod.core.utils.log.LogX
import com.jsxposed.xmod.feature.hook.LPParam
import com.jsxposed.xmod.feature.jsxposed.manager.JsXposedManager
import de.robv.android.xposed.XC_MethodHook
import de.robv.android.xposed.XposedHelpers
import java.util.Collections

object HookJsXposed {

    private const val TAG = "FINDBUGS"
    private val initStarted = Collections.synchronizedSet(mutableSetOf<String>())
    private val setupStarted = Collections.synchronizedSet(mutableSetOf<String>())

    private fun trace(message: String) {
        LogX.d(TAG, message)
    }

    fun setup(lpparam: LPParam) {
        try {
            val processKey = "${lpparam.packageName}|${lpparam.processName}"
            trace("HookJsXposed.setup start package=${lpparam.packageName} process=${lpparam.processName} thread=${Thread.currentThread().name}")
            if (!setupStarted.add(processKey)) {
                trace("HookJsXposed.setup skip duplicate package=${lpparam.packageName} process=${lpparam.processName}")
                return
            }

            XposedHelpers.findAndHookMethod(
                "android.app.Application",
                lpparam.classLoader,
                "attach",
                Context::class.java,
                object : XC_MethodHook() {
                    override fun afterHookedMethod(param: MethodHookParam) {
                        val context = param.args[0] as? Context ?: return
                        trace("HookJsXposed.afterAttach enter package=${lpparam.packageName} process=${lpparam.processName} thread=${Thread.currentThread().name} context=${context.javaClass.name}")

                        if (!initStarted.add(processKey)) {
                            trace("HookJsXposed.init already started package=${lpparam.packageName} process=${lpparam.processName}")
                            return
                        }

                        Thread {
                            val start = System.currentTimeMillis()
                            try {
                                trace("HookJsXposed.async init start package=${lpparam.packageName} process=${lpparam.processName} worker=${Thread.currentThread().name}")
                                JsXposedManager.init(context, lpparam)
                                trace("HookJsXposed.async init finish package=${lpparam.packageName} process=${lpparam.processName} cost=${System.currentTimeMillis() - start}ms")
                            } catch (t: Throwable) {
                                initStarted.remove(processKey)
                                LogX.e(TAG, "HookJsXposed.async init failed: ${t.message}")
                            }
                        }.apply {
                            name = "JsXposedInit-${lpparam.packageName}"
                            isDaemon = true
                            start()
                        }

                        trace("HookJsXposed.afterAttach return package=${lpparam.packageName} process=${lpparam.processName}")
                    }
                }
            )

            trace("HookJsXposed.setup attach hook installed package=${lpparam.packageName} process=${lpparam.processName}")
        } catch (e: Throwable) {
            LogX.e(TAG, "HookJsXposed.setup failed: ${e.message}")
        }
    }
}
