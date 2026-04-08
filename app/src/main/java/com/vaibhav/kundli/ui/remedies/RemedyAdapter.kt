package com.vaibhav.kundli.ui.remedies

import android.graphics.Color
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.vaibhav.kundli.databinding.ItemRemedyBinding
import com.vaibhav.kundli.domain.model.Remedy

class RemedyAdapter : ListAdapter<Remedy, RemedyAdapter.ViewHolder>(DiffCallback()) {

    inner class ViewHolder(private val binding: ItemRemedyBinding) :
        RecyclerView.ViewHolder(binding.root) {
        fun bind(item: Remedy) {
            binding.tvTitle.text = item.title
            binding.tvDescription.text = item.description
            binding.tvPlanet.text = item.planet
            binding.tvCategory.text = item.category
            binding.tvDifficulty.text = item.difficulty
            val difficultyColor = when (item.difficulty) {
                "Easy" -> "#00C853"
                "Medium" -> "#FFD700"
                "Hard" -> "#D32F2F"
                else -> "#FFFFFF"
            }
            binding.tvDifficulty.setTextColor(Color.parseColor(difficultyColor))
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ItemRemedyBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) = holder.bind(getItem(position))

    private class DiffCallback : DiffUtil.ItemCallback<Remedy>() {
        override fun areItemsTheSame(old: Remedy, new: Remedy) = old.id == new.id
        override fun areContentsTheSame(old: Remedy, new: Remedy) = old == new
    }
}
