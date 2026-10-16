package com.jsxposed.xmod.core.constants

import android.annotation.SuppressLint
import android.os.Build

@SuppressLint("SdCardPath")
class PathConstant {

    companion object {

        const val TMP_PATH = "/data/local/tmp"

        const val FLUTTER_ASSETS_PATH =
            "/data/user/0/${AppConstant.APP_PACKAGE_NAME}/app_flutter/flutter_assets"

        const val FRIDA_SO_DIR_PATH = "$TMP_PATH/JsxposedXSo/libs"
        const val PROJECT_DIR_PATH = "$FLUTTER_ASSETS_PATH/Projects"
        const val CONFIG_DIR_PATH = "$FLUTTER_ASSETS_PATH/Configs"

        const val PINIA_PATH = "/data/user/0/${AppConstant.APP_PACKAGE_NAME}/shared_prefs/pinia.xml"

        fun fridaProjectDirPath(packageName: String) = "$TMP_PATH/JsxposedX/${packageName}"
        fun fridaHookJsPath(packageName: String) = "${fridaProjectDirPath(packageName)}/hook.js"

        fun jsProjectDirPath(packageName: String) = "$PROJECT_DIR_PATH/${packageName}/JsProjects"

        fun logDirPath(packageName: String) = "$PROJECT_DIR_PATH/${packageName}/Logs"



        val FRIDA_CLIENT_PATH get() = "$FRIDA_SO_DIR_PATH/${
            if (Build.SUPPORTED_ABIS[0].contains("arm64")) "frida-client-arm64" else "frida-client-arm32"
        }"
    }
}
