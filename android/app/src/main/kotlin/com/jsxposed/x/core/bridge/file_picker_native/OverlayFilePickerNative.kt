package com.jsxposed.xmod.core.bridge.file_picker_native

import android.content.Context
import android.content.Intent
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

object OverlayFilePickerNative {
    private const val CHANNEL_NAME = "com.jsxposed.xmod/file_picker_proxy"
    private const val EXTRA_REQUEST_TYPE = "request_type"
    private const val EXTRA_ALLOWED_EXTENSIONS = "allowed_extensions"
    private const val EXTRA_SAVE_FILE_NAME = "save_file_name"

    private var pendingResult: MethodChannel.Result? = null

    fun register(context: Context, messenger: BinaryMessenger) {
        MethodChannel(messenger, CHANNEL_NAME).setMethodCallHandler { call, result ->
            when (call.method) {
                "pickImage" -> launchPicker(
                    context = context,
                    result = result,
                    requestType = RequestType.IMAGE,
                    allowedExtensions = null,
                )

                "pickFile" -> {
                    @Suppress("UNCHECKED_CAST")
                    val allowedExtensions =
                        call.argument<List<String>>("allowedExtensions")
                            ?.filter { it.isNotBlank() }
                            ?.map { it.lowercase() }
                            ?.takeIf { it.isNotEmpty() }
                            ?.let(::ArrayList)
                    launchPicker(
                        context = context,
                        result = result,
                        requestType = RequestType.FILE,
                        allowedExtensions = allowedExtensions,
                    )
                }

                "saveFile" -> launchSaver(
                    context = context,
                    result = result,
                    fileName = call.argument<String>("name"),
                    bytes = call.argument<ByteArray>("bytes"),
                )

                else -> result.notImplemented()
            }
        }
    }

    internal fun requestType(intent: Intent): RequestType {
        return when (intent.getStringExtra(EXTRA_REQUEST_TYPE)) {
            RequestType.IMAGE.value -> RequestType.IMAGE
            else -> RequestType.FILE
        }
    }

    internal fun allowedExtensions(intent: Intent): ArrayList<String>? {
        return intent.getStringArrayListExtra(EXTRA_ALLOWED_EXTENSIONS)
    }

    internal fun saveFileName(intent: Intent): String? {
        return intent.getStringExtra(EXTRA_SAVE_FILE_NAME)
    }

    internal fun completeSuccess(data: Map<String, Any?>?) {
        pendingResult?.success(data)
        pendingResult = null
    }

    /// 保存流程回传的是纯字符串（展示路径）而非 map。
    internal fun completeSuccessValue(data: String?) {
        pendingResult?.success(data)
        pendingResult = null
    }

    internal fun completeError(code: String, message: String?) {
        pendingResult?.error(code, message, null)
        pendingResult = null
    }

    internal fun completeCancel() {
        completeSuccess(null)
    }

    private fun launchSaver(
        context: Context,
        result: MethodChannel.Result,
        fileName: String?,
        bytes: ByteArray?
    ) {
        if (bytes == null) {
            result.error("invalid_args", "Missing file bytes", null)
            return
        }
        if (pendingResult != null) {
            result.error("already_active", "File picker is already active", null)
            return
        }

        pendingResult = result
        val intent = Intent(context, OverlayFileSaveProxyActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            putExtra(EXTRA_SAVE_FILE_NAME, fileName)
            putExtra(OverlayFileSaveProxyActivity.EXTRA_SAVE_FILE_BYTES, bytes)
        }

        try {
            context.startActivity(intent)
        } catch (t: Throwable) {
            pendingResult = null
            result.error("OPEN_SAVER_FAILED", t.message, null)
        }
    }

    private fun launchPicker(
        context: Context,
        result: MethodChannel.Result,
        requestType: RequestType,
        allowedExtensions: ArrayList<String>?
    ) {
        if (pendingResult != null) {
            result.error("already_active", "File picker is already active", null)
            return
        }

        pendingResult = result
        val intent = Intent(context, OverlayFilePickerProxyActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            putExtra(EXTRA_REQUEST_TYPE, requestType.value)
            if (!allowedExtensions.isNullOrEmpty()) {
                putStringArrayListExtra(EXTRA_ALLOWED_EXTENSIONS, allowedExtensions)
            }
        }

        try {
            context.startActivity(intent)
        } catch (t: Throwable) {
            pendingResult = null
            result.error("OPEN_PICKER_FAILED", t.message, null)
        }
    }
}

internal enum class RequestType(val value: String) {
    IMAGE("image"),
    FILE("file"),
}
