package com.vaibhav.kundli.ui.profile

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
import com.vaibhav.kundli.databinding.FragmentEditProfileBinding
import com.vaibhav.kundli.domain.model.UiState
import com.vaibhav.kundli.domain.model.UserProfile
import com.vaibhav.kundli.util.showToast
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.launch

@AndroidEntryPoint
class EditProfileFragment : Fragment() {

    private var _binding: FragmentEditProfileBinding? = null
    private val binding get() = _binding!!
    private val viewModel: ProfileViewModel by viewModels()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        _binding = FragmentEditProfileBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        val local = viewModel.getLocalProfile()
        binding.etName.setText(local.name)
        binding.etEmail.setText(local.email)
        binding.etPhone.setText(local.phone)
        binding.etDateOfBirth.setText(local.dateOfBirth)
        binding.rgGender.check(
            when (local.gender) {
                "Male" -> com.vaibhav.kundli.R.id.rbMale
                "Female" -> com.vaibhav.kundli.R.id.rbFemale
                else -> com.vaibhav.kundli.R.id.rbOther
            }
        )

        binding.btnSave.setOnClickListener {
            val name = binding.etName.text.toString().trim()
            if (name.isEmpty()) { binding.etName.error = "Required"; return@setOnClickListener }

            val gender = when (binding.rgGender.checkedRadioButtonId) {
                com.vaibhav.kundli.R.id.rbMale -> "Male"
                com.vaibhav.kundli.R.id.rbFemale -> "Female"
                else -> "Other"
            }

            val updatedProfile = UserProfile(
                uid = local.uid,
                name = name,
                email = local.email,
                phone = binding.etPhone.text.toString().trim(),
                dateOfBirth = binding.etDateOfBirth.text.toString().trim(),
                gender = gender
            )
            viewModel.saveProfile(updatedProfile)
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewLifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED) {
                viewModel.saveState.collect { state ->
                    when (state) {
                        is UiState.Loading -> {
                            binding.progressBar.isVisible = true
                            binding.btnSave.isEnabled = false
                        }
                        is UiState.Success -> {
                            binding.progressBar.isVisible = false
                            binding.btnSave.isEnabled = true
                            showToast("Profile saved successfully")
                            findNavController().navigateUp()
                            viewModel.resetSaveState()
                        }
                        is UiState.Error -> {
                            binding.progressBar.isVisible = false
                            binding.btnSave.isEnabled = true
                            showToast(state.message)
                            viewModel.resetSaveState()
                        }
                        else -> {
                            binding.progressBar.isVisible = false
                            binding.btnSave.isEnabled = true
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
