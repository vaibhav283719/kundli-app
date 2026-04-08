package com.vaibhav.kundli.ui.kundli

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.vaibhav.kundli.data.repository.KundliRepository
import com.vaibhav.kundli.domain.model.BirthDetails
import com.vaibhav.kundli.domain.model.KundliChart
import com.vaibhav.kundli.domain.model.UiState
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class KundliViewModel @Inject constructor(
    private val kundliRepository: KundliRepository
) : ViewModel() {

    private val _kundliState = MutableStateFlow<UiState<KundliChart>>(UiState.Idle)
    val kundliState: StateFlow<UiState<KundliChart>> = _kundliState

    private val _kundliList = MutableStateFlow<UiState<List<KundliChart>>>(UiState.Loading)
    val kundliList: StateFlow<UiState<List<KundliChart>>> = _kundliList

    init {
        loadAllKundlis()
    }

    fun loadAllKundlis() {
        viewModelScope.launch {
            kundliRepository.getAllKundlis()
                .catch { _kundliList.value = UiState.Error(it.message ?: "Error loading kundlis") }
                .collect { charts ->
                    _kundliList.value = UiState.Success(charts)
                }
        }
    }

    fun generateKundli(birthDetails: BirthDetails) {
        viewModelScope.launch(Dispatchers.Default) {
            _kundliState.value = UiState.Loading
            try {
                val chart = kundliRepository.generateKundliChart(birthDetails)
                kundliRepository.saveKundli(chart)
                _kundliState.value = UiState.Success(chart)
            } catch (e: Exception) {
                _kundliState.value = UiState.Error(e.message ?: "Failed to generate kundli")
            }
        }
    }

    fun loadKundliById(id: String) {
        viewModelScope.launch {
            _kundliState.value = UiState.Loading
            try {
                val chart = kundliRepository.getKundliById(id)
                if (chart != null) {
                    _kundliState.value = UiState.Success(chart)
                } else {
                    _kundliState.value = UiState.Error("Kundli not found")
                }
            } catch (e: Exception) {
                _kundliState.value = UiState.Error(e.message ?: "Error loading kundli")
            }
        }
    }

    fun deleteKundli(id: String) {
        viewModelScope.launch {
            try {
                kundliRepository.deleteKundli(id)
            } catch (e: Exception) {
                // Handle silently
            }
        }
    }

    fun resetState() {
        _kundliState.value = UiState.Idle
    }
}
