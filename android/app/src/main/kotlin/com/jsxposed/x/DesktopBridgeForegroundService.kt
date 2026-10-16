package com.jsxposed.xmod

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import com.jsxposed.xmod.bridge.NativeConsoleCenter
import com.jsxposed.xmod.bridge.NativeLogHistory
import com.jsxposed.xmod.bridge.NativeShellSession
import com.jsxposed.xmod.bridge.NativeWebSocketServer
import com.jsxposed.xmod.core.bridge.pinia_native.Pinia
import com.jsxposed.xmod.core.bridge.project_native.Project
import com.jsxposed.xmod.core.bridge.status_management_native.StatusManagement
import com.jsxposed.xmod.core.utils.ApkUtils
import java.util.concurrent.TimeUnit

/**
 * 前台服务：托管原生 WebSocket 服务器，保持桌面端连接。
 * 所有项目/脚本/状态数据均在 Kotlin 原生层处理，不依赖 FlutterEngine，
 * 应用被划掉后进程仍能响应桌面端的脚本数据操作。
 */
class DesktopBridgeForegroundService : Service() {

    companion object {
        private const val TAG = "DesktopBridgeService"
        private const val CHANNEL_ID = "desktop_bridge"
        private const val NOTIFICATION_ID = 1001

        private const val SOURCE_FRIDA = "frida"
        private const val SOURCE_XPOSED = "xposed"
    }

    private var webSocketServer: NativeWebSocketServer? = null
    private var statusManagement: StatusManagement? = null
    private var project: Project? = null
    private var pinia: Pinia? = null
    // 纯原生后台能力中心：console / log / shell，不依赖 Flutter 引擎
    private var consoleCenter: NativeConsoleCenter? = null
    private var logHistory: NativeLogHistory? = null
    private var shellSession: NativeShellSession? = null

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "Service onCreate")
        val appContext = applicationContext
        statusManagement = StatusManagement(appContext)
        project = Project(appContext)
        pinia = Pinia(appContext)
        // 原生后台能力：broadcast 委托给 WebSocket 服务器（可能尚未启动，回调动态取值）
        logHistory = NativeLogHistory(appContext)
        shellSession = NativeShellSession { event, payload -> webSocketServer?.broadcast(event, payload) }
        consoleCenter = NativeConsoleCenter { event, payload -> webSocketServer?.broadcast(event, payload) }
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "Service onStartCommand")

        val notification = createNotification()
        startForeground(NOTIFICATION_ID, notification)

        startWebSocketServer()

        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        super.onDestroy()
        Log.d(TAG, "Service onDestroy")
        consoleCenter?.destroy()
        shellSession?.close()
        webSocketServer?.stopServer()
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        super.onTaskRemoved(rootIntent)
        Log.d(TAG, "Task removed, service continues")
    }

    private fun startWebSocketServer() {
        Log.d(TAG, "Starting WebSocket server")
        try {
            val server = NativeWebSocketServer(
                port = 8765,
                deviceInfo = getDeviceInfo(),
                requestHandler = { request ->
                    handleBridgeRequest(request)
                }
            )
            webSocketServer = server
            server.startServer()
            Log.i(TAG, "WebSocket server started on port 8765")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to start WebSocket server", e)
        }
    }

    private fun handleBridgeRequest(request: Map<String, Any?>): Map<String, Any?> {
        val method = request["method"] as? String ?: request["action"] as? String ?: "unknown"
        val params = request["params"] as? Map<String, Any?>
        Log.d(TAG, "Handling bridge request: $method")

        return try {
            when (method) {
                "device.get_info" -> success(getDeviceInfo())
                "device.get_capabilities" -> success(getCapabilities())
                "device.get_health" -> success(
                    mapOf(
                        "status" to "ready",
                        "connectedClients" to 1,
                        "timestamp" to nowIso(),
                    )
                )
                "device.subscribe_events" -> success(mapOf("subscribed" to true))
                "request.cancel" -> success(mapOf("cancelled" to (params?.get("requestId") ?: "")))

                "status.is_hook" -> success(mapOf("isHook" to (statusManagement?.isHook() ?: false)))
                "status.is_root" -> success(
                    mapOf(
                        "isRoot" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            statusManagement?.isRoot() ?: false
                        } else false,
                    )
                )
                "status.is_frida" -> {
                    val frida = statusManagement?.isFrida()
                    success(mapOf("status" to (frida?.status ?: false), "type" to (frida?.type ?: -1)))
                }

                "project.list" -> listProjects()
                "script.list" -> listScripts(params)
                "script.read" -> readScript(params)
                "script.write" -> writeScript(params)
                "script.delete" -> deleteScript(params)
                "script.toggle" -> toggleScript(params)
                "script.get_enabled" -> getScriptEnabled(params)

                "shell.exec" -> shellExec(params)

                // 脚本运行：纯原生打开目标应用，后台也能执行
                "script.run" -> runScript(params)

                // console / log / shell 全部纯原生实现，划掉应用后依旧可用
                "console.start" -> {
                    val cc = consoleCenter ?: return fail("INTERNAL_ERROR", "Console center not ready")
                    success(cc.start(requireString(params, "packageName")))
                }
                "console.stop" -> success(consoleCenter?.stop() ?: mapOf("stopped" to true))
                "console.get_state" -> success(consoleCenter?.getState() ?: emptyConsoleState())
                "console.set_paused" -> success(consoleCenter?.setPaused(requireBool(params, "paused")) ?: emptyConsoleState())
                "console.set_autoscroll" -> success(consoleCenter?.setAutoScroll(requireBool(params, "autoScroll")) ?: emptyConsoleState())
                "console.set_search" -> success(consoleCenter?.setSearch(params?.get("query") as? String ?: "") ?: emptyConsoleState())
                "console.set_level" -> success(consoleCenter?.setLevel(params?.get("level") as? String ?: "V") ?: emptyConsoleState())
                "console.set_source" -> success(consoleCenter?.setSource(params?.get("source") as? String ?: "") ?: emptyConsoleState())
                "console.clear" -> success(consoleCenter?.clear() ?: mapOf("cleared" to true))

                "log.query" -> {
                    val lh = logHistory ?: return fail("INTERNAL_ERROR", "Log history not ready")
                    success(lh.query(params))
                }
                "log.delete_history" -> success(logHistory?.deleteHistory(params) ?: mapOf("deleted" to true))

                "shell.open" -> success(shellSession?.open(params?.get("useSu") as? Boolean ?: true) ?: mapOf("opened" to false))
                "shell.write" -> success(shellSession?.write(requireString(params, "data")) ?: mapOf("written" to 0))
                "shell.close" -> success(shellSession?.close() ?: mapOf("closed" to true))

                else -> fail("CAPABILITY_UNAVAILABLE", "Unsupported method: $method")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to handle request $method", e)
            fail("INTERNAL_ERROR", e.message ?: "Unknown error")
        }
    }

    // ---------- 项目 / 脚本 ----------

    /** 纯原生打开目标应用：xposed 注入的 js 在目标进程启动时由 hook 加载，frida 由 zygisk 注入。
     *  开启 restartApp 时需要先 kill 目标应用再启动，让钩子重新生效。
     */
    private fun runScript(params: Map<String, Any?>?): Map<String, Any?> {
        val packageName = requireString(params, "packageName")
        val source = requireSource(params)
        val restartApp = params?.get("restartApp") as? Boolean ?: true
        Log.d(TAG, "Run script: opening target app $packageName (source=$source, restartApp=$restartApp)")
        
        // 开启 restartApp 时需要重启目标应用
        if (restartApp) {
            try {
                // 先 kill 目标应用（让新的钩子生效）
                val killResult = com.jsxposed.xmod.core.utils.shell.Shell(su = true).execute("killall -9 $packageName")
                if (!killResult.startsWith("ERROR")) {
                    Log.d(TAG, "Killed target app: $packageName")
                    // 等待进程完全退出
                    Thread.sleep(500)
                } else {
                    Log.w(TAG, "Kill failed (app might not be running): $killResult")
                }
            } catch (e: Exception) {
                Log.w(TAG, "Kill failed: ${e.message}")
            }
        }
        
        ApkUtils.openAppX(applicationContext, packageName)
        return success(mapOf("opened" to true, "packageName" to packageName))
    }

    private fun listProjects(): Map<String, Any?> {
        val projects = project?.getProjects() ?: emptyList()
        return success(
            mapOf(
                "projects" to projects.map { appInfo ->
                    buildMap<String, Any?> {
                        put("packageName", appInfo.packageName)
                        put("name", appInfo.name)
                        put("versionName", appInfo.versionName)
                        put("versionCode", appInfo.versionCode)
                        if (appInfo.icon != null && appInfo.icon.isNotEmpty()) {
                            put("iconUrl", "data:image/png;base64,${android.util.Base64.encodeToString(appInfo.icon, android.util.Base64.NO_WRAP)}")
                        }
                    }
                },
            )
        )
    }

    private fun listScripts(params: Map<String, Any?>?): Map<String, Any?> {
        val packageName = requireString(params, "packageName")
        val source = requireSource(params)
        val p = project ?: throw IllegalStateException("Project not ready")
        val paths = if (source == SOURCE_FRIDA) p.getFridaScripts(packageName) else p.getJsScripts(packageName)
        val scripts = paths.map { path ->
            val key = scriptStatusKey(packageName, source, path)
            mapOf(
                "localPath" to path,
                "name" to displayName(path, source),
                "enabled" to getScriptEnabled(key),
            )
        }
        return success(mapOf("packageName" to packageName, "source" to source, "scripts" to scripts))
    }

    private fun readScript(params: Map<String, Any?>?): Map<String, Any?> {
        val packageName = requireString(params, "packageName")
        val source = requireSource(params)
        val localPath = requireString(params, "localPath")
        val p = project ?: throw IllegalStateException("Project not ready")
        val found = findScriptPath(scriptPaths(p, packageName, source), localPath)
            ?: throw IllegalArgumentException("Script not found: $localPath")
        val content = if (source == SOURCE_FRIDA) {
            p.readFridaScript(packageName, fileName(found))
        } else {
            p.readJsScript(packageName, fileName(found))
        }
        return success(mapOf("packageName" to packageName, "source" to source, "localPath" to found, "content" to content))
    }

    private fun writeScript(params: Map<String, Any?>?): Map<String, Any?> {
        val packageName = requireString(params, "packageName")
        val source = requireSource(params)
        val localPath = requireString(params, "localPath")
        val content = requireString(params, "content")
        val p = project ?: throw IllegalStateException("Project not ready")
        // 已存在的脚本沿用设备真实路径，否则视为新建，取文件名
        val target = findScriptPath(scriptPaths(p, packageName, source), localPath) ?: localPath
        val name = fileName(target)
        if (source == SOURCE_FRIDA) {
            p.createFridaScript(packageName, content, name, false)
            p.bundleFridaHookJs(packageName)
        } else {
            p.createJsScript(packageName, content, name, false)
        }
        return success(mapOf("packageName" to packageName, "source" to source, "localPath" to target))
    }

    private fun deleteScript(params: Map<String, Any?>?): Map<String, Any?> {
        val packageName = requireString(params, "packageName")
        val source = requireSource(params)
        val localPath = requireString(params, "localPath")
        val p = project ?: throw IllegalStateException("Project not ready")
        val found = findScriptPath(scriptPaths(p, packageName, source), localPath)
            ?: throw IllegalArgumentException("Script not found: $localPath")
        if (source == SOURCE_FRIDA) {
            p.deleteFridaScript(packageName, fileName(found))
        } else {
            p.deleteJsScript(packageName, fileName(found))
        }
        pinia?.remove(space = "pinia", key = scriptStatusKey(packageName, source, found))
        return success(mapOf("deleted" to true))
    }

    private fun toggleScript(params: Map<String, Any?>?): Map<String, Any?> {
        val packageName = requireString(params, "packageName")
        val source = requireSource(params)
        val localPath = requireString(params, "localPath")
        val enabled = params?.get("enabled") as? Boolean
            ?: throw IllegalArgumentException("Missing required bool parameter: enabled")
        val p = project ?: throw IllegalStateException("Project not ready")
        // 与 Dart 保持一致：按文件名匹配设备真实完整路径，作为启停键的一部分
        val found = findScriptPath(scriptPaths(p, packageName, source), localPath) ?: localPath
        Log.d(TAG, "Toggle script: pkg=$packageName src=$source path=$found enabled=$enabled")
        pinia?.setValue(space = "pinia", key = scriptStatusKey(packageName, source, found), value = enabled)
        if (source == SOURCE_FRIDA) {
            project?.bundleFridaHookJs(packageName)
        }
        return success(mapOf("enabled" to enabled))
    }

    private fun getScriptEnabled(params: Map<String, Any?>?): Map<String, Any?> {
        val packageName = requireString(params, "packageName")
        val source = requireSource(params)
        val localPath = requireString(params, "localPath")
        val p = project ?: throw IllegalStateException("Project not ready")
        // 与 listScripts 一致：按文件名匹配设备真实完整路径再读启停键
        val found = findScriptPath(scriptPaths(p, packageName, source), localPath) ?: localPath
        val enabled = getScriptEnabled(scriptStatusKey(packageName, source, found))
        return success(mapOf("packageName" to packageName, "source" to source, "localPath" to found, "enabled" to enabled))
    }

    private fun scriptStatusKey(packageName: String, source: String, localPath: String): String {
        val prefix = if (source == SOURCE_FRIDA) "frida_check_status" else "xposed_check_status"
        return "${prefix}_${packageName}_$localPath"
    }

    private fun getScriptEnabled(key: String): Boolean {
        return try {
            pinia?.getValue<Boolean>(space = "pinia", key = key, defaultValue = false) ?: false
        } catch (e: Exception) {
            Log.w(TAG, "Failed to read script status $key", e)
            false
        }
    }

    // ---------- shell ----------

    private fun shellExec(params: Map<String, Any?>?): Map<String, Any?> {
        val command = requireString(params, "command")
        val useSu = params?.get("useSu") as? Boolean ?: true
        return try {
            val process = Runtime.getRuntime().exec(if (useSu) arrayOf("su", "-c", command) else arrayOf("sh", "-c", command))
            val finished = process.waitFor(100, TimeUnit.SECONDS)
            if (finished) {
                val stdout = process.inputStream.bufferedReader().readText()
                val stderr = process.errorStream.bufferedReader().readText()
                success(mapOf("exitCode" to process.exitValue(), "stdout" to stdout, "stderr" to stderr))
            } else {
                process.destroy()
                fail("INTERNAL_ERROR", "Shell command timed out")
            }
        } catch (e: Exception) {
            success(mapOf("exitCode" to -1, "stdout" to "", "stderr" to (e.message ?: "")))
        }
    }

    // ---------- 能力 / 设备信息 ----------

    private fun getCapabilities(): Map<String, Any?> {
        val isHook = statusManagement?.isHook() ?: false
        val isRoot = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            statusManagement?.isRoot() ?: false
        } else false
        val frida = statusManagement?.isFrida()
        val fridaReady = frida?.status ?: false
        val fridaType = frida?.type?.toInt() ?: -1
        return success(
            mapOf(
                "deviceId" to getDeviceInfo()["deviceId"],
                "protocolVersion" to "1.0",
                "platform" to "android",
                "capabilities" to mapOf(
                    "xposed" to mapOf("available" to isHook, "framework" to (if (isHook) "LSPosed" else null)),
                    "frida" to mapOf(
                        "available" to fridaReady,
                        "installed" to (fridaType >= 0),
                        "mode" to (if (fridaType == 1) "zygisk" else null),
                        "state" to when (fridaType) {
                            1 -> "ready"
                            0 -> "installed"
                            else -> "unavailable"
                        },
                    ),
                    "root" to isRoot,
                    "memory" to isRoot,
                    "shell" to isRoot,
                    "screenshot" to true,
                ),
            )
        )
    }

    private fun getDeviceInfo(): Map<String, Any> {
        return mapOf(
            "deviceId" to android.provider.Settings.Secure.getString(
                contentResolver,
                android.provider.Settings.Secure.ANDROID_ID
            ),
            "platform" to "android",
            "androidApi" to android.os.Build.VERSION.SDK_INT,
            "androidVersion" to android.os.Build.VERSION.RELEASE,
            "abi" to (android.os.Build.SUPPORTED_ABIS.firstOrNull() ?: "unknown"),
            "model" to android.os.Build.MODEL,
            "manufacturer" to android.os.Build.MANUFACTURER
        )
    }

    // ---------- 工具 ----------

    private fun success(data: Map<String, Any?>): Map<String, Any?> = mapOf("success" to true, "data" to data)

    private fun fail(code: String, message: String): Map<String, Any?> =
        mapOf("success" to false, "error" to mapOf("errorCode" to code, "errorMessage" to message))

    private fun requireString(params: Map<String, Any?>?, key: String): String {
        val value = params?.get(key)
        if (value is String && value.isNotEmpty()) return value
        throw IllegalArgumentException("Missing required string parameter: $key")
    }

    private fun requireBool(params: Map<String, Any?>?, key: String): Boolean {
        val value = params?.get(key) as? Boolean
            ?: throw IllegalArgumentException("Missing required bool parameter: $key")
        return value
    }

    /** console 未初始化时的默认状态，与 desktop_console_service.dart 的 getState 键对齐。 */
    private fun emptyConsoleState(): Map<String, Any?> = mapOf(
        "isRunning" to false,
        "isStarting" to false,
        "isPaused" to false,
        "autoScroll" to true,
        "searchQuery" to "",
        "sessionId" to "",
        "sessionConversationId" to "",
        "targetPackage" to "",
        "entryCount" to 0,
    )


    private fun requireSource(params: Map<String, Any?>?): String {
        val source = requireString(params, "source")
        if (source != SOURCE_FRIDA && source != SOURCE_XPOSED) {
            throw IllegalArgumentException("Unsupported script source: $source")
        }
        return source
    }

    private fun scriptPaths(p: Project, packageName: String, source: String): List<String> =
        if (source == SOURCE_FRIDA) p.getFridaScripts(packageName) else p.getJsScripts(packageName)

    private fun findScriptPath(paths: List<String>, localPath: String): String? =
        paths.firstOrNull { fileName(it) == fileName(localPath) }

    private fun fileName(path: String): String = path.substringAfterLast('/')

    private fun displayName(path: String, source: String): String {
        val name = fileName(path)
        if (source != SOURCE_XPOSED) return name
        // 与 Dart PathUtils 保持一致：移除 [visual]/[tradition] 前缀
        return name.replace(Regex("\\[.*?]"), "")
    }

    private fun nowIso(): String {
        val fmt = java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", java.util.Locale.US)
        fmt.timeZone = java.util.TimeZone.getTimeZone("UTC")
        return fmt.format(java.util.Date())
    }

    // ---------- 通知 ----------

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "桌面桥接服务",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "保持与桌面端的连接"
                setShowBadge(false)
            }
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {
        val intent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("JsxposedX 桥接服务")
            .setContentText("桌面端连接保持中")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setOngoing(true)
            .setContentIntent(pendingIntent)
            .build()
    }
}
