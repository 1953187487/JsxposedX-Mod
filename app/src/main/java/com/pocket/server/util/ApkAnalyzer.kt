package com.pocket.server.util

import java.io.File
import java.security.MessageDigest
import java.util.zip.ZipFile

object ApkAnalyzer {

    fun sha256(file: File): String {
        val d = MessageDigest.getInstance("SHA-256")
        file.inputStream().use { input ->
            val buf = ByteArray(64 * 1024)
            while (true) {
                val n = input.read(buf)
                if (n <= 0) break
                d.update(buf, 0, n)
            }
        }
        return d.digest().joinToString("") { "%02x".format(it) }
    }

    fun basicInfo(apk: File): String {
        val sb = StringBuilder()
        sb.appendLine("文件: ${apk.name}  大小: ${apk.length() / 1024}KB  SHA-256: ${sha256(apk).take(16)}…")
        try {
            ZipFile(apk).use { z ->
                val entries = z.entries().asSequence().toList()
                val dex = entries.count { it.name.endsWith(".dex") }
                val abis = entries.mapNotNull { e ->
                    Regex("^lib/([^/]+)/").find(e.name)?.groupValues?.get(1)
                }.distinct()
                val assets = entries.count { it.name.startsWith("assets/") }
                val manifest = entries.any { it.name == "AndroidManifest.xml" }
                sb.appendLine("DEX 文件数: $dex  资源文件数: $assets  含清单: $manifest")
                sb.appendLine("支持 ABI: ${abis.joinToString()}")
            }
        } catch (e: Exception) {
            sb.appendLine("ZIP 解析失败: ${e.message}")
        }
        return sb.toString()
    }

    fun summarizeProject(proj: File): String {
        val sb = StringBuilder()
        val manifest = File(proj, "AndroidManifest.xml")
        if (manifest.exists()) {
            val text = manifest.readText()
            val pkg = Regex("package=\"([^\"]+)\"").find(text)?.groupValues?.get(1) ?: "?"
            val perms = Regex("uses-permission[^>]*android:name=\"([^\"]+)\"").findAll(text)
                .map { it.groupValues[1] }.distinct().toList()
            val activities = Regex("<(activity|service|receiver)[\\s>]").findAll(text).count()
            sb.appendLine("包名: $pkg")
            sb.appendLine("组件数(activity/service/receiver): $activities")
            sb.appendLine("权限(${perms.size}): ${perms.take(20).joinToString()}")
        }
        val smaliRoot = File(proj, "smali")
        if (smaliRoot.exists()) {
            val smaliFiles = smaliRoot.walkTopDown().filter { it.extension == "smali" }.toList()
            sb.appendLine("smali 文件总数: ${smaliFiles.size}")
            val topDirs = smaliRoot.listFiles()?.filter { it.isDirectory }?.take(12)?.map { it.name } ?: emptyList()
            sb.appendLine("顶级包: ${topDirs.joinToString()}")
        }
        val assetsDir = File(proj, "assets")
        if (assetsDir.exists()) {
            val names = assetsDir.walkTopDown().filter { it.isFile }.take(25).map { it.relativeTo(proj).path }.toList()
            sb.appendLine("assets 文件(前25): ${names.joinToString()}")
        }
        val libDir = File(proj, "lib")
        if (libDir.exists()) {
            sb.appendLine("lib ABI: ${libDir.listFiles()?.map { it.name }?.joinToString()}")
        }
        return sb.toString()
    }
}
