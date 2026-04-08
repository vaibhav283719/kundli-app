package com.vaibhav.kundli

import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class KundliFcmService : FirebaseMessagingService() {
    override fun onMessageReceived(message: RemoteMessage) {
        super.onMessageReceived(message)
        // Handle FCM messages here
    }

    override fun onNewToken(token: String) {
        super.onNewToken(token)
        // Update token in Firestore if needed
    }
}
