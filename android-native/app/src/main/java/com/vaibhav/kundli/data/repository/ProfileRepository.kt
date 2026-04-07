package com.vaibhav.kundli.data.repository

import com.vaibhav.kundli.domain.model.UserProfile
import kotlinx.coroutines.tasks.await
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class ProfileRepository @Inject constructor() {
    private var firestore: com.google.firebase.firestore.FirebaseFirestore? = null

    init {
        try {
            firestore = com.google.firebase.firestore.FirebaseFirestore.getInstance()
        } catch (e: Exception) {
            // Firebase not configured
        }
    }

    suspend fun saveProfile(profile: UserProfile): Result<Unit> {
        return try {
            val db = firestore ?: return Result.success(Unit) // offline mode
            db.collection("users").document(profile.uid).set(profile).await()
            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    suspend fun getProfile(uid: String): Result<UserProfile> {
        return try {
            val db = firestore ?: return Result.failure(Exception("Offline mode"))
            val doc = db.collection("users").document(uid).get().await()
            if (doc.exists()) {
                val profile = doc.toObject(UserProfile::class.java)
                    ?: UserProfile(uid = uid)
                Result.success(profile)
            } else {
                Result.success(UserProfile(uid = uid))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    suspend fun updateProfile(uid: String, updates: Map<String, Any>): Result<Unit> {
        return try {
            val db = firestore ?: return Result.success(Unit)
            db.collection("users").document(uid).update(updates).await()
            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
