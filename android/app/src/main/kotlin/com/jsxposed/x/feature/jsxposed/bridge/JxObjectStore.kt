package com.jsxposed.xmod.feature.jsxposed.bridge

import java.util.UUID
import java.util.concurrent.ConcurrentHashMap

/**
 * 暂存跨语言的 Java 对象，防止被 QuickJS 转换时抛出 Unsupported Java type 异常。
 * JS 侧会拿到一个带 __java_obj_id 属性的 JSObject
 */
object JxObjectStore {
    private val store = ConcurrentHashMap<String, Any>()

    fun save(obj: Any): String {
        val id = UUID.randomUUID().toString()
        store[id] = obj
        return id
    }

    fun get(id: String): Any? {
        return store[id]
    }

    fun remove(id: String) {
        store.remove(id)
    }
}
