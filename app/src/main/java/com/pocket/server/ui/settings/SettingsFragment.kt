package com.pocket.server.ui.settings

import android.content.Intent
import android.graphics.Color
import android.net.Uri
import android.os.Bundle
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.pocket.server.BuildConfig
import com.pocket.server.MainActivity
import com.pocket.server.R
import com.pocket.server.ai.AiClient
import com.pocket.server.ai.AiConfig
import com.pocket.server.update.Release
import com.pocket.server.update.UpdateChecker
import com.pocket.server.util.Prefs
import kotlinx.coroutines.launch

class SettingsFragment : Fragment() {

    private val themeColors = intArrayOf(
        Color.parseColor("#673AB7"), Color.parseColor("#2196F3"), Color.parseColor("#009688"),
        Color.parseColor("#4CAF50"), Color.parseColor("#FF9800"), Color.parseColor("#F44336"),
        Color.parseColor("#E91E63"), Color.parseColor("#3F51B5")
    )
    private val colorNames = listOf("默认紫", "蓝", "青", "绿", "橙", "红", "粉", "靛蓝")

    private var releases: List<Release> = emptyList()

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        return inflater.inflate(R.layout.fragment_settings, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        buildColorRow(view.findViewById(R.id.color_row))

        val baseUrl = view.findViewById<EditText>(R.id.edit_base_url)
        val apiKey = view.findViewById<EditText>(R.id.edit_api_key)
        val model = view.findViewById<EditText>(R.id.edit_model)
        val repo = view.findViewById<EditText>(R.id.edit_repo)
        val token = view.findViewById<EditText>(R.id.edit_github_token)

        baseUrl.setText(Prefs.getStr(requireContext(), "ai_base_url"))
        apiKey.setText(Prefs.getStr(requireContext(), "ai_api_key"))
        model.setText(Prefs.getStr(requireContext(), "ai_model"))
        repo.setText(Prefs.getStr(requireContext(), "github_repo"))
        token.setText(Prefs.getStr(requireContext(), "github_token"))

        baseUrl.setOnFocusChangeListener { _, f -> if (!f) Prefs.putStr(requireContext(), "ai_base_url", baseUrl.text.toString().trim()) }
        apiKey.setOnFocusChangeListener { _, f -> if (!f) Prefs.putStr(requireContext(), "ai_api_key", apiKey.text.toString().trim()) }
        model.setOnFocusChangeListener { _, f -> if (!f) Prefs.putStr(requireContext(), "ai_model", model.text.toString().trim()) }
        repo.setOnFocusChangeListener { _, f -> if (!f) Prefs.putStr(requireContext(), "github_repo", repo.text.toString().trim()) }
        token.setOnFocusChangeListener { _, f -> if (!f) Prefs.putStr(requireContext(), "github_token", token.text.toString().trim()) }

        view.findViewById<View>(R.id.btn_pull_models).setOnClickListener { pullModels(model) }
        view.findViewById<View>(R.id.btn_test_model).setOnClickListener { testModel() }
        view.findViewById<View>(R.id.btn_check_update).setOnClickListener { checkUpdate() }
        view.findViewById<View>(R.id.btn_history).setOnClickListener { showHistory() }
        view.findViewById<View>(R.id.btn_about).setOnClickListener { showDoc("关于我们", "docs/about.txt") }
        view.findViewById<View>(R.id.btn_agreement).setOnClickListener { showDoc("用户须知协议", "docs/agreement_user.txt") }
        view.findViewById<View>(R.id.btn_license).setOnClickListener { showDoc("开源协议", "docs/license_open_source.txt") }

        view.findViewById<TextView>(R.id.text_version).text = "口袋服务器 PocketServer v${BuildConfig.VERSION_NAME}"
    }

    private fun buildColorRow(row: LinearLayout) {
        val current = Prefs.getInt(requireContext(), "theme_index", 0)
        themeColors.forEachIndexed { i, c ->
            val v = View(requireContext())
            val lp = LinearLayout.LayoutParams(64, 64)
            lp.marginEnd = 20
            v.layoutParams = lp
            v.background = android.graphics.drawable.GradientDrawable().apply {
                shape = android.graphics.drawable.GradientDrawable.OVAL
                setColor(c)
                if (i == current) setStroke(6, Color.WHITE)
            }
            v.setOnClickListener {
                (activity as? MainActivity)?.applyTheme(i)
            }
            row.addView(v)
        }
    }

    private fun aiClient(): AiClient = AiClient(
        AiConfig(
            baseUrl = Prefs.getStr(requireContext(), "ai_base_url"),
            apiKey = Prefs.getStr(requireContext(), "ai_api_key"),
            model = Prefs.getStr(requireContext(), "ai_model")
        )
    )

    private fun pullModels(modelEdit: EditText) {
        saveAiFields()
        lifecycleScope.launch {
            try {
                val models = aiClient().listModels()
                if (models.isEmpty()) throw IllegalStateException("服务商返回空列表")
                MaterialAlertDialogBuilder(requireContext())
                    .setTitle("选择模型（共 ${models.size} 个）")
                    .setItems(models.toTypedArray()) { _, which ->
                        modelEdit.setText(models[which])
                        Prefs.putStr(requireContext(), "ai_model", models[which])
                    }
                    .setNegativeButton("取消", null)
                    .show()
            } catch (e: Exception) {
                Toast.makeText(requireContext(), "拉取失败：${e.message}", Toast.LENGTH_LONG).show()
            }
        }
    }

    private fun testModel() {
        saveAiFields()
        lifecycleScope.launch {
            try {
                val reply = aiClient().test()
                MaterialAlertDialogBuilder(requireContext())
                    .setTitle("测试成功")
                    .setMessage("模型回复：$reply")
                    .setPositiveButton("好的", null)
                    .show()
            } catch (e: Exception) {
                MaterialAlertDialogBuilder(requireContext())
                    .setTitle("测试失败")
                    .setMessage(e.message ?: "未知错误")
                    .setPositiveButton("好的", null)
                    .show()
            }
        }
    }

    private fun saveAiFields() {
        val v = requireView()
        Prefs.putStr(requireContext(), "ai_base_url", v.findViewById<EditText>(R.id.edit_base_url).text.toString().trim())
        Prefs.putStr(requireContext(), "ai_api_key", v.findViewById<EditText>(R.id.edit_api_key).text.toString().trim())
        Prefs.putStr(requireContext(), "ai_model", v.findViewById<EditText>(R.id.edit_model).text.toString().trim())
        Prefs.putStr(requireContext(), "github_repo", v.findViewById<EditText>(R.id.edit_repo).text.toString().trim())
        Prefs.putStr(requireContext(), "github_token", v.findViewById<EditText>(R.id.edit_github_token).text.toString().trim())
    }

    private suspend fun loadReleases(): List<Release> {
        saveAiFields()
        return UpdateChecker.fetchReleases(
            Prefs.getStr(requireContext(), "github_repo"),
            Prefs.getStr(requireContext(), "github_token")
        )
    }

    private fun checkUpdate() {
        lifecycleScope.launch {
            try {
                releases = loadReleases()
                if (releases.isEmpty()) {
                    Toast.makeText(requireContext(), "仓库还没有发布版本", Toast.LENGTH_LONG).show()
                    return@launch
                }
                val latest = releases.first()
                if (UpdateChecker.isNewer(latest.tagName, BuildConfig.VERSION_NAME)) {
                    MaterialAlertDialogBuilder(requireContext())
                        .setTitle("发现新版本 ${latest.tagName}")
                        .setMessage("当前版本 v${BuildConfig.VERSION_NAME}\n\n${latest.body.take(500)}")
                        .setPositiveButton("下载 APK") { _, _ -> openUrl(latest.apkUrl ?: latest.htmlUrl) }
                        .setNegativeButton("关闭", null)
                        .show()
                } else {
                    Toast.makeText(requireContext(), "已是最新版本 v${BuildConfig.VERSION_NAME}", Toast.LENGTH_LONG).show()
                }
            } catch (e: Exception) {
                Toast.makeText(requireContext(), "检查更新失败：${e.message}", Toast.LENGTH_LONG).show()
            }
        }
    }

    private fun showHistory() {
        lifecycleScope.launch {
            try {
                releases = loadReleases()
                if (releases.isEmpty()) {
                    Toast.makeText(requireContext(), "仓库还没有发布版本", Toast.LENGTH_LONG).show()
                    return@launch
                }
                val rv = RecyclerView(requireContext())
                rv.layoutParams = ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, 900)
                rv.layoutManager = LinearLayoutManager(requireContext())
                rv.adapter = ReleaseAdapter(releases, onDownload = { r -> openUrl(r.apkUrl ?: r.htmlUrl) }, onOpen = { r -> openUrl(r.htmlUrl) })
                rv.setPadding(24, 8, 24, 8)
                MaterialAlertDialogBuilder(requireContext())
                    .setTitle("历史版本")
                    .setView(rv)
                    .setPositiveButton("关闭", null)
                    .show()
            } catch (e: Exception) {
                Toast.makeText(requireContext(), "获取历史版本失败：${e.message}", Toast.LENGTH_LONG).show()
            }
        }
    }

    private fun showDoc(title: String, assetPath: String) {
        val text = try {
            requireContext().assets.open(assetPath).bufferedReader().readText()
        } catch (e: Exception) {
            "文档缺失: $assetPath"
        }
        val tv = TextView(requireContext())
        tv.text = text
        tv.setPadding(48, 24, 48, 24)
        tv.textSize = 13f
        tv.movementMethod = android.text.method.ScrollingMovementMethod()
        val sv = ScrollView(requireContext())
        sv.addView(tv)
        MaterialAlertDialogBuilder(requireContext())
            .setTitle(title)
            .setView(sv)
            .setPositiveButton("关闭", null)
            .show()
    }

    private fun openUrl(url: String) {
        try {
            startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
        } catch (_: Exception) { }
    }
}
