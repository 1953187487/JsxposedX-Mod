package com.jsxposed.xmod.ai

import com.google.gson.Gson
import com.google.gson.JsonParser
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import java.util.concurrent.TimeUnit

data class AiConfig(
    val baseUrl: String,
    val apiKey: String,
    val model: String
)

class AiClient(private val cfg: AiConfig) {

    private val gson = Gson()
    private val client = OkHttpClient.Builder()
        .connectTimeout(20, TimeUnit.SECONDS)
        .readTimeout(120, TimeUnit.SECONDS)
        .writeTimeout(60, TimeUnit.SECONDS)
        .build()

    fun normalizedBase(): String {
        var b = cfg.baseUrl.trim().trimEnd('/')
        if (b.isEmpty()) throw IllegalStateException("未配置服务商地址")
        if (!b.endsWith("/v1")) b += "/v1"
        return b
    }

    private fun req(url: String, method: String = "GET", body: String? = null): Request.Builder {
        val b = Request.Builder().url(url)
            .header("Authorization", "Bearer ${cfg.apiKey}")
            .header("Content-Type", "application/json")
        return if (body != null) b.post(body.toRequestBody("application/json".toMediaType())) else b.get()
    }

    suspend fun listModels(): List<String> = withContext(Dispatchers.IO) {
        val resp = client.newCall(req("${normalizedBase()}/models").build()).execute()
        resp.use {
            val text = it.body?.string() ?: ""
            if (!it.isSuccessful) throw IllegalStateException("拉取模型失败 HTTP ${it.code}: ${text.take(200)}")
            val root = JsonParser.parseString(text)
            val arr = root.asJsonObject.get("data")?.asJsonArray
                ?: throw IllegalStateException("响应中没有 data 字段: ${text.take(200)}")
            arr.mapNotNull { el ->
                val obj = el.asJsonObject
                (obj.get("id") ?: obj.get("name"))?.takeIf { j -> !j.isJsonNull }?.asString
            }.sorted()
        }
    }

    suspend fun chat(messages: List<Map<String, String>>): String = withContext(Dispatchers.IO) {
        val payload = gson.toJson(
            mapOf(
                "model" to cfg.model,
                "messages" to messages,
                "stream" to false,
                "temperature" to 0.4
            )
        )
        val resp = client.newCall(req("${normalizedBase()}/chat/completions", "POST", payload).build()).execute()
        resp.use {
            val text = it.body?.string() ?: ""
            if (!it.isSuccessful) throw IllegalStateException("请求失败 HTTP ${it.code}: ${text.take(300)}")
            val root = JsonParser.parseString(text).asJsonObject
            val content = root.getAsJsonArray("choices")?.get(0)?.asJsonObject
                ?.getAsJsonObject("message")?.get("content")?.asString
                ?: throw IllegalStateException("响应格式异常: ${text.take(300)}")
            content
        }
    }

    suspend fun test(): String {
        val reply = chat(listOf(mapOf("role" to "user", "content" to "回复\"连接成功\"两个字")))
        return reply.take(100)
    }
}
