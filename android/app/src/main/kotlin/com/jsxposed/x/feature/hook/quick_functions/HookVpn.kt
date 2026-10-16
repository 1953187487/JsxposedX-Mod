package com.jsxposed.xmod.feature.hook.quick_functions

import android.content.Context
import com.jsxposed.xmod.feature.hook.HookImpl
import de.robv.android.xposed.XC_MethodHook
import de.robv.android.xposed.XC_MethodHook.MethodHookParam
import de.robv.android.xposed.XposedHelpers
import com.jsxposed.xmod.feature.hook.LPParam


class HookVpn(private val lpparam: LPParam) : HookImpl {
    lateinit var context: Context
    override fun onAttach(context: Context) {
        this.context = context
        create()
    }

    override fun create() {
        XposedHelpers.findAndHookMethod(
            "java.net.NetworkInterface",
            lpparam.classLoader,
            "getName",
            object : XC_MethodHook() {
                override fun beforeHookedMethod(param: MethodHookParam) {
                    super.beforeHookedMethod(param)
                    param.result = "hello"
                }
            }
        )
    }

}
