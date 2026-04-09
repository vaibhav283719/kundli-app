package com.vaibhav.kundli.data.local.prefs

import android.content.Context
import android.content.SharedPreferences
import com.vaibhav.kundli.util.Constants
import dagger.hilt.android.qualifiers.ApplicationContext
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class AppPreferences @Inject constructor(@ApplicationContext context: Context) {

    private val prefs: SharedPreferences =
        context.getSharedPreferences(Constants.PREF_NAME, Context.MODE_PRIVATE)

    var isLoggedIn: Boolean
        get() = prefs.getBoolean(Constants.KEY_IS_LOGGED_IN, false)
        set(value) = prefs.edit().putBoolean(Constants.KEY_IS_LOGGED_IN, value).apply()

    var userId: String
        get() = prefs.getString(Constants.KEY_USER_ID, "") ?: ""
        set(value) = prefs.edit().putString(Constants.KEY_USER_ID, value).apply()

    var userName: String
        get() = prefs.getString(Constants.KEY_USER_NAME, "") ?: ""
        set(value) = prefs.edit().putString(Constants.KEY_USER_NAME, value).apply()

    var userEmail: String
        get() = prefs.getString(Constants.KEY_USER_EMAIL, "") ?: ""
        set(value) = prefs.edit().putString(Constants.KEY_USER_EMAIL, value).apply()

    var theme: String
        get() = prefs.getString(Constants.KEY_THEME, Constants.THEME_DARK) ?: Constants.THEME_DARK
        set(value) = prefs.edit().putString(Constants.KEY_THEME, value).apply()

    var language: String
        get() = prefs.getString(Constants.KEY_LANGUAGE, Constants.LANG_ENGLISH) ?: Constants.LANG_ENGLISH
        set(value) = prefs.edit().putString(Constants.KEY_LANGUAGE, value).apply()

    var notificationsEnabled: Boolean
        get() = prefs.getBoolean(Constants.KEY_NOTIFICATIONS, true)
        set(value) = prefs.edit().putBoolean(Constants.KEY_NOTIFICATIONS, value).apply()

    var isPremium: Boolean
        get() = prefs.getBoolean(Constants.KEY_IS_PREMIUM, false)
        set(value) = prefs.edit().putBoolean(Constants.KEY_IS_PREMIUM, value).apply()

    fun clearAll() {
        prefs.edit().clear().apply()
    }
}
