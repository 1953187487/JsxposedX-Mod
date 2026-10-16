package com.jsxposed.xmod.feature.hook.quick_functions

import android.content.Context
import android.os.Bundle
import android.widget.Toast
import com.jsxposed.xmod.core.utils.ApkUtils
import com.jsxposed.xmod.feature.hook.HookImpl
import com.jsxposed.xmod.feature.hook.LPParam
import de.robv.android.xposed.XC_MethodHook
import de.robv.android.xposed.XposedHelpers

class HookInjectTip(private val lpparam: LPParam) : HookImpl {

    lateinit var context: Context

    override fun onAttach(context: Context) {
        this.context = context
        create()
    }

    override fun create() {
        val className = ApkUtils.getResolveInfo(context, lpparam.packageName)?.name ?: return

        XposedHelpers.findAndHookMethod(
            className,
            lpparam.classLoader,
            "onCreate",
            Bundle::class.java,
            object : XC_MethodHook() {
                override fun afterHookedMethod(param: MethodHookParam?) {
                    super.afterHookedMethod(param)
                    Toast.makeText(
                        context,
                        "JsxposedX Hook: ${lpparam.packageName}",
                        Toast.LENGTH_SHORT
                    ).show()
                }
            }
        )
    }
}