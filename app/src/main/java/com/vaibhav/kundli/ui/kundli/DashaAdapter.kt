package com.vaibhav.kundli.ui.kundli

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.vaibhav.kundli.databinding.ItemDashaBinding
import com.vaibhav.kundli.domain.model.DashaPeriod
import com.vaibhav.kundli.util.formatDate

class DashaAdapter : ListAdapter<DashaPeriod, DashaAdapter.ViewHolder>(DiffCallback()) {

    inner class ViewHolder(private val binding: ItemDashaBinding) :
        RecyclerView.ViewHolder(binding.root) {
        fun bind(item: DashaPeriod) {
            binding.tvDashaLord.text = "${item.planet} Mahadasha"
            binding.tvDashaYears.text = "${item.years} years"
            binding.tvDashaStart.text = item.startDate.formatDate()
            binding.tvDashaEnd.text = item.endDate.formatDate()
            if (item.antarDashas.isNotEmpty()) {
                val current = item.antarDashas.firstOrNull { d ->
                    val now = System.currentTimeMillis()
                    d.startDate.time <= now && d.endDate.time >= now
                }
                binding.tvCurrentAntardasha.text = if (current != null)
                    "Current Antardasha: ${current.planet}" else ""
            }
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ItemDashaBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) = holder.bind(getItem(position))

    private class DiffCallback : DiffUtil.ItemCallback<DashaPeriod>() {
        override fun areItemsTheSame(old: DashaPeriod, new: DashaPeriod) = old.planet == new.planet
        override fun areContentsTheSame(old: DashaPeriod, new: DashaPeriod) = old == new
    }
}
