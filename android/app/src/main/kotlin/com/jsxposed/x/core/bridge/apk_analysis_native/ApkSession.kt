package com.jsxposed.xmod.core.bridge.apk_analysis_native

import android.content.Context
import com.jsxposed.xmod.core.utils.shell.Shell
import java.io.File
import java.util.UUID

class ApkSession(private val context: Context) {
    private val sessions = mutableMapOf<String, String>()

    @Synchronized
    fun openSession(packageName: String): String {
        val sessionId = UUID.randomUUID().toString()
        val apkPath = context.packageManager.getApplicationInfo(packageName, 0).publicSourceDir
        sessions[sessionId] = resolveLocalPath(apkPath, sessionId)
        return sessionId
    }

    @Synchronized
    fun getLocalPath(sessionId: String): String =
        sessions[sessionId] ?: throw IllegalStateException("Session not found: $sessionId")

    @Synchronized
    fun closeSession(sessionId: String) {
        val path = sessions.remove(sessionId) ?: return
        val file = File(path)
        if (file.canonicalPath.startsWith(context.cacheDir.canonicalPath)) {
            file.delete()
        }
    }

    @Synchronized
    fun closeAll() {
        sessions.keys.toList().forEach(::closeSession)
    }

    private fun resolveLocalPath(apkPath: String, sessionId: String): String {
        return try {
            File(apkPath).inputStream().close()
            apkPath
        } catch (e: Exception) {
            val tmp = File(context.cacheDir, "apk_session_$sessionId.apk")
            Shell(su = true).copy(apkPath, tmp.absolutePath)
            tmp.absolutePath
        }
    }
}
