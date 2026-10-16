package com.jsxposed.xmod

import android.annotation.SuppressLint
import com.jsxposed.xmod.feature.hook.LPParam
import com.jsxposed.xmod.feature.hook.ModuleInterfaceParamWrapper
import com.jsxposed.xmod.feature.hook.lpparamProcessName
import de.robv.android.xposed.IXposedHookZygoteInit
import io.github.libxposed.api.XposedInterface
import io.github.libxposed.api.XposedModule
import io.github.libxposed.api.XposedModuleInterface
import top.sacz.xphelper.XpHelper

class NewApiHook(base: XposedInterface, param: XposedModuleInterface.ModuleLoadedParam) :
    XposedModule(base, param) {

    private val mainHook = MainHook()

    init {
        instance = this
        lpparamProcessName = param.processName
        try {
            val suparam = createStartupParam(this.applicationInfo.sourceDir)
            XpHelper.initZygote(suparam)
        } catch (_: Exception) {
        }
    }

    @SuppressLint("DiscouragedPrivateApi")
    override fun onPackageLoaded(param: XposedModuleInterface.PackageLoadedParam) {
        super.onPackageLoaded(param)
        forwardToRuntime(ModuleInterfaceParamWrapper(param))
    }

    private fun forwardToRuntime(lpparam: LPParam) {
        mainHook.handleNewApiPackageLoaded(lpparam)
    }

    companion object {
        @Volatile
        var instance: NewApiHook? = null

        fun usePreferencesSnapshotTransport(): Boolean = true
    }

    private fun createStartupParam(modulePath: String): IXposedHookZygoteInit.StartupParam {
        val clazz = IXposedHookZygoteInit.StartupParam::class.java
        val constructor = clazz.getDeclaredConstructor()
        constructor.isAccessible = true
        val instance = constructor.newInstance()
        val fieldModulePath = clazz.getDeclaredField("modulePath")
        fieldModulePath.isAccessible = true
        fieldModulePath.set(instance, modulePath)
        return instance
    }
}
