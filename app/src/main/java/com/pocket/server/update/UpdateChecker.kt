package com.pocket.server.update

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.Request
import com.google.gson.JsonParser
import java.util.concurrent.TimeUnit

data class Release(
    val name: String,
    val tagName: String,
    val publishedAt: String,
    val body: String,
    val htmlUrl: String,
    val apkUrl: String?
)

object UpdateChecker {

    private val client = OkHttpClient.Builder()
        .connectTimeout(20, TimeUnit.SECONDS)
        .readTimeout(60, TimeUnit.SECONDS)
        .build()

    suspend fun fetchReleases(repo: String, token: String): List<Release> = withContext(Dispatchers.IO) {
        if (repo.isBlank() || !repo.contains('/')) throw IllegalStateException("请先在设置中配置仓库，格式：用户名/仓库名")
        val b = Request.Builder()
            .url("https://api.github.com/repos/${repo.trim()}/releases?per_page=30")
            .header("Accept", "application/vnd.github+json")
        if (token.isNotBlank()) b.header("Authorization", "Bearer ${token.trim()}")
        client.newCall(b.build()).execute().use { resp ->
            val text = resp.body?.string() ?: ""
            if (!resp.isSuccessful) throw IllegalStateException("获取版本失败 HTTP ${resp.code}: ${text.take(200)}")
            val arr = JsonParser.parseString(text).asJsonArray
            arr.map { el ->
                val o = el.asJsonObject
                var apk: String? = null
                val assets = o.getAsJsonArray("assets")
                if (assets != null) {
                    for (a in assets) {
                        val ao = a.asJsonObject
                        val n = ao.get("name")?.asString ?: ""
                        if (n.endsWith(".apk")) {
                            apk = ao.get("browser_download_url")?.asString
                            break
                        }
                    }
                }
                Release(
                    name = o.get("name")?.takeIf { !it.isJsonNull }?.asString ?: "",
                    tagName = o.get("tag_name")?.asString ?: "",
                    publishedAt = o.get("published_at")?.takeIf { !it.isJsonNull }?.asString ?: "",
                    body = o.get("body")?.takeIf { !it.isJsonNull }?.asString ?: "",
                    htmlUrl = o.get("html_url")?.asString ?: "",
                    apkUrl = apk
                )
            }.filter { it.tagName.isNotBlank() }
        }
    }

    fun isNewer(remote: String, local: String): Boolean {
        val r = remote.trim().removePrefix("v").split(".", "-", "+")
        val l = local.trim().removePrefix("v").split(".", "-", "+")
        val n = maxOf(r.size, l.size)
        for (i in 0 until n) {
            val rv = r.getOrNull(i)?.toIntOrNull() ?: 0
            val lv = l.getOrNull(i)?.toIntOrNull() ?: 0
            if (rv != lv) return rv > lv
        }
        return false
    }
}
