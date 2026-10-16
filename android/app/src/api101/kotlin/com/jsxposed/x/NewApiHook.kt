package com.jsxposed.xmod

import android.annotation.SuppressLint
import com.jsxposed.xmod.core.utils.log.LogX
import com.jsxposed.xmod.feature.hook.Api101PackageReadyParamWrapper
import com.jsxposed.xmod.feature.hook.LPParam
import de.robv.android.xposed.IXposedHookZygoteInit
import io.github.libxposed.api.XposedModule
import io.github.libxposed.api.XposedModuleInterface
import top.sacz.xphelper.XpHelper

class NewApiHook : XposedModule() {

    private val mainHook = MainHook()

    override fun onModuleLoaded(param: XposedModuleInterface.ModuleLoadedParam) {
        instance = this
        processName = param.processName

        runCatching {
            val startupParam = createStartupParam(getModuleApplicationInfo().sourceDir)
            XpHelper.initZygote(startupParam)
        }.onFailure {
            LogX.e("NewApiHook", "onModuleLoaded init failed: ${it.message}")
        }
    }

    @SuppressLint("DiscouragedPrivateApi")
    override fun onPackageReady(param: XposedModuleInterface.PackageReadyParam) {
        super.onPackageReady(param)
        forwardToRuntime(Api101PackageReadyParamWrapper(param, processName))
    }

    private fun forwardToRuntime(lpparam: LPParam) {
        mainHook.handleNewApiPackageLoaded(lpparam)
    }

    companion object {
        @Volatile
        var instance: NewApiHook? = null

        @Volatile
        private var processName: String = ""

        fun usePreferencesSnapshotTransport(): Boolean = false
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
