package com.jsxposed.xmod.bridge

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.util.Log
import java.io.File
import java.text.SimpleDateFormat
import java.util.Locale
import java.util.TimeZone

/**
 * 历史日志（纯原生直读 Drift SQLite，不依赖 Flutter 引擎）。
 * 库文件：context.filesDir/jsxposedx_ai.sqlite（与 lib/features/ai/.../ai_database.dart 一致）。
 * 协议对齐 lib/core/transport/android_desktop_bridge_server.dart 的 log.query / log.delete_history。
 */
class NativeLogHistory(context: Context) {

    private val TAG = "NativeLogHistory"
    private val dbFile = File(context.filesDir, "jsxposedx_ai.sqlite")

    private fun openDb(): SQLiteDatabase? {
        return try {
            if (!dbFile.exists()) return null
            SQLiteDatabase.openDatabase(
                dbFile.absolutePath, null,
                SQLiteDatabase.OPEN_READONLY
            ).also { it.enableWriteAheadLogging() }
        } catch (e: Exception) {
            Log.e(TAG, "open db failed", e)
            null
        }
    }

    /**
     * 分页查询历史日志。
     * params: conversationId(必填), before?(ISO8601可空), beforeId?(Int可空), limit?(默认100), runId/scriptName/source/level?(可选过滤)
     * 返回 {conversationId, logs:[{id,runId,conversationId,source,scriptName,level,message,stackTrace,timestamp(ISO8601)}]}
     */
    fun query(params: Map<String, Any?>?): Map<String, Any?> {
        val conversationId = params?.get("conversationId") as? String
            ?: return mapOf("error" to "Missing required string parameter: conversationId")
        val before = (params?.get("before") as? String)?.let { parseIso(it) }
        val beforeId = (params?.get("beforeId") as? Number)?.toInt()
        val limit = ((params?.get("limit") as? Number)?.toInt() ?: 100).coerceIn(1, 500)

        val db = openDb() ?: return mapOf("conversationId" to conversationId, "logs" to emptyList<Map<String, Any?>>())

        val selection = StringBuilder("conversation_id = ?")
        val args = mutableListOf<String>()
        args.add(conversationId)

        // 可选精确过滤
        (params?.get("runId") as? String)?.let { if (it.isNotEmpty()) { selection.append(" AND run_id = ?"); args.add(it) } }
        (params?.get("scriptName") as? String)?.let { if (it.isNotEmpty()) { selection.append(" AND script_name = ?"); args.add(it) } }
        (params?.get("source") as? String)?.let { if (it.isNotEmpty()) { selection.append(" AND source = ?"); args.add(it) } }
        (params?.get("level") as? String)?.let { if (it.isNotEmpty()) { selection.append(" AND level = ?"); args.add(it) } }

        // 游标分页：(timestamp < before) OR (timestamp = before AND id < beforeId)
        if (before != null) {
            if (beforeId != null) {
                selection.append(" AND (timestamp < ? OR (timestamp = ? AND id < ?))")
                args.add(before.toString()); args.add(before.toString()); args.add(beforeId.toString())
            } else {
                selection.append(" AND timestamp < ?")
                args.add(before.toString())
            }
        }

        val logs = ArrayList<Map<String, Any?>>(limit)
        try {
            db.rawQuery(
                "SELECT id, run_id, conversation_id, source, script_name, level, message, stack_trace, timestamp " +
                    "FROM script_logs WHERE $selection ORDER BY timestamp DESC, id DESC LIMIT ?",
                (args + limit.toString()).toTypedArray()
            ).use { c ->
                while (c.moveToNext()) {
                    val tsSec = c.getLong(c.getColumnIndexOrThrow("timestamp"))
                    logs.add(
                        mapOf<String, Any?>(
                            "id" to c.getLong(c.getColumnIndexOrThrow("id")),
                            "runId" to (c.getString(c.getColumnIndexOrThrow("run_id")) ?: ""),
                            "conversationId" to (c.getString(c.getColumnIndexOrThrow("conversation_id")) ?: ""),
                            "source" to (c.getString(c.getColumnIndexOrThrow("source")) ?: ""),
                            "scriptName" to (c.getString(c.getColumnIndexOrThrow("script_name")) ?: ""),
                            "level" to (c.getString(c.getColumnIndexOrThrow("level")) ?: ""),
                            "message" to (c.getString(c.getColumnIndexOrThrow("message")) ?: ""),
                            "stackTrace" to (c.getString(c.getColumnIndexOrThrow("stack_trace")) ?: ""),
                            "timestamp" to formatIso(tsSec * 1000L)
                        )
                    )
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "query failed", e)
        } finally {
            db.close()
        }
        return mapOf("conversationId" to conversationId, "logs" to logs)
    }

    /**
     * 删除会话历史。返回 {deleted:true}。
     */
    fun deleteHistory(params: Map<String, Any?>?): Map<String, Any?> {
        val conversationId = params?.get("conversationId") as? String
            ?: return mapOf("error" to "Missing required string parameter: conversationId")
        val db = openDb() ?: return mapOf("deleted" to true)
        try {
            db.execSQL("DELETE FROM script_logs WHERE conversation_id = ?", arrayOf(conversationId))
            db.execSQL("DELETE FROM script_runs WHERE conversation_id = ?", arrayOf(conversationId))
        } catch (e: Exception) {
            Log.e(TAG, "delete failed", e)
        } finally {
            db.close()
        }
        return mapOf("deleted" to true)
    }

    // ---------- 工具 ----------

    private val isoFmt = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.US).apply {
        timeZone = TimeZone.getTimeZone("UTC")
    }

    private fun formatIso(epochMillis: Long): String = isoFmt.format(java.util.Date(epochMillis))

    /** ISO8601 -> unix 秒（Drift 用 INTEGER 秒存储）。解析失败返回 null。 */
    private fun parseIso(iso: String): Long? {
        return try {
            val dt = java.time.Instant.parse(iso)
            dt.epochSecond
        } catch (e: Exception) {
            try {
                // 兼容非 UTC 后缀
                java.time.OffsetDateTime.parse(iso).toInstant().epochSecond
            } catch (e2: Exception) {
                Log.w(TAG, "parseIso failed: $iso")
                null
            }
        }
    }
}
