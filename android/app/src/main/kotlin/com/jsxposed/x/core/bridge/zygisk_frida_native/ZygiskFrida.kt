package com.jsxposed.xmod.core.bridge.zygisk_frida_native

import com.google.gson.Gson
import com.jsxposed.xmod.core.models.FridaConfig
import com.jsxposed.xmod.core.models.FridaConfigRoot
import com.jsxposed.xmod.core.utils.shell.Shell

class ZygiskFrida {
    companion object {
        private const val MODULE_DIR = "/data/adb/modules/jsxposedx-frida"
        private const val CONFIG_PATH = "/data/local/tmp/JsxposedXSo/config.json"
        private const val CODE_OK = 0
        private const val CODE_MODULE_NOT_READY = 1
        private const val CODE_READ_FAILED = 2
        private const val CODE_WRITE_FAILED = 3
    }

    private val shell = Shell(su = true)
    private val gson = Gson()

    fun isModuleInstalled(): Boolean {
        return shell.isFolder(MODULE_DIR)
    }

    fun isModuleReady(): Boolean {
        if (!isModuleInstalled()) return false
        if (!shell.isFile(CONFIG_PATH)) return false
        return readConfigRoot() != null
    }

    fun isTargetEnabled(packageName: String): Boolean {
        if (!isModuleReady()) return false
        val root = readConfigRoot() ?: return false
        return root.containsTarget(packageName)
    }

    fun setTargetEnabled(packageName: String, enabled: Boolean): Int {
        if (!isModuleReady()) return CODE_MODULE_NOT_READY

        val root = readConfigRoot() ?: return CODE_READ_FAILED
        val updatedRoot = if (enabled) {
            root.upsertDefaultTarget(packageName)
        } else {
            root.removeTargets(packageName)
        }
        val json = gson.toJson(updatedRoot)
        if (!shell.write(json, CONFIG_PATH)) return CODE_WRITE_FAILED

        return CODE_OK
    }

    private fun readConfigRoot(): FridaConfigRoot? {
        val raw = shell.read(CONFIG_PATH)
        if (raw.isBlank() || isReadError(raw)) return null
        return try {
            gson.fromJson(raw, FridaConfigRoot::class.java) ?: FridaConfigRoot()
        } catch (_: Exception) {
            null
        }
    }

    private fun isReadError(raw: String): Boolean {
        return raw.startsWith("ERROR(") || raw.startsWith("EXCEPTION:")
    }
}
