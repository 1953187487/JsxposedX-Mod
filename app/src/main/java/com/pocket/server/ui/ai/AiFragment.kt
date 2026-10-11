package com.pocket.server.ui.ai

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.provider.OpenableColumns
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.pocket.server.R
import com.pocket.server.ai.AiClient
import com.pocket.server.ai.AiConfig
import com.pocket.server.env.EnvironmentManager
import com.pocket.server.env.ServerManager
import com.pocket.server.util.ApkAnalyzer
import com.pocket.server.util.Prefs
import kotlinx.coroutines.launch
import java.io.File

class AiFragment : Fragment() {

    private val em get() = EnvironmentManager.get()
    private val sm get() = ServerManager.get()

    private val chat = mutableListOf<ChatMsg>()
    private lateinit var chatAdapter: ChatAdapter
    private var pickedApkName: String? = null

    private val pickApk = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { r ->
        if (r.resultCode == Activity.RESULT_OK) r.data?.data?.let { importApk(it) }
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        return inflater.inflate(R.layout.fragment_ai, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        val rvAccounts = view.findViewById<RecyclerView>(R.id.rv_accounts)
        rvAccounts.layoutManager = LinearLayoutManager(requireContext())
        rvAccounts.adapter = AccountAdapter(emptyList())

        val rvChat = view.findViewById<RecyclerView>(R.id.rv_chat)
        rvChat.layoutManager = LinearLayoutManager(requireContext())
        chatAdapter = ChatAdapter(chat)
        rvChat.adapter = chatAdapter

        val edit = view.findViewById<EditText>(R.id.edit_message)
        view.findViewById<View>(R.id.btn_send).setOnClickListener {
            val text = edit.text.toString().trim()
            if (text.isEmpty()) return@setOnClickListener
            edit.setText("")
            sendToAi(text)
        }

        view.findViewById<View>(R.id.btn_refresh_accounts).setOnClickListener { refreshAccounts() }
        view.findViewById<View>(R.id.btn_pick_apk).setOnClickListener { openApkPicker() }
        view.findViewById<View>(R.id.btn_install_toolchain).setOnClickListener { installToolchain() }
        view.findViewById<View>(R.id.btn_analyze_server).setOnClickListener { analyzeServer() }
        view.findViewById<View>(R.id.btn_unpack_ai).setOnClickListener { unpackWithAi() }
        view.findViewById<View>(R.id.btn_onlinize).setOnClickListener { onlinizeFlow() }

        refreshAccounts()
    }

    private fun refreshAccounts() {
        val accounts = sm.accounts(requireContext())
        val rv = requireView().findViewById<RecyclerView>(R.id.rv_accounts)
        rv.adapter = AccountAdapter(accounts)
        val hint = requireView().findViewById<TextView>(R.id.text_accounts_hint)
        hint.text = when {
            !sm.isRunning() -> "提示：启动服务器功能后，这里显示注册账户与在线状态（当前服务器未运行）"
            accounts.isEmpty() -> "服务器运行中，暂无注册账户（客户端调用 /api/register 注册）"
            else -> "共 ${accounts.size} 个账户，其中 ${accounts.count { it.online }} 个在线"
        }
    }

    private fun openApkPicker() {
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "*/*"
            putExtra(Intent.EXTRA_MIME_TYPES, arrayOf("application/vnd.android.package-archive", "application/zip", "application/octet-stream"))
        }
        pickApk.launch(intent)
    }

    private fun importApk(uri: Uri) {
        try {
            var name = "imported.apk"
            requireContext().contentResolver.query(uri, null, null, null, null)?.use { c ->
                val idx = c.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                if (idx >= 0 && c.moveToFirst()) name = c.getString(idx) ?: name
            }
            if (!name.endsWith(".apk", true)) name += ".apk"
            val dest = File(em.apkDir(requireContext()), name)
            requireContext().contentResolver.openInputStream(uri)?.use { input ->
                dest.outputStream().use { output -> input.copyTo(output) }
            }
            pickedApkName = name
            Prefs.putStr(requireContext(), "last_apk", name)
            Toast.makeText(requireContext(), "已导入工作区: $name", Toast.LENGTH_SHORT).show()
            em.appendLog(requireContext(), "[apk] 导入 $name")
            em.appendLog(requireContext(), ApkAnalyzer.basicInfo(dest))
        } catch (e: Exception) {
            Toast.makeText(requireContext(), "导入失败: ${e.message}", Toast.LENGTH_LONG).show()
        }
    }

    private fun lastApk(): File? {
        val name = pickedApkName ?: Prefs.getStr(requireContext(), "last_apk")
        if (name.isBlank()) return null
        val f = File(em.apkDir(requireContext()), name)
        return if (f.exists()) f else null
    }

    private fun envPathOf(hostFile: File): String =
        "/root/workspace/" + hostFile.relativeTo(em.workspaceDir(requireContext())).path

    private fun requireToolchain(onReady: () -> Unit) {
        if (!em.isInstalled(requireContext())) {
            Toast.makeText(requireContext(), "请先在主页一键安装依赖", Toast.LENGTH_LONG).show()
            return
        }
        lifecycleScope.launch {
            try {
                val out = em.runCapture(requireContext(), "(test -f /srv/tools/apktool.jar && command -v java >/dev/null && echo READY) || echo NO")
                if (out.contains("READY")) onReady()
                else Toast.makeText(requireContext(), "请先安装 APK 工具链", Toast.LENGTH_LONG).show()
            } catch (e: Exception) {
                Toast.makeText(requireContext(), "工具链检测失败：${e.message}", Toast.LENGTH_LONG).show()
            }
        }
    }

    private fun installToolchain() {
        if (!em.isInstalled(requireContext())) {
            Toast.makeText(requireContext(), "请先在主页一键安装依赖", Toast.LENGTH_LONG).show()
            return
        }
        sm.copyAsset(requireContext(), "scripts/install_toolchain.sh", File(em.toolsDir(requireContext()), "install_toolchain.sh"))
        sm.copyAsset(requireContext(), "tools/apksigner.jar", File(em.toolsDir(requireContext()), "apksigner.jar"))
        lifecycleScope.launch {
            try {
                em.runCapture(
                    requireContext(),
                    "sh /srv/tools/install_toolchain.sh",
                    streamLog = { em.appendLog(requireContext(), it) }
                )
                em.appendLog(requireContext(), "[toolchain] 安装完成")
            } catch (e: Exception) {
                em.appendLog(requireContext(), "[toolchain] 失败: ${e.message}")
                Toast.makeText(requireContext(), "工具链安装失败", Toast.LENGTH_LONG).show()
            }
        }
    }

    private fun unpackWithAi() {
        requireToolchain {
            val apk = lastApk() ?: run {
                Toast.makeText(requireContext(), "请先选择 APK", Toast.LENGTH_LONG).show()
                return@requireToolchain
            }
            lifecycleScope.launch {
                try {
                    em.appendLog(requireContext(), "[unpack] apktool 解包 ${apk.name}（大量解包进行中）…")
                    em.runCapture(
                        requireContext(),
                        "rm -rf /tmp/proj && java -jar /srv/tools/apktool.jar d -f -o /tmp/proj '${envPathOf(apk)}'",
                        streamLog = { em.appendLog(requireContext(), it) }
                    )
                    val proj = File(em.rootfsDir(requireContext()), "tmp/proj")
                    val summary = ApkAnalyzer.summarizeProject(proj)
                    em.appendLog(requireContext(), "[unpack] 解包完成，结构摘要：\n$summary")
                    sendToAi(
                        "我刚用 apktool 解包了一个安卓 APK，以下是结构与静态分析结果，请分析它的架构、联网与服务器交互方式，并给出把它改造成联机版 / 接入自建服务器的思路（smali 层面要动哪些点）：\n\n$summary"
                    )
                } catch (e: Exception) {
                    em.appendLog(requireContext(), "[unpack] 失败: ${e.message}")
                    Toast.makeText(requireContext(), "解包失败", Toast.LENGTH_LONG).show()
                }
            }
        }
    }

    private fun analyzeServer() {
        val accounts = sm.accounts(requireContext())
        val snap = buildString {
            appendLine("服务器运行中: ${sm.isRunning()}")
            appendLine("当前服务包: ${sm.currentPack?.name ?: "无"}")
            appendLine("注册账户数: ${accounts.size}")
            accounts.forEach { appendLine("- ${it.username} 在线=${it.online} 注册于=${it.registeredAt} 最近活跃=${it.lastSeen}") }
            val logText = em.log.value ?: ""
            appendLine("最近日志：\n${logText.lines().takeLast(20).joinToString("\n")}")
        }
        sendToAi("请分析当前口袋服务器的运行状态并给出建议：\n\n$snap")
    }

    private fun onlinizeFlow() {
        requireToolchain {
            val apks = em.apkDir(requireContext()).listFiles { f -> f.extension == "apk" }?.sortedByDescending { it.lastModified() } ?: emptyList()
            if (apks.isEmpty()) {
                Toast.makeText(requireContext(), "请先选择 APK", Toast.LENGTH_LONG).show()
                return@requireToolchain
            }
            val packs = em.onlinePackDir(requireContext()).listFiles { f -> f.extension == "zip" }?.sortedByDescending { it.lastModified() } ?: emptyList()
            if (packs.isEmpty()) {
                Toast.makeText(requireContext(), "请先把联机补丁包（zip，内部为要覆盖替换的相对路径文件）放入工作区 onlinepack 目录", Toast.LENGTH_LONG).show()
                return@requireToolchain
            }
            MaterialAlertDialogBuilder(requireContext())
                .setTitle("选择要联机化的 APK")
                .setItems(apks.map { it.name }.toTypedArray()) { _, ai ->
                    MaterialAlertDialogBuilder(requireContext())
                        .setTitle("选择联机补丁包（将覆盖替换文件）")
                        .setItems(packs.map { it.name }.toTypedArray()) { _, pi ->
                            runOnlinize(apks[ai], packs[pi])
                        }
                        .setNegativeButton("取消", null)
                        .show()
                }
                .setNegativeButton("取消", null)
                .show()
        }
    }

    private fun runOnlinize(apk: File, patch: File) {
        sm.copyAsset(requireContext(), "scripts/onlinize.sh", File(em.toolsDir(requireContext()), "onlinize.sh"))
        sm.copyAsset(requireContext(), "tools/apksigner.jar", File(em.toolsDir(requireContext()), "apksigner.jar"))
        val base = apk.name.removeSuffix(".apk")
        lifecycleScope.launch {
            try {
                em.appendLog(requireContext(), "[onlinize] 开始：${apk.name} + ${patch.name}")
                em.runCapture(
                    requireContext(),
                    "sh /srv/tools/onlinize.sh '${envPathOf(apk)}' '${envPathOf(patch)}' '${base}-online.apk'",
                    streamLog = { em.appendLog(requireContext(), it) }
                )
                val out = File(em.outputDir(requireContext()), "${base}-online.apk")
                em.appendLog(requireContext(), "[onlinize] 联机版已输出: ${out.absolutePath}")
                MaterialAlertDialogBuilder(requireContext())
                    .setTitle("联机化完成")
                    .setMessage("已重建并签名联机版 APK：\n${out.absolutePath}\n\n所有文件已按补丁包覆盖替换，服务器联机文件已替换完成。")
                    .setPositiveButton("安装") { _, _ -> installApk(out) }
                    .setNegativeButton("关闭", null)
                    .show()
            } catch (e: Exception) {
                em.appendLog(requireContext(), "[onlinize] 失败: ${e.message}")
                Toast.makeText(requireContext(), "联机化失败", Toast.LENGTH_LONG).show()
            }
        }
    }

    private fun installApk(f: File) {
        try {
            val uri = androidx.core.content.FileProvider.getUriForFile(
                requireContext(), "${requireContext().packageName}.fileprovider", f
            )
            val i = Intent(Intent.ACTION_VIEW).setDataAndType(uri, "application/vnd.android.package-archive")
                .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(i)
        } catch (e: Exception) {
            Toast.makeText(requireContext(), "无法安装: ${e.message}", Toast.LENGTH_LONG).show()
        }
    }

    private fun aiClient(): AiClient {
        val cfg = AiConfig(
            baseUrl = Prefs.getStr(requireContext(), "ai_base_url"),
            apiKey = Prefs.getStr(requireContext(), "ai_api_key"),
            model = Prefs.getStr(requireContext(), "ai_model")
        )
        return AiClient(cfg)
    }

    private fun sendToAi(content: String) {
        chatAdapter.add(ChatMsg("user", content))
        lifecycleScope.launch {
            try {
                val client = aiClient()
                val history = chat.filter { it.role != "sys" }.takeLast(12).map {
                    mapOf("role" to (if (it.role == "user") "user" else "assistant"), "content" to it.text)
                }.toMutableList()
                if (history.none { it["role"] == "system" }) {
                    history.add(0, mapOf("role" to "system", "content" to SYSTEM_PROMPT))
                }
                val reply = client.chat(history)
                chatAdapter.add(ChatMsg("ai", reply))
            } catch (e: Exception) {
                chatAdapter.add(ChatMsg("ai", "请求失败：${e.message}\n\n请到「设置」配置 AI 服务商（地址 / Key / 模型）。"))
            }
        }
    }

    companion object {
        val SYSTEM_PROMPT = """
            你是「口袋服务器」应用内置的 AI 助手。这是一个把安卓手机变成软件服务器与游戏服务器的工具：
            - 环境基于 proot + Alpine Linux，可用 apk 安装依赖（python3、openjdk17 等）
            - 服务器功能支持内置用户系统服务包与工作区自定义服务包（start.sh）
            - APK 工具链：apktool（解包/回编译 smali）、jadx（转 Java 源码）、apksigner（签名）
            用户可能让你分析服务器状态、注册账户、APK 解包结果，或规划把单机软件/游戏改造成接入自建服务器的联机版。回答使用中文，给出可执行的具体步骤。
        """.trimIndent()
    }
}
