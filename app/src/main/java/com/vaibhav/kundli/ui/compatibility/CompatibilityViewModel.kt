package com.vaibhav.kundli.ui.compatibility

import androidx.lifecycle.ViewModel
import com.vaibhav.kundli.domain.calculator.GunMilanCalculator
import com.vaibhav.kundli.domain.model.CompatibilityResult
import com.vaibhav.kundli.domain.model.UiState
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import javax.inject.Inject

@HiltViewModel
class CompatibilityViewModel @Inject constructor() : ViewModel() {

    private val _compatibilityState = MutableStateFlow<UiState<CompatibilityResult>>(UiState.Idle)
    val compatibilityState: StateFlow<UiState<CompatibilityResult>> = _compatibilityState

    fun calculate(
        person1Name: String, person1Nakshatra: Int,
        person2Name: String, person2Nakshatra: Int
    ) {
        _compatibilityState.value = UiState.Loading
        val result = GunMilanCalculator.calculate(person1Name, person1Nakshatra, person2Name, person2Nakshatra)
        _compatibilityState.value = UiState.Success(result)
    }

    fun getTotalScore(result: CompatibilityResult) = GunMilanCalculator.getTotalScore(result)
    fun getMaxScore() = GunMilanCalculator.getMaxScore()
    fun resetState() { _compatibilityState.value = UiState.Idle }
}
