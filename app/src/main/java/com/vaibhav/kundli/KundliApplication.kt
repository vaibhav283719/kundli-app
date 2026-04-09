package com.vaibhav.kundli

import android.app.Application
import com.google.android.gms.ads.MobileAds
import com.google.firebase.FirebaseApp
import dagger.hilt.android.HiltAndroidApp

@HiltAndroidApp
class KundliApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        try {
            FirebaseApp.initializeApp(this)
        } catch (e: Exception) {
            // Firebase not configured, running in offline mode
        }
        try {
            MobileAds.initialize(this)
        } catch (e: Exception) {
            // Ads init failed
        }
    }
}
