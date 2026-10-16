package com.jsxposed.xmod.feature.hook.quick_functions

/**
 * 算法追踪拦截器接口
 */
interface CryptoInterceptor {
    fun onIntercept(data: ByteArray, isInput: Boolean, context: CryptoContext): ByteArray?
}

/**
 * 加解密上下文信息包装
 */
data class CryptoContext(
    val algorithm: String,
    val mode: Int,
    val key: ByteArray?,
    val iv: ByteArray?,
    val packageName: String,
    val fingerprint: String,
    val stackTrace: List<String>
) {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as CryptoContext

        if (mode != other.mode) return false
        if (algorithm != other.algorithm) return false
        if (!key.contentEquals(other.key)) return false
        if (!iv.contentEquals(other.iv)) return false
        if (packageName != other.packageName) return false
        if (fingerprint != other.fingerprint) return false
        if (stackTrace != other.stackTrace) return false

        return true
    }

    override fun hashCode(): Int {
        var result = mode
        result = 31 * result + algorithm.hashCode()
        result = 31 * result + (key?.contentHashCode() ?: 0)
        result = 31 * result + (iv?.contentHashCode() ?: 0)
        result = 31 * result + packageName.hashCode()
        result = 31 * result + fingerprint.hashCode()
        result = 31 * result + stackTrace.hashCode()
        return result
    }
}

