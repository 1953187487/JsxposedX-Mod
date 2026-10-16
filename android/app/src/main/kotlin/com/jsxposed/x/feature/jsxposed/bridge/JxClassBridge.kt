package com.jsxposed.xmod.feature.jsxposed.bridge

import com.jsxposed.xmod.core.utils.log.LogX
import com.whl.quickjs.wrapper.JSArray
import com.whl.quickjs.wrapper.JSObject
import com.whl.quickjs.wrapper.QuickJSContext
import de.robv.android.xposed.XposedHelpers

/**
 * 类查询与对象实例化能力桥接
 */
class JxClassBridge(private val qjs: QuickJSContext, private val classLoader: ClassLoader) {
    private val TAG = "JxClassBridge"

    /**
     * JS 侧调用 Jx.findClass(className)
     */
    fun findClass(className: String): Any? {
        return try {
            val clazz = XposedHelpers.findClassIfExists(className, classLoader)
            clazz != null
        } catch (e: Exception) {
            LogX.e(TAG, "findClass error: ${e.message}")
            false
        }
    }

    /**
     * JS 侧调用 Jx.loadClass(className)，返回 wrapped Class 对象
     */
    fun loadClass(className: String): Any? {
        return try {
            val clazz = XposedHelpers.findClassIfExists(className, classLoader)
            if (clazz != null) BridgeUtils.wrapJavaObject(qjs, clazz) else null
        } catch (e: Exception) {
            LogX.e(TAG, "loadClass error: ${e.message}")
            null
        }
    }

    /**
     * JS 侧调用 Jx.newInstance("com.test.Cls", ["int", "java.lang.String"], [1, "test"])
     */
    fun newInstance(className: String, paramTypesArray: JSArray?, paramValuesArray: JSArray?): Any? {
        try {
            val clazz = XposedHelpers.findClassIfExists(className, classLoader) ?: return null
            
            val types = BridgeUtils.jsArrayToStringArray(paramTypesArray)
            val values = BridgeUtils.jsArrayToObjectArray(paramValuesArray, qjs)

            val result = if (types.isNotEmpty()) {
                val paramClasses = types.map { BridgeUtils.parseTypeToClass(it, classLoader) as Class<*> }.toTypedArray()
                XposedHelpers.newInstance(clazz, paramClasses, *values)
            } else {
                XposedHelpers.newInstance(clazz, *values)
            }
            return BridgeUtils.wrapJavaObject(qjs, result)
        } catch (e: Exception) {
            LogX.e(TAG, "newInstance ($className) error: ${e.message}")
            return null
        }
    }

    // ── 类内省 ──

    fun getMethods(args: Array<Any?>?): JSArray {
        val className = args?.get(0)?.toString() ?: return qjs.createNewJSArray()
        val arr = qjs.createNewJSArray()
        try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            val methods = clazz.declaredMethods
            for (i in methods.indices) {
                arr.set(methods[i].name, i)
            }
        } catch (e: Exception) {
            LogX.e(TAG, "getMethods error: ${e.message}")
        }
        return arr
    }

    fun getFields(args: Array<Any?>?): JSArray {
        val className = args?.get(0)?.toString() ?: return qjs.createNewJSArray()
        val arr = qjs.createNewJSArray()
        try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            val fields = clazz.declaredFields
            for (i in fields.indices) {
                arr.set(fields[i].name, i)
            }
        } catch (e: Exception) {
            LogX.e(TAG, "getFields error: ${e.message}")
        }
        return arr
    }

    fun getConstructors(args: Array<Any?>?): JSArray {
        val className = args?.get(0)?.toString() ?: return qjs.createNewJSArray()
        val arr = qjs.createNewJSArray()
        try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            val ctors = clazz.declaredConstructors
            for (i in ctors.indices) {
                val sig = ctors[i].parameterTypes.joinToString(",") { it.name }
                arr.set(sig, i)
            }
        } catch (e: Exception) {
            LogX.e(TAG, "getConstructors error: ${e.message}")
        }
        return arr
    }

    fun getSuperclass(args: Array<Any?>?): String? {
        val className = args?.get(0)?.toString() ?: return null
        return try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            clazz.superclass?.name
        } catch (e: Exception) {
            LogX.e(TAG, "getSuperclass error: ${e.message}")
            null
        }
    }

    fun getInterfaces(args: Array<Any?>?): JSArray {
        val className = args?.get(0)?.toString() ?: return qjs.createNewJSArray()
        val arr = qjs.createNewJSArray()
        try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            val ifaces = clazz.interfaces
            for (i in ifaces.indices) {
                arr.set(ifaces[i].name, i)
            }
        } catch (e: Exception) {
            LogX.e(TAG, "getInterfaces error: ${e.message}")
        }
        return arr
    }

    fun instanceOf(args: Array<Any?>?): Boolean {
        val obj = BridgeUtils.unwrapJavaObject(args?.get(0)) ?: return false
        val className = args?.getOrNull(1)?.toString() ?: return false
        return try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            clazz.isInstance(obj)
        } catch (e: Exception) {
            LogX.e(TAG, "instanceOf error: ${e.message}")
            false
        }
    }
}
