package com.vaibhav.kundli.ui.horoscope

import android.graphics.Color
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.vaibhav.kundli.databinding.ItemZodiacSignBinding

data class ZodiacSignItem(val name: String, val symbol: String, val isSelected: Boolean)

class ZodiacSignAdapter(private val onSignClick: (Int) -> Unit) :
    ListAdapter<ZodiacSignItem, ZodiacSignAdapter.ViewHolder>(DiffCallback()) {

    private var selectedIndex = 0

    fun setSelectedIndex(index: Int) {
        val old = selectedIndex
        selectedIndex = index
        notifyItemChanged(old)
        notifyItemChanged(index)
    }

    inner class ViewHolder(private val binding: ItemZodiacSignBinding) :
        RecyclerView.ViewHolder(binding.root) {
        fun bind(item: ZodiacSignItem, position: Int) {
            binding.tvSymbol.text = item.symbol
            binding.tvName.text = item.name
            val isSelected = position == selectedIndex
            binding.root.setBackgroundColor(
                if (isSelected) Color.parseColor("#FF6B0033") else Color.TRANSPARENT
            )
            binding.tvSymbol.setTextColor(
                if (isSelected) Color.parseColor("#FF6B00") else Color.parseColor("#FFD700")
            )
            binding.root.setOnClickListener { onSignClick(position) }
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ItemZodiacSignBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.bind(getItem(position), position)
    }

    private class DiffCallback : DiffUtil.ItemCallback<ZodiacSignItem>() {
        override fun areItemsTheSame(old: ZodiacSignItem, new: ZodiacSignItem) = old.name == new.name
        override fun areContentsTheSame(old: ZodiacSignItem, new: ZodiacSignItem) = old == new
    }
}
