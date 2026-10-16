package com.jsxposed.xmod.core.bridge.zygisk_frida_native

import android.content.Context

class ZygiskFridaNativeImpl(private val context: Context) : ZygiskFridaNative {
    private val logic = ZygiskFrida()

    override fun isModuleInstalled(): Boolean = logic.isModuleInstalled()

    override fun isModuleReady(): Boolean = logic.isModuleReady()

    override fun isTargetEnabled(packageName: String): Boolean = logic.isTargetEnabled(packageName)

    override fun setTargetEnabled(packageName: String, enabled: Boolean): Long {
        return logic.setTargetEnabled(packageName, enabled).toLong()
    }
}
