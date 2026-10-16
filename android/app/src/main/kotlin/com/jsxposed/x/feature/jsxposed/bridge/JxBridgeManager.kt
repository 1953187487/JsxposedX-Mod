package com.jsxposed.xmod.feature.jsxposed.bridge

import com.jsxposed.xmod.feature.jsxposed.manager.JxSingleThreadDispatcher
import com.whl.quickjs.wrapper.JSObject
import com.whl.quickjs.wrapper.QuickJSContext

/**
 * 统管并且初始化所有的 Xposed API 桥接层，打包后混入到 JS 的 Jx 全局变量中
 */
class JxBridgeManager(
    private val qjs: QuickJSContext,
    private val classLoader: ClassLoader,
    private val dispatcher: JxSingleThreadDispatcher,
) {

    private val logBridge = JxLogBridge(qjs)
    private val hookBridge = JxHookBridge(qjs, classLoader, dispatcher, logBridge)
    private val classBridge = JxClassBridge(qjs, classLoader)
    private val fieldBridge = JxFieldBridge(qjs, classLoader)
    private val methodBridge = JxMethodBridge(qjs, classLoader)

    fun beginScriptScope(scriptKey: String, runId: String) {
        hookBridge.beginScriptScope(scriptKey, runId)
        logBridge.beginScriptScope(scriptKey, runId)
    }

    fun endScriptScope() {
        hookBridge.endScriptScope()
        logBridge.endScriptScope()
    }

    fun unhookScript(scriptKey: String): Int {
        return hookBridge.unhookScript(scriptKey)
    }

    fun injectToJs() {
        val globalObj = qjs.globalObject
        
        // 如果 global 里面没有 Jx，则创建一个空的
        var jx = globalObj.getProperty("Jx") as? JSObject
        if (jx == null) {
            jx = qjs.createNewJSObject()
            globalObj.setProperty("Jx", jx)
        }

        // --- 1. 注入 LogBridge 模块 ---
        jx.setProperty("log") { args ->
            logBridge.log(args?.get(0)?.toString() ?: "")
        }
        jx.setProperty("logException") { args ->
            logBridge.logException(args?.get(0)?.toString() ?: "")
        }

        val console = qjs.createNewJSObject()
        console.setProperty("log") { args ->
            logBridge.log("I", args?.get(0)?.toString() ?: "")
        }
        console.setProperty("info") { args ->
            logBridge.log("I", args?.get(0)?.toString() ?: "")
        }
        console.setProperty("warn") { args ->
            logBridge.log("W", args?.get(0)?.toString() ?: "")
        }
        console.setProperty("error") { args ->
            logBridge.log("E", args?.get(0)?.toString() ?: "")
        }
        globalObj.setProperty("console", console)

        // --- 2. 注入 ClassBridge 模块 ---
        jx.setProperty("findClass") { args ->
            classBridge.findClass(args?.get(0)?.toString() ?: "")
        }
        jx.setProperty("loadClass") { args ->
            classBridge.loadClass(args?.get(0)?.toString() ?: "")
        }
        jx.setProperty("newInstance") { args ->
            val className = args?.get(0)?.toString() ?: ""
            val paramTypes = args?.get(1) as? com.whl.quickjs.wrapper.JSArray
            val paramValues = args?.get(2) as? com.whl.quickjs.wrapper.JSArray
            classBridge.newInstance(className, paramTypes, paramValues)
        }
        
        // --- 3. 注入 FieldBridge 模块 ---
        jx.setProperty("getObjectField") { args -> fieldBridge.getObjectField(args) }
        jx.setProperty("setObjectField") { args -> fieldBridge.setObjectField(args) }
        jx.setProperty("getStaticObjectField") { args -> fieldBridge.getStaticObjectField(args) }
        jx.setProperty("setStaticObjectField") { args -> fieldBridge.setStaticObjectField(args) }
        
        // 专门给基本数据类型封装 (QuickJS JS端类型为 Number/Boolean)
        jx.setProperty("getIntField") { args -> fieldBridge.getIntField(args) }
        jx.setProperty("setIntField") { args -> fieldBridge.setIntField(args) }
        jx.setProperty("getBooleanField") { args -> fieldBridge.getBooleanField(args) }
        jx.setProperty("setBooleanField") { args -> fieldBridge.setBooleanField(args) }
        jx.setProperty("getLongField") { args -> fieldBridge.getLongField(args) }
        jx.setProperty("setLongField") { args -> fieldBridge.setLongField(args) }
        jx.setProperty("getFloatField") { args -> fieldBridge.getFloatField(args) }
        jx.setProperty("setFloatField") { args -> fieldBridge.setFloatField(args) }
        jx.setProperty("getDoubleField") { args -> fieldBridge.getDoubleField(args) }
        jx.setProperty("setDoubleField") { args -> fieldBridge.setDoubleField(args) }
        jx.setProperty("getShortField") { args -> fieldBridge.getShortField(args) }
        jx.setProperty("setShortField") { args -> fieldBridge.setShortField(args) }
        jx.setProperty("getByteField") { args -> fieldBridge.getByteField(args) }
        jx.setProperty("setByteField") { args -> fieldBridge.setByteField(args) }
        jx.setProperty("getCharField") { args -> fieldBridge.getCharField(args) }
        jx.setProperty("setCharField") { args -> fieldBridge.setCharField(args) }

        // 静态基本类型字段
        jx.setProperty("getStaticIntField") { args -> fieldBridge.getStaticIntField(args) }
        jx.setProperty("setStaticIntField") { args -> fieldBridge.setStaticIntField(args) }
        jx.setProperty("getStaticBooleanField") { args -> fieldBridge.getStaticBooleanField(args) }
        jx.setProperty("setStaticBooleanField") { args -> fieldBridge.setStaticBooleanField(args) }
        jx.setProperty("getStaticLongField") { args -> fieldBridge.getStaticLongField(args) }
        jx.setProperty("setStaticLongField") { args -> fieldBridge.setStaticLongField(args) }
        jx.setProperty("getStaticFloatField") { args -> fieldBridge.getStaticFloatField(args) }
        jx.setProperty("setStaticFloatField") { args -> fieldBridge.setStaticFloatField(args) }
        jx.setProperty("getStaticDoubleField") { args -> fieldBridge.getStaticDoubleField(args) }
        jx.setProperty("setStaticDoubleField") { args -> fieldBridge.setStaticDoubleField(args) }
        jx.setProperty("getStaticShortField") { args -> fieldBridge.getStaticShortField(args) }
        jx.setProperty("setStaticShortField") { args -> fieldBridge.setStaticShortField(args) }
        jx.setProperty("getStaticByteField") { args -> fieldBridge.getStaticByteField(args) }
        jx.setProperty("setStaticByteField") { args -> fieldBridge.setStaticByteField(args) }
        jx.setProperty("getStaticCharField") { args -> fieldBridge.getStaticCharField(args) }
        jx.setProperty("setStaticCharField") { args -> fieldBridge.setStaticCharField(args) }

        // 附加字段
        jx.setProperty("setExtra") { args -> fieldBridge.setExtra(args) }
        jx.setProperty("getExtra") { args -> fieldBridge.getExtra(args) }
        jx.setProperty("removeExtra") { args -> fieldBridge.removeExtra(args) }

        // --- 4. 注入 MethodBridge 模块 ---
        jx.setProperty("callMethod") { args ->
            val obj = args?.get(0)
            val methodName = args?.get(1)?.toString() ?: ""
            val paramTypes = args?.get(2) as? com.whl.quickjs.wrapper.JSArray
            val paramValues = args?.get(3) as? com.whl.quickjs.wrapper.JSArray
            methodBridge.callMethod(obj, methodName, paramTypes, paramValues)
        }
        jx.setProperty("callStaticMethod") { args ->
            val className = args?.get(0)?.toString() ?: ""
            val methodName = args?.get(1)?.toString() ?: ""
            val paramTypes = args?.get(2) as? com.whl.quickjs.wrapper.JSArray
            val paramValues = args?.get(3) as? com.whl.quickjs.wrapper.JSArray
            methodBridge.callStaticMethod(className, methodName, paramTypes, paramValues)
        }

        // --- 5. 注入 HookBridge (升级版) ---
        jx.setProperty("hookMethod") { args ->
            val className = args?.get(0)?.toString() ?: ""
            val methodName = args?.get(1)?.toString() ?: ""
            val paramTypes = args?.get(2) as? com.whl.quickjs.wrapper.JSArray
            val callbacks = args?.get(3) as? com.whl.quickjs.wrapper.JSObject
            if (callbacks != null) {
                hookBridge.hookMethod(className, methodName, paramTypes, callbacks)
            } else {
                com.jsxposed.xmod.core.utils.log.LogX.e("JxBridgeManager", "hookMethod: missing callbacks")
                -1
            }
        }

        jx.setProperty("hookConstructor") { args ->
            val className = args?.get(0)?.toString() ?: ""
            val paramTypes = args?.get(1) as? com.whl.quickjs.wrapper.JSArray
            val callbacks = args?.get(2) as? com.whl.quickjs.wrapper.JSObject
            if (callbacks != null) {
                hookBridge.hookConstructor(className, paramTypes, callbacks)
            } else -1
        }

        jx.setProperty("unhook") { args -> hookBridge.unhook(args) }

        jx.setProperty("hookAllMethods") { args ->
            val className = args?.get(0)?.toString() ?: ""
            val methodName = args?.get(1)?.toString() ?: ""
            val callbacks = args?.get(2) as? com.whl.quickjs.wrapper.JSObject
            if (callbacks != null) hookBridge.hookAllMethods(className, methodName, callbacks)
            else null
        }

        jx.setProperty("hookAllConstructors") { args ->
            val className = args?.get(0)?.toString() ?: ""
            val callbacks = args?.get(1) as? com.whl.quickjs.wrapper.JSObject
            if (callbacks != null) hookBridge.hookAllConstructors(className, callbacks)
            else null
        }

        jx.setProperty("invokeOriginal") { args -> hookBridge.invokeOriginal(args) }

        // --- 6. 注入 ClassBridge 内省方法 ---
        jx.setProperty("getMethods") { args -> classBridge.getMethods(args) }
        jx.setProperty("getFields") { args -> classBridge.getFields(args) }
        jx.setProperty("getConstructors") { args -> classBridge.getConstructors(args) }
        jx.setProperty("getSuperclass") { args -> classBridge.getSuperclass(args) }
        jx.setProperty("getInterfaces") { args -> classBridge.getInterfaces(args) }
        jx.setProperty("instanceOf") { args -> classBridge.instanceOf(args) }
    }
}
