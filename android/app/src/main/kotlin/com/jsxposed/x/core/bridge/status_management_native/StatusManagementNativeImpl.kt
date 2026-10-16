package com.jsxposed.xmod.core.bridge.status_management_native

import android.content.Context
import android.os.Build
import androidx.annotation.RequiresApi

class StatusManagementNativeImpl(private val context: Context) : StatusManagementNative {

    override fun isHook(): Boolean = StatusManagement(context).isHook()

    @RequiresApi(Build.VERSION_CODES.O)
    override fun isRoot(): Boolean = StatusManagement(context).isRoot()

    override fun isFrida(): FridaStatusData = StatusManagement(context).isFrida()

}
