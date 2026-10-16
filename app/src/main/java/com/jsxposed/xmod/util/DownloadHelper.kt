package com.jsxposed.xmod.util

import android.app.DownloadManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Environment
import java.io.File

object DownloadHelper {
    /**
     * 下载文件并返回下载ID
     * @param context 上下文
     * @param url 要下载的文件URL
     * @param title 通知栏标题
     * @param description 通知栏描述
     * @param mimeType MIME类型，例如 "application/vnd.android.package-archive"
     * @param destinationSubPath 相对于Environment.DIRECTORY_DOWNLOADS的子路径，例如 "JsxposedX-Mod/updates"
     * @return 下载ID
     */
    fun download(
        context: Context,
        url: String,
        title: String,
        description: String,
        mimeType: String,
        destinationSubPath: String? = null
    ): Long {
        val downloadManager = context.getSystemService(Context.DOWNLOAD_SERVICE) as DownloadManager
        val request = DownloadManager.Request(Uri.parse(url)).apply {
            setTitle(title)
            setDescription(description)
            setMimeType(mimeType)
            // 允许在移动网络下下载
            setAllowedNetworkTypes(DownloadManager.Request.NETWORK_WIFI or DownloadManager.Request.NETWORK_MOBILE)
            // 允许漫游时下载
            setAllowedOverRoaming(true)
            // 显示在通知栏中
            setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED)
            // 设置下载目录
            val destDir = if (destinationSubPath != null) {
                Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).apply {
                    val dir = File(this, destinationSubPath)
                    dir.mkdirs()
                }
                destinationSubPath
            } else {
                Environment.DIRECTORY_DOWNLOADS
            }
            setDestinationInExternalPublicDir(destDir, Uri.parse(url).lastPathSegment ?: "download")
        }
        return downloadManager.enqueue(request)
    }

    /**
     * 打开下载好的文件（使用系统安装程序）
     * @param context 上下文
     * @param downloadedFilePath 已下载文件的绝对路径
     */
    fun openDownloadedFile(context: Context, downloadedFilePath: String) {
        val file = File(downloadedFilePath)
        val uri = androidx.core.content.FileProvider.getUriForFile(
            context,
            "${context.packageName}.fileprovider",
            file
        )
        val intent = Intent(Intent.ACTION_VIEW).apply {
            setDataAndType(uri, "application/vnd.android.package-archive")
            flags = Intent.FLAG_GRANT_READ_URI_PERMISSION
        }
        context.startActivity(intent)
    }
}