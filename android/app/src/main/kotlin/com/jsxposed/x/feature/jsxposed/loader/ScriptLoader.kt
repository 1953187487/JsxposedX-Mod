package com.jsxposed.xmod.feature.jsxposed.loader

import android.content.Context
import android.util.Log
import com.jsxposed.xmod.JsXposedTransportConfig
import com.jsxposed.xmod.core.bridge.xposed_js_snapshot.XposedScriptSnapshotRepository
import com.jsxposed.xmod.core.utils.shell.PiniaRoot
import com.jsxposed.xmod.core.utils.log.LogX
import com.jsxposed.xmod.feature.jsxposed.bridge.JxBridgeManager
import com.whl.quickjs.wrapper.QuickJSContext
import org.json.JSONObject

/**
 * JS 脚本加载器 (客户端)
 * 负责通过 libxposed remote file 读取宿主生成的脚本快照并投递到 JS 引擎
 */
class ScriptLoader(
    private val context: Context,
    private val qjs: QuickJSContext,
    private val packageName: String,
    private val bridgeManager: JxBridgeManager,
) {
    private val TAG = "FINDBUGS"
    private val piniaRoot = PiniaRoot()

    fun loadAndExecute() {
        val loadStart = System.currentTimeMillis()
        val fileName = XposedScriptSnapshotRepository.snapshotFileName(packageName)

        try {
            LogX.d(TAG, "snapshot-open-start package=$packageName thread=${Thread.currentThread().name} file=$fileName transport=${if (JsXposedTransportConfig.usePreferencesSnapshotTransport()) "pinia" else "remote-file"}")
            val snapshotText = if (JsXposedTransportConfig.usePreferencesSnapshotTransport()) {
                XposedScriptSnapshotRepository.readSnapshotFromPreferences(packageName, piniaRoot)
            } else {
                XposedRemoteFileReader.readText(fileName)
            }
            if (snapshotText.isNullOrEmpty()) {
                LogX.d(TAG, "snapshot-empty package=$packageName file=$fileName reason=file-missing-or-empty")
                return
            }
            LogX.d(TAG, "snapshot-open-finish package=$packageName file=$fileName size=${snapshotText.length} cost=${System.currentTimeMillis() - loadStart}ms")

            val snapshot = JSONObject(snapshotText)
            val scripts = snapshot.optJSONArray("scripts")
            val count = scripts?.length() ?: 0
            LogX.d(TAG, "snapshot-parse-finish package=$packageName file=$fileName count=$count")
            if (count == 0) {
                LogX.d(TAG, "snapshot-empty package=$packageName file=$fileName reason=no-snapshot-scripts")
                return
            }

            for (index in 0 until count) {
                val item = scripts?.optJSONObject(index) ?: continue
                val scriptName = item.optString("name")
                val localPath = item.optString("localPath")
                val sourceCode = item.optString("code")
                if (scriptName.isBlank() || localPath.isBlank() || sourceCode.isEmpty()) {
                    LogX.e(TAG, "snapshot-entry-invalid package=$packageName file=$fileName index=$index")
                    continue
                }

                val switchKey = XposedScriptSnapshotRepository.scriptSwitchKey(packageName, localPath)
                val enabled = piniaRoot.getBoolean(switchKey, false)
                LogX.d(TAG, "script-status-check package=$packageName script=$scriptName enabled=$enabled key=$switchKey")
                if (!enabled) {
                    val removed = bridgeManager.unhookScript(localPath)
                    LogX.d(TAG, "script-skip-disabled package=$packageName script=$scriptName autoUnhook=$removed")
                    LogX.d(TAG, "script-skip-disabled package=$packageName script=$scriptName")
                    continue
                }

                val runContextKey = "jx_script_run_context_${packageName}_xposed_$scriptName"
                val runContext = runCatching {
                    JSONObject(piniaRoot.getString(runContextKey, ""))
                }.getOrNull()
                val runId = runContext?.optString("runId").orEmpty()
                val removed = bridgeManager.unhookScript(localPath)
                LogX.d(TAG, "script-reload-cleanup package=$packageName script=$scriptName removed=$removed")
                LogX.d(TAG, "script-execute-start package=$packageName script=$scriptName size=${sourceCode.length}")
                val executeStart = System.currentTimeMillis()
                bridgeManager.beginScriptScope(localPath, runId)
                try {
                    executeScript(scriptName, sourceCode)
                } finally {
                    bridgeManager.endScriptScope()
                }
                LogX.d(TAG, "script-execute-finish package=$packageName script=$scriptName cost=${System.currentTimeMillis() - executeStart}ms")
            }

            LogX.d(TAG, "ScriptLoader.loadAndExecute finish package=$packageName cost=${System.currentTimeMillis() - loadStart}ms")
        } catch (e: UnsupportedOperationException) {
            LogX.e(TAG, "snapshot-open-unsupported package=$packageName file=$fileName error=${e.message}")
        } catch (e: Exception) {
            LogX.e(TAG, "snapshot-open-failed package=$packageName file=$fileName error=${e.message}")
        }
    }

    private fun executeScript(scriptName: String, sourceCode: String) {
        try {
            qjs.evaluate(sourceCode, scriptName)
            LogX.d(TAG, "[$packageName] 脚本执行成功: $scriptName")
        } catch (e: Exception) {
            LogX.e(
                TAG,
                "[$packageName] 脚本语法错误或者执行崩溃 ($scriptName): ${e.message}",
                Log.getStackTraceString(e),
            )
        }
    }
}
