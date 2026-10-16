package com.jsxposed.xmod.core.utils.shell

import android.content.SharedPreferences
import com.jsxposed.xmod.core.utils.log.LogX

class PiniaRoot(
    private val prefsName: String = "pinia"
) {
    companion object {
         const val TAG = "PiniaRoot"
    }

    @PublishedApi
    internal fun remotePrefs(): SharedPreferences? {
        return try {
            com.jsxposed.xmod.NewApiHook.instance?.getRemotePreferences(prefsName)
        } catch (e: Exception) {
            LogX.e(TAG, "getRemotePreferences failed: ${e.message}")
            null
        }
    }

    fun getAll(): Map<String, *> {
        return remotePrefs()?.all ?: emptyMap<String, Any>()
    }

    fun refresh() = getAll()

    inline fun <reified T> getValue(key: String, defaultValue: T): T {
        val prefs = remotePrefs() ?: return defaultValue
        @Suppress("UNCHECKED_CAST")
        return when (T::class) {
            String::class -> prefs.getString(key, defaultValue as String) as T
            Int::class -> prefs.getInt(key, defaultValue as Int) as T
            Boolean::class -> prefs.getBoolean(key, defaultValue as Boolean) as T
            Long::class -> prefs.getLong(key, defaultValue as Long) as T
            Float::class -> prefs.getFloat(key, defaultValue as Float) as T
            else -> defaultValue
        }
    }

    fun getString(key: String, defaultValue: String): String = getValue(key, defaultValue)
    fun getInt(key: String, defaultValue: Int): Int = getValue(key, defaultValue)
    fun getBoolean(key: String, defaultValue: Boolean): Boolean = getValue(key, defaultValue)
    fun getLong(key: String, defaultValue: Long): Long = getValue(key, defaultValue)
    fun getFloat(key: String, defaultValue: Float): Float = getValue(key, defaultValue)

    fun setValue(key: String, value: Any) {
        val prefs = remotePrefs() ?: run {
            LogX.e(TAG, "setValue failed: RemotePreferences not available")
            return
        }
        prefs.edit().apply {
            when (value) {
                is String -> putString(key, value)
                is Boolean -> putBoolean(key, value)
                is Int -> putInt(key, value)
                is Float -> putFloat(key, value)
                is Long -> putLong(key, value)
                else -> {
                    LogX.e(TAG, "setValue: unsupported type ${value.javaClass}")
                    return
                }
            }
            apply()
        }
    }

    fun setString(key: String, value: String) = setValue(key, value)
    fun setInt(key: String, value: Int) = setValue(key, value)
    fun setBoolean(key: String, value: Boolean) = setValue(key, value)
    fun setLong(key: String, value: Long) = setValue(key, value)
    fun setFloat(key: String, value: Float) = setValue(key, value)

    fun remove(key: String) {
        remotePrefs()?.edit()?.remove(key)?.apply()
    }

    fun clear() {
        remotePrefs()?.edit()?.clear()?.apply()
    }

    fun contains(key: String): Boolean {
        return remotePrefs()?.contains(key) ?: false
    }
}
