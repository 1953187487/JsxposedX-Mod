package com.jsxposed.xmod.core.bridge.url_helper_native

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.net.Uri
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

object UrlHelperNative {
    private const val CHANNEL_NAME = "com.jsxposed.xmod/url_helper"

    fun register(context: Context, messenger: BinaryMessenger) {
        MethodChannel(messenger, CHANNEL_NAME).setMethodCallHandler { call, result ->
            when (call.method) {
                "openExternalUrl" -> handleOpenExternalUrl(context, call, result)
                else -> result.notImplemented()
            }
        }
    }

    private fun handleOpenExternalUrl(
        context: Context,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        val url = call.argument<String>("url")?.trim()
        if (url.isNullOrEmpty()) {
            result.success(false)
            return
        }

        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url)).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }

        try {
            context.startActivity(intent)
            result.success(true)
        } catch (_: ActivityNotFoundException) {
            result.success(false)
        } catch (t: Throwable) {
            result.error("OPEN_URL_FAILED", t.message, null)
        }
    }
}
