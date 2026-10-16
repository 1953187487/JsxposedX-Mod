package com.jsxposed.xmod.core.models

import com.google.gson.JsonObject
import com.google.gson.annotations.SerializedName
import com.jsxposed.xmod.core.constants.PathConstant

private const val DEFAULT_GADGET_SOURCE_PATH = "/data/local/tmp/JsxposedXSo/libgadget.so"

/**
 * 对齐 `docs/AI_RUNTIME_USAGE_V1.md` 的 `config.json` v1 结构。
 *
 * - `FridaConfigRoot` 对应根对象：`version/defaults/targets`
 * - `FridaConfigDefaults` 对应根级 `defaults`
 * - `FridaConfig` 对应 `targets[]` 中的单个 target
 */
data class FridaConfigRoot(
    val version: Int = VERSION_1,
    val defaults: FridaConfigDefaults = FridaConfigDefaults(),
    val targets: MutableList<FridaConfig> = mutableListOf()
) {
    companion object {
        const val VERSION_1 = 1
    }

    fun containsTarget(packageName: String): Boolean {
        return targets.any { it.appName == packageName }
    }

    fun upsertDefaultTarget(packageName: String): FridaConfigRoot {
        val updatedTargets = targets
            .filterNot { it.appName == packageName }
            .toMutableList()
            .apply { add(FridaConfig.defaultForPackage(packageName)) }

        return copy(targets = updatedTargets)
    }

    fun removeTargets(packageName: String): FridaConfigRoot {
        return copy(targets = targets.filterNot { it.appName == packageName }.toMutableList())
    }

    fun findResolvedTargetForProcess(processName: String): ResolvedFridaConfig? {
        return targets
            .asSequence()
            .mapNotNull { it.resolve(defaults) }
            .firstOrNull { it.enabled && it.matchesProcess(processName) && it.isValid() }
    }
}

data class FridaConfigDefaults(
    val enabled: Boolean = true,

    @SerializedName("process_scope")
    val processScope: String = FridaConfig.PROCESS_SCOPE_MAIN_AND_CHILD,

    @SerializedName("start_up_delay_ms")
    val startUpDelayMs: Long = 0L,

    @SerializedName("injected_libraries")
    val injectedLibraries: List<InjectedLibrary> = emptyList(),

    @SerializedName("child_gating")
    val childGating: ChildGatingConfig = ChildGatingConfig.defaultConfig(),

    val gadget: FridaGadgetConfig = FridaGadgetConfig.defaultRuntime()
)

data class FridaConfig(
    @SerializedName("app_name")
    val appName: String = "",

    val enabled: Boolean? = null,

    @SerializedName("process_scope")
    val processScope: String? = null,

    @SerializedName("start_up_delay_ms")
    val startUpDelayMs: Long? = null,

    @SerializedName("injected_libraries")
    val injectedLibraries: List<InjectedLibrary>? = null,

    @SerializedName("child_gating")
    val childGating: ChildGatingConfig? = null,

    val gadget: FridaGadgetConfig? = null
) {
    companion object {
        const val PROCESS_SCOPE_MAIN_ONLY = "main_only"
        const val PROCESS_SCOPE_MAIN_AND_CHILD = "main_and_child"

        fun defaultForPackage(packageName: String): FridaConfig {
            return FridaConfig(
                appName = packageName,
                enabled = true,
                processScope = PROCESS_SCOPE_MAIN_AND_CHILD,
                startUpDelayMs = 0L,
                injectedLibraries = emptyList(),
                childGating = ChildGatingConfig.defaultConfig(),
                gadget = FridaGadgetConfig.defaultRuntime().copy(
                    jsPath = PathConstant.fridaHookJsPath(packageName)
                )
            )
        }
    }

    fun resolve(defaults: FridaConfigDefaults = FridaConfigDefaults()): ResolvedFridaConfig? {
        if (appName.isBlank()) return null

        val resolved = ResolvedFridaConfig(
            appName = appName,
            enabled = enabled ?: defaults.enabled,
            processScope = processScope ?: defaults.processScope,
            startUpDelayMs = startUpDelayMs ?: defaults.startUpDelayMs,
            injectedLibraries = injectedLibraries ?: defaults.injectedLibraries,
            childGating = (childGating ?: ChildGatingConfig()).resolve(defaults.childGating),
            gadget = (gadget ?: FridaGadgetConfig()).resolve(defaults.gadget)
        )

        return if (resolved.isValid()) resolved else null
    }
}

data class ResolvedFridaConfig(
    val appName: String,
    val enabled: Boolean,
    val processScope: String,
    val startUpDelayMs: Long,
    val injectedLibraries: List<InjectedLibrary>,
    val childGating: ResolvedChildGatingConfig,
    val gadget: ResolvedFridaGadgetConfig
) {
    fun matchesProcess(processName: String): Boolean {
        return when (processScope) {
            FridaConfig.PROCESS_SCOPE_MAIN_ONLY -> processName == appName
            FridaConfig.PROCESS_SCOPE_MAIN_AND_CHILD -> {
                processName == appName || processName.startsWith("$appName:")
            }

            else -> false
        }
    }

    fun isValid(): Boolean {
        return appName.isNotBlank() && gadget.isValid()
    }
}

data class FridaGadgetConfig(
    val enabled: Boolean? = null,

    @SerializedName("source_path")
    val sourcePath: String? = null,

    @SerializedName("js_path")
    val jsPath: String? = null,

    @SerializedName("script_dir")
    val scriptDir: String? = null,

    @SerializedName("frida_config")
    val fridaConfig: JsonObject? = null
) {
    companion object {
        fun defaultRuntime(): FridaGadgetConfig {
            return FridaGadgetConfig(
                enabled = true,
                sourcePath = DEFAULT_GADGET_SOURCE_PATH
            )
        }
    }

    fun resolve(defaults: FridaGadgetConfig = defaultRuntime()): ResolvedFridaGadgetConfig {
        return ResolvedFridaGadgetConfig(
            enabled = enabled ?: defaults.enabled ?: true,
            sourcePath = sourcePath ?: defaults.sourcePath ?: DEFAULT_GADGET_SOURCE_PATH,
            jsPath = jsPath ?: defaults.jsPath,
            scriptDir = scriptDir ?: defaults.scriptDir,
            fridaConfig = fridaConfig ?: defaults.fridaConfig
        )
    }
}

data class ResolvedFridaGadgetConfig(
    val enabled: Boolean,
    val sourcePath: String,
    val jsPath: String? = null,
    val scriptDir: String? = null,
    val fridaConfig: JsonObject? = null
) {
    fun interactionConfigCount(): Int {
        return listOf(jsPath, scriptDir, fridaConfig).count { it != null }
    }

    fun isValid(): Boolean {
        return interactionConfigCount() <= 1
    }
}

data class InjectedLibrary(
    val path: String = ""
)

data class ChildGatingConfig(
    val enabled: Boolean? = null,
    val mode: String? = null,

    @SerializedName("injected_libraries")
    val injectedLibraries: List<InjectedLibrary>? = null
) {
    companion object {
        const val MODE_FREEZE = "freeze"
        const val MODE_INJECT = "inject"

        fun defaultConfig(): ChildGatingConfig {
            return ChildGatingConfig(
                enabled = false,
                mode = MODE_FREEZE,
                injectedLibraries = emptyList()
            )
        }
    }

    fun resolve(defaults: ChildGatingConfig = defaultConfig()): ResolvedChildGatingConfig {
        return ResolvedChildGatingConfig(
            enabled = enabled ?: defaults.enabled ?: false,
            mode = mode ?: defaults.mode ?: MODE_FREEZE,
            injectedLibraries = injectedLibraries ?: defaults.injectedLibraries ?: emptyList()
        )
    }
}

data class ResolvedChildGatingConfig(
    val enabled: Boolean,
    val mode: String,
    val injectedLibraries: List<InjectedLibrary>
)
