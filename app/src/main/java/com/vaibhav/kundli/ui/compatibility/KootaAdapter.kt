package com.vaibhav.kundli.ui.compatibility

import android.graphics.Color
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.vaibhav.kundli.databinding.ItemKootaBinding
import com.vaibhav.kundli.domain.model.KootaResult

class KootaAdapter : ListAdapter<KootaResult, KootaAdapter.ViewHolder>(DiffCallback()) {

    inner class ViewHolder(private val binding: ItemKootaBinding) :
        RecyclerView.ViewHolder(binding.root) {
        fun bind(item: KootaResult) {
            binding.tvKootaName.text = item.name
            binding.tvScore.text = "${item.obtainedPoints} / ${item.maxPoints}"
            binding.tvDescription.text = item.description
            binding.progressBar.max = item.maxPoints
            binding.progressBar.progress = item.obtainedPoints
            val color = if (item.isCompatible) "#00C853" else "#D32F2F"
            binding.tvScore.setTextColor(Color.parseColor(color))
            binding.tvCompatible.text = if (item.isCompatible) "✓ Compatible" else "✗ Incompatible"
            binding.tvCompatible.setTextColor(Color.parseColor(color))
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ItemKootaBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) = holder.bind(getItem(position))

    private class DiffCallback : DiffUtil.ItemCallback<KootaResult>() {
        override fun areItemsTheSame(old: KootaResult, new: KootaResult) = old.name == new.name
        override fun areContentsTheSame(old: KootaResult, new: KootaResult) = old == new
    }
}
