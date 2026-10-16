package com.jsxposed.xmod.env

import android.content.Context
import android.content.Intent
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import java.io.File

data class AccountInfo(
    val username: String,
    val registeredAt: String = "",
    val lastSeen: String = "",
    val online: Boolean = false
)

class ServerManager private constructor() {

    companion object {
        @Volatile private var instance: ServerManager? = null
        fun get(): ServerManager =
            instance ?: synchronized(this) { instance ?: ServerManager().also { instance = it } }
    }

    private val gson = Gson()

    var process: Process? = null
        private set

    fun isRunning(): Boolean = process?.isAlive == true

    fun start(ctx: Context, onLine: (String) -> Unit): Process {
        if (isRunning()) throw IllegalStateException("服务器已在运行，请先停止")
        val em = EnvironmentManager.get()
        if (!em.isInstalled(ctx)) throw IllegalStateException("环境未安装，请先一键安装依赖")

        copyBuiltinAssets(ctx)

        val p = em.runDetached(
            ctx,
            "python3 /srv/builtin/user_server.py 2>&1",
            workdir = "/srv/data",
            onLine = onLine
        )
        process = p

        val svc = Intent(ctx, ServerService::class.java)
        ctx.startService(svc)
        return p
    }

    fun stop(ctx: Context) {
        try {
            process?.destroy()
            process?.waitFor()
        } catch (_: Exception) { }
        process = null
        val svc = Intent(ctx, ServerService::class.java)
        ctx.stopService(svc)
    }

    fun accounts(ctx: Context): List<AccountInfo> {
        val f = File(EnvironmentManager.get().serverDataDir(ctx), "accounts.json")
        if (!f.exists()) return emptyList()
        return try {
            val type = object : TypeToken<List<AccountInfo>>() {}.type
            gson.fromJson<List<AccountInfo>>(f.readText(), type) ?: emptyList()
        } catch (_: Exception) {
            emptyList()
        }
    }

    private fun copyBuiltinAssets(ctx: Context) {
        val em = EnvironmentManager.get()
        val dest = File(em.builtinDir(ctx), "user_server.py")
        dest.parentFile?.mkdirs()
        ctx.assets.open("pysrv/user_server.py").use { input ->
            dest.outputStream().use { output -> input.copyTo(output) }
        }
    }
}
