package com.jsxposed.xmod

import com.jsxposed.xmod.core.bridge.apk_analysis_native.ApkAnalysisNative
import com.jsxposed.xmod.core.bridge.apk_analysis_native.ApkAnalysisNativeImpl
import com.jsxposed.xmod.core.bridge.app_native.AppNative
import com.jsxposed.xmod.core.bridge.pinia_native.PiniaNativeImpl
import com.jsxposed.xmod.core.bridge.file_picker_native.OverlayFilePickerNative
import com.jsxposed.xmod.core.bridge.zygisk_frida_native.ZygiskFridaNative
import com.jsxposed.xmod.core.bridge.zygisk_frida_native.ZygiskFridaNativeImpl
import com.jsxposed.xmod.core.bridge.status_management_native.StatusManagementNative
import com.jsxposed.xmod.core.bridge.status_management_native.StatusManagementNativeImpl
import com.jsxposed.xmod.core.bridge.app_native.AppNativeImpl
import com.jsxposed.xmod.core.bridge.memory_tool_native.MemoryToolNative
import com.jsxposed.xmod.core.bridge.memory_tool_native.MemoryToolNativeImpl
import com.jsxposed.xmod.core.bridge.pinia_native.PiniaNative
import com.jsxposed.xmod.core.bridge.project_native.ProjectNative
import com.jsxposed.xmod.core.bridge.project_native.ProjectNativeImpl
import com.jsxposed.xmod.core.bridge.url_helper_native.UrlHelperNative
import com.jsxposed.xmod.core.bridge.so_analysis_native.SoAnalysisNative
import com.jsxposed.xmod.core.bridge.so_analysis_native.SoAnalysisNativeImpl
import com.jsxposed.xmod.core.bridge.lsposed_native.LSPosedNative
import com.jsxposed.xmod.core.bridge.lsposed_native.LSPosedNativeImpl
import com.jsxposed.xmod.core.bridge.shell_native.ShellNative
import com.jsxposed.xmod.core.bridge.shell_native.ShellNativeImpl
import io.flutter.plugin.common.BinaryMessenger

object NativeProvider {
    private var appNativeImpl: AppNativeImpl? = null
    private var projectNativeImpl: ProjectNativeImpl? = null
    private var apkAnalysisImpl: ApkAnalysisNativeImpl? = null
    private var soAnalysisImpl: SoAnalysisNativeImpl? = null
    private var memoryToolImpl: MemoryToolNativeImpl? = null

    fun registerAll(context: android.content.Context, messenger: BinaryMessenger) {
        PiniaNative.setUp(messenger, PiniaNativeImpl(context))
        StatusManagementNative.setUp(messenger, StatusManagementNativeImpl(context))
        appNativeImpl?.dispose()
        appNativeImpl = AppNativeImpl(context)
        AppNative.setUp(messenger, appNativeImpl)
        projectNativeImpl?.cleanup()
        projectNativeImpl = ProjectNativeImpl(context)
        ProjectNative.setUp(messenger, projectNativeImpl)
        soAnalysisImpl?.cleanup()
        apkAnalysisImpl?.cleanup()
        memoryToolImpl?.cleanup()
        val nextApkAnalysisImpl = ApkAnalysisNativeImpl(context)
        val nextSoAnalysisImpl = SoAnalysisNativeImpl(
            context,
            nextApkAnalysisImpl.sharedSession,
        )
        val nextMemoryToolImpl = MemoryToolNativeImpl(context)
        apkAnalysisImpl = nextApkAnalysisImpl
        soAnalysisImpl = nextSoAnalysisImpl
        memoryToolImpl = nextMemoryToolImpl
        ApkAnalysisNative.setUp(messenger, nextApkAnalysisImpl)
        SoAnalysisNative.setUp(messenger, nextSoAnalysisImpl)
        MemoryToolNative.setUp(messenger, nextMemoryToolImpl)
        LSPosedNative.setUp(messenger, LSPosedNativeImpl(context))
        ZygiskFridaNative.setUp(messenger, ZygiskFridaNativeImpl(context))
        OverlayFilePickerNative.register(context, messenger)
        UrlHelperNative.register(context, messenger)
        ShellNative.setUp(messenger, ShellNativeImpl(context))
    }

    fun dispose() {
        appNativeImpl?.dispose()
        appNativeImpl = null
        projectNativeImpl?.cleanup()
        projectNativeImpl = null
        soAnalysisImpl?.cleanup()
        soAnalysisImpl = null
        apkAnalysisImpl?.cleanup()
        apkAnalysisImpl = null
        memoryToolImpl?.cleanup()
        memoryToolImpl = null
    }
}
