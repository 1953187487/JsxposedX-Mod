package com.jsxposed.xmod.feature.jsxposed.bridge

import com.jsxposed.xmod.feature.jsxposed.manager.JxSingleThreadDispatcher
import com.jsxposed.xmod.core.utils.log.LogX
import com.whl.quickjs.wrapper.JSArray
import com.whl.quickjs.wrapper.JSFunction
import com.whl.quickjs.wrapper.JSObject
import com.whl.quickjs.wrapper.QuickJSContext
import de.robv.android.xposed.XC_MethodHook
import de.robv.android.xposed.XposedBridge
import de.robv.android.xposed.XposedHelpers
import java.lang.reflect.Member
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.atomic.AtomicInteger

/**
 * 核心 Hook 桥接：将 Xposed 的 findAndHookMethod 暴露给 JS，并支持参数类型数组
 */
class JxHookBridge(
    private val qjs: QuickJSContext,
    private val classLoader: ClassLoader,
    private val dispatcher: JxSingleThreadDispatcher,
    private val logBridge: JxLogBridge,
) {
    private val TAG = "JxHookBridge"
    private val hookIdCounter = AtomicInteger(0)
    private val hookStore = ConcurrentHashMap<Int, XC_MethodHook.Unhook>()
    private val hookOwnerStore = ConcurrentHashMap<Int, String>()
    private val scriptHookIds = ConcurrentHashMap<String, MutableSet<Int>>()

    @Volatile
    private var currentScriptKey: String? = null

    @Volatile
    private var currentRunId: String = ""

    fun beginScriptScope(scriptKey: String, runId: String) {
        currentScriptKey = scriptKey
        currentRunId = runId
        LogX.d(TAG, "script-scope-begin script=$scriptKey")
    }

    fun endScriptScope() {
        currentScriptKey = null
        currentRunId = ""
    }

    fun unhookScript(scriptKey: String): Int {
        val ids = scriptHookIds.remove(scriptKey)?.toList() ?: emptyList()
        if (ids.isEmpty()) {
            LogX.d(TAG, "script-unhook-skip script=$scriptKey reason=no-hooks")
            return 0
        }

        var removed = 0
        ids.forEach { id ->
            val unhook = hookStore.remove(id) ?: return@forEach
            hookOwnerStore.remove(id)
            try {
                unhook.unhook()
                removed++
            } catch (e: Throwable) {
                LogX.e(TAG, "script-unhook-failed script=$scriptKey id=$id error=${e.message}")
            }
        }
        LogX.d(TAG, "script-unhook-finish script=$scriptKey removed=$removed")
        return removed
    }

    private fun registerHookOwner(id: Int) {
        val scriptKey = currentScriptKey ?: return
        hookOwnerStore[id] = scriptKey
        scriptHookIds.computeIfAbsent(scriptKey) { ConcurrentHashMap.newKeySet<Int>() }.add(id)
    }

    private fun forgetHookOwner(id: Int) {
        val scriptKey = hookOwnerStore.remove(id) ?: return
        scriptHookIds[scriptKey]?.let { ids ->
            ids.remove(id)
            if (ids.isEmpty()) {
                scriptHookIds.remove(scriptKey)
            }
        }
    }

    fun hookMethod(className: String, methodName: String, paramTypesArray: JSArray?, callbacks: JSObject): Int {
        try {
            val callback = buildCallback(callbacks)
            val types = BridgeUtils.jsArrayToStringArray(paramTypesArray)
            val argsArray = ArrayList<Any?>()
            for (i in types.indices) {
                argsArray.add(BridgeUtils.parseTypeToClass(types[i], classLoader))
            }
            argsArray.add(callback)

            val unhook = XposedHelpers.findAndHookMethod(
                className, classLoader, methodName, *argsArray.toArray()
            )
            val id = hookIdCounter.incrementAndGet()
            hookStore[id] = unhook
            registerHookOwner(id)
            LogX.d(TAG, "成功注册 Hook[$id]: $className#$methodName")
            return id
        } catch (e: Throwable) {
            LogX.e(TAG, "注册 Hook 崩溃 ($className#$methodName): ${e.message}")
            return -1
        }
    }

    fun hookConstructor(className: String, paramTypesArray: JSArray?, callbacks: JSObject): Int {
        try {
            val callback = buildCallback(callbacks)
            val types = BridgeUtils.jsArrayToStringArray(paramTypesArray)
            val argsArray = ArrayList<Any?>()
            for (i in types.indices) {
                argsArray.add(BridgeUtils.parseTypeToClass(types[i], classLoader))
            }
            argsArray.add(callback)

            val unhook = XposedHelpers.findAndHookConstructor(
                className, classLoader, *argsArray.toArray()
            )
            val id = hookIdCounter.incrementAndGet()
            hookStore[id] = unhook
            registerHookOwner(id)
            LogX.d(TAG, "成功注册 Constructor Hook[$id]: $className")
            return id
        } catch (e: Throwable) {
            LogX.e(TAG, "注册 Constructor Hook 崩溃 ($className): ${e.message}")
            return -1
        }
    }

    // ── unhook ──

    fun unhook(args: Array<Any?>?): Boolean {
        val id = (args?.get(0) as? Number)?.toInt() ?: return false
        val unhook = hookStore.remove(id) ?: return false
        forgetHookOwner(id)
        try {
            unhook.unhook()
            LogX.d(TAG, "已移除 Hook[$id]")
            return true
        } catch (e: Throwable) {
            LogX.e(TAG, "unhook[$id] 失败: ${e.message}")
            return false
        }
    }

    // ── hookAllMethods ──

    fun hookAllMethods(className: String, methodName: String, callbacks: JSObject): JSArray {
        val ids = qjs.createNewJSArray()
        try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            val callback = buildCallback(callbacks)
            val unhooks = XposedBridge.hookAllMethods(clazz, methodName, callback)
            var idx = 0
            for (u in unhooks) {
                val id = hookIdCounter.incrementAndGet()
                hookStore[id] = u
                registerHookOwner(id)
                ids.set(id, idx++)
            }
            LogX.d(TAG, "hookAllMethods: $className#$methodName -> ${unhooks.size} hooks")
        } catch (e: Throwable) {
            LogX.e(TAG, "hookAllMethods 崩溃 ($className#$methodName): ${e.message}")
        }
        return ids
    }

    // ── hookAllConstructors ──

    fun hookAllConstructors(className: String, callbacks: JSObject): JSArray {
        val ids = qjs.createNewJSArray()
        try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            val callback = buildCallback(callbacks)
            val unhooks = XposedBridge.hookAllConstructors(clazz, callback)
            var idx = 0
            for (u in unhooks) {
                val id = hookIdCounter.incrementAndGet()
                hookStore[id] = u
                registerHookOwner(id)
                ids.set(id, idx++)
            }
            LogX.d(TAG, "hookAllConstructors: $className -> ${unhooks.size} hooks")
        } catch (e: Throwable) {
            LogX.e(TAG, "hookAllConstructors 崩溃 ($className): ${e.message}")
        }
        return ids
    }

    // ── invokeOriginal ──

    fun invokeOriginal(args: Array<Any?>?): Any? {
        val methodObj = BridgeUtils.unwrapJavaObject(args?.get(0))
        val thisObj = BridgeUtils.unwrapJavaObject(args?.getOrNull(1))
        val jsArgs = args?.getOrNull(2) as? JSArray
        if (methodObj !is Member) {
            LogX.e(TAG, "invokeOriginal: 第一个参数不是 Method/Constructor")
            return null
        }
        return try {
            val realArgs = if (jsArgs != null) BridgeUtils.jsArrayToObjectArray(jsArgs, qjs) else arrayOf()
            val result = XposedBridge.invokeOriginalMethod(methodObj, thisObj, realArgs)
            BridgeUtils.wrapJavaObject(qjs, result)
        } catch (e: Throwable) {
            LogX.e(TAG, "invokeOriginal 异常: ${e.message}")
            null
        }
    }

    // ── 内部工具 ──

    private fun buildCallback(callbacks: JSObject): XC_MethodHook {
        val beforeCb = callbacks.getProperty("before") as? JSFunction
        val afterCb = callbacks.getProperty("after") as? JSFunction
        val scriptName = (currentScriptKey ?: "<unknown>").substringAfterLast('/')
        val runId = currentRunId
        return object : XC_MethodHook() {
            override fun beforeHookedMethod(param: MethodHookParam) {
                try {
                    if (beforeCb != null) {
                        dispatcher.submit {
                            logBridge.withScriptScope(scriptName, runId) {
                                beforeCb.call(wrapParam(param))
                            }
                        }
                    }
                }
                catch (e: Throwable) { LogX.e(TAG, "before JS 异常: ${e.message}") }
            }
            override fun afterHookedMethod(param: MethodHookParam) {
                try {
                    if (afterCb != null) {
                        dispatcher.submit {
                            logBridge.withScriptScope(scriptName, runId) {
                                afterCb.call(wrapParam(param))
                            }
                        }
                    }
                }
                catch (e: Throwable) { LogX.e(TAG, "after JS 异常: ${e.message}") }
            }
        }
    }

    private fun wrapParam(param: XC_MethodHook.MethodHookParam): JSObject {
        val jsParam = qjs.createNewJSObject()

        jsParam.setProperty("raw",
            (BridgeUtils.wrapJavaObject(qjs, param) as? JSObject) ?: qjs.createNewJSObject())
        jsParam.setProperty("thisObject",
            (BridgeUtils.wrapJavaObject(qjs, param.thisObject) as? JSObject) ?: qjs.createNewJSObject())

        // method — 被 hook 的 Method/Constructor 对象
        jsParam.setProperty("method",
            (BridgeUtils.wrapJavaObject(qjs, param.method) as? JSObject) ?: qjs.createNewJSObject())

        // args
        jsParam.setProperty("getArg") { args: Array<Any?>? ->
            val index = (args?.get(0) as? Number)?.toInt() ?: return@setProperty null
            if (index in param.args.indices) BridgeUtils.wrapJavaObject(qjs, param.args[index]) else null
        }
        jsParam.setProperty("setArg") { args: Array<Any?>? ->
            val index = (args?.get(0) as? Number)?.toInt() ?: return@setProperty null
            if (index in param.args.indices) param.args[index] = BridgeUtils.unwrapJavaObject(args[1])
            null
        }
        jsParam.setProperty("argsLength", param.args.size)

        // result
        jsParam.setProperty("getResult") { _: Array<Any?>? ->
            BridgeUtils.wrapJavaObject(qjs, param.result)
        }
        jsParam.setProperty("setResult") { args: Array<Any?>? ->
            param.result = BridgeUtils.unwrapJavaObject(args?.get(0))
            null
        }

        // throwable
        jsParam.setProperty("hasThrowable") { _: Array<Any?>? ->
            param.hasThrowable()
        }
        jsParam.setProperty("getThrowable") { _: Array<Any?>? ->
            val t = param.throwable
            if (t != null) BridgeUtils.wrapJavaObject(qjs, t) else null
        }
        jsParam.setProperty("setThrowable") { args: Array<Any?>? ->
            val msg = args?.get(0)?.toString() ?: "JS exception"
            param.throwable = RuntimeException(msg)
            null
        }

        return jsParam
    }
}
