package com.vaibhav.kundli.domain.model

import java.util.Date
import java.util.UUID

data class BirthDetails(
    val id: String = UUID.randomUUID().toString(),
    val name: String,
    val dateOfBirth: Date,
    val timeOfBirthHour: Double,
    val placeOfBirth: String,
    val latitude: Double,
    val longitude: Double,
    val timezone: Double
)

data class PlanetPosition(
    val planet: String,
    val longitude: Double,
    val rashi: Int,
    val rashiDegree: Double,
    val nakshatra: Int,
    val nakshatraPada: Int,
    val house: Int,
    val isRetrograde: Boolean = false,
    val isCombust: Boolean = false,
    val isExalted: Boolean = false,
    val isDebilitated: Boolean = false
)

data class DashaPeriod(
    val planet: String,
    val startDate: Date,
    val endDate: Date,
    val years: Int,
    val antarDashas: List<DashaPeriod> = emptyList()
)

data class KundliYoga(
    val name: String,
    val description: String,
    val isPresent: Boolean,
    val involvedPlanets: List<String>
)

data class KundliChart(
    val id: String,
    val birthDetails: BirthDetails,
    val lagnaRashi: Int,
    val lagnaLongitude: Double,
    val planetPositions: List<PlanetPosition>,
    val houseRashis: List<Int>,
    val dashas: List<DashaPeriod>,
    val yogas: List<KundliYoga>,
    val createdAt: Date
)

data class KootaResult(
    val name: String,
    val maxPoints: Int,
    val obtainedPoints: Int,
    val description: String,
    val isCompatible: Boolean
)

data class CompatibilityResult(
    val person1Name: String,
    val person1Nakshatra: Int,
    val person2Name: String,
    val person2Nakshatra: Int,
    val kootaResults: List<KootaResult>,
    val calculatedAt: Date
)

data class HoroscopeData(
    val zodiacSign: String,
    val zodiacSignHindi: String,
    val date: Date,
    val prediction: String,
    val love: String,
    val career: String,
    val health: String,
    val finance: String,
    val luckyNumber: Int,
    val luckyColor: String,
    val luckyGem: String,
    val compatibleSigns: List<String>,
    val rating: Int
)

data class Remedy(
    val id: String,
    val title: String,
    val description: String,
    val planet: String,
    val category: String,
    val difficulty: String
)

data class UserProfile(
    val uid: String = "",
    val name: String = "",
    val email: String = "",
    val phone: String = "",
    val dateOfBirth: String = "",
    val gender: String = "",
    val photoUrl: String = "",
    val isPremium: Boolean = false
)

sealed class UiState<out T> {
    object Loading : UiState<Nothing>()
    data class Success<T>(val data: T) : UiState<T>()
    data class Error(val message: String) : UiState<Nothing>()
    object Idle : UiState<Nothing>()
}
