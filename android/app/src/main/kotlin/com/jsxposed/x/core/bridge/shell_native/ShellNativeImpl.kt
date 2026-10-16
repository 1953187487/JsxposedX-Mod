package com.jsxposed.xmod.core.bridge.shell_native

import android.content.Context
import com.jsxposed.xmod.core.utils.shell.Shell
import java.util.concurrent.FutureTask
import java.util.concurrent.TimeUnit

class ShellNativeImpl(context: Context) : ShellNative {

    override fun executeShell(
        command: String,
        useSu: Boolean,
        timeoutSeconds: Long,
        callback: (Result<ShellResult>) -> Unit
    ) {
        try {
            val result = executeWithTimeout(command, useSu, timeoutSeconds.toInt())
            callback(Result.success(result))
        } catch (e: Exception) {
            callback(Result.success(ShellResult(
                exitCode = -1,
                stdout = "",
                stderr = "EXCEPTION: ${e.message}"
            )))
        }
    }

    private fun executeWithTimeout(command: String, useSu: Boolean, timeoutSeconds: Int): ShellResult {
        val task = FutureTask {
            val shell = Shell(su = useSu)
            val raw = shell.execute(command)

            val exitCode: Long
            val stdout: String
            val stderr: String

            if (raw.startsWith("ERROR(")) {
                val codeEnd = raw.indexOf(')')
                exitCode = raw.substring(6, codeEnd).toLongOrNull() ?: -1
                stderr = if (raw.length > codeEnd + 1) raw.substring(codeEnd + 2).trim() else ""
                stdout = ""
            } else if (raw.startsWith("EXCEPTION:")) {
                exitCode = -1
                stdout = ""
                stderr = raw.removePrefix("EXCEPTION:").trim()
            } else {
                exitCode = 0
                stdout = raw
                stderr = ""
            }

            ShellResult(exitCode, stdout, stderr)
        }

        val thread = Thread(task)
        thread.start()

        return try {
            task.get(timeoutSeconds.toLong(), TimeUnit.SECONDS)
        } catch (e: java.util.concurrent.TimeoutException) {
            thread.interrupt()
            ShellResult(
                exitCode = -1,
                stdout = "",
                stderr = "TIMEOUT: command exceeded ${timeoutSeconds}s limit"
            )
        }
    }
}