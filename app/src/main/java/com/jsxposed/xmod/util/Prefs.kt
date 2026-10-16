package com.jsxposed.xmod.util

import android.content.Context
import android.content.SharedPreferences

object Prefs {

    private const val NAME = "jsxposed_prefs"

    private fun sp(ctx: Context): SharedPreferences =
        ctx.getSharedPreferences(NAME, Context.MODE_PRIVATE)

    fun getInt(ctx: Context, key: String, def: Int): Int = sp(ctx).getInt(key, def)
    fun putInt(ctx: Context, key: String, value: Int) = sp(ctx).edit().putInt(key, value).apply()
    fun getBool(ctx: Context, key: String, def: Boolean): Boolean = sp(ctx).getBoolean(key, def)
    fun putBool(ctx: Context, key: String, value: Boolean) = sp(ctx).edit().putBoolean(key, value).apply()
    fun getStr(ctx: Context, key: String, def: String = ""): String = sp(ctx).getString(key, def) ?: def
    fun putStr(ctx: Context, key: String, value: String) = sp(ctx).edit().putString(key, value).apply()
}
