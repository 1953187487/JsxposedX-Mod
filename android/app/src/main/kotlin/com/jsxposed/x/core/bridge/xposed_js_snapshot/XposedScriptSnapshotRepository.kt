package com.jsxposed.xmod.core.bridge.xposed_js_snapshot

import android.content.Context
import android.os.ParcelFileDescriptor
import com.jsxposed.xmod.JsXposedTransportConfig
import com.jsxposed.xmod.core.bridge.lsposed_native.LSPosed
import com.jsxposed.xmod.core.bridge.project_native.Project
import com.jsxposed.xmod.core.utils.shell.PiniaRoot
import com.jsxposed.xmod.core.utils.log.LogX
import org.json.JSONArray
import org.json.JSONObject

class XposedScriptSnapshotRepository(private val context: Context) {

    companion object {
        private const val TAG = "XposedScriptSnapshot"
        private const val SNAPSHOT_VERSION = 1
        private const val PINIA_SPACE = "pinia"
        private const val XPOSED_SWITCH_PREFIX = "xposed_check_status_"
        private const val SNAPSHOT_PREF_PREFIX = "xposed_snapshot_"
        private const val SNAPSHOT_CHUNK_SIZE = 16 * 1024

        fun snapshotFileName(packageName: String): String {
            val sanitizedPackage = packageName.replace('.', '_')
            return "xposed_js_${sanitizedPackage}.json"
        }

        fun packageNameFromSwitchKey(key: String): String? {
            if (!key.startsWith(XPOSED_SWITCH_PREFIX)) return null
            val payload = key.removePrefix(XPOSED_SWITCH_PREFIX)
            val marker = "_/data/"
            val markerIndex = payload.indexOf(marker)
            if (markerIndex <= 0) return null
            return payload.substring(0, markerIndex)
        }

        fun scriptSwitchKey(packageName: String, localPath: String): String {
            return "${XPOSED_SWITCH_PREFIX}${packageName}_${localPath}"
        }

        private fun snapshotPrefsBaseKey(packageName: String): String {
            val sanitizedPackage = packageName.replace('.', '_')
            return "${SNAPSHOT_PREF_PREFIX}${sanitizedPackage}"
        }

        private fun snapshotPrefsCountKey(packageName: String): String {
            return "${snapshotPrefsBaseKey(packageName)}_count"
        }

        private fun snapshotPrefsChunkKey(packageName: String, index: Int): String {
            return "${snapshotPrefsBaseKey(packageName)}_chunk_$index"
        }

        fun readSnapshotFromPreferences(packageName: String, piniaRoot: PiniaRoot): String? {
            val count = piniaRoot.getInt(snapshotPrefsCountKey(packageName), 0)
            if (count <= 0) return null

            val builder = StringBuilder()
            for (index in 0 until count) {
                val chunk = piniaRoot.getString(snapshotPrefsChunkKey(packageName, index), "")
                if (chunk.isEmpty()) {
                    LogX.e(TAG, "readSnapshotFromPreferences missing chunk package=$packageName index=$index count=$count")
                    return null
                }
                builder.append(chunk)
            }
            return builder.toString()
        }
    }

    private val project = Project(context)

    fun buildSnapshot(packageName: String): String {
        val scripts = JSONArray()
        val scriptPaths = project.getJsScripts(packageName)

        scriptPaths.forEach { path ->
            val scriptName = java.io.File(path).name
            val sourceCode = project.readJsScript(packageName, scriptName)
            if (sourceCode.isEmpty() || sourceCode.startsWith("cat: ")) {
                LogX.e(TAG, "buildSnapshot skip unreadable package=$packageName script=$scriptName")
                return@forEach
            }

            val item = JSONObject()
            item.put("name", scriptName)
            item.put("localPath", path)
            item.put("code", sourceCode)
            scripts.put(item)
        }

        return JSONObject().apply {
            put("version", SNAPSHOT_VERSION)
            put("packageName", packageName)
            put("updatedAt", System.currentTimeMillis())
            put("scripts", scripts)
        }.toString()
    }

    fun writeSnapshot(packageName: String) {
        val snapshot = buildSnapshot(packageName)
        if (JsXposedTransportConfig.usePreferencesSnapshotTransport()) {
            writeSnapshotToPreferences(packageName, snapshot)
            return
        }
        val fileName = snapshotFileName(packageName)
        val descriptor = LSPosed.openRemoteFile(fileName)

        if (descriptor == null) {
            LogX.e(TAG, "writeSnapshot failed package=$packageName file=$fileName reason=remote-file-unavailable")
            return
        }

        try {
            ParcelFileDescriptor.AutoCloseOutputStream(descriptor).use { output ->
                output.channel.truncate(0)
                output.channel.position(0)
                output.bufferedWriter(Charsets.UTF_8).use {
                    it.write(snapshot)
                    it.flush()
                }
            }
            LogX.d(TAG, "writeSnapshot success package=$packageName file=$fileName size=${snapshot.length}")
        } catch (e: Exception) {
            LogX.e(TAG, "writeSnapshot failed package=$packageName file=$fileName error=${e.message}")
        }
    }

    private fun writeSnapshotToPreferences(packageName: String, snapshot: String) {
        val prefs = LSPosed.getRemotePreferences(PINIA_SPACE)
        if (prefs == null) {
            LogX.e(TAG, "writeSnapshotToPreferences failed package=$packageName reason=remote-prefs-unavailable")
            return
        }

        try {
            val previousCount = prefs.getInt(snapshotPrefsCountKey(packageName), 0)
            val chunks = snapshot.chunked(SNAPSHOT_CHUNK_SIZE)
            val editor = prefs.edit()
            editor.putInt(snapshotPrefsCountKey(packageName), chunks.size)
            chunks.forEachIndexed { index, chunk ->
                editor.putString(snapshotPrefsChunkKey(packageName, index), chunk)
            }
            if (previousCount > chunks.size) {
                for (index in chunks.size until previousCount) {
                    editor.remove(snapshotPrefsChunkKey(packageName, index))
                }
            }
            val committed = editor.commit()
            if (!committed) {
                LogX.e(TAG, "writeSnapshotToPreferences failed package=$packageName reason=commit-false")
                return
            }
            LogX.d(TAG, "writeSnapshotToPreferences success package=$packageName chunks=${chunks.size} size=${snapshot.length}")
        } catch (e: Exception) {
            LogX.e(TAG, "writeSnapshotToPreferences failed package=$packageName error=${e.message}")
        }
    }

    fun rebuildAllSnapshots() {
        val packages = project.getProjects().map { it.packageName }.distinct().sorted()
        packages.forEach { writeSnapshot(it) }
        LogX.d(TAG, "rebuildAllSnapshots finished count=${packages.size}")
    }

    fun refreshForSwitchKey(space: String, key: String) {
        if (space != PINIA_SPACE) return
        val packageName = packageNameFromSwitchKey(key) ?: return
        writeSnapshot(packageName)
    }

    fun refreshAfterClear(space: String) {
        if (space != PINIA_SPACE) return
        rebuildAllSnapshots()
    }
}
