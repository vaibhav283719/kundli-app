package com.vaibhav.kundli.ui.remedies

import androidx.lifecycle.ViewModel
import com.vaibhav.kundli.domain.model.Remedy
import com.vaibhav.kundli.domain.service.RemedyService
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import javax.inject.Inject

@HiltViewModel
class RemediesViewModel @Inject constructor(
    private val remedyService: RemedyService
) : ViewModel() {

    private val _selectedCategory = MutableStateFlow("All")
    val selectedCategory: StateFlow<String> = _selectedCategory

    private val _remedies = MutableStateFlow<List<Remedy>>(emptyList())
    val remedies: StateFlow<List<Remedy>> = _remedies

    val categories: List<String> = listOf("All") + remedyService.getCategories()

    init {
        loadRemedies()
    }

    fun selectCategory(category: String) {
        _selectedCategory.value = category
        loadRemedies()
    }

    private fun loadRemedies() {
        val cat = _selectedCategory.value
        _remedies.value = if (cat == "All") {
            remedyService.getAllRemedies()
        } else {
            remedyService.getRemediesByCategory(cat)
        }
    }
}
