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
import androidx.navigation.fragment.findNavController
import com.vaibhav.kundli.R
import com.vaibhav.kundli.databinding.FragmentKundliListBinding
import com.vaibhav.kundli.domain.model.UiState
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.launch

@AndroidEntryPoint
class KundliListFragment : Fragment() {

    private var _binding: FragmentKundliListBinding? = null
    private val binding get() = _binding!!
    private val viewModel: KundliViewModel by viewModels()

    private val adapter by lazy {
        KundliListAdapter(
            onItemClick = { chart ->
                val action = KundliListFragmentDirections
                    .actionKundliListFragmentToKundliChartFragment(kundliId = chart.id)
                findNavController().navigate(action)
            },
            onDeleteClick = { chart ->
                viewModel.deleteKundli(chart.id)
            }
        )
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        _binding = FragmentKundliListBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.rvKundlis.adapter = adapter

        binding.fabNewKundli.setOnClickListener {
            findNavController().navigate(R.id.action_kundliListFragment_to_birthDetailsFragment)
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewLifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED) {
                viewModel.kundliList.collect { state ->
                    when (state) {
                        is UiState.Loading -> binding.progressBar.isVisible = true
                        is UiState.Success -> {
                            binding.progressBar.isVisible = false
                            adapter.submitList(state.data)
                            binding.tvEmpty.isVisible = state.data.isEmpty()
                        }
                        is UiState.Error -> binding.progressBar.isVisible = false
                        else -> binding.progressBar.isVisible = false
                    }
                }
            }
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}
