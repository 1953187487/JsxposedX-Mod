package com.jsxposed.xmod.core.models

/**
 * 加解密行为模型记录 (审计用)
 */
data class Encrypt(
    val algorithm: String,      // 算法全称，如 AES/CBC/PKCS5Padding
    val operation: Int,         // 操作类型：1-加密 (ENCRYPT) / 2-解密 (DECRYPT)
    val key: String,            // 密钥的 Hex 字符串
    val iv: String?,            // 初始向量的 Hex 字符串 (可选)
    val input: String,          // 输入原始数据的 UTF-8 字符串
    val output: String,         // 输出结果数据的 UTF-8 字符串
    val inputHex: String,       // 输入原始数据的 Hex (无损记录)
    val outputHex: String,      // 输出结果数据的 Hex (无损记录)
    val stackTrace: List<String>, // 调用栈信息
    val fingerprint: String = "",    // 调用处指纹 (基于堆栈哈希)
    val timestamp: Long = System.currentTimeMillis()
)
