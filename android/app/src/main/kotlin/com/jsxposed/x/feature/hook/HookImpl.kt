package com.jsxposed.xmod.feature.hook

import android.content.Context

interface HookImpl {


    fun onAttach(context: Context)

    fun create()
}