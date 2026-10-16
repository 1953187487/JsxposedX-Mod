package com.jsxposed.xmod.feature.hook.quick_functions

import android.content.Context
import com.jsxposed.xmod.feature.hook.HookImpl
import de.robv.android.xposed.XC_MethodHook
import de.robv.android.xposed.XposedHelpers
import com.jsxposed.xmod.feature.hook.LPParam


class HookScreenshort(private val lpparam: LPParam) : HookImpl {
    lateinit var context: Context
    override fun onAttach(context: Context) {
        this.context = context
        create()
    }

    override fun create() {
        XposedHelpers.findAndHookMethod(
            "android.view.Window",
            lpparam.classLoader,
            "setFlags",
            Int::class.java,
            Int::class.java,
            object : XC_MethodHook() {
                override fun beforeHookedMethod(param: MethodHookParam?) {
                    super.beforeHookedMethod(param)
                    if (param?.args[0] == 8192) {//FLAG_SECURE
                        param.args[0] = 0
                    }
                }

            }
        )
    }
}
