package com.vaibhav.kundli.ui.horoscope

import androidx.lifecycle.ViewModel
import com.vaibhav.kundli.domain.model.HoroscopeData
import com.vaibhav.kundli.domain.model.UiState
import com.vaibhav.kundli.domain.service.HoroscopeService
import com.vaibhav.kundli.util.Constants
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import java.util.Date
import javax.inject.Inject

@HiltViewModel
class HoroscopeViewModel @Inject constructor(
    private val horoscopeService: HoroscopeService
) : ViewModel() {

    private val _horoscopeState = MutableStateFlow<UiState<HoroscopeData>>(UiState.Idle)
    val horoscopeState: StateFlow<UiState<HoroscopeData>> = _horoscopeState

    private val _selectedSignIndex = MutableStateFlow(0)
    val selectedSignIndex: StateFlow<Int> = _selectedSignIndex

    init {
        loadHoroscope(0)
    }

    fun loadHoroscope(signIndex: Int, date: Date = Date()) {
        _selectedSignIndex.value = signIndex
        val sign = Constants.ZODIAC_SIGNS.getOrElse(signIndex) { "Aries" }
        val data = horoscopeService.getHoroscope(sign, "daily", date)
        _horoscopeState.value = UiState.Success(data)
    }

    fun selectSign(index: Int) = loadHoroscope(index)
}
