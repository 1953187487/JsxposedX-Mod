package com.jsxposed.xmod.feature.provider

import android.content.ContentProvider
import android.content.ContentValues
import android.database.Cursor
import android.net.Uri
import com.jsxposed.xmod.core.constants.PathConstant
import com.jsxposed.xmod.core.utils.log.LogX
import com.jsxposed.xmod.core.utils.shell.Shell
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * 审计日志 ContentProvider
 * Hook 进程将日志数据通过 ContentProvider 传给主应用进程，
 * 主应用进程使用 Root Shell 写入（与 Project.kt 逻辑一致）。
 */
class AuditLogProvider : ContentProvider() {

    companion object {
        const val AUTHORITY = "com.jsxposed.xmod.audit"
        private const val TAG = "AuditLogProvider"
        private val dateFormat = SimpleDateFormat("yyyyMMdd", Locale.getDefault())
    }

    // Shell 实例由主进程持有，具有 Root 权限
    private val shell = Shell(su = true)

    override fun onCreate(): Boolean = true

    override fun insert(uri: Uri, values: ContentValues?): Uri? {
        val packageName = values?.getAsString("package") ?: return null
        val content = values.getAsString("content") ?: return null

        try {
            val today = dateFormat.format(Date())
            val logDir = "${PathConstant.logDirPath(packageName)}/crypto"
            val fullPath = "$logDir/audit_$today.log"

            // 用 Root Shell 创建目录并追加写入（与 Project.kt 保持一致）
            shell.mkdir(logDir)
            val success = shell.append(content, fullPath)

            if (success) {
                LogX.d(TAG, "[$packageName] 审计日志写入成功: $fullPath")
            } else {
                LogX.e(TAG, "[$packageName] 审计日志写入失败: $fullPath")
            }
        } catch (e: Exception) {
            LogX.e(TAG, "[$packageName] 写入异常: ${e.message}")
        }

        return null
    }

    override fun query(uri: Uri, projection: Array<out String>?, selection: String?, selectionArgs: Array<out String>?, sortOrder: String?): Cursor? = null
    override fun getType(uri: Uri): String? = null
    override fun delete(uri: Uri, selection: String?, selectionArgs: Array<out String>?): Int = 0
    override fun update(uri: Uri, values: ContentValues?, selection: String?, selectionArgs: Array<out String>?): Int = 0
}
