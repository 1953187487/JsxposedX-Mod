package com.jsxposed.xmod.core.bridge.file_picker_native

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.os.Environment
import androidx.activity.ComponentActivity
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.net.toUri
import com.mr.flutter.plugin.filepicker.FileUtils
import java.io.File
import java.util.Locale

class OverlayFilePickerProxyActivity : ComponentActivity() {
    private var completed = false

    private val pickerLauncher =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            when (result.resultCode) {
                Activity.RESULT_OK -> handlePickedResult(result.data)
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
        launchPicker()
    }

    private fun launchPicker() {
        val pickerIntent = when (OverlayFilePickerNative.requestType(intent)) {
            RequestType.IMAGE -> buildImageIntent()
            RequestType.FILE -> buildFileIntent(
                OverlayFilePickerNative.allowedExtensions(intent)
            )
        }

        if (pickerIntent.resolveActivity(packageManager) == null) {
            finishWithError(
                "invalid_format_type",
                "Can't handle the provided file type."
            )
            return
        }

        pickerLauncher.launch(pickerIntent)
    }

    private fun buildImageIntent(): Intent {
        val rootUri = (Environment.getExternalStorageDirectory().path + File.separator).toUri()
        return Intent(Intent.ACTION_PICK).apply {
            setDataAndType(rootUri, "image/*")
            type = "image/*"
            putExtra(Intent.EXTRA_ALLOW_MULTIPLE, false)
            putExtra("multi-pick", false)
        }
    }

    private fun buildFileIntent(allowedExtensions: ArrayList<String>?): Intent {
        val mimeTypes = FileUtils.getMimeTypes(allowedExtensions)
        return Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "*/*"
            putExtra(Intent.EXTRA_MIME_TYPES, mimeTypes.toTypedArray())
            putExtra(Intent.EXTRA_ALLOW_MULTIPLE, false)
            putExtra("multi-pick", false)
        }
    }

    private fun handlePickedResult(data: Intent?) {
        val uri = data?.data ?: data?.clipData?.getItemAt(0)?.uri
        if (uri == null) {
            finishWithError("unknown_path", "Failed to retrieve path.")
            return
        }

        val fileInfo = FileUtils.openFileStream(this, uri, true)
        if (fileInfo == null) {
            finishWithError("unknown_path", "Failed to retrieve path.")
            return
        }

        finishWithSuccess(
            hashMapOf(
                "path" to fileInfo.path,
                "name" to fileInfo.name,
                "size" to fileInfo.size,
                "bytes" to fileInfo.bytes,
                "extension" to resolveExtension(fileInfo.name, fileInfo.path),
            )
        )
    }

    private fun finishWithSuccess(data: Map<String, Any?>?) {
        if (completed) {
            return
        }
        completed = true
        OverlayFilePickerNative.completeSuccess(data)
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

    private fun resolveExtension(name: String?, path: String?): String? {
        val source = when {
            !name.isNullOrBlank() -> name
            !path.isNullOrBlank() -> path
            else -> return null
        }
        val index = source.lastIndexOf('.')
        if (index < 0 || index >= source.length - 1) {
            return null
        }
        return source.substring(index + 1).lowercase(Locale.ROOT)
    }
}
