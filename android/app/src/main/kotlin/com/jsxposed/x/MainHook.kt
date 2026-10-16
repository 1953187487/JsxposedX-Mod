package com.jsxposed.xmod

import android.annotation.SuppressLint
import com.jsxposed.xmod.core.constants.AppConstant
import com.jsxposed.xmod.core.utils.log.LogX
import com.jsxposed.xmod.feature.hook.HookProcess
import com.jsxposed.xmod.feature.hook.LPParam
import com.jsxposed.xmod.feature.hook.LoadPackageParamWrapper
import com.jsxposed.xmod.feature.jsxposed.hook.HookJsXposed
import de.robv.android.xposed.IXposedHookLoadPackage
import de.robv.android.xposed.IXposedHookZygoteInit
import de.robv.android.xposed.callbacks.XC_LoadPackage
import top.sacz.xphelper.XpHelper
import java.util.Collections

class MainHook : IXposedHookLoadPackage, IXposedHookZygoteInit {

    companion object {
        const val TAG = "FINDBUGS"
        val hookedProcesses = Collections.synchronizedSet(mutableSetOf<String>())
    }

    override fun initZygote(startupParam: IXposedHookZygoteInit.StartupParam) {
        XpHelper.initZygote(startupParam)
        LogX.d(TAG, "========== MainHook.initZygote ==========")
        LogX.d(TAG, "  modulePath: ${startupParam.modulePath}")
        LogX.d(TAG, "  thread: ${Thread.currentThread().name}")
        LogX.d(TAG, "Xposed module loaded successfully")
    }

    override fun handleLoadPackage(lpparam: XC_LoadPackage.LoadPackageParam) {
        LogX.d(
            TAG,
            "MainHook.handleLoadPackage package=${lpparam.packageName} process=${lpparam.processName} classLoader=${lpparam.classLoader} thread=${Thread.currentThread().name}"
        )
        Thread.currentThread().contextClassLoader = lpparam.classLoader

        doHook(LoadPackageParamWrapper(lpparam))
    }

    @SuppressLint("PrivateApi")
    fun handleNewApiPackageLoaded(lpparam: LPParam) {
        LogX.d(
            TAG,
            "MainHook.handleNewApiPackageLoaded package=${lpparam.packageName} process=${lpparam.processName} classLoader=${lpparam.classLoader} thread=${Thread.currentThread().name}"
        )
        Thread.currentThread().contextClassLoader = lpparam.classLoader

        doHook(lpparam)
    }

    private fun findProcessPid(shell: com.jsxposed.xmod.core.utils.shell.Shell, packageName: String): Int {
        return try {
            val pidRaw = shell.execute("pidof -s $packageName 2>/dev/null || echo 0").trim()
            val candidatePids = pidRaw.split(Regex("\\s+")).filter { it.matches(Regex("\\d+")) }

            for (candidatePid in candidatePids) {
                val cmdline = shell.execute("tr '\\0' ' ' < /proc/$candidatePid/cmdline 2>/dev/null || echo").trim()
                val isTargetProcess = cmdline == packageName || cmdline.startsWith("$packageName:")
                if (isTargetProcess) {
                    return candidatePid.toInt()
                }
            }
            0
        } catch (_: Exception) {
            0
        }
    }

    private fun doHook(lpparam: LPParam) {
        val start = System.currentTimeMillis()
        val processKey = "${lpparam.packageName}|${lpparam.processName}"
        LogX.d(
            TAG,
            "MainHook.doHook start package=${lpparam.packageName} process=${lpparam.processName} thread=${Thread.currentThread().name}"
        )
        if (!hookedProcesses.add(processKey)) {
            LogX.w(
                TAG,
                "MainHook.doHook skip duplicate package=${lpparam.packageName} process=${lpparam.processName}"
            )
            return
        }

        if (lpparam.packageName == AppConstant.APP_PACKAGE_NAME) {
            LogX.d(TAG, "Main app loaded")
        }

        HookProcess(lpparam).register()
        LogX.d(
            TAG,
            "MainHook.doHook after HookProcess package=${lpparam.packageName} process=${lpparam.processName}"
        )
        HookJsXposed.setup(lpparam)
        LogX.d(
            TAG,
            "MainHook.doHook finish package=${lpparam.packageName} process=${lpparam.processName} cost=${System.currentTimeMillis() - start}ms"
        )
    }

}
