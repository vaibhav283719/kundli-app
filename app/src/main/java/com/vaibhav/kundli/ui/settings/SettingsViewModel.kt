package com.vaibhav.kundli.ui.settings

import androidx.appcompat.app.AppCompatDelegate
import androidx.lifecycle.ViewModel
import com.vaibhav.kundli.data.local.prefs.AppPreferences
import com.vaibhav.kundli.util.Constants
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import javax.inject.Inject

@HiltViewModel
class SettingsViewModel @Inject constructor(
    private val prefs: AppPreferences
) : ViewModel() {

    private val _theme = MutableStateFlow(prefs.theme)
    val theme: StateFlow<String> = _theme

    private val _language = MutableStateFlow(prefs.language)
    val language: StateFlow<String> = _language

    private val _notifications = MutableStateFlow(prefs.notificationsEnabled)
    val notifications: StateFlow<Boolean> = _notifications

    fun setTheme(theme: String) {
        prefs.theme = theme
        _theme.value = theme
        when (theme) {
            Constants.THEME_DARK -> AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES)
            Constants.THEME_LIGHT -> AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO)
            else -> AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM)
        }
    }

    fun setLanguage(language: String) {
        prefs.language = language
        _language.value = language
    }

    fun setNotifications(enabled: Boolean) {
        prefs.notificationsEnabled = enabled
        _notifications.value = enabled
    }
}
