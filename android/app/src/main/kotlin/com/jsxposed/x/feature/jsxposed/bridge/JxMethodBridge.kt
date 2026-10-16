package com.jsxposed.xmod.feature.jsxposed.bridge

import com.jsxposed.xmod.core.utils.log.LogX
import com.whl.quickjs.wrapper.JSArray
import com.whl.quickjs.wrapper.QuickJSContext
import de.robv.android.xposed.XposedHelpers

/**
 * 原生方法强制调用桥接
 */
class JxMethodBridge(private val qjs: QuickJSContext, private val classLoader: ClassLoader) {
    private val TAG = "JxMethodBridge"

    /**
     * 调用普通方法
     */
    fun callMethod(obj: Any?, methodName: String, paramTypesArray: JSArray?, paramValuesArray: JSArray?): Any? {
        if (obj == null) return null
        try {
            val realObj = BridgeUtils.unwrapJavaObject(obj) ?: return null
            val types = BridgeUtils.jsArrayToStringArray(paramTypesArray)
            val values = BridgeUtils.jsArrayToObjectArray(paramValuesArray, qjs)

            val result = if (types.isNotEmpty()) {
                val paramClasses = types.map { BridgeUtils.parseTypeToClass(it, classLoader) as Class<*> }.toTypedArray()
                XposedHelpers.callMethod(realObj, methodName, paramClasses, *values)
            } else {
                XposedHelpers.callMethod(realObj, methodName, *values)
            }
            return BridgeUtils.wrapJavaObject(qjs, result)
        } catch (e: Exception) {
            LogX.e(TAG, "callMethod ($methodName) error: ${e.message}")
            return null
        }
    }

    /**
     * 调用静态方法
     */
    fun callStaticMethod(className: String, methodName: String, paramTypesArray: JSArray?, paramValuesArray: JSArray?): Any? {
        try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            val types = BridgeUtils.jsArrayToStringArray(paramTypesArray)
            val values = BridgeUtils.jsArrayToObjectArray(paramValuesArray, qjs)

            val result = if (types.isNotEmpty()) {
                val paramClasses = types.map { BridgeUtils.parseTypeToClass(it, classLoader) as Class<*> }.toTypedArray()
                XposedHelpers.callStaticMethod(clazz, methodName, paramClasses, *values)
            } else {
                XposedHelpers.callStaticMethod(clazz, methodName, *values)
            }
            return BridgeUtils.wrapJavaObject(qjs, result)
        } catch (e: Exception) {
            LogX.e(TAG, "callStaticMethod ($className.$methodName) error: ${e.message}")
            return null
        }
    }
}
