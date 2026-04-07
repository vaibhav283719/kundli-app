package com.vaibhav.kundli.ui.compatibility

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import androidx.core.view.isVisible
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.lifecycleScope
import androidx.lifecycle.repeatOnLifecycle
import com.vaibhav.kundli.databinding.FragmentCompatibilityBinding
import com.vaibhav.kundli.domain.model.UiState
import com.vaibhav.kundli.util.Constants
import com.vaibhav.kundli.util.showToast
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.launch

@AndroidEntryPoint
class CompatibilityFragment : Fragment() {

    private var _binding: FragmentCompatibilityBinding? = null
    private val binding get() = _binding!!
    private val viewModel: CompatibilityViewModel by viewModels()
    private val kootaAdapter = KootaAdapter()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        _binding = FragmentCompatibilityBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        setupSpinners()
        binding.rvKootas.adapter = kootaAdapter

        binding.btnCalculate.setOnClickListener {
            val name1 = binding.etPerson1Name.text.toString().trim()
            val name2 = binding.etPerson2Name.text.toString().trim()
            val nak1 = binding.spinnerNakshatra1.selectedItemPosition
            val nak2 = binding.spinnerNakshatra2.selectedItemPosition

            if (name1.isEmpty()) { binding.etPerson1Name.error = "Required"; return@setOnClickListener }
            if (name2.isEmpty()) { binding.etPerson2Name.error = "Required"; return@setOnClickListener }

            viewModel.calculate(name1, nak1, name2, nak2)
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewLifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED) {
                viewModel.compatibilityState.collect { state ->
                    when (state) {
                        is UiState.Loading -> {
                            binding.progressBar.isVisible = true
                            binding.resultsCard.isVisible = false
                        }
                        is UiState.Success -> {
                            binding.progressBar.isVisible = false
                            val result = state.data
                            val total = viewModel.getTotalScore(result)
                            val max = viewModel.getMaxScore()
                            binding.resultsCard.isVisible = true
                            binding.tvTotalScore.text = "$total / $max"
                            binding.tvCompatibilityLevel.text = when {
                                total >= 28 -> "Excellent Match 💚"
                                total >= 21 -> "Good Match 💛"
                                total >= 14 -> "Average Match 🧡"
                                else -> "Poor Match ❤"
                            }
                            kootaAdapter.submitList(result.kootaResults)
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

    private fun setupSpinners() {
        val nakshatraList = Constants.NAKSHATRAS.mapIndexed { i, n -> "${i+1}. $n" }
        val adapter1 = ArrayAdapter(requireContext(), android.R.layout.simple_spinner_item, nakshatraList)
        adapter1.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        binding.spinnerNakshatra1.adapter = adapter1

        val adapter2 = ArrayAdapter(requireContext(), android.R.layout.simple_spinner_item, nakshatraList)
        adapter2.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        binding.spinnerNakshatra2.adapter = adapter2
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}
