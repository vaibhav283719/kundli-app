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
import com.vaibhav.kundli.R
import com.vaibhav.kundli.databinding.FragmentRegisterBinding
import com.vaibhav.kundli.domain.model.UiState
import com.vaibhav.kundli.util.showToast
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.launch

@AndroidEntryPoint
class RegisterFragment : Fragment() {

    private var _binding: FragmentRegisterBinding? = null
    private val binding get() = _binding!!
    private val viewModel: AuthViewModel by viewModels()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        _binding = FragmentRegisterBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.btnRegister.setOnClickListener {
            val name = binding.etName.text.toString().trim()
            val email = binding.etEmail.text.toString().trim()
            val password = binding.etPassword.text.toString()
            val confirmPassword = binding.etConfirmPassword.text.toString()

            if (validateInputs(name, email, password, confirmPassword)) {
                viewModel.register(name, email, password)
            }
        }

        binding.tvLogin.setOnClickListener {
            findNavController().navigateUp()
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewLifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED) {
                viewModel.authState.collect { state ->
                    when (state) {
                        is UiState.Loading -> {
                            binding.progressBar.isVisible = true
                            binding.btnRegister.isEnabled = false
                        }
                        is UiState.Success -> {
                            binding.progressBar.isVisible = false
                            binding.btnRegister.isEnabled = true
                            findNavController().navigate(R.id.action_registerFragment_to_homeFragment)
                        }
                        is UiState.Error -> {
                            binding.progressBar.isVisible = false
                            binding.btnRegister.isEnabled = true
                            showToast(state.message)
                            viewModel.resetState()
                        }
                        else -> {
                            binding.progressBar.isVisible = false
                            binding.btnRegister.isEnabled = true
                        }
                    }
                }
            }
        }
    }

    private fun validateInputs(name: String, email: String, password: String, confirm: String): Boolean {
        if (name.isEmpty()) { binding.etName.error = "Name is required"; return false }
        if (email.isEmpty()) { binding.etEmail.error = "Email is required"; return false }
        if (!android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches()) {
            binding.etEmail.error = "Invalid email format"; return false
        }
        if (password.length < 6) { binding.etPassword.error = "Minimum 6 characters"; return false }
        if (password != confirm) { binding.etConfirmPassword.error = "Passwords do not match"; return false }
        return true
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}
