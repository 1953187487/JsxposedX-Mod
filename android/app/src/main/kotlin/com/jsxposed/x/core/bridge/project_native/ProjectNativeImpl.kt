package com.jsxposed.xmod.core.bridge.project_native

import android.content.Context
import android.os.Build
import androidx.annotation.RequiresApi
import com.jsxposed.xmod.core.bridge.xposed_js_snapshot.XposedScriptSnapshotRepository
import com.jsxposed.xmod.core.models.Encrypt
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class ProjectNativeImpl(context: Context) : ProjectNative {
    private val appContext = context.applicationContext
    private val project = Project(appContext)
    private val snapshotRepository by lazy { XposedScriptSnapshotRepository(appContext) }
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)

    private fun <T> launchResult(callback: (Result<T>) -> Unit, block: () -> T) {
        scope.launch {
            val result = try {
                Result.success(block())
            } catch (error: CancellationException) {
                throw error
            } catch (error: Exception) {
                Result.failure(error)
            }
            withContext(Dispatchers.Main.immediate) {
                callback(result)
            }
        }
    }

    override fun initProject(callback: (Result<Unit>) -> Unit) = launchResult(callback) {
        project.initProject()
    }

    override fun projectExists(packageName: String, callback: (Result<Boolean>) -> Unit) = launchResult(callback) {
        project.projectExists(packageName)
    }

    override fun createProject(packageName: String, callback: (Result<Unit>) -> Unit) = launchResult(callback) {
        project.createProject(packageName)
    }

    override fun deleteProject(packageName: String, callback: (Result<Unit>) -> Unit) = launchResult(callback) {
        project.deleteProject(packageName)
    }

    override fun getProjects(callback: (Result<List<AppInfo>>) -> Unit) = launchResult(callback) {
        project.getProjects()
    }

    override fun getFridaScripts(packageName: String, callback: (Result<List<String>>) -> Unit) = launchResult(callback) {
        project.getFridaScripts(packageName)
    }

    override fun createFridaScript(
        packageName: String,
        content: String,
        localPath: String,
        append: Boolean,
        callback: (Result<Unit>) -> Unit,
    ) = launchResult(callback) {
        project.createFridaScript(
            packageName = packageName, content = content, localPath = localPath, append = append
        )
    }

    override fun readFridaScript(
        packageName: String,
        localPath: String,
        callback: (Result<String>) -> Unit,
    ) = launchResult(callback) {
        project.readFridaScript(
            packageName = packageName,
            localPath = localPath,
        )
    }

    override fun deleteFridaScript(
        packageName: String,
        scriptName: String,
        callback: (Result<Unit>) -> Unit,
    ) = launchResult(callback) {
        project.deleteFridaScript(packageName, scriptName)
    }

    override fun importFridaScripts(
        packageName: String, localPaths: List<String>, callback: (Result<Unit>) -> Unit
    ) = launchResult(callback) {
        project.importFridaScripts(packageName, localPaths)
    }


    override fun bundleFridaHookJs(packageName: String, callback: (Result<Unit>) -> Unit) = launchResult(callback) {
        project.bundleFridaHookJs(packageName)
    }

    override fun getJsScripts(packageName: String, callback: (Result<List<String>>) -> Unit) = launchResult(callback) {
        project.getJsScripts(packageName)
    }

    override fun createJsScript(
        packageName: String,
        content: String,
        localPath: String,
        append: Boolean,
        callback: (Result<Unit>) -> Unit,
    ) = launchResult(callback) {
        project.createJsScript(
            packageName = packageName, content = content, localPath = localPath, append = append
        )
        snapshotRepository.writeSnapshot(packageName)
    }

    override fun readJsScript(
        packageName: String,
        localPath: String,
        callback: (Result<String>) -> Unit,
    ) = launchResult(callback) {
        project.readJsScript(
            packageName = packageName,
            localPath = localPath,
        )
    }

    override fun deleteJsScript(
        packageName: String,
        localPath: String,
        callback: (Result<Unit>) -> Unit,
    ) = launchResult(callback) {
        project.deleteJsScript(packageName, localPath)
        snapshotRepository.writeSnapshot(packageName)
    }

    override fun importJsScripts(
        packageName: String, localPaths: List<String>, callback: (Result<Unit>) -> Unit
    ) = launchResult(callback) {
        project.importJsScripts(packageName, localPaths)
        snapshotRepository.writeSnapshot(packageName)
    }

    @RequiresApi(Build.VERSION_CODES.FROYO)
    override fun getAuditLogs(
        packageName: String,
        limit: Long,
        offset: Long,
        keyword: String?,
        callback: (Result<List<AuditLog?>>) -> Unit
    ) = launchResult(callback) {
        project.getAuditLogs(packageName, limit, offset, keyword).map { encrypt ->
            AuditLog(
                algorithm = encrypt.algorithm,
                operation = encrypt.operation.toLong(),
                key = encrypt.key,
                keyBase64 = Project.hexToBase64(encrypt.key),
                keyPlaintext = Project.hexToPlaintext(encrypt.key),
                iv = encrypt.iv,
                ivBase64 = Project.hexToBase64(encrypt.iv),
                ivPlaintext = Project.hexToPlaintext(encrypt.iv),
                input = encrypt.input,
                inputBase64 = Project.hexToBase64(encrypt.inputHex),
                output = encrypt.output,
                outputBase64 = Project.hexToBase64(encrypt.outputHex),
                inputHex = encrypt.inputHex,
                outputHex = encrypt.outputHex,
                stackTrace = encrypt.stackTrace,
                fingerprint = encrypt.fingerprint,
                timestamp = encrypt.timestamp,
            )
        }
    }

    override fun deleteAuditLog(
        packageName: String, timestamp: Long, callback: (Result<Unit>) -> Unit
    ) = launchResult(callback) {
        project.deleteAuditLog(packageName, timestamp)
    }

    override fun updateAuditLog(
        packageName: String, updatedLog: AuditLog, callback: (Result<Unit>) -> Unit
    ) = launchResult(callback) {
        val encrypt = Encrypt(
            algorithm = updatedLog.algorithm,
            operation = updatedLog.operation.toInt(),
            key = updatedLog.key,
            iv = updatedLog.iv,
            input = updatedLog.input,
            output = updatedLog.output,
            inputHex = updatedLog.inputHex,
            outputHex = updatedLog.outputHex,
            stackTrace = updatedLog.stackTrace.filterNotNull(),
            fingerprint = updatedLog.fingerprint,
            timestamp = updatedLog.timestamp,
        )
        project.updateAuditLog(packageName, encrypt)
    }

    override fun clearAuditLogs(packageName: String, callback: (Result<Unit>) -> Unit) = launchResult(callback) {
        project.clearAuditLogs(packageName)
    }

    fun cleanup() {
        scope.cancel()
    }
}
