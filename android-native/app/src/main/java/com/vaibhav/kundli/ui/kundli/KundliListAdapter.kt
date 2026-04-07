package com.vaibhav.kundli.ui.kundli

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.vaibhav.kundli.databinding.ItemKundliCardBinding
import com.vaibhav.kundli.domain.model.KundliChart
import com.vaibhav.kundli.util.Constants
import com.vaibhav.kundli.util.formatDate

class KundliListAdapter(
    private val onItemClick: (KundliChart) -> Unit,
    private val onDeleteClick: (KundliChart) -> Unit
) : ListAdapter<KundliChart, KundliListAdapter.ViewHolder>(DiffCallback()) {

    inner class ViewHolder(private val binding: ItemKundliCardBinding) :
        RecyclerView.ViewHolder(binding.root) {
        fun bind(item: KundliChart) {
            binding.tvName.text = item.birthDetails.name
            binding.tvDob.text = item.birthDetails.dateOfBirth.formatDate()
            binding.tvPlace.text = item.birthDetails.placeOfBirth
            val lagnaName = Constants.ZODIAC_SIGNS.getOrElse(item.lagnaRashi) { "" }
            binding.tvLagna.text = "Lagna: $lagnaName ${Constants.ZODIAC_SYMBOLS.getOrElse(item.lagnaRashi) { "" }}"
            binding.root.setOnClickListener { onItemClick(item) }
            binding.btnDelete.setOnClickListener { onDeleteClick(item) }
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ItemKundliCardBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) = holder.bind(getItem(position))

    private class DiffCallback : DiffUtil.ItemCallback<KundliChart>() {
        override fun areItemsTheSame(old: KundliChart, new: KundliChart) = old.id == new.id
        override fun areContentsTheSame(old: KundliChart, new: KundliChart) = old == new
    }
}
