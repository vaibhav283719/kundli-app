package com.vaibhav.kundli.data.repository

import com.google.firebase.auth.FirebaseAuth
import com.vaibhav.kundli.data.local.prefs.AppPreferences
import kotlinx.coroutines.tasks.await
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class AuthRepository @Inject constructor(
    private val prefs: AppPreferences
) {
    private var firebaseAuth: FirebaseAuth? = null

    init {
        try {
            firebaseAuth = FirebaseAuth.getInstance()
        } catch (e: Exception) {
            // Firebase not configured
        }
    }

    fun isLoggedIn(): Boolean = prefs.isLoggedIn || (firebaseAuth?.currentUser != null)

    suspend fun signIn(email: String, password: String): Result<String> {
        return try {
            val auth = firebaseAuth
            if (auth != null) {
                val result = auth.signInWithEmailAndPassword(email, password).await()
                val user = result.user ?: return Result.failure(Exception("Sign in failed"))
                prefs.isLoggedIn = true
                prefs.userId = user.uid
                prefs.userEmail = user.email ?: email
                prefs.userName = user.displayName ?: email.substringBefore("@")
                Result.success(user.uid)
            } else {
                offlineSignIn(email, password)
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    private fun offlineSignIn(email: String, password: String): Result<String> {
        return if (email.isNotEmpty() && password.length >= 6) {
            prefs.isLoggedIn = true
            prefs.userEmail = email
            prefs.userName = email.substringBefore("@").capitalizeFirst()
            prefs.userId = email.hashCode().toString()
            Result.success(prefs.userId)
        } else {
            Result.failure(Exception("Invalid credentials"))
        }
    }

    suspend fun register(name: String, email: String, password: String): Result<String> {
        return try {
            val auth = firebaseAuth
            if (auth != null) {
                val result = auth.createUserWithEmailAndPassword(email, password).await()
                val user = result.user ?: return Result.failure(Exception("Registration failed"))
                prefs.isLoggedIn = true
                prefs.userId = user.uid
                prefs.userEmail = email
                prefs.userName = name
                Result.success(user.uid)
            } else {
                offlineRegister(name, email, password)
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    private fun offlineRegister(name: String, email: String, password: String): Result<String> {
        return if (email.isNotEmpty() && password.length >= 6) {
            prefs.isLoggedIn = true
            prefs.userEmail = email
            prefs.userName = name
            prefs.userId = email.hashCode().toString()
            Result.success(prefs.userId)
        } else {
            Result.failure(Exception("Registration failed"))
        }
    }

    suspend fun forgotPassword(email: String): Result<Unit> {
        return try {
            firebaseAuth?.sendPasswordResetEmail(email)?.await()
            Result.success(Unit)
        } catch (e: Exception) {
            // In offline mode still return success
            Result.success(Unit)
        }
    }

    fun signOut() {
        try { firebaseAuth?.signOut() } catch (_: Exception) {}
        prefs.clearAll()
    }

    fun getCurrentUserName(): String = prefs.userName
    fun getCurrentUserEmail(): String = prefs.userEmail
    fun getCurrentUserId(): String = prefs.userId

    private fun String.capitalizeFirst(): String =
        if (isEmpty()) this else this[0].uppercase() + substring(1)
}
