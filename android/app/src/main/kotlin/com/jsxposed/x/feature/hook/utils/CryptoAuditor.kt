package com.jsxposed.xmod.feature.hook.utils

import android.annotation.SuppressLint
import android.content.ContentValues
import android.content.Context
import android.net.Uri
import com.google.gson.Gson
import com.jsxposed.xmod.core.models.Encrypt
import com.jsxposed.xmod.core.utils.log.LogX
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.concurrent.ConcurrentLinkedQueue
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicBoolean

/**
 * 算法追踪异步审计员
 * 通过 ContentProvider 将日志写回主应用进程，
 * 规避 Hook 进程 Mount Namespace 隔离导致文件不可见的问题。
 */
object CryptoAuditor {
    private val queue = ConcurrentLinkedQueue<Encrypt>()
    private val executor = Executors.newSingleThreadScheduledExecutor()
    private val gson = Gson()
    private val isRunning = AtomicBoolean(false)

    private var targetPackage: String = "unknown"
    private var appContext: Context? = null

    @SuppressLint("ConstantLocale")
    private val dateFormat = SimpleDateFormat("yyyyMMdd", Locale.getDefault())

    private const val BATCH_SIZE = 10
    private val PROVIDER_URI = Uri.parse("content://com.jsxposed.xmod.audit/log")

    /**
     * 初始化审计员
     * @param packageName 目标 App 的包名
     * @param context     目标 App 的 Context (用于访问 ContentResolver)
     */
    fun init(packageName: String, context: Context) {
        this.targetPackage = packageName
        this.appContext = context
        LogX.d("CryptoAuditor", "[$targetPackage] 初始化完成 (ContentProvider 模式)")
        start()
    }

    private fun start() {
        if (isRunning.getAndSet(true)) return
        executor.scheduleWithFixedDelay({ processQueue() }, 2, 2, TimeUnit.SECONDS)
    }

    fun audit(data: Encrypt) {
        queue.offer(data)
        if (queue.size >= BATCH_SIZE) {
            executor.execute { processQueue() }
        }
    }

    private fun processQueue() {
        if (queue.isEmpty()) return

        val logs = mutableListOf<Encrypt>()
        while (queue.isNotEmpty() && logs.size < 100) {
            queue.poll()?.let { logs.add(it) }
        }
        if (logs.isEmpty()) return

        val ndjson = logs.joinToString("\n") { gson.toJson(it) } + "\n"
        val ctx = appContext ?: run {
            LogX.e("CryptoAuditor", "[$targetPackage] Context 未初始化，跳过写入")
            return
        }

        try {
            val values = ContentValues().apply {
                put("package", targetPackage)
                put("content", ndjson)
            }
            ctx.contentResolver.insert(PROVIDER_URI, values)
            LogX.d("CryptoAuditor", "[$targetPackage] 已通过 ContentProvider 提交 ${logs.size} 条审计日志")
        } catch (e: Exception) {
            LogX.e("CryptoAuditor", "[$targetPackage] ContentProvider 写入异常: ${e.message}")
        }
    }

    fun stop() {
        isRunning.set(false)
        executor.shutdown()
    }
}
