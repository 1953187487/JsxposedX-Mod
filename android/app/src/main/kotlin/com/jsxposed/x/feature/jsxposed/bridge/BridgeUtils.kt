package com.jsxposed.xmod.feature.jsxposed.bridge

import com.jsxposed.xmod.core.utils.log.LogX
import com.whl.quickjs.wrapper.JSArray
import com.whl.quickjs.wrapper.QuickJSContext
import de.robv.android.xposed.XposedHelpers

object BridgeUtils {
    
    fun jsArrayToStringArray(jsArray: JSArray?): Array<String> {
        if (jsArray == null) return emptyArray()
        val list = mutableListOf<String>()
        for (i in 0 until jsArray.length()) {
            list.add(jsArray.get(i)?.toString() ?: "")
        }
        return list.toTypedArray()
    }

    fun jsArrayToObjectArray(jsArray: JSArray?, qjs: QuickJSContext): Array<Any?> {
        if (jsArray == null) return emptyArray()
        val list = mutableListOf<Any?>()
        for (i in 0 until jsArray.length()) {
            list.add(unwrapJavaObject(jsArray.get(i)))
        }
        return list.toTypedArray()
    }

    /**
     * 将 Java 对象包装为 JSObject 发送给 JS。
     */
    fun wrapJavaObject(qjs: QuickJSContext, obj: Any?): Any? {
        if (obj == null) return null
        if (obj is String || obj is Number || obj is Boolean || obj is Char) {
            return obj
        }
        // 如果原本就是 JS 对象，直接返回
        if (obj is com.whl.quickjs.wrapper.JSObject || obj is JSArray) {
            return obj
        }
        
        val id = JxObjectStore.save(obj)
        val jsObj = qjs.createNewJSObject()
        jsObj.setProperty("__java_obj_id", id)
        jsObj.setProperty("__java_class_name", obj.javaClass.name)
        // 增加一个 release 方法，允许 JS 主动释放对象（避免内存泄露）
        jsObj.setProperty("release") { _: Array<Any?>? ->
            JxObjectStore.remove(id)
            null
        }
        // 覆盖 toString，方便调试
        jsObj.setProperty("toString") { _: Array<Any?>? ->
            try { obj.toString() } catch (e: Exception) { obj.javaClass.name }
        }
        return jsObj
    }

    /**
     * 将 JS 传过来的 __java_obj_id JSObject 还原为真实的 Java 对象。
     */
    fun unwrapJavaObject(obj: Any?): Any? {
        if (obj is com.whl.quickjs.wrapper.JSObject) {
            try {
                val idObj = obj.getProperty("__java_obj_id")
                if (idObj is String) {
                    return JxObjectStore.get(idObj)
                }
            } catch (e: Exception) {
                // Ignore, it might be a regular JS object that does not expose __java_obj_id safely or it's missing
            }
        }
        return obj // 字符串、数字、布尔值直接透传
    }

    fun parseTypeToClass(typeName: String, classLoader: ClassLoader): Any {
        return when (typeName) {
            "int" -> Int::class.javaPrimitiveType!!
            "long" -> Long::class.javaPrimitiveType!!
            "boolean" -> Boolean::class.javaPrimitiveType!!
            "byte" -> Byte::class.javaPrimitiveType!!
            "short" -> Short::class.javaPrimitiveType!!
            "float" -> Float::class.javaPrimitiveType!!
            "double" -> Double::class.javaPrimitiveType!!
            "char" -> Char::class.javaPrimitiveType!!
            // 处理数组类型，例如 byte[] -> [B, java.lang.String[] -> [Ljava.lang.String;
            else -> {
                try {
                    XposedHelpers.findClass(typeName, classLoader)
                } catch (e: Exception) {
                    LogX.e("BridgeUtils", "Failed to parse type: $typeName")
                    typeName // 直接透传字符串让 Xposed 自己解析
                }
            }
        }
    }
}
