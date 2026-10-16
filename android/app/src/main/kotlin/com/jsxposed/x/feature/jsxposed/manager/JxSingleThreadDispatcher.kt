package com.jsxposed.xmod.feature.jsxposed.manager

import java.util.concurrent.Callable
import java.util.concurrent.Executors

class JxSingleThreadDispatcher(
    private val threadName: String
) {
    private val executor = Executors.newSingleThreadExecutor { runnable ->
        Thread(runnable, threadName).apply {
            isDaemon = true
        }
    }

    fun <T> submit(task: () -> T): T {
        if (Thread.currentThread().name == threadName) {
            return task()
        }

        return executor.submit(Callable { task() }).get()
    }

    fun execute(task: () -> Unit) {
        if (Thread.currentThread().name == threadName) {
            task()
            return
        }

        executor.execute(task)
    }
}
