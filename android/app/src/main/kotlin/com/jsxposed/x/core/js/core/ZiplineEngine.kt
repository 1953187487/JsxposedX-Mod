package com.jsxposed.xmod.core.js.core

import android.util.Log
import com.jsxposed.xmod.core.utils.log.LogX
import com.whl.quickjs.wrapper.QuickJSContext
import com.whl.quickjs.android.QuickJSLoader
import java.util.concurrent.Callable
import java.util.concurrent.Executors

/**
 * Zipline/QuickJS 核心引擎，负责底层实例管理和线程调度
 */
class ZiplineEngine {
    private val executor = Executors.newSingleThreadExecutor { runnable ->
        Thread(runnable, "QuickJsThread")
    }
    
    private var quickJs: QuickJSContext? = null

    fun getOrCreate(onCreated: (QuickJSContext) -> Unit): QuickJSContext {
        return synchronized(this) {
            quickJs ?: run {
                try {
                    QuickJSLoader.init()
                } catch (e: Throwable) {
                    LogX.e("ZiplineEngine", "QuickJSLoader.init failed, but we already loaded the .so manually in AttachHooker:", Log.getStackTraceString(e))
                    // 强制通过反射设置初始化标志，绕过库内部的验证（因为在 Xposed 目标应用进程中 System.loadLibrary 会找不到库而抛异常，但我们在 AttachHooker 里已经通过绝对路径注入了 .so）
                    try {
                        val field = QuickJSLoader::class.java.getDeclaredField("sIsInit")
                        field.isAccessible = true
                        field.set(null, true)
                    } catch (t: Throwable) {
                        LogX.e("ZiplineEngine", "Reflection to set sIsInit failed: ${t.message}")
                    }
                }
                
                val qjs = QuickJSContext.create()
                onCreated(qjs)
                quickJs = qjs
                qjs
            }
        }
    }

    /**
     * 同步提交：阻塞当前线程直到任务完成
     */
    fun <T> submit(task: (QuickJSContext) -> T): T {
        if (Thread.currentThread().name == "QuickJsThread") {
            val q = getOrCreate {}
            return task(q)
        }
        
        val future = executor.submit(Callable {
            val q = getOrCreate {}
            task(q)
        })
        return future.get()
    }

    fun execute(task: (QuickJSContext) -> Unit) {
        if (Thread.currentThread().name == "QuickJsThread") {
            val q = getOrCreate {}
            task(q)
            return
        }
        executor.execute { 
            val q = getOrCreate {}
            task(q) 
        }
    }

    fun shutDown() {
        executor.execute { 
            quickJs?.destroy()
            quickJs = null 
        }
        executor.shutdown()
    }
}
