package com.vaibhav.kundli.ui.kundli

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.lifecycleScope
import androidx.lifecycle.repeatOnLifecycle
import androidx.navigation.fragment.navArgs
import com.google.android.material.tabs.TabLayout
import com.vaibhav.kundli.databinding.FragmentKundliChartBinding
import com.vaibhav.kundli.domain.model.KundliChart
import com.vaibhav.kundli.domain.model.UiState
import com.vaibhav.kundli.util.Constants
import com.vaibhav.kundli.util.formatDate
import com.vaibhav.kundli.util.showToast
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.launch

@AndroidEntryPoint
class KundliChartFragment : Fragment() {

    private var _binding: FragmentKundliChartBinding? = null
    private val binding get() = _binding!!
    private val viewModel: KundliViewModel by viewModels()
    private val args: KundliChartFragmentArgs by navArgs()

    private val planetAdapter = KundliChartAdapter()
    private val dashaAdapter = DashaAdapter()
    private val yogaAdapter = YogaAdapter()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        _binding = FragmentKundliChartBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        val kundliId = args.kundliId
        if (kundliId.isNotEmpty()) {
            viewModel.loadKundliById(kundliId)
        }

        binding.rvPlanets.adapter = planetAdapter
        binding.rvDasha.adapter = dashaAdapter
        binding.rvYogas.adapter = yogaAdapter

        setupTabs()
        observeState()
    }

    private fun setupTabs() {
        binding.tabLayout.addOnTabSelectedListener(object : TabLayout.OnTabSelectedListener {
            override fun onTabSelected(tab: TabLayout.Tab?) {
                when (tab?.position) {
                    0 -> showPlanetsView()
                    1 -> showDashaView()
                    2 -> showYogasView()
                }
            }
            override fun onTabUnselected(tab: TabLayout.Tab?) {}
            override fun onTabReselected(tab: TabLayout.Tab?) {}
        })
    }

    private fun showPlanetsView() {
        binding.chartContainer.isVisible = true
        binding.rvPlanets.isVisible = true
        binding.rvDasha.isVisible = false
        binding.rvYogas.isVisible = false
    }

    private fun showDashaView() {
        binding.chartContainer.isVisible = false
        binding.rvPlanets.isVisible = false
        binding.rvDasha.isVisible = true
        binding.rvYogas.isVisible = false
    }

    private fun showYogasView() {
        binding.chartContainer.isVisible = false
        binding.rvPlanets.isVisible = false
        binding.rvDasha.isVisible = false
        binding.rvYogas.isVisible = true
    }

    private fun observeState() {
        viewLifecycleOwner.lifecycleScope.launch {
            viewLifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED) {
                viewModel.kundliState.collect { state ->
                    when (state) {
                        is UiState.Loading -> binding.progressBar.isVisible = true
                        is UiState.Success -> {
                            binding.progressBar.isVisible = false
                            bindChart(state.data)
                        }
                        is UiState.Error -> {
                            binding.progressBar.isVisible = false
                            showToast(state.message)
                        }
                        else -> binding.progressBar.isVisible = false
                    }
                }
            }
        }
    }

    private fun bindChart(chart: KundliChart) {
        binding.tvPersonName.text = chart.birthDetails.name
        binding.tvBirthInfo.text = buildString {
            append(chart.birthDetails.dateOfBirth.formatDate())
            append(" • ")
            append(chart.birthDetails.placeOfBirth)
        }
        val lagnaRashiName = Constants.ZODIAC_SIGNS.getOrElse(chart.lagnaRashi) { "" }
        binding.tvLagna.text = "Lagna: $lagnaRashiName ${Constants.ZODIAC_SYMBOLS.getOrElse(chart.lagnaRashi) { "" }}"

        // Set up chart view
        binding.kundliChartView.planets = chart.planetPositions
        binding.kundliChartView.lagnaRashi = chart.lagnaRashi

        planetAdapter.submitList(chart.planetPositions)
        dashaAdapter.submitList(chart.dashas)
        yogaAdapter.submitList(chart.yogas)

        showPlanetsView()
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}
