package com.jsxposed.xmod.core.bridge.file_picker_native

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.result.contract.ActivityResultContracts

/**
 * 悬浮窗（独立 FlutterEngine）保存文件的原生代理。
 *
 * 悬浮窗没有宿主 Activity，`FilePicker.platform.saveFile` 不可用；
 * 这里通过 SAF 的 ACTION_CREATE_DOCUMENT 弹出系统保存面板，
 * 把 Dart 侧传入的字节流写入用户选定的位置。
 */
class OverlayFileSaveProxyActivity : ComponentActivity() {
    companion object {
        const val EXTRA_SAVE_FILE_BYTES = "save_file_bytes"
    }

    private var completed = false

    private val saverLauncher =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            when (result.resultCode) {
                Activity.RESULT_OK -> writeToTarget(result.data?.data)
                Activity.RESULT_CANCELED -> finishWithCancel()
                else -> finishWithError(
                    "unknown_activity",
                    "Unknown activity error, please file an issue."
                )
            }
        }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (savedInstanceState != null) {
            finish()
            return
        }
        launchSaver()
    }

    private fun launchSaver() {
        val fileName = OverlayFilePickerNative.saveFileName(intent)
            ?.takeIf { it.isNotBlank() }
            ?: "export.bin"

        val saverIntent = Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = resolveMimeType(fileName)
            putExtra(Intent.EXTRA_TITLE, fileName)
        }

        if (saverIntent.resolveActivity(packageManager) == null) {
            finishWithError("invalid_format_type", "Can't handle file saving.")
            return
        }

        saverLauncher.launch(saverIntent)
    }

    private fun writeToTarget(uri: Uri?) {
        if (uri == null) {
            finishWithError("unknown_path", "Failed to retrieve target path.")
            return
        }
        val bytes = intent.getByteArrayExtra(EXTRA_SAVE_FILE_BYTES)
        if (bytes == null) {
            finishWithError("invalid_args", "Missing file bytes.")
            return
        }

        try {
            contentResolver.openOutputStream(uri)?.use { output ->
                output.write(bytes)
                output.flush()
            } ?: run {
                finishWithError("write_failed", "Failed to open output stream.")
                return
            }
        } catch (t: Throwable) {
            finishWithError("write_failed", t.message)
            return
        }

        finishWithSuccess(uri.toString())
    }

    private fun resolveMimeType(fileName: String): String {
        val extension = fileName.substringAfterLast('.', "").lowercase()
        return when (extension) {
            "js", "json", "ts" -> "text/plain"
            "kt", "java", "dart", "c", "cpp", "cs", "py", "sh", "smali" -> "text/plain"
            "xml" -> "text/xml"
            "html" -> "text/html"
            "css" -> "text/css"
            "md" -> "text/markdown"
            "yaml", "yml" -> "text/plain"
            "txt" -> "text/plain"
            else -> "application/octet-stream"
        }
    }

    private fun finishWithSuccess(path: String?) {
        if (completed) {
            return
        }
        completed = true
        OverlayFilePickerNative.completeSuccessValue(path)
        finish()
        overridePendingTransition(0, 0)
    }

    private fun finishWithError(code: String, message: String?) {
        if (completed) {
            return
        }
        completed = true
        OverlayFilePickerNative.completeError(code, message)
        finish()
        overridePendingTransition(0, 0)
    }

    private fun finishWithCancel() {
        if (completed) {
            return
        }
        completed = true
        OverlayFilePickerNative.completeCancel()
        finish()
        overridePendingTransition(0, 0)
    }
}
