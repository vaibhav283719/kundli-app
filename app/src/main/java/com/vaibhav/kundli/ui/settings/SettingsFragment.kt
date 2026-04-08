package com.vaibhav.kundli.ui.settings

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.lifecycleScope
import androidx.lifecycle.repeatOnLifecycle
import com.vaibhav.kundli.databinding.FragmentSettingsBinding
import com.vaibhav.kundli.util.Constants
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.launch

@AndroidEntryPoint
class SettingsFragment : Fragment() {

    private var _binding: FragmentSettingsBinding? = null
    private val binding get() = _binding!!
    private val viewModel: SettingsViewModel by viewModels()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        _binding = FragmentSettingsBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        setupThemeRadioGroup()
        setupLanguageRadioGroup()
        setupNotificationSwitch()
        observeSettings()
    }

    private fun setupThemeRadioGroup() {
        binding.rgTheme.setOnCheckedChangeListener { _, checkedId ->
            val theme = when (checkedId) {
                com.vaibhav.kundli.R.id.rbDark -> Constants.THEME_DARK
                com.vaibhav.kundli.R.id.rbLight -> Constants.THEME_LIGHT
                else -> Constants.THEME_SYSTEM
            }
            viewModel.setTheme(theme)
        }
    }

    private fun setupLanguageRadioGroup() {
        binding.rgLanguage.setOnCheckedChangeListener { _, checkedId ->
            val lang = when (checkedId) {
                com.vaibhav.kundli.R.id.rbEnglish -> Constants.LANG_ENGLISH
                com.vaibhav.kundli.R.id.rbHindi -> Constants.LANG_HINDI
                else -> Constants.LANG_ENGLISH
            }
            viewModel.setLanguage(lang)
        }
    }

    private fun setupNotificationSwitch() {
        binding.switchNotifications.setOnCheckedChangeListener { _, isChecked ->
            viewModel.setNotifications(isChecked)
        }
    }

    private fun observeSettings() {
        viewLifecycleOwner.lifecycleScope.launch {
            viewLifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED) {
                viewModel.theme.collect { theme ->
                    val id = when (theme) {
                        Constants.THEME_DARK -> com.vaibhav.kundli.R.id.rbDark
                        Constants.THEME_LIGHT -> com.vaibhav.kundli.R.id.rbLight
                        else -> com.vaibhav.kundli.R.id.rbSystem
                    }
                    binding.rgTheme.check(id)
                }
            }
        }
        viewLifecycleOwner.lifecycleScope.launch {
            viewLifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED) {
                viewModel.language.collect { lang ->
                    val id = when (lang) {
                        Constants.LANG_HINDI -> com.vaibhav.kundli.R.id.rbHindi
                        else -> com.vaibhav.kundli.R.id.rbEnglish
                    }
                    binding.rgLanguage.check(id)
                }
            }
        }
        viewLifecycleOwner.lifecycleScope.launch {
            viewLifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED) {
                viewModel.notifications.collect { enabled ->
                    binding.switchNotifications.isChecked = enabled
                }
            }
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}
