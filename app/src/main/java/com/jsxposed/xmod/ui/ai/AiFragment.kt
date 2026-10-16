package com.jsxposed.xmod.ui.ai

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.jsxposed.xmod.R
import com.jsxposed.xmod.ai.AiClient
import com.jsxposed.xmod.ai.AiConfig
import com.jsxposed.xmod.env.ServerManager
import com.jsxposed.xmod.util.Prefs
import kotlinx.coroutines.launch

class AiFragment : Fragment() {

    private val sm get() = ServerManager.get()

    private val chat = mutableListOf<ChatMsg>()
    private lateinit var chatAdapter: ChatAdapter

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
            你是「JsxposedX-Mod」应用内置的 AI 助手。这是一个基于 JsxposedX 的 Xposed 辅助工具二改版本，无需 root、无需授权，仅依赖 Dhizuku 辅助权限即可完成模块注入。
            用户可能询问 Xposed 模块使用、Dhizuku 授权、目标进程 hook 等问题。回答使用中文，给出可执行的具体步骤。
        """.trimIndent()
    }
}
