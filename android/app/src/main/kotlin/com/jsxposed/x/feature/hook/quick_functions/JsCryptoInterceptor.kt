package com.jsxposed.xmod.feature.hook.quick_functions

import com.google.gson.Gson
import com.jsxposed.xmod.core.utils.log.LogX
import com.jsxposed.xmod.feature.hook.utils.ByteUtils
import com.jsxposed.xmod.core.js.ZiplineManager

/**
 * 专业版 JS 算法拦截器
 * 采用 Zipline Service 强类型通信架构
 */
class JsCryptoInterceptor(private val packageName: String, private val jsCode: String) : CryptoInterceptor {
    private val TAG = "JsCryptoInterceptor"
    private val serviceName = "CryptoJsService"

    init {
        setupJsEnvironment()
    }

    private fun setupJsEnvironment() {
        LogX.d(TAG, "******** [Process: $packageName] 初始化 JS 拦截器 Service ********")
        
        // 脚本包装器：
        // 直接在全局执行用户代码，不能使用 IIFE 包裹，否则像 function onIntercept() 这样的定义将无法进入 globalThis
        val wrappedCode = """
            try {
                console.log("[JsCrypto] 开始注入拦截脚本与内置工具库...");
                
                // 内置 JxCrypto 工具库
                globalThis.JxCrypto = {
                    stringToHex: function(str) {
                        var utf8 = unescape(encodeURIComponent(str));
                        var hex = '';
                        for (var i = 0; i < utf8.length; i++) {
                            var code = utf8.charCodeAt(i).toString(16).toUpperCase();
                            if (code.length < 2) code = '0' + code;
                            hex += code;
                        }
                        return hex;
                    },
                    hexToString: function(hex) {
                        var str = '';
                        for (var i = 0; i < hex.length; i += 2) {
                            str += String.fromCharCode(parseInt(hex.substr(i, 2), 16));
                        }
                        try {
                            return decodeURIComponent(escape(str));
                        } catch(e) {
                            return str;
                        }
                    },
                    replaceWithString: function(newString) {
                        return this.stringToHex(newString);
                    }
                };

                // 运行用户代码，期望它定义全局变量/函数 (如 onIntercept)
                $jsCode
                
                console.log("[JsCrypto] 脚本及工具库注入完成");
            } catch(e) {
                console.error("[JsCrypto] 执行异常: " + e.message);
            }
        """.trimIndent()

        ZiplineManager.loadScript(wrappedCode, "crypto_script_$packageName")
    }

    override fun onIntercept(data: ByteArray, isInput: Boolean, context: CryptoContext): ByteArray? {
        // 使用 ZiplineManager 同步调度执行 JS 函数
        return ZiplineManager.runInEngine { q ->
            try {
                // 1. 确保环境 (Jx 对象等已就绪)
                // 2. 准备参数
                val dataHex = ByteUtils.toHex(data)
                val contextMap = mapOf(
                    "algorithm" to context.algorithm,
                    "mode" to context.mode,
                    "key" to (context.key?.let { ByteUtils.toHex(it) } ?: ""),
                    "iv" to (context.iv?.let { ByteUtils.toHex(it) } ?: ""),
                    "fingerprint" to context.fingerprint,
                    "stackTrace" to context.stackTrace
                )
                
                val gson = Gson()
                val dataJson = gson.toJson(mapOf(
                    "data" to dataHex,
                    "isInput" to isInput,
                    "context" to contextMap
                ))

                // 3. 构造 JS 调用 (直接 evaluate 字符串)
                val callJs = """
                    (function() {
                        if (typeof onIntercept !== 'function') {
                            return JSON.stringify({ error: "onIntercept 未定义" });
                        }
                        try {
                            var args = $dataJson;
                            var result = onIntercept(args.data, args.isInput, args.context);
                            return JSON.stringify({ result: result });
                        } catch (e) {
                            return JSON.stringify({ error: e.toString() });
                        }
                    })()
                """.trimIndent()
                val resultObj = q.evaluate(callJs)
                val jsonResult = resultObj?.toString() ?: "{}"
                val resultWrapper = gson.fromJson(jsonResult, Map::class.java) as? Map<String, String>

                if (resultWrapper != null && resultWrapper.containsKey("result")) {
                    val resultHex = resultWrapper["result"]
                    if (resultHex != null && resultHex != dataHex) {
                        ByteUtils.fromHex(resultHex)
                    } else {
                        null
                    }
                } else {
                    resultWrapper?.get("error")?.let { 
                        LogX.e(TAG, "JS 执行错误: $it") 
                    }
                    null
                }
            } catch (e: Exception) {
                LogX.e(TAG, "JS 执行严重错误: ${e.message}")
                null
            }
        }
    }
}
