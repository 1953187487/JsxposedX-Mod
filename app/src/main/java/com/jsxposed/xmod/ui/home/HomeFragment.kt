package com.jsxposed.xmod.ui.home

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.google.android.material.progressindicator.LinearProgressIndicator
import com.jsxposed.xmod.R
import com.jsxposed.xmod.env.EnvironmentManager
import com.jsxposed.xmod.env.ServerManager
import com.jsxposed.xmod.util.Prefs
import kotlinx.coroutines.launch

class HomeFragment : Fragment() {

    private val em get() = EnvironmentManager.get()
    private val sm get() = ServerManager.get()

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        return inflater.inflate(R.layout.fragment_home, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        val statusText = view.findViewById<TextView>(R.id.text_env_status)
        val detailText = view.findViewById<TextView>(R.id.text_env_detail)
        val progress = view.findViewById<LinearProgressIndicator>(R.id.progress_install)
        val progressText = view.findViewById<TextView>(R.id.text_progress)
        val console = view.findViewById<TextView>(R.id.text_console)
        val btnInstall = view.findViewById<View>(R.id.btn_install)
        val btnStart = view.findViewById<View>(R.id.btn_start_server)
        val btnStop = view.findViewById<View>(R.id.btn_stop)

        em.state.observe(viewLifecycleOwner) { st ->
            statusText.text = when (st) {
                EnvironmentManager.State.NOT_INSTALLED -> getString(R.string.env_status_not_installed)
                EnvironmentManager.State.INSTALLING -> getString(R.string.env_status_installing)
                EnvironmentManager.State.READY -> getString(R.string.env_status_ready)
                EnvironmentManager.State.RUNNING -> getString(R.string.env_status_running)
            }
            val installing = st == EnvironmentManager.State.INSTALLING
            btnInstall.isEnabled = !installing
            btnStart.isEnabled = !installing && st != EnvironmentManager.State.RUNNING
            btnStop.isEnabled = st == EnvironmentManager.State.RUNNING
            detailText.text = if (em.isInstalled(requireContext()))
                "proot + Alpine Linux(${em.alpineVersion(requireContext())}) · 架构 ${em.arch()}"
            else
                "proot 用户态 Linux · Alpine 根文件系统 · 就绪后即可开启服务器功能"
        }

        em.log.observe(viewLifecycleOwner) { t ->
            console.text = t
            (console.parent as? android.widget.ScrollView)?.scrollTo(0, console.height)
        }

        em.progress.observe(viewLifecycleOwner) { p ->
            if (p == null) {
                progress.visibility = View.GONE
                progressText.visibility = View.GONE
            } else {
                progress.visibility = View.VISIBLE
                progressText.visibility = View.VISIBLE
                progress.setProgressCompat(p.first, true)
                progressText.text = "${p.second} (${p.first}%)"
            }
        }

        btnInstall.setOnClickListener {
            MaterialAlertDialogBuilder(requireContext())
                .setTitle("安装依赖")
                .setMessage("将下载 proot 运行环境与 Alpine Linux 根文件系统并自动安装基础依赖（约 10~60MB，取决于网络），是否继续？")
                .setPositiveButton("安装") { _, _ -> startInstall() }
                .setNegativeButton("稍后", null)
                .show()
        }

        btnStart.setOnClickListener {
            try {
                sm.start(requireContext()) { line -> em.appendLog(requireContext(), "[server] $line") }
                em.state.postValue(EnvironmentManager.State.RUNNING)
                em.appendLog(requireContext(), "[server] 用户系统服务包已启动，日志见下方")
            } catch (e: Exception) {
                Toast.makeText(requireContext(), e.message, Toast.LENGTH_LONG).show()
            }
        }

        btnStop.setOnClickListener {
            sm.stop(requireContext())
            em.state.postValue(EnvironmentManager.State.READY)
            em.appendLog(requireContext(), "[server] 服务器已停止")
        }

        em.refreshState(requireContext())
        maybeFirstRunDialog()
    }

    private fun startInstall() {
        lifecycleScope.launch {
            try {
                em.install(requireContext())
            } catch (e: Exception) {
                Toast.makeText(requireContext(), "安装失败：${e.message}", Toast.LENGTH_LONG).show()
            }
        }
    }

    private fun maybeFirstRunDialog() {
        if (!Prefs.getBool(requireContext(), "asked_install", false) && !em.isInstalled(requireContext())) {
            Prefs.putBool(requireContext(), "asked_install", true)
            MaterialAlertDialogBuilder(requireContext())
                .setTitle("欢迎使用JsxposedX-Mod")
                .setMessage("检测到尚未安装运行环境。\n\n是否立即一键安装依赖？（proot + Alpine Linux + 基础工具，安装完成后即可把手机用作软件服务器 / 游戏服务器）")
                .setPositiveButton("立即安装") { _, _ -> startInstall() }
                .setNegativeButton("稍后", null)
                .show()
        }
    }
}
