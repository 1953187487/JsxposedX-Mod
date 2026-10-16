package com.jsxposed.xmod.core.models

/**
 * 算法追踪拦截/篡改规则模型
 */
data class EncryptKeyword(
    val keyword: String,        // 匹配关键词 (支持搜索)
    val replacement: String?,    // 替换后的内容 (若为 null 则仅审计不篡改)
    val isEnabled: Boolean = true, // 是否启用当前规则
    val matchType: MatchType = MatchType.STRING, // 匹配模式
    val scope: MatchScope = MatchScope.BOTH,     // 匹配范围
    val featureCode: String? = null // 可选：指纹特征码 (关联特定的 Key/IV)
)

enum class MatchType {
    STRING, HEX, REGEX
}

enum class MatchScope {
    INPUT, OUTPUT, BOTH
}
