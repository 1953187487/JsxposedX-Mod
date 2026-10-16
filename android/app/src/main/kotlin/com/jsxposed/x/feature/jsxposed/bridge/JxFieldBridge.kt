package com.jsxposed.xmod.feature.jsxposed.bridge

import com.jsxposed.xmod.core.utils.log.LogX
import com.whl.quickjs.wrapper.JSArray
import com.whl.quickjs.wrapper.QuickJSContext
import de.robv.android.xposed.XposedHelpers

/**
 * 变量与属性强行读写桥接
 */
class JxFieldBridge(private val qjs: QuickJSContext, private val classLoader: ClassLoader) {
    private val TAG = "JxFieldBridge"

    fun getObjectField(args: Array<Any?>?): Any? {
        val obj = args?.get(0) ?: return null
        val fieldName = args.getOrNull(1)?.toString() ?: return null
        val realObj = BridgeUtils.unwrapJavaObject(obj) ?: return null
        return try {
            val result = XposedHelpers.getObjectField(realObj, fieldName)
            BridgeUtils.wrapJavaObject(qjs, result)
        } catch (e: Exception) {
            LogX.e(TAG, "getObjectField error: ${e.message}")
            null
        }
    }

    fun setObjectField(args: Array<Any?>?): Any? {
        val obj = args?.get(0) ?: return null
        val fieldName = args.getOrNull(1)?.toString() ?: return null
        val realObj = BridgeUtils.unwrapJavaObject(obj) ?: return null
        val value = BridgeUtils.unwrapJavaObject(args.getOrNull(2))
        try {
            XposedHelpers.setObjectField(realObj, fieldName, value)
        } catch (e: Exception) {
            LogX.e(TAG, "setObjectField error: ${e.message}")
        }
        return null
    }

    fun getStaticObjectField(args: Array<Any?>?): Any? {
        val className = args?.get(0)?.toString() ?: return null
        val fieldName = args.getOrNull(1)?.toString() ?: return null
        return try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            val result = XposedHelpers.getStaticObjectField(clazz, fieldName)
            BridgeUtils.wrapJavaObject(qjs, result)
        } catch (e: Exception) {
            LogX.e(TAG, "getStaticObjectField error: ${e.message}")
            null
        }
    }

    fun setStaticObjectField(args: Array<Any?>?): Any? {
        val className = args?.get(0)?.toString() ?: return null
        val fieldName = args.getOrNull(1)?.toString() ?: return null
        val value = BridgeUtils.unwrapJavaObject(args.getOrNull(2))
        try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            XposedHelpers.setStaticObjectField(clazz, fieldName, value)
        } catch (e: Exception) {
            LogX.e(TAG, "setStaticObjectField error: ${e.message}")
        }
        return null
    }
    
    // Primitives
    fun getIntField(args: Array<Any?>?): Int {
        val obj = args?.get(0) ?: return 0
        val fieldName = args.getOrNull(1)?.toString() ?: return 0
        val realObj = BridgeUtils.unwrapJavaObject(obj) ?: return 0
        return try { XposedHelpers.getIntField(realObj, fieldName) } catch (e: Exception) { 0 }
    }
    
    fun setIntField(args: Array<Any?>?): Any? {
        val obj = args?.get(0) ?: return null
        val fieldName = args.getOrNull(1)?.toString() ?: return null
        val value = (args.getOrNull(2) as? Number)?.toInt() ?: 0
        val realObj = BridgeUtils.unwrapJavaObject(obj) ?: return null
        try { XposedHelpers.setIntField(realObj, fieldName, value) } catch (e: Exception) {}
        return null
    }
    
    fun getBooleanField(args: Array<Any?>?): Boolean {
        val obj = args?.get(0) ?: return false
        val fieldName = args.getOrNull(1)?.toString() ?: return false
        val realObj = BridgeUtils.unwrapJavaObject(obj) ?: return false
        return try { XposedHelpers.getBooleanField(realObj, fieldName) } catch (e: Exception) { false }
    }

    fun setBooleanField(args: Array<Any?>?): Any? {
        val obj = args?.get(0) ?: return null
        val fieldName = args.getOrNull(1)?.toString() ?: return null
        val value = (args.getOrNull(2) as? Boolean) ?: false
        val realObj = BridgeUtils.unwrapJavaObject(obj) ?: return null
        try { XposedHelpers.setBooleanField(realObj, fieldName, value) } catch (e: Exception) {}
        return null
    }

    fun getLongField(args: Array<Any?>?): Long {
        val obj = args?.get(0) ?: return 0L
        val fieldName = args.getOrNull(1)?.toString() ?: return 0L
        val realObj = BridgeUtils.unwrapJavaObject(obj) ?: return 0L
        return try { XposedHelpers.getLongField(realObj, fieldName) } catch (e: Exception) { 0L }
    }

    fun setLongField(args: Array<Any?>?): Any? {
        val obj = args?.get(0) ?: return null
        val fieldName = args.getOrNull(1)?.toString() ?: return null
        val value = (args.getOrNull(2) as? Number)?.toLong() ?: 0L
        val realObj = BridgeUtils.unwrapJavaObject(obj) ?: return null
        try { XposedHelpers.setLongField(realObj, fieldName, value) } catch (e: Exception) {}
        return null
    }

    fun getFloatField(args: Array<Any?>?): Float {
        val obj = args?.get(0) ?: return 0f
        val fieldName = args.getOrNull(1)?.toString() ?: return 0f
        val realObj = BridgeUtils.unwrapJavaObject(obj) ?: return 0f
        return try { XposedHelpers.getFloatField(realObj, fieldName) } catch (e: Exception) { 0f }
    }

    fun setFloatField(args: Array<Any?>?): Any? {
        val obj = args?.get(0) ?: return null
        val fieldName = args.getOrNull(1)?.toString() ?: return null
        val value = (args.getOrNull(2) as? Number)?.toFloat() ?: 0f
        val realObj = BridgeUtils.unwrapJavaObject(obj) ?: return null
        try { XposedHelpers.setFloatField(realObj, fieldName, value) } catch (e: Exception) {}
        return null
    }

    fun getDoubleField(args: Array<Any?>?): Double {
        val obj = args?.get(0) ?: return 0.0
        val fieldName = args.getOrNull(1)?.toString() ?: return 0.0
        val realObj = BridgeUtils.unwrapJavaObject(obj) ?: return 0.0
        return try { XposedHelpers.getDoubleField(realObj, fieldName) } catch (e: Exception) { 0.0 }
    }

    fun setDoubleField(args: Array<Any?>?): Any? {
        val obj = args?.get(0) ?: return null
        val fieldName = args.getOrNull(1)?.toString() ?: return null
        val value = (args.getOrNull(2) as? Number)?.toDouble() ?: 0.0
        val realObj = BridgeUtils.unwrapJavaObject(obj) ?: return null
        try { XposedHelpers.setDoubleField(realObj, fieldName, value) } catch (e: Exception) {}
        return null
    }

    fun getShortField(args: Array<Any?>?): Short {
        val obj = args?.get(0) ?: return 0
        val fieldName = args.getOrNull(1)?.toString() ?: return 0
        val realObj = BridgeUtils.unwrapJavaObject(obj) ?: return 0
        return try { XposedHelpers.getShortField(realObj, fieldName) } catch (e: Exception) { 0 }
    }

    fun setShortField(args: Array<Any?>?): Any? {
        val obj = args?.get(0) ?: return null
        val fieldName = args.getOrNull(1)?.toString() ?: return null
        val value = (args.getOrNull(2) as? Number)?.toShort() ?: 0
        val realObj = BridgeUtils.unwrapJavaObject(obj) ?: return null
        try { XposedHelpers.setShortField(realObj, fieldName, value) } catch (e: Exception) {}
        return null
    }

    fun getByteField(args: Array<Any?>?): Byte {
        val obj = args?.get(0) ?: return 0
        val fieldName = args.getOrNull(1)?.toString() ?: return 0
        val realObj = BridgeUtils.unwrapJavaObject(obj) ?: return 0
        return try { XposedHelpers.getByteField(realObj, fieldName) } catch (e: Exception) { 0 }
    }

    fun setByteField(args: Array<Any?>?): Any? {
        val obj = args?.get(0) ?: return null
        val fieldName = args.getOrNull(1)?.toString() ?: return null
        val value = (args.getOrNull(2) as? Number)?.toByte() ?: 0
        val realObj = BridgeUtils.unwrapJavaObject(obj) ?: return null
        try { XposedHelpers.setByteField(realObj, fieldName, value) } catch (e: Exception) {}
        return null
    }

    fun getCharField(args: Array<Any?>?): Char {
        val obj = args?.get(0) ?: return '\u0000'
        val fieldName = args.getOrNull(1)?.toString() ?: return '\u0000'
        val realObj = BridgeUtils.unwrapJavaObject(obj) ?: return '\u0000'
        return try { XposedHelpers.getCharField(realObj, fieldName) } catch (e: Exception) { '\u0000' }
    }

    fun setCharField(args: Array<Any?>?): Any? {
        val obj = args?.get(0) ?: return null
        val fieldName = args.getOrNull(1)?.toString() ?: return null
        val raw = args.getOrNull(2)?.toString() ?: ""
        val value = if (raw.isNotEmpty()) raw[0] else '\u0000'
        val realObj = BridgeUtils.unwrapJavaObject(obj) ?: return null
        try { XposedHelpers.setCharField(realObj, fieldName, value) } catch (e: Exception) {}
        return null
    }

    // ── Static Primitives ──

    fun getStaticIntField(args: Array<Any?>?): Int {
        val className = args?.get(0)?.toString() ?: return 0
        val fieldName = args.getOrNull(1)?.toString() ?: return 0
        return try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            XposedHelpers.getStaticIntField(clazz, fieldName)
        } catch (e: Exception) { 0 }
    }

    fun setStaticIntField(args: Array<Any?>?): Any? {
        val className = args?.get(0)?.toString() ?: return null
        val fieldName = args.getOrNull(1)?.toString() ?: return null
        val value = (args.getOrNull(2) as? Number)?.toInt() ?: 0
        try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            XposedHelpers.setStaticIntField(clazz, fieldName, value)
        } catch (e: Exception) {}
        return null
    }

    fun getStaticBooleanField(args: Array<Any?>?): Boolean {
        val className = args?.get(0)?.toString() ?: return false
        val fieldName = args.getOrNull(1)?.toString() ?: return false
        return try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            XposedHelpers.getStaticBooleanField(clazz, fieldName)
        } catch (e: Exception) { false }
    }

    fun setStaticBooleanField(args: Array<Any?>?): Any? {
        val className = args?.get(0)?.toString() ?: return null
        val fieldName = args.getOrNull(1)?.toString() ?: return null
        val value = (args.getOrNull(2) as? Boolean) ?: false
        try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            XposedHelpers.setStaticBooleanField(clazz, fieldName, value)
        } catch (e: Exception) {}
        return null
    }

    fun getStaticLongField(args: Array<Any?>?): Long {
        val className = args?.get(0)?.toString() ?: return 0L
        val fieldName = args.getOrNull(1)?.toString() ?: return 0L
        return try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            XposedHelpers.getStaticLongField(clazz, fieldName)
        } catch (e: Exception) { 0L }
    }

    fun setStaticLongField(args: Array<Any?>?): Any? {
        val className = args?.get(0)?.toString() ?: return null
        val fieldName = args.getOrNull(1)?.toString() ?: return null
        val value = (args.getOrNull(2) as? Number)?.toLong() ?: 0L
        try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            XposedHelpers.setStaticLongField(clazz, fieldName, value)
        } catch (e: Exception) {}
        return null
    }

    fun getStaticFloatField(args: Array<Any?>?): Float {
        val className = args?.get(0)?.toString() ?: return 0f
        val fieldName = args.getOrNull(1)?.toString() ?: return 0f
        return try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            XposedHelpers.getStaticFloatField(clazz, fieldName)
        } catch (e: Exception) { 0f }
    }

    fun setStaticFloatField(args: Array<Any?>?): Any? {
        val className = args?.get(0)?.toString() ?: return null
        val fieldName = args.getOrNull(1)?.toString() ?: return null
        val value = (args.getOrNull(2) as? Number)?.toFloat() ?: 0f
        try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            XposedHelpers.setStaticFloatField(clazz, fieldName, value)
        } catch (e: Exception) {}
        return null
    }

    fun getStaticDoubleField(args: Array<Any?>?): Double {
        val className = args?.get(0)?.toString() ?: return 0.0
        val fieldName = args.getOrNull(1)?.toString() ?: return 0.0
        return try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            XposedHelpers.getStaticDoubleField(clazz, fieldName)
        } catch (e: Exception) { 0.0 }
    }

    fun setStaticDoubleField(args: Array<Any?>?): Any? {
        val className = args?.get(0)?.toString() ?: return null
        val fieldName = args.getOrNull(1)?.toString() ?: return null
        val value = (args.getOrNull(2) as? Number)?.toDouble() ?: 0.0
        try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            XposedHelpers.setStaticDoubleField(clazz, fieldName, value)
        } catch (e: Exception) {}
        return null
    }

    fun getStaticShortField(args: Array<Any?>?): Short {
        val className = args?.get(0)?.toString() ?: return 0
        val fieldName = args.getOrNull(1)?.toString() ?: return 0
        return try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            XposedHelpers.getStaticShortField(clazz, fieldName)
        } catch (e: Exception) { 0 }
    }

    fun setStaticShortField(args: Array<Any?>?): Any? {
        val className = args?.get(0)?.toString() ?: return null
        val fieldName = args.getOrNull(1)?.toString() ?: return null
        val value = (args.getOrNull(2) as? Number)?.toShort() ?: 0
        try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            XposedHelpers.setStaticShortField(clazz, fieldName, value)
        } catch (e: Exception) {}
        return null
    }

    fun getStaticByteField(args: Array<Any?>?): Byte {
        val className = args?.get(0)?.toString() ?: return 0
        val fieldName = args.getOrNull(1)?.toString() ?: return 0
        return try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            XposedHelpers.getStaticByteField(clazz, fieldName)
        } catch (e: Exception) { 0 }
    }

    fun setStaticByteField(args: Array<Any?>?): Any? {
        val className = args?.get(0)?.toString() ?: return null
        val fieldName = args.getOrNull(1)?.toString() ?: return null
        val value = (args.getOrNull(2) as? Number)?.toByte() ?: 0
        try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            XposedHelpers.setStaticByteField(clazz, fieldName, value)
        } catch (e: Exception) {}
        return null
    }

    fun getStaticCharField(args: Array<Any?>?): Char {
        val className = args?.get(0)?.toString() ?: return '\u0000'
        val fieldName = args.getOrNull(1)?.toString() ?: return '\u0000'
        return try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            XposedHelpers.getStaticCharField(clazz, fieldName)
        } catch (e: Exception) { '\u0000' }
    }

    fun setStaticCharField(args: Array<Any?>?): Any? {
        val className = args?.get(0)?.toString() ?: return null
        val fieldName = args.getOrNull(1)?.toString() ?: return null
        val raw = args.getOrNull(2)?.toString() ?: ""
        val value = if (raw.isNotEmpty()) raw[0] else '\u0000'
        try {
            val clazz = XposedHelpers.findClass(className, classLoader)
            XposedHelpers.setStaticCharField(clazz, fieldName, value)
        } catch (e: Exception) {}
        return null
    }

    // ── Additional Instance Fields ──

    fun setExtra(args: Array<Any?>?): Any? {
        val obj = BridgeUtils.unwrapJavaObject(args?.get(0)) ?: return null
        val key = args?.getOrNull(1)?.toString() ?: return null
        val value = BridgeUtils.unwrapJavaObject(args?.getOrNull(2))
        try {
            XposedHelpers.setAdditionalInstanceField(obj, key, value)
        } catch (e: Exception) {
            LogX.e(TAG, "setExtra error: ${e.message}")
        }
        return null
    }

    fun getExtra(args: Array<Any?>?): Any? {
        val obj = BridgeUtils.unwrapJavaObject(args?.get(0)) ?: return null
        val key = args?.getOrNull(1)?.toString() ?: return null
        return try {
            val result = XposedHelpers.getAdditionalInstanceField(obj, key)
            BridgeUtils.wrapJavaObject(qjs, result)
        } catch (e: Exception) {
            LogX.e(TAG, "getExtra error: ${e.message}")
            null
        }
    }

    fun removeExtra(args: Array<Any?>?): Any? {
        val obj = BridgeUtils.unwrapJavaObject(args?.get(0)) ?: return null
        val key = args?.getOrNull(1)?.toString() ?: return null
        try {
            XposedHelpers.removeAdditionalInstanceField(obj, key)
        } catch (e: Exception) {
            LogX.e(TAG, "removeExtra error: ${e.message}")
        }
        return null
    }
}