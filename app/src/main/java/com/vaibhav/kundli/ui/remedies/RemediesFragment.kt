package com.vaibhav.kundli.ui.remedies

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.lifecycleScope
import androidx.lifecycle.repeatOnLifecycle
import com.google.android.material.chip.Chip
import com.vaibhav.kundli.databinding.FragmentRemediesBinding
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.launch

@AndroidEntryPoint
class RemediesFragment : Fragment() {

    private var _binding: FragmentRemediesBinding? = null
    private val binding get() = _binding!!
    private val viewModel: RemediesViewModel by viewModels()
    private val adapter = RemedyAdapter()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        _binding = FragmentRemediesBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.rvRemedies.adapter = adapter
        setupChips()

        viewLifecycleOwner.lifecycleScope.launch {
            viewLifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED) {
                viewModel.remedies.collect { remedies ->
                    adapter.submitList(remedies)
                }
            }
        }
    }

    private fun setupChips() {
        viewModel.categories.forEach { category ->
            val chip = Chip(requireContext()).apply {
                text = category
                isCheckable = true
                isChecked = category == "All"
                setOnClickListener {
                    viewModel.selectCategory(category)
                    updateChipSelection(category)
                }
            }
            binding.chipGroup.addView(chip)
        }
    }

    private fun updateChipSelection(selectedCategory: String) {
        for (i in 0 until binding.chipGroup.childCount) {
            val chip = binding.chipGroup.getChildAt(i) as? Chip
            chip?.isChecked = chip?.text == selectedCategory
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}
