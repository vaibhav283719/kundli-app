package com.vaibhav.kundli.ui.auth

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
import com.vaibhav.kundli.databinding.FragmentForgotPasswordBinding
import com.vaibhav.kundli.domain.model.UiState
import com.vaibhav.kundli.util.showToast
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.launch

@AndroidEntryPoint
class ForgotPasswordFragment : Fragment() {

    private var _binding: FragmentForgotPasswordBinding? = null
    private val binding get() = _binding!!
    private val viewModel: AuthViewModel by viewModels()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        _binding = FragmentForgotPasswordBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.btnSendReset.setOnClickListener {
            val email = binding.etEmail.text.toString().trim()
            if (email.isEmpty()) {
                binding.etEmail.error = "Email is required"
                return@setOnClickListener
            }
            if (!android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches()) {
                binding.etEmail.error = "Invalid email format"
                return@setOnClickListener
            }
            viewModel.forgotPassword(email)
        }

        binding.tvBackToLogin.setOnClickListener {
            findNavController().navigateUp()
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewLifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED) {
                viewModel.authState.collect { state ->
                    when (state) {
                        is UiState.Loading -> {
                            binding.progressBar.isVisible = true
                            binding.btnSendReset.isEnabled = false
                        }
                        is UiState.Success -> {
                            binding.progressBar.isVisible = false
                            binding.btnSendReset.isEnabled = true
                            showToast("Password reset email sent successfully")
                            findNavController().navigateUp()
                        }
                        is UiState.Error -> {
                            binding.progressBar.isVisible = false
                            binding.btnSendReset.isEnabled = true
                            showToast(state.message)
                            viewModel.resetState()
                        }
                        else -> {
                            binding.progressBar.isVisible = false
                            binding.btnSendReset.isEnabled = true
                        }
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
