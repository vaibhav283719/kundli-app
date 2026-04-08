package com.vaibhav.kundli.ui.kundli

import android.app.DatePickerDialog
import android.app.TimePickerDialog
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
import androidx.navigation.fragment.findNavController
import com.vaibhav.kundli.R
import com.vaibhav.kundli.databinding.FragmentBirthDetailsBinding
import com.vaibhav.kundli.domain.model.BirthDetails
import com.vaibhav.kundli.domain.model.UiState
import com.vaibhav.kundli.util.AdManager
import com.vaibhav.kundli.util.Constants
import com.vaibhav.kundli.util.showToast
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.*
import javax.inject.Inject

@AndroidEntryPoint
class BirthDetailsFragment : Fragment() {

    private var _binding: FragmentBirthDetailsBinding? = null
    private val binding get() = _binding!!
    private val viewModel: KundliViewModel by viewModels()

    @Inject lateinit var adManager: AdManager

    private var selectedDate: Calendar = Calendar.getInstance()
    private var selectedHour: Int = 6
    private var selectedMinute: Int = 0

    private val dateFormat = SimpleDateFormat("dd MMMM yyyy", Locale.getDefault())
    private val timeFormat = SimpleDateFormat("hh:mm a", Locale.getDefault())

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        _binding = FragmentBirthDetailsBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        setupCityDropdown()
        setupDateTimePickers()
        setupCalculateButton()
        observeState()
        adManager.loadInterstitial()
    }

    private fun setupCityDropdown() {
        val cities = Constants.COMMON_CITIES.keys.toList() + listOf("Custom")
        val adapter = ArrayAdapter(requireContext(), android.R.layout.simple_dropdown_item_1line, cities)
        binding.actvCity.setAdapter(adapter)

        binding.actvCity.setOnItemClickListener { _, _, position, _ ->
            val selectedCity = cities[position]
            if (selectedCity != "Custom") {
                val coords = Constants.COMMON_CITIES[selectedCity]
                if (coords != null) {
                    binding.etLatitude.setText(coords.first.toString())
                    binding.etLongitude.setText(coords.second.toString())
                    binding.etLatitude.isEnabled = false
                    binding.etLongitude.isEnabled = false
                }
            } else {
                binding.etLatitude.isEnabled = true
                binding.etLongitude.isEnabled = true
                binding.etLatitude.setText("")
                binding.etLongitude.setText("")
            }
        }
    }

    private fun setupDateTimePickers() {
        binding.etDateOfBirth.setOnClickListener {
            val year = selectedDate.get(Calendar.YEAR)
            val month = selectedDate.get(Calendar.MONTH)
            val day = selectedDate.get(Calendar.DAY_OF_MONTH)

            DatePickerDialog(requireContext(), { _, y, m, d ->
                selectedDate.set(y, m, d)
                binding.etDateOfBirth.setText(dateFormat.format(selectedDate.time))
            }, year, month, day).apply {
                datePicker.maxDate = System.currentTimeMillis()
                show()
            }
        }

        binding.etTimeOfBirth.setOnClickListener {
            TimePickerDialog(requireContext(), { _, hour, minute ->
                selectedHour = hour
                selectedMinute = minute
                val cal = Calendar.getInstance()
                cal.set(Calendar.HOUR_OF_DAY, hour)
                cal.set(Calendar.MINUTE, minute)
                binding.etTimeOfBirth.setText(timeFormat.format(cal.time))
            }, selectedHour, selectedMinute, false).show()
        }
    }

    private fun setupCalculateButton() {
        binding.btnCalculate.setOnClickListener {
            val name = binding.etName.text.toString().trim()
            val city = binding.actvCity.text.toString().trim()
            val latStr = binding.etLatitude.text.toString().trim()
            val lonStr = binding.etLongitude.text.toString().trim()
            val tzStr = binding.etTimezone.text.toString().trim()

            if (!validateInputs(name, city, latStr, lonStr)) return@setOnClickListener

            val lat = latStr.toDoubleOrNull() ?: 28.7041
            val lon = lonStr.toDoubleOrNull() ?: 77.1025
            val tz = tzStr.toDoubleOrNull() ?: 5.5
            val timeHour = selectedHour + selectedMinute / 60.0 - tz

            val birthDetails = BirthDetails(
                name = name,
                dateOfBirth = selectedDate.time,
                timeOfBirthHour = timeHour,
                placeOfBirth = city,
                latitude = lat,
                longitude = lon,
                timezone = tz
            )
            viewModel.generateKundli(birthDetails)
        }
    }

    private fun validateInputs(name: String, city: String, lat: String, lon: String): Boolean {
        if (name.isEmpty()) { binding.etName.error = "Name is required"; return false }
        if (binding.etDateOfBirth.text.isNullOrEmpty()) {
            showToast("Please select date of birth"); return false
        }
        if (binding.etTimeOfBirth.text.isNullOrEmpty()) {
            showToast("Please select time of birth"); return false
        }
        if (city.isEmpty()) { binding.actvCity.error = "Place is required"; return false }
        if (lat.isEmpty()) { binding.etLatitude.error = "Latitude is required"; return false }
        if (lon.isEmpty()) { binding.etLongitude.error = "Longitude is required"; return false }
        return true
    }

    private fun observeState() {
        viewLifecycleOwner.lifecycleScope.launch {
            viewLifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED) {
                viewModel.kundliState.collect { state ->
                    when (state) {
                        is UiState.Loading -> {
                            binding.progressBar.isVisible = true
                            binding.btnCalculate.isEnabled = false
                        }
                        is UiState.Success -> {
                            binding.progressBar.isVisible = false
                            binding.btnCalculate.isEnabled = true
                            val kundliId = state.data.id
                            adManager.showInterstitial(requireActivity()) {
                                val bundle = Bundle().apply { putString("kundliId", kundliId) }
                                findNavController().navigate(R.id.action_birthDetailsFragment_to_kundliChartFragment, bundle)
                            }
                            viewModel.resetState()
                        }
                        is UiState.Error -> {
                            binding.progressBar.isVisible = false
                            binding.btnCalculate.isEnabled = true
                            showToast(state.message)
                            viewModel.resetState()
                        }
                        else -> {
                            binding.progressBar.isVisible = false
                            binding.btnCalculate.isEnabled = true
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
