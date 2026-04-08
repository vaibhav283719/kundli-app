package com.vaibhav.kundli.ui.home

import androidx.lifecycle.ViewModel
import com.vaibhav.kundli.data.local.prefs.AppPreferences
import com.vaibhav.kundli.data.repository.AuthRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

@HiltViewModel
class HomeViewModel @Inject constructor(
    private val prefs: AppPreferences,
    private val authRepository: AuthRepository
) : ViewModel() {

    fun getUserName(): String = prefs.userName.ifEmpty { "Astrology Seeker" }
    fun isPremium(): Boolean = prefs.isPremium
    fun signOut() = authRepository.signOut()
}
