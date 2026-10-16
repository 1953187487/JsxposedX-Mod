package com.jsxposed.xmod.core.utils.shell

import com.google.gson.Gson
import com.jsxposed.xmod.core.constants.QuickFunctionsConstant
import com.jsxposed.xmod.core.models.DialogKeyword
import com.jsxposed.xmod.core.models.EncryptKeyword
import org.json.JSONArray

class QuickFunctionsUtils {

    private val pinia = PiniaRoot()

    fun getQuickFunctionStatus(packageName: String, name: String): Boolean {
        return pinia.getBoolean("${packageName}_$name", false)
    }

    fun setQuickFunctionStatus(packageName: String, name: String, status: Boolean) {
        pinia.setBoolean("${packageName}_$name", status)
    }

    /**
     * 获取所有弹窗关键词对象列表
     */
    fun getDialogKeywords(packageName: String, name: String): List<DialogKeyword> {
        val raw = pinia.getString("${packageName}_${name}_keywords", "[]")
        val result = mutableListOf<DialogKeyword>()
        try {
            val jsonArray = JSONArray(raw)
            for (i in 0 until jsonArray.length()) {
                val obj = jsonArray.optJSONObject(i) ?: continue
                val keyword = obj.optString("keyword")
                val isCheck = obj.optBoolean("isCheck", false)
                if (keyword.isNotEmpty()) {
                    result.add(DialogKeyword(keyword, isCheck))
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return result
    }

    /**
     * 获取已启用的关键词字符串列表（用于 Hook 逻辑）
     */
    fun getEnabledDialogKeywords(packageName: String, name: String): List<String> {
        return getDialogKeywords(packageName, name)
            .filter { it.isCheck }
            .map { it.keyword }
    }

    /**
     * 获取已启用的算法追踪拦截规则 (支持分页)
     * @param offset 跳过的规则数量
     * @param limit 本次获取的最大数量 (-1 表示不限制)
     */
    fun getEnabledEncryptKeywords(packageName: String, offset: Int = 0, limit: Int = -1): List<EncryptKeyword> {
        val raw = pinia.getString("${packageName}_${QuickFunctionsConstant.ALGORITHMIC_TRACKING}_rules", "[]")
        val result = mutableListOf<EncryptKeyword>()
        try {
            val jsonArray = JSONArray(raw)
            val gson = Gson()
            var matchedCount = 0
            
            for (i in 0 until jsonArray.length()) {
                val jsonStr = jsonArray.optString(i) ?: continue
                val rule = gson.fromJson(jsonStr, EncryptKeyword::class.java)
                
                if (rule.isEnabled) {
                    if (matchedCount < offset) {
                        matchedCount++
                        continue
                    }
                    
                    result.add(rule)
                    matchedCount++
                    
                    if (limit != -1 && result.size >= limit) {
                        break
                    }
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return result
    }
}