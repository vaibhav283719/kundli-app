package com.vaibhav.kundli.ui.kundli

import android.graphics.Color
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.vaibhav.kundli.databinding.ItemYogaBinding
import com.vaibhav.kundli.domain.model.KundliYoga

class YogaAdapter : ListAdapter<KundliYoga, YogaAdapter.ViewHolder>(DiffCallback()) {

    inner class ViewHolder(private val binding: ItemYogaBinding) :
        RecyclerView.ViewHolder(binding.root) {
        fun bind(item: KundliYoga) {
            binding.tvYogaName.text = item.name
            binding.tvYogaDescription.text = item.description
            binding.tvPlanetsInvolved.text = "Planets: ${item.involvedPlanets.joinToString(", ")}"
            if (item.isPresent) {
                binding.tvStatus.text = "✓ Present in Chart"
                binding.tvStatus.setTextColor(Color.parseColor("#00C853"))
                binding.cardRoot.alpha = 1f
            } else {
                binding.tvStatus.text = "✗ Not Present"
                binding.tvStatus.setTextColor(Color.parseColor("#757575"))
                binding.cardRoot.alpha = 0.6f
            }
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ItemYogaBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) = holder.bind(getItem(position))

    private class DiffCallback : DiffUtil.ItemCallback<KundliYoga>() {
        override fun areItemsTheSame(old: KundliYoga, new: KundliYoga) = old.name == new.name
        override fun areContentsTheSame(old: KundliYoga, new: KundliYoga) = old == new
    }
}
