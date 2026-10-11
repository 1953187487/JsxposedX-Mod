package com.pocket.server.ui.ai

import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.pocket.server.R
import com.pocket.server.env.AccountInfo

class AccountAdapter(private val items: List<AccountInfo>) : RecyclerView.Adapter<AccountAdapter.VH>() {

    class VH(v: android.view.View) : RecyclerView.ViewHolder(v) {
        val dot: android.view.View = v.findViewById(R.id.dot_status)
        val name: TextView = v.findViewById(R.id.text_account_name)
        val status: TextView = v.findViewById(R.id.text_account_status)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VH {
        val v = LayoutInflater.from(parent.context).inflate(R.layout.item_account, parent, false)
        return VH(v)
    }

    override fun onBindViewHolder(h: VH, position: Int) {
        val a = items[position]
        h.name.text = a.username
        h.status.text = if (a.online) "在线" else "离线"
        h.dot.setBackgroundResource(if (a.online) R.color.dot_online else R.color.dot_offline)
    }

    override fun getItemCount() = items.size
}
