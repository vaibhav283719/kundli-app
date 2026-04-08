package com.vaibhav.kundli.ui.horoscope

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.lifecycleScope
import androidx.lifecycle.repeatOnLifecycle
import androidx.recyclerview.widget.LinearLayoutManager
import com.vaibhav.kundli.databinding.FragmentHoroscopeBinding
import com.vaibhav.kundli.domain.model.HoroscopeData
import com.vaibhav.kundli.domain.model.UiState
import com.vaibhav.kundli.util.Constants
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.launch

@AndroidEntryPoint
class HoroscopeFragment : Fragment() {

    private var _binding: FragmentHoroscopeBinding? = null
    private val binding get() = _binding!!
    private val viewModel: HoroscopeViewModel by viewModels()

    private val zodiacAdapter = ZodiacSignAdapter { index ->
        viewModel.selectSign(index)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        _binding = FragmentHoroscopeBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.rvZodiacSigns.apply {
            layoutManager = LinearLayoutManager(requireContext(), LinearLayoutManager.HORIZONTAL, false)
            adapter = zodiacAdapter
        }

        zodiacAdapter.submitList(Constants.ZODIAC_SIGNS.mapIndexed { i, sign ->
            ZodiacSignItem(sign, Constants.ZODIAC_SYMBOLS[i], i == 0)
        })

        viewLifecycleOwner.lifecycleScope.launch {
            viewLifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED) {
                viewModel.horoscopeState.collect { state ->
                    if (state is UiState.Success) bindHoroscope(state.data)
                }
            }
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewLifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED) {
                viewModel.selectedSignIndex.collect { index ->
                    zodiacAdapter.setSelectedIndex(index)
                    binding.rvZodiacSigns.smoothScrollToPosition(index)
                }
            }
        }
    }

    private fun bindHoroscope(data: HoroscopeData) {
        binding.tvSignName.text = "${data.zodiacSign} / ${data.zodiacSignHindi}"
        binding.tvSignSymbol.text = Constants.ZODIAC_SYMBOLS.getOrElse(
            Constants.ZODIAC_SIGNS.indexOf(data.zodiacSign)
        ) { "" }
        binding.tvPrediction.text = data.prediction
        binding.tvLove.text = data.love
        binding.tvCareer.text = data.career
        binding.tvHealth.text = data.health
        binding.tvFinance.text = data.finance
        binding.tvLuckyNumber.text = "Lucky Number: ${data.luckyNumber}"
        binding.tvLuckyColor.text = "Lucky Color: ${data.luckyColor}"
        binding.tvLuckyGem.text = "Lucky Gem: ${data.luckyGem}"
        binding.tvCompatible.text = "Compatible: ${data.compatibleSigns.joinToString(", ")}"

        val stars = "★".repeat(data.rating) + "☆".repeat(5 - data.rating)
        binding.tvRating.text = stars
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}
