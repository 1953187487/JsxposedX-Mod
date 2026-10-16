package com.jsxposed.xmod.core.bridge.pinia_native

import android.content.Context

class PiniaNativeImpl(val context: Context) : PiniaNative {
    private val pinia = Pinia(context)

    override fun setString(space: String, key: String, value: String, type: Long) = pinia.setValue(space, key, value, type.toInt())
    override fun setInt(space: String, key: String, value: Long, type: Long) = pinia.setValue(space, key, value.toInt(), type.toInt())
    override fun setBool(space: String, key: String, value: Boolean, type: Long) = pinia.setValue(space, key, value, type.toInt())
    override fun setDouble(space: String, key: String, value: Double, type: Long) = pinia.setValue(space, key, value.toFloat(), type.toInt())
    override fun setLong(space: String, key: String, value: Long, type: Long) = pinia.setValue(space, key, value, type.toInt())

    override fun getString(space: String, key: String, defaultValue: String, type: Long): String = pinia.getValue(space, key, defaultValue, type.toInt())
    override fun getInt(space: String, key: String, defaultValue: Long, type: Long): Long = pinia.getValue(space, key, defaultValue.toInt(), type.toInt()).toLong()
    override fun getBool(space: String, key: String, defaultValue: Boolean, type: Long): Boolean = pinia.getValue(space, key, defaultValue, type.toInt())
    override fun getDouble(space: String, key: String, defaultValue: Double, type: Long): Double = pinia.getValue(space, key, defaultValue.toFloat(), type.toInt()).toDouble()
    override fun getLong(space: String, key: String, defaultValue: Long, type: Long): Long = pinia.getValue(space, key, defaultValue, type.toInt())

    override fun contains(space: String, key: String, type: Long): Boolean = pinia.contains(space, key, type.toInt())
    override fun remove(space: String, key: String, type: Long) = pinia.remove(space, key, type.toInt())
    override fun clear(space: String, type: Long) = pinia.clear(space, type.toInt())
}
