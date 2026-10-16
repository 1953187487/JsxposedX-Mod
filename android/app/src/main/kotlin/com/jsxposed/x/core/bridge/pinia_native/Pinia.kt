package com.jsxposed.xmod.core.bridge.pinia_native

import android.content.Context
import android.content.SharedPreferences
import androidx.core.content.edit
import com.jsxposed.xmod.core.bridge.lsposed_native.LSPosed
import com.jsxposed.xmod.core.bridge.xposed_js_snapshot.XposedScriptSnapshotRepository
import com.jsxposed.xmod.core.utils.log.LogX

class Pinia(val context: Context) {

    companion object {
        const val TAG = "Pinia"
        const val TYPE_LOCAL = 1
        const val TYPE_REMOTE = 2
    }

    private val snapshotRepository by lazy { XposedScriptSnapshotRepository(context) }

    @PublishedApi
    internal fun prefs(space: String, type: Int): SharedPreferences {
        if (type == TYPE_REMOTE) {
            val remote = LSPosed.getRemotePreferences(space)
            if (remote != null) return remote
            LogX.e(TAG, "XposedService not connected for remote prefs: space=$space")
            throw IllegalStateException("XposedService not connected for remote prefs: $space")
        }
        return context.getSharedPreferences(space, Context.MODE_PRIVATE)
    }

    fun setValue(space: String = "pinia", key: String, value: Any, type: Int = TYPE_REMOTE) {
        prefs(space, type).edit {
            when (value) {
                is String -> putString(key, value)
                is Boolean -> putBoolean(key, value)
                is Int -> putInt(key, value)
                is Float -> putFloat(key, value)
                is Long -> putLong(key, value)
                else -> throw IllegalArgumentException("Unsupported value type: ${value.javaClass}")
            }
        }
        snapshotRepository.refreshForSwitchKey(space, key)
    }

    inline fun <reified T> getValue(space: String = "pinia", key: String, defaultValue: T, type: Int = TYPE_REMOTE): T {
        val p = prefs(space, type)
        return when (T::class) {
            Boolean::class -> p.getBoolean(key, defaultValue as Boolean) as T
            String::class -> p.getString(key, defaultValue as String) as T
            Int::class -> p.getInt(key, defaultValue as Int) as T
            Float::class -> p.getFloat(key, defaultValue as Float) as T
            Long::class -> p.getLong(key, defaultValue as Long) as T
            else -> throw IllegalArgumentException("Unsupported type: ${T::class}")
        }
    }

    fun contains(space: String = "pinia", key: String, type: Int = TYPE_REMOTE): Boolean =
        prefs(space, type).contains(key)

    fun remove(space: String = "pinia", key: String, type: Int = TYPE_REMOTE) {
        prefs(space, type).edit { remove(key) }
        snapshotRepository.refreshForSwitchKey(space, key)
    }

    fun clear(space: String = "pinia", type: Int = TYPE_REMOTE) {
        prefs(space, type).edit { clear() }
        snapshotRepository.refreshAfterClear(space)
    }
}
