package com.jsxposed.xmod.feature.hook.utils

/**
 * 字节处理工具类
 */
object ByteUtils {
    private val HEX_CHARS = "0123456789ABCDEF".toCharArray()

    /**
     * ByteArray 转 Hex 字符串
     */
    fun toHex(bytes: ByteArray?): String {
        if (bytes == null || bytes.isEmpty()) return ""
        val result = CharArray(bytes.size * 2)
        for (i in bytes.indices) {
            val v = bytes[i].toInt() and 0xFF
            result[i * 2] = HEX_CHARS[v ushr 4]
            result[i * 2 + 1] = HEX_CHARS[v and 0x0F]
        }
        return String(result)
    }

    /**
     * 安全转 UTF-8 字符串，失败则回退至 Hex
     */
    fun toSafeString(bytes: ByteArray?): String {
        if (bytes == null || bytes.isEmpty()) return ""
        return try {
            // 简单的启发式检查：如果包含大量不可见字符（且不是换行符等），则认为是二进制
            val s = String(bytes, Charsets.UTF_8)
            if (isProbablyBinary(bytes)) {
                "[HEX] ${toHex(bytes)}"
            } else {
                s
            }
        } catch (e: Exception) {
            "[HEX] ${toHex(bytes)}"
        }
    }

    fun md5(string: String): String {
        return try {
            val digest = java.security.MessageDigest.getInstance("MD5")
            digest.update(string.toByteArray())
            val messageDigest = digest.digest()
            toHex(messageDigest)
        } catch (e: Exception) {
            ""
        }
    }

    /**
     * Hex 字符串转 ByteArray
     */
    fun fromHex(hex: String): ByteArray {
        val len = hex.length
        val data = ByteArray(len / 2)
        var i = 0
        while (i < len) {
            data[i / 2] = ((Character.digit(hex[i], 16) shl 4) + Character.digit(hex[i + 1], 16)).toByte()
            i += 2
        }
        return data
    }

    private fun isProbablyBinary(bytes: ByteArray): Boolean {
        var unprintable = 0
        for (b in bytes) {
            val i = b.toInt() and 0xFF
            if (i < 32 && i != 9 && i != 10 && i != 13) {
                unprintable++
            }
        }
        return if (bytes.isEmpty()) false else (unprintable.toDouble() / bytes.size) > 0.3
    }
}
