package com.pocket.server.ui.settings

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.pocket.server.R
import com.pocket.server.update.Release

class ReleaseAdapter(
    private val items: List<Release>,
    private val onDownload: (Release) -> Unit,
    private val onOpen: (Release) -> Unit
) : RecyclerView.Adapter<ReleaseAdapter.VH>() {

    class VH(v: View) : RecyclerView.ViewHolder(v) {
        val name: TextView = v.findViewById(R.id.text_release_name)
        val meta: TextView = v.findViewById(R.id.text_release_meta)
        val body: TextView = v.findViewById(R.id.text_release_body)
        val btn: View = v.findViewById(R.id.btn_download)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VH {
        val v = LayoutInflater.from(parent.context).inflate(R.layout.item_release, parent, false)
        return VH(v)
    }

    override fun onBindViewHolder(h: VH, position: Int) {
        val r = items[position]
        h.name.text = if (r.name.isBlank()) r.tagName else r.name
        h.meta.text = "${r.tagName} · ${r.publishedAt.take(10)}"
        h.body.text = r.body.ifBlank { "（无更新说明）" }
        h.btn.isEnabled = r.apkUrl != null
        h.btn.setOnClickListener { r.apkUrl?.let { onDownload(r) } }
        h.itemView.setOnLongClickListener { onOpen(r); true }
    }

    override fun getItemCount() = items.size
}
