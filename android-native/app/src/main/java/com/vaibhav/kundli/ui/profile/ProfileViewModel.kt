package com.vaibhav.kundli.ui.profile

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.vaibhav.kundli.data.local.prefs.AppPreferences
import com.vaibhav.kundli.data.repository.ProfileRepository
import com.vaibhav.kundli.domain.model.UiState
import com.vaibhav.kundli.domain.model.UserProfile
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class ProfileViewModel @Inject constructor(
    private val prefs: AppPreferences,
    private val profileRepository: ProfileRepository
) : ViewModel() {

    private val _profileState = MutableStateFlow<UiState<UserProfile>>(UiState.Loading)
    val profileState: StateFlow<UiState<UserProfile>> = _profileState

    private val _saveState = MutableStateFlow<UiState<Unit>>(UiState.Idle)
    val saveState: StateFlow<UiState<Unit>> = _saveState

    init {
        loadProfile()
    }

    fun loadProfile() {
        viewModelScope.launch {
            _profileState.value = UiState.Loading
            // Build profile from local prefs first
            val localProfile = UserProfile(
                uid = prefs.userId,
                name = prefs.userName,
                email = prefs.userEmail,
                isPremium = prefs.isPremium
            )
            // Try to get from Firestore
            val result = profileRepository.getProfile(prefs.userId)
            _profileState.value = if (result.isSuccess) {
                val firestoreProfile = result.getOrNull()
                UiState.Success(firestoreProfile?.copy(
                    name = firestoreProfile.name.ifEmpty { localProfile.name },
                    email = firestoreProfile.email.ifEmpty { localProfile.email }
                ) ?: localProfile)
            } else {
                UiState.Success(localProfile)
            }
        }
    }

    fun saveProfile(profile: UserProfile) {
        viewModelScope.launch {
            _saveState.value = UiState.Loading
            prefs.userName = profile.name
            val result = profileRepository.saveProfile(profile)
            _saveState.value = if (result.isSuccess) {
                UiState.Success(Unit)
            } else {
                UiState.Error(result.exceptionOrNull()?.message ?: "Save failed")
            }
        }
    }

    fun resetSaveState() { _saveState.value = UiState.Idle }

    fun getLocalProfile() = UserProfile(
        uid = prefs.userId,
        name = prefs.userName,
        email = prefs.userEmail,
        isPremium = prefs.isPremium
    )
}
