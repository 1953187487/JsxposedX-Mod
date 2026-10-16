package com.jsxposed.xmod.feature.hook.quick_functions

import android.content.Context
import android.widget.Toast
import com.jsxposed.xmod.core.constants.QuickFunctionsConstant
import com.jsxposed.xmod.core.models.DialogKeyword
import com.jsxposed.xmod.core.utils.log.LogX
import com.jsxposed.xmod.core.utils.shell.QuickFunctionsUtils
import com.jsxposed.xmod.feature.hook.HookImpl
import com.jsxposed.xmod.feature.hook.LPParam
import de.robv.android.xposed.XC_MethodHook
import de.robv.android.xposed.XposedHelpers

class HookDialogKeyword(private val lpparam: LPParam) : HookImpl {
    private val keywordsList: MutableList<String> = QuickFunctionsUtils().getEnabledDialogKeywords(
        packageName = lpparam.packageName,
        name = QuickFunctionsConstant.REMOVE_DIALOGS
    ) as MutableList<String>


    override fun onAttach(context: Context) {
        LogX.e("HookDialogKeyword", "onAttach called, lpparam.classLoader set")
        create()
    }

    override fun create() {
        LogX.d("keywordsList", keywordsList)

        if (lpparam.classLoader == null) {
            LogX.e("HookDialogKeyword", "lpparam.classLoader为空，hook失败")
            return
        }

        XposedHelpers.findAndHookMethod(
            "android.app.Dialog", lpparam.classLoader, "show", object : XC_MethodHook() {
                override fun afterHookedMethod(param: MethodHookParam?) {
                    super.afterHookedMethod(param)
                    try {
                        val dialog = param?.thisObject
                        val mAlertField = XposedHelpers.findField(dialog?.javaClass, "mAlert")
                        mAlertField.isAccessible = true
                        val alertController = mAlertField.get(dialog)
                        val mTitleField =
                            XposedHelpers.findField(alertController.javaClass, "mTitle")
                        mTitleField.isAccessible = true
                        val title = mTitleField.get(alertController) as? CharSequence ?: ""
                        val mMessageField =
                            XposedHelpers.findField(alertController.javaClass, "mMessage")
                        mMessageField.isAccessible = true
                        val message = mMessageField.get(alertController) as? CharSequence ?: ""

                        LogX.e("HookDialogKeyword", "弹窗 title: $title, message: $message")
                        LogX.e("HookDialogKeyword", "待检测关键词列表: $keywordsList")

                        val titleStr = title.toString()
                        val messageStr = message.toString()

                        val matchedKeyword = keywordsList.firstOrNull { keyword ->
                            titleStr.contains(keyword, ignoreCase = true) || messageStr.contains(
                                keyword,
                                ignoreCase = true
                            )
                        }

                        if (matchedKeyword != null) {
                            LogX.e("HookDialogKeyword", "匹配关键词: $matchedKeyword，准备拦截弹窗")

                            val context = dialog?.javaClass?.getMethod("getContext")
                                ?.invoke(dialog) as? Context
                            if (context != null) {
                                Toast.makeText(
                                    context,
                                    "关键词($matchedKeyword)已拦截",
                                    Toast.LENGTH_SHORT
                                ).show()
                            } else {
                                LogX.e("HookDialogKeyword", "无法获取Dialog的Context")
                            }

                            LogX.e("HookDialogKeyword", "调用 dismiss 方法关闭弹窗")
                            dialog?.javaClass?.getMethod("dismiss")?.invoke(dialog)
                        } else {
                            LogX.e("HookDialogKeyword", "无匹配关键词，弹窗正常显示")
                        }

                    } catch (e: Exception) {
                        LogX.e("HookDialogKeyword error", e)
                    }
                }
            })
    }
}
