package com.jsxposed.xmod.feature.jsxposed.loader

import android.os.ParcelFileDescriptor
import com.jsxposed.xmod.NewApiHook
import java.io.FileNotFoundException

object XposedRemoteFileReader {

    fun readText(name: String): String? {
        val descriptor = NewApiHook.instance?.openRemoteFile(name) ?: return null
        return try {
            ParcelFileDescriptor.AutoCloseInputStream(descriptor).bufferedReader(Charsets.UTF_8).use {
                it.readText()
            }
        } catch (_: FileNotFoundException) {
            null
        }
    }
}
