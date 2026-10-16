package com.jsxposed.xmod

import android.app.Application
import com.jsxposed.xmod.core.bridge.lsposed_native.LSPosed
import com.jsxposed.xmod.core.utils.log.LogX

class App : Application() {
    override fun onCreate() {
        super.onCreate()
        LogX.d("FixHookError", "App.onCreate")
        LSPosed.initService(this)
        LogX.d("FixHookError", "App.onCreate initService done")
    }
}
