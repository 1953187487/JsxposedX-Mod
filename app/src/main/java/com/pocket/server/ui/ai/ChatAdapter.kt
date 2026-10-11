package com.pocket.server.ui.ai

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.pocket.server.R

data class ChatMsg(val role: String, val text: String)

class ChatAdapter(private val items: MutableList<ChatMsg>) : RecyclerView.Adapter<ChatAdapter.VH>() {

    class VH(v: View, isUser: Boolean) : RecyclerView.ViewHolder(v) {
        val text: TextView = v.findViewById(R.id.text_message)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VH {
        val layout = if (viewType == 0) R.layout.item_chat_user else R.layout.item_chat_ai
        return VH(LayoutInflater.from(parent.context).inflate(layout, parent, false), viewType == 0)
    }

    override fun getItemViewType(position: Int) = if (items[position].role == "user") 0 else 1

    override fun onBindViewHolder(h: VH, position: Int) {
        h.text.text = items[position].text
    }

    override fun getItemCount() = items.size

    fun add(m: ChatMsg) {
        items.add(m)
        notifyItemInserted(items.size - 1)
    }
}
