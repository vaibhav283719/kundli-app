package com.vaibhav.kundli.ui.kundli

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.vaibhav.kundli.databinding.ItemPlanetPositionBinding
import com.vaibhav.kundli.domain.model.PlanetPosition
import com.vaibhav.kundli.util.Constants
import com.vaibhav.kundli.util.toDegreesMinutesSeconds

class KundliChartAdapter : ListAdapter<PlanetPosition, KundliChartAdapter.ViewHolder>(DiffCallback()) {

    inner class ViewHolder(private val binding: ItemPlanetPositionBinding) :
        RecyclerView.ViewHolder(binding.root) {

        fun bind(item: PlanetPosition) {
            binding.tvPlanetName.text = item.planet
            binding.tvPlanetHindi.text = Constants.PLANETS_HINDI.getOrElse(
                Constants.PLANETS.indexOf(item.planet)
            ) { item.planet }
            val rashi = Constants.ZODIAC_SIGNS.getOrElse(item.rashi) { "Unknown" }
            val nakshatra = Constants.NAKSHATRAS.getOrElse(item.nakshatra) { "Unknown" }
            binding.tvRashi.text = "$rashi ${Constants.ZODIAC_SYMBOLS.getOrElse(item.rashi) { "" }}"
            binding.tvNakshatra.text = "$nakshatra (Pada ${item.nakshatraPada})"
            binding.tvHouse.text = "House ${item.house}"
            binding.tvLongitude.text = item.rashiDegree.toDegreesMinutesSeconds()

            val tags = buildList {
                if (item.isRetrograde) add("R")
                if (item.isCombust) add("C")
                if (item.isExalted) add("Ex")
                if (item.isDebilitated) add("Deb")
            }
            binding.tvTags.text = tags.joinToString(" ")
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ItemPlanetPositionBinding.inflate(
            LayoutInflater.from(parent.context), parent, false
        )
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.bind(getItem(position))
    }

    private class DiffCallback : DiffUtil.ItemCallback<PlanetPosition>() {
        override fun areItemsTheSame(old: PlanetPosition, new: PlanetPosition) =
            old.planet == new.planet
        override fun areContentsTheSame(old: PlanetPosition, new: PlanetPosition) = old == new
    }
}
