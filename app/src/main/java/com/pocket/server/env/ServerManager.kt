package com.pocket.server.env

import android.content.Context
import android.content.Intent
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import java.io.File

data class ServerPack(
    val id: String,
    val name: String,
    val desc: String,
    val builtin: Boolean,
    val dir: File?
)

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

    var currentPack: ServerPack? = null
        private set

    fun isRunning(): Boolean = process?.isAlive == true

    fun packs(ctx: Context): List<ServerPack> {
        val list = mutableListOf(
            ServerPack("builtin", "用户系统服务包（内置）", "注册/登录/在线心跳/账户列表 API + 软件包静态托管，端口 8080", true, null)
        )
        val dir = EnvironmentManager.get().serverPackDir(ctx)
        dir.listFiles { f -> f.isDirectory && File(f, "start.sh").exists() }?.sortedBy { it.name }?.forEach {
            val descFile = File(it, "pack.json")
            var desc = "自定义服务包，入口 start.sh"
            if (descFile.exists()) {
                try {
                    val o = gson.fromJson(descFile.readText(), Map::class.java)
                    desc = (o["desc"] as? String) ?: desc
                } catch (_: Exception) { }
            }
            list.add(ServerPack(it.name, it.name, desc, false, it))
        }
        return list
    }

    fun start(ctx: Context, pack: ServerPack, onLine: (String) -> Unit): Process {
        if (isRunning()) throw IllegalStateException("服务器已在运行，请先停止")
        val em = EnvironmentManager.get()
        if (!em.isInstalled(ctx)) throw IllegalStateException("环境未安装，请先一键安装依赖")

        copyBuiltinAssets(ctx)

        val p = if (pack.builtin) {
            em.runDetached(
                ctx,
                "python3 /srv/builtin/user_server.py 2>&1",
                workdir = "/srv/data",
                onLine = onLine
            )
        } else {
            val hostDir = pack.dir ?: throw IllegalStateException("服务包目录不存在")
            em.runDetached(
                ctx,
                "sh /srv/pack/start.sh 2>&1",
                workdir = "/srv/pack",
                extraBinds = listOf(hostDir.absolutePath to "/srv/pack"),
                onLine = onLine
            )
        }
        process = p
        currentPack = pack

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
        currentPack = null
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
        copyAsset(ctx, "pysrv/user_server.py", File(em.builtinDir(ctx), "user_server.py"))
    }

    fun copyAsset(ctx: Context, assetPath: String, dest: File) {
        dest.parentFile?.mkdirs()
        ctx.assets.open(assetPath).use { input ->
            dest.outputStream().use { output -> input.copyTo(output) }
        }
    }
}
