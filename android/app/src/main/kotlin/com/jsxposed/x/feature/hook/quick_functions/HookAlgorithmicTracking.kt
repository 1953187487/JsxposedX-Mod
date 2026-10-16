package com.jsxposed.xmod.feature.hook.quick_functions

import android.content.Context
import com.jsxposed.xmod.core.models.Encrypt
import com.jsxposed.xmod.feature.hook.HookImpl
import com.jsxposed.xmod.feature.hook.utils.ByteUtils
import com.jsxposed.xmod.feature.hook.utils.CryptoAuditor
import com.jsxposed.xmod.core.utils.log.LogX
import com.jsxposed.xmod.core.utils.shell.PiniaRoot
import com.jsxposed.xmod.feature.hook.LPParam
import de.robv.android.xposed.XC_MethodHook
import de.robv.android.xposed.XposedBridge
import javax.crypto.Cipher
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec

// 已移至 CryptoModels.kt

/**
 * 算法追踪核心实现 (高度扩展版)
 * 1. 负责底层的 Cipher Hook 点位挂载
 * 2. 负责基础的高性能数据审计 (CryptoAuditor)
 * 3. 提供 interceptors 列表接口，方便外部动态注入拦截逻辑 (如 JSBridge)
 */
class HookAlgorithmicTracking(private val lpparam: LPParam) : HookImpl {

    private val TAG = "HookAlgorithmicTracking"
    // 开放接口：外部可以直接向此列表添加拦截器实现业务逻辑 (例如 JS 插件)
    val interceptors = mutableListOf<CryptoInterceptor>()

    // 线程局部变量记录上下文
    private val currentIv = ThreadLocal<ByteArray?>()
    private val currentKey = ThreadLocal<ByteArray?>()
    private val currentMode = ThreadLocal<Int>()

    override fun onAttach(context: Context) {
        LogX.d(TAG, "算法追踪 onAttach")
        // 1. 初始化核心审计器 (支持 ContentProvider 模式)
        CryptoAuditor.init(lpparam.packageName, context)

        // 2. 如果有 JS 脚本，则挂载 JS 拦截器
        try {
            val jsCode = PiniaRoot().getString("${lpparam.packageName}_audit_log_js_code", "")
            if (jsCode.isNotBlank()) {
                interceptors.add(JsCryptoInterceptor(lpparam.packageName, jsCode))
                LogX.i(TAG, "已挂载 JS 算法拦截器 (代码长度: ${jsCode.length})")
            }
        } catch (e: Exception) {
            LogX.e(TAG, "初始化 JS 拦截器失败: ${e.message}")
        }

        LogX.d(TAG, "算法追踪初始化完成，正在启动 Hook 点...")
        create()
    }

    override fun create() {
        hookCryptoInfrastructure()
    }

    private fun hookCryptoInfrastructure() {
        // IV 捕获
        XposedBridge.hookAllConstructors(IvParameterSpec::class.java, object : XC_MethodHook() {
            override fun afterHookedMethod(param: MethodHookParam) {
                currentIv.set((param.thisObject as IvParameterSpec).iv)
            }
        })

        // 密钥捕获
        XposedBridge.hookAllConstructors(SecretKeySpec::class.java, object : XC_MethodHook() {
            override fun afterHookedMethod(param: MethodHookParam) {
                currentKey.set((param.thisObject as SecretKeySpec).encoded)
            }
        })

        // 模式捕获 (全面覆盖所有 init 重载)
        XposedBridge.hookAllMethods(Cipher::class.java, "init", object : XC_MethodHook() {
            override fun beforeHookedMethod(param: MethodHookParam) {
                if (param.args.isNotEmpty() && param.args[0] is Int) {
                    currentMode.set(param.args[0] as Int)
                }
            }
        })

        // 核心拦截点 (全面覆盖所有 doFinal 重载)
        XposedBridge.hookAllMethods(Cipher::class.java, "doFinal", object : XC_MethodHook() {
            override fun beforeHookedMethod(param: MethodHookParam) {
                // 加密前的输入篡改机会
                if (currentMode.get() == Cipher.ENCRYPT_MODE) {
                    tryIntercept(param, isInput = true)
                }
            }

            override fun afterHookedMethod(param: MethodHookParam) {
                // 审计总是在最后执行，且不受篡改影响
                performAudit(param)

                // 解密后的输出篡改机会
                if (currentMode.get() == Cipher.DECRYPT_MODE) {
                    tryIntercept(param, isInput = false)
                }
            }
        })
    }

    /**
     * 根据堆栈信息生成指纹 (Fingerprint)
     * 过滤掉框架和 Hook 层，仅保留业务逻辑相关的关键帧
     */
    private fun getFingerprint(): Pair<String, String> {
        val stack = Thread.currentThread().stackTrace
        // 关键帧过滤逻辑：
        // 1. 过滤掉系统库和 Xposed 框架
        // 2. 重点关注 App 自己的包名
        val frames = stack.filter { frame ->
            val cn = frame.className
            !cn.startsWith("java.") && 
            !cn.startsWith("android.") && 
            !cn.startsWith("com.android.") &&
            !cn.startsWith("de.robv.android.xposed.") &&
            !cn.startsWith("com.jsxposed.xmod.") // 过滤掉本框架
        }
        
        // 拼接前 5 帧业务代码作为指纹基础
        val fingerprintSource = frames.take(5).joinToString("|") { "${it.className}.${it.methodName}(${it.lineNumber})" }
        val fingerprint = ByteUtils.md5(fingerprintSource).take(8) // 取 8 位缩写方便查看
        
        return fingerprint to fingerprintSource
    }

    private fun tryIntercept(param: XC_MethodHook.MethodHookParam, isInput: Boolean) {
        if (interceptors.isEmpty()) return

        // 智能获取数据：针对不同的 doFinal 重载获取 ByteArray 数据
        val originalData = if (isInput) {
            // 输入通常在 args 中
            param.args.firstOrNull { it is ByteArray } as? ByteArray ?: return
        } else {
            // 输出在 result 中
            param.result as? ByteArray ?: return
        }

        val (fingerprint, _) = getFingerprint()
        val stackTrace = Thread.currentThread().stackTrace.drop(3).take(15).map { it.toString() }

        val context = CryptoContext(
            algorithm = (param.thisObject as Cipher).algorithm,
            mode = currentMode.get() ?: -1,
            key = currentKey.get(),
            iv = currentIv.get(),
            packageName = lpparam.packageName,
            fingerprint = fingerprint,
            stackTrace = stackTrace
        )

        var processedData = originalData

        // 统一链式调用
        interceptors.forEach { interceptor ->
            try {
                interceptor.onIntercept(processedData, isInput, context)?.let { newData ->
                    processedData = newData
                }
            } catch (e: Exception) {
                LogX.e(TAG, "拦截器执行异常: ${e.message}")
            }
        }

        // 修改数据
        if (processedData !== originalData) {
            if (isInput) {
                // 替换第一个 ByteArray 参数
                val index = param.args.indexOfFirst { it is ByteArray }
                if (index >= 0) param.args[index] = processedData
            } else {
                param.result = processedData
            }
        }
    }

    private fun performAudit(param: XC_MethodHook.MethodHookParam) {
        try {
            val cipher = param.thisObject as Cipher
            val inputBytes = if (param.args.isNotEmpty() && param.args[0] is ByteArray) param.args[0] as ByteArray else byteArrayOf()
            val outputBytes = if (param.result != null && param.result is ByteArray) param.result as ByteArray else byteArrayOf()

            val (fingerprint, _) = getFingerprint()
            val stackTrace = Thread.currentThread().stackTrace.drop(3).take(15).map { it.toString() }
            
            val record = Encrypt(
                algorithm = cipher.algorithm,
                operation = if (currentMode.get() == Cipher.ENCRYPT_MODE) 1 else 2,
                key = ByteUtils.toHex(currentKey.get()),
                iv = ByteUtils.toHex(currentIv.get()),
                input = ByteUtils.toSafeString(inputBytes),
                output = ByteUtils.toSafeString(outputBytes),
                inputHex = ByteUtils.toHex(inputBytes),
                outputHex = ByteUtils.toHex(outputBytes),
                stackTrace = stackTrace,
                fingerprint = fingerprint
            )
            
            LogX.d("CryptoTracking", "捕获到算法: ${record.algorithm} | 操作: ${if (record.operation == 1) "ENCRYPT" else "DECRYPT"} | 指纹: $fingerprint")
            CryptoAuditor.audit(record)
        } catch (_: Exception) {}
    }
}