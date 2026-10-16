package com.jsxposed.xmod.feature.hook

import io.github.libxposed.api.XposedModuleInterface

var lpparamProcessName: String = ""

class ModuleInterfaceParamWrapper(
    private val origin: XposedModuleInterface.PackageLoadedParam
) : LPParam {
    override val packageName get() = origin.packageName
    override val processName get() = lpparamProcessName
    override val classLoader get() = origin.classLoader
    override val appInfo get() = origin.applicationInfo
    override val isFirstApplication get() = origin.isFirstPackage
}
