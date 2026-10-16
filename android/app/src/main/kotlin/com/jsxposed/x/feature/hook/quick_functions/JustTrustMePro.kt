package com.jsxposed.xmod.feature.hook.quick_functions

import android.content.Context
import android.os.Build
import com.jsxposed.xmod.core.utils.log.LogX
import com.jsxposed.xmod.feature.hook.HookImpl
import com.jsxposed.xmod.feature.hook.LPParam
import de.robv.android.xposed.XC_MethodHook
import de.robv.android.xposed.XC_MethodReplacement
import de.robv.android.xposed.XposedHelpers
import java.net.Socket
import java.security.SecureRandom
import java.security.cert.CertPath
import java.security.cert.CertPathParameters
import java.security.cert.TrustAnchor
import java.security.cert.X509Certificate
import javax.net.ssl.KeyManager
import javax.net.ssl.SSLContext
import javax.net.ssl.SSLEngine
import javax.net.ssl.SSLSocketFactory
import javax.net.ssl.TrustManager
import javax.net.ssl.X509ExtendedTrustManager
import javax.net.ssl.X509TrustManager

class JustTrustMePro(private val lpparam: LPParam) : HookImpl {
    lateinit var context: Context
    override fun onAttach(context: Context) {
        this.context = context
        create()
    }

    private val TAG = "JustTrustMePro"
    private var currentPackageName = ""

    override fun create() {
        currentPackageName = lpparam.packageName
        hookAndroidSecurityProvider() // 关键修复�?
        bypassCertPathValidation()
        hookRootTrustManager()

        // ==================== 1. Apache HttpClient Hook ====================
        try {
            // Hook DefaultHttpClient
            XposedHelpers.findAndHookConstructor(
                "org.apache.http.impl.client.DefaultHttpClient",
                lpparam.classLoader,
                object : XC_MethodHook() {
                    override fun afterHookedMethod(param: MethodHookParam) {
                        param.thisObject.javaClass.getDeclaredField("connManager").let {
                            it.isAccessible = true
                            it.set(param.thisObject, getTrustAllConnectionManager())
                        }
                    }
                })
        } catch (e: Throwable) {
            LogX.e(TAG, "Apache HttpClient not found in $currentPackageName")
        }

        // ==================== 2. 标准JSSE Hook ====================
        // Hook TrustManagerFactory
        XposedHelpers.findAndHookMethod(
            "javax.net.ssl.TrustManagerFactory",
            lpparam.classLoader,
            "getTrustManagers",
            object : XC_MethodHook() {
                override fun afterHookedMethod(param: MethodHookParam) {
                    param.result = arrayOf(getTrustManager())
                }
            })

        // Hook SSLContext.init
        XposedHelpers.findAndHookMethod(
            "javax.net.ssl.SSLContext",
            lpparam.classLoader,
            "init",
            Array<KeyManager>::class.java,
            Array<TrustManager>::class.java,
            SecureRandom::class.java,
            object : XC_MethodHook() {
                override fun beforeHookedMethod(param: MethodHookParam) {
                    param.args[0] = null
                    param.args[1] = arrayOf(getTrustManager())
                    param.args[2] = null
                }
            })

        // ==================== 3. WebView Hook ====================
        try {
            XposedHelpers.findAndHookMethod(
                "android.webkit.WebViewClient",
                lpparam.classLoader,
                "onReceivedSslError",
                XposedHelpers.findClass("android.webkit.WebView", lpparam.classLoader),
                XposedHelpers.findClass("android.webkit.SslErrorHandler", lpparam.classLoader),
                XposedHelpers.findClass("android.webkit.SslError", lpparam.classLoader),
                object : XC_MethodReplacement() {
                    override fun replaceHookedMethod(param: MethodHookParam): Any? {
                        XposedHelpers.callMethod(param.args[1], "proceed")
                        return null
                    }
                })
        } catch (e: Throwable) {
            LogX.e(TAG, "WebView hook failed", e)
        }

        // ==================== 4. OkHttp Hook ====================
        try {
            // OkHttp 2.x
            XposedHelpers.findAndHookMethod(
                "com.squareup.okhttp.CertificatePinner",
                lpparam.classLoader,
                "check",
                String::class.java,
                List::class.java,
                object : XC_MethodReplacement() {
                    override fun replaceHookedMethod(param: MethodHookParam): Any {
                        return true
                    }
                })

            // OkHttp 3.x
            XposedHelpers.findAndHookMethod(
                "okhttp3.CertificatePinner",
                lpparam.classLoader,
                "check",
                String::class.java,
                List::class.java,
                object : XC_MethodReplacement() {
                    override fun replaceHookedMethod(param: MethodHookParam): Any {
                        return true
                    }
                })
        } catch (e: Throwable) {
            LogX.e(TAG, "OkHttp hook failed", e)
        }

        // ==================== 5. 其他第三方库 Hook ====================
        // HttpClientAndroidLib
        try {
            XposedHelpers.findAndHookMethod(
                "ch.boye.httpclientandroidlib.conn.ssl.AbstractVerifier",
                lpparam.classLoader,
                "verify",
                String::class.java,
                Array<String>::class.java,
                Array<String>::class.java,
                Boolean::class.java,
                object : XC_MethodReplacement() {
                    override fun replaceHookedMethod(param: MethodHookParam): Any {
                        return true
                    }
                })
        } catch (e: Throwable) {
            LogX.e(TAG, "HttpClientAndroidLib hook failed", e)
        }

        // xUtils
        try {
            XposedHelpers.findAndHookMethod(
                "org.xutils.http.RequestParams",
                lpparam.classLoader,
                "setSslSocketFactory",
                SSLSocketFactory::class.java,
                object : XC_MethodHook() {
                    override fun beforeHookedMethod(param: MethodHookParam) {
                        param.args[0] = createTrustAllSSLFactory()
                    }
                })
        } catch (e: Throwable) {
            LogX.e(TAG, "xUtils hook failed", e)
        }
    }

    // ==================== 原版工具方法 ====================
    private fun getTrustManager(): X509TrustManager {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            object : X509ExtendedTrustManager() {
                override fun checkClientTrusted(chain: Array<X509Certificate>, authType: String) {}
                override fun checkServerTrusted(chain: Array<X509Certificate>, authType: String) {}
                override fun getAcceptedIssuers(): Array<X509Certificate> = arrayOf()
                override fun checkClientTrusted(
                    chain: Array<X509Certificate>, authType: String, socket: Socket
                ) {
                }

                override fun checkServerTrusted(
                    chain: Array<X509Certificate>, authType: String, socket: Socket
                ) {
                }

                override fun checkClientTrusted(
                    chain: Array<X509Certificate>, authType: String, engine: SSLEngine
                ) {
                }

                override fun checkServerTrusted(
                    chain: Array<X509Certificate>, authType: String, engine: SSLEngine
                ) {
                }
            }
        } else {
            object : X509TrustManager {
                override fun checkClientTrusted(chain: Array<X509Certificate>, authType: String) {}
                override fun checkServerTrusted(chain: Array<X509Certificate>, authType: String) {}
                override fun getAcceptedIssuers(): Array<X509Certificate> = arrayOf()
            }
        }
    }

    private fun getTrustAllConnectionManager(): Any {
        return try {
            val schemeRegistry = XposedHelpers.newInstance(
                XposedHelpers.findClass(
                    "org.apache.http.conn.scheme.SchemeRegistry", lpparam.classLoader
                )
            )

            // 创建信任所有证书的SSLSocketFactory
            val sslSocketFactory = XposedHelpers.newInstance(
                XposedHelpers.findClass(
                    "org.apache.http.conn.ssl.SSLSocketFactory", lpparam.classLoader
                ), getTrustManager()
            )

            // 注册HTTP和HTTPS协议
            XposedHelpers.callMethod(
                schemeRegistry, "register", XposedHelpers.newInstance(
                    XposedHelpers.findClass(
                        "org.apache.http.conn.scheme.Scheme", lpparam.classLoader
                    ), "http", XposedHelpers.callStaticMethod(
                        XposedHelpers.findClass(
                            "org.apache.http.conn.scheme.PlainSocketFactory", lpparam.classLoader
                        ), "getSocketFactory"
                    ), 80
                )
            )

            XposedHelpers.callMethod(
                schemeRegistry, "register", XposedHelpers.newInstance(
                    XposedHelpers.findClass(
                        "org.apache.http.conn.scheme.Scheme", lpparam.classLoader
                    ), "https", sslSocketFactory, 443
                )
            )

            // 创建连接管理�?
            XposedHelpers.newInstance(
                XposedHelpers.findClass(
                    "org.apache.http.impl.conn.SingleClientConnManager", lpparam.classLoader
                ), schemeRegistry
            )
        } catch (e: Throwable) {
            throw RuntimeException("Failed to create trust-all connection manager", e)
        }
    }

    private fun createTrustAllSSLFactory(): SSLSocketFactory {
        return try {
            val sslContext = SSLContext.getInstance("TLS")
            sslContext.init(null, arrayOf(getTrustManager()), null)
            sslContext.socketFactory
        } catch (e: Exception) {
            throw RuntimeException("Failed to create trust-all SSL factory", e)
        }
    }

    // ==================== 系统级核武器 Hook ====================
    private fun hookAndroidSecurityProvider() {
        try {
            // Android 7.0+ 的核弹级修复
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                XposedHelpers.findAndHookMethod(
                    "android.security.net.config.RootTrustManager",
                    lpparam.classLoader,
                    "checkServerTrusted",
                    Array<X509Certificate>::class.java,
                    String::class.java,
                    object : XC_MethodReplacement() {
                        override fun replaceHookedMethod(param: MethodHookParam): Any? {
                            LogX.e(TAG, "Bypassed RootTrustManager verification")
                            return null
                        }
                    })
            }

            // 通杀所�?Provider 实现
            XposedHelpers.findAndHookMethod(
                "java.security.Provider",
                lpparam.classLoader,
                "getService",
                String::class.java,
                String::class.java,
                object : XC_MethodHook() {
                    override fun afterHookedMethod(param: MethodHookParam) {
                        if ("CertPathValidator" == param.args[0] && "PKIX" == param.args[1]) {
                            // 替换为始终信任的验证�?
                            param.result = XposedHelpers.newInstance(
                                XposedHelpers.findClass(
                                    "sun.security.provider.certpath.PKIXCertPathValidator",
                                    lpparam.classLoader
                                )
                            )
                        }
                    }
                })
        } catch (e: Throwable) {
            LogX.e(TAG, "Hook Android Security Provider failed", e)
        }
    }

    private fun hookRootTrustManager() {
        try {
            XposedHelpers.findAndHookMethod(
                "com.android.org.conscrypt.TrustManagerImpl",
                lpparam.classLoader,
                "checkTrusted",
                Array<X509Certificate>::class.java,
                String::class.java,
                String::class.java,
                Boolean::class.java,
                Boolean::class.java,
                object : XC_MethodReplacement() {
                    override fun replaceHookedMethod(param: MethodHookParam): Any? {
                        LogX.e(TAG, "Bypassed Conscrypt TrustManager verification")
                        return null
                    }
                })
        } catch (e: Throwable) {
            LogX.e(TAG, "Conscrypt hook not available", e)
        }
    }

    private fun bypassCertPathValidation() {
        try {
            // 多重保险：同�?Hook 引擎方法和实现类
            XposedHelpers.findAndHookMethod(
                "java.security.cert.CertPathValidatorSpi",
                lpparam.classLoader,
                "engineValidate",
                CertPath::class.java,
                CertPathParameters::class.java,
                object : XC_MethodReplacement() {
                    override fun replaceHookedMethod(param: MethodHookParam): Any {
                        return XposedHelpers.newInstance(
                            XposedHelpers.findClass(
                                "java.security.cert.PKIXCertPathValidatorResult",
                                lpparam.classLoader
                            ), TrustAnchor(
                                X509Certificate::class.java.getDeclaredConstructor().newInstance(),
                                null
                            ), null, null
                        )
                    }
                })

            // 针对 Android 特定实现
            XposedHelpers.findAndHookMethod(
                "com.android.org.bouncycastle.jce.provider.PKIXCertPathValidatorSpi",
                lpparam.classLoader,
                "engineValidate",
                CertPath::class.java,
                CertPathParameters::class.java,
                object : XC_MethodReplacement() {
                    override fun replaceHookedMethod(param: MethodHookParam): Any {
                        return XposedHelpers.newInstance(
                            XposedHelpers.findClass(
                                "java.security.cert.PKIXCertPathValidatorResult",
                                lpparam.classLoader
                            ), TrustAnchor(
                                X509Certificate::class.java.getDeclaredConstructor().newInstance(),
                                null
                            ), null, null
                        )
                    }
                })
        } catch (e: Throwable) {
            LogX.e(TAG, "CertPathValidator hook failed", e)
        }
    }
}
