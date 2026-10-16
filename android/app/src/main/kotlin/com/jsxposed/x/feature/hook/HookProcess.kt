package com.jsxposed.xmod.feature.hook

import com.jsxposed.xmod.core.constants.QuickFunctionsConstant
import com.jsxposed.xmod.core.utils.log.LogX
import com.jsxposed.xmod.core.utils.shell.QuickFunctionsUtils
import com.jsxposed.xmod.feature.hook.quick_functions.HookAlgorithmicTracking
import com.jsxposed.xmod.feature.hook.quick_functions.HookDialogKeyword
import com.jsxposed.xmod.feature.hook.quick_functions.HookInjectTip
import com.jsxposed.xmod.feature.hook.quick_functions.HookModifiedVersion
import com.jsxposed.xmod.feature.hook.quick_functions.HookScreenshort
import com.jsxposed.xmod.feature.hook.quick_functions.HookVpn
import com.jsxposed.xmod.feature.hook.quick_functions.JustTrustMePro
import java.util.Collections

class HookProcess(val lpparam: LPParam) {
    private companion object {
        const val TAG = "FINDBUGS"
        val registeredProcesses = Collections.synchronizedSet(mutableSetOf<String>())
    }

    private val quickFunctionsUtils = QuickFunctionsUtils()
    private val packageName = lpparam.packageName

    private fun logSwitch(name: String, enabled: Boolean) {
        LogX.d(TAG, "HookProcess.switch package=$packageName process=${lpparam.processName} name=$name enabled=$enabled")
    }

    fun register() {
        val start = System.currentTimeMillis()
        val processKey = "$packageName|${lpparam.processName}"
        LogX.d(TAG, "HookProcess.register start package=$packageName process=${lpparam.processName} thread=${Thread.currentThread().name}")
        if (!registeredProcesses.add(processKey)) {
            LogX.w(TAG, "HookProcess.register skip duplicate package=$packageName process=${lpparam.processName}")
            return
        }

        val masterEnabled = quickFunctionsUtils.getQuickFunctionStatus(
            packageName, QuickFunctionsConstant.MASTER_SWITCH
        )
        logSwitch("MASTER_SWITCH", masterEnabled)
        if (!masterEnabled) {
            LogX.d(TAG, "HookProcess.register skip package=$packageName process=${lpparam.processName} reason=master-switch-off")
            return
        }

        val injectTipEnabled = quickFunctionsUtils.getQuickFunctionStatus(
            packageName, QuickFunctionsConstant.INJECT_TIP
        )
        logSwitch("INJECT_TIP", injectTipEnabled)
        if (injectTipEnabled) {
            AttachHooker.register(HookInjectTip(lpparam))
        }

        val screenshotEnabled = quickFunctionsUtils.getQuickFunctionStatus(
            packageName, QuickFunctionsConstant.REMOVE_SCREENSHORT_DETECTION
        )
        logSwitch("REMOVE_SCREENSHORT_DETECTION", screenshotEnabled)
        if (screenshotEnabled) {
            AttachHooker.register(HookScreenshort(lpparam))
        }

        val captureEnabled = quickFunctionsUtils.getQuickFunctionStatus(
            packageName, QuickFunctionsConstant.REMOVE_CAPTURE_DETECTION
        )
        logSwitch("REMOVE_CAPTURE_DETECTION", captureEnabled)
        if (captureEnabled) {
            AttachHooker.apply {
                register(HookVpn(lpparam))
                register(JustTrustMePro(lpparam))
            }
        }

        val removeDialogsEnabled = quickFunctionsUtils.getQuickFunctionStatus(
            packageName, QuickFunctionsConstant.REMOVE_DIALOGS
        )
        logSwitch("REMOVE_DIALOGS", removeDialogsEnabled)
        if (removeDialogsEnabled) {
            AttachHooker.register(HookDialogKeyword(lpparam))
        }

        val modifiedVersionEnabled = quickFunctionsUtils.getQuickFunctionStatus(
            packageName, QuickFunctionsConstant.MODIFIED_VERSION
        )
        logSwitch("MODIFIED_VERSION", modifiedVersionEnabled)
        if (modifiedVersionEnabled) {
            AttachHooker.register(HookModifiedVersion(lpparam))
        }

//        // 隐藏 Xposed
//        if (quickFunctionsUtils.getQuickFunctionStatus(
//                packageName, QuickFunctionsConstant.HIDE_XPOSED
//            )
//        ) {
//            AttachHooker.register(HideXposed(lpparam))
//        }
//
//        // 隐藏 Root
//        if (quickFunctionsUtils.getQuickFunctionStatus(
//                packageName, QuickFunctionsConstant.HIDE_ROOT
//            )
//        ) {
//            // T AttachHooker.register(HookHideRoot(lpparam))
//        }
//
//        // 隐藏应用
//        if (quickFunctionsUtils.getQuickFunctionStatus(
//                packageName, QuickFunctionsConstant.HIDE_APPS
//            )
//        ) {
//            //  AttachHooker.register(HookHideApps(lpparam))
//        }

        val algorithmTrackingEnabled = quickFunctionsUtils.getQuickFunctionStatus(
            packageName, QuickFunctionsConstant.ALGORITHMIC_TRACKING
        )
        logSwitch("ALGORITHMIC_TRACKING", algorithmTrackingEnabled)
        if (algorithmTrackingEnabled) {
            AttachHooker.register(HookAlgorithmicTracking(lpparam))
        }

        AttachHooker.setupAttachHook(lpparam)
        LogX.d(TAG, "HookProcess.register finish package=$packageName process=${lpparam.processName} cost=${System.currentTimeMillis() - start}ms")
    }
}
