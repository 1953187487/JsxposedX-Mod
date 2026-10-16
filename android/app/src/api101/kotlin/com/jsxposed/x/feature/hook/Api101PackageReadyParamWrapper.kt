package com.jsxposed.xmod.feature.hook

import io.github.libxposed.api.XposedModuleInterface

class Api101PackageReadyParamWrapper(
    private val origin: XposedModuleInterface.PackageReadyParam,
    private val currentProcessName: String
) : LPParam {
    override val packageName get() = origin.packageName
    override val processName get() = currentProcessName
    override val classLoader get() = origin.classLoader
    override val appInfo get() = origin.applicationInfo
    override val isFirstApplication get() = origin.isFirstPackage
}
