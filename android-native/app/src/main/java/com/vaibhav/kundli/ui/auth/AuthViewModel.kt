package com.vaibhav.kundli.ui.auth

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.vaibhav.kundli.data.repository.AuthRepository
import com.vaibhav.kundli.domain.model.UiState
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class AuthViewModel @Inject constructor(
    private val authRepository: AuthRepository
) : ViewModel() {

    private val _authState = MutableStateFlow<UiState<String>>(UiState.Idle)
    val authState: StateFlow<UiState<String>> = _authState

    fun isLoggedIn(): Boolean = authRepository.isLoggedIn()

    fun signIn(email: String, password: String) {
        viewModelScope.launch {
            _authState.value = UiState.Loading
            val result = authRepository.signIn(email, password)
            _authState.value = if (result.isSuccess) {
                UiState.Success(result.getOrDefault(""))
            } else {
                UiState.Error(result.exceptionOrNull()?.message ?: "Sign in failed")
            }
        }
    }

    fun register(name: String, email: String, password: String) {
        viewModelScope.launch {
            _authState.value = UiState.Loading
            val result = authRepository.register(name, email, password)
            _authState.value = if (result.isSuccess) {
                UiState.Success(result.getOrDefault(""))
            } else {
                UiState.Error(result.exceptionOrNull()?.message ?: "Registration failed")
            }
        }
    }

    fun forgotPassword(email: String) {
        viewModelScope.launch {
            _authState.value = UiState.Loading
            val result = authRepository.forgotPassword(email)
            _authState.value = if (result.isSuccess) {
                UiState.Success("Password reset email sent")
            } else {
                UiState.Error(result.exceptionOrNull()?.message ?: "Failed to send reset email")
            }
        }
    }

    fun signOut() {
        authRepository.signOut()
        _authState.value = UiState.Idle
    }

    fun resetState() {
        _authState.value = UiState.Idle
    }
}
