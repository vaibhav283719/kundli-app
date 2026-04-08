package com.vaibhav.kundli.data.repository

import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.vaibhav.kundli.data.local.db.KundliChartEntity
import com.vaibhav.kundli.data.local.db.KundliDao
import com.vaibhav.kundli.domain.calculator.AstrologyCalculator
import com.vaibhav.kundli.domain.model.*
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import java.util.*
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class KundliRepository @Inject constructor(
    private val kundliDao: KundliDao,
    private val gson: Gson
) {
    fun getAllKundlis(): Flow<List<KundliChart>> {
        return kundliDao.getAll().map { entities ->
            entities.map { it.toKundliChart() }
        }
    }

    suspend fun getKundliById(id: String): KundliChart? {
        return kundliDao.getById(id)?.toKundliChart()
    }

    suspend fun saveKundli(chart: KundliChart) {
        kundliDao.insert(chart.toEntity())
    }

    suspend fun deleteKundli(id: String) {
        kundliDao.deleteById(id)
    }

    fun generateKundliChart(birthDetails: BirthDetails): KundliChart {
        val calendar = Calendar.getInstance()
        calendar.time = birthDetails.dateOfBirth
        val year = calendar.get(Calendar.YEAR)
        val month = calendar.get(Calendar.MONTH) + 1
        val day = calendar.get(Calendar.DAY_OF_MONTH)
        val hour = birthDetails.timeOfBirthHour

        val jd = AstrologyCalculator.julianDayNumber(year, month, day, hour)
        val ayanamsa = AstrologyCalculator.lahiriAyanamsa(jd)
        val ascTropical = AstrologyCalculator.calculateAscendant(jd, birthDetails.latitude, birthDetails.longitude)
        val ascSidereal = AstrologyCalculator.toSidereal(ascTropical, ayanamsa)
        val lagnaRashi = AstrologyCalculator.getRashi(ascSidereal)
        val houseCusps = AstrologyCalculator.calculateHouseCusps(ascSidereal)
        val houseRashis = houseCusps.map { AstrologyCalculator.getRashi(it) }
        val planets = AstrologyCalculator.calculateAllPlanets(jd, birthDetails.latitude, birthDetails.longitude)

        val moonPosition = planets.first { it.planet == "Moon" }
        val dashas = AstrologyCalculator.calculateVimshottariDasha(
            moonPosition.nakshatra,
            birthDetails.dateOfBirth,
            moonPosition.longitude
        )

        val yogas = AstrologyCalculator.detectYogas(planets, lagnaRashi)

        return KundliChart(
            id = birthDetails.id,
            birthDetails = birthDetails,
            lagnaRashi = lagnaRashi,
            lagnaLongitude = ascSidereal,
            planetPositions = planets,
            houseRashis = houseRashis,
            dashas = dashas,
            yogas = yogas,
            createdAt = Date()
        )
    }

    private fun KundliChart.toEntity(): KundliChartEntity {
        return KundliChartEntity(
            id = id,
            name = birthDetails.name,
            dateOfBirth = birthDetails.dateOfBirth.time,
            placeOfBirth = birthDetails.placeOfBirth,
            latitude = birthDetails.latitude,
            longitude = birthDetails.longitude,
            timezone = birthDetails.timezone,
            lagnaRashi = lagnaRashi,
            lagnaLongitude = lagnaLongitude,
            planetPositionsJson = gson.toJson(planetPositions),
            houseRashisJson = gson.toJson(houseRashis),
            dashasJson = gson.toJson(dashas),
            yogasJson = gson.toJson(yogas),
            createdAt = createdAt.time
        )
    }

    private fun KundliChartEntity.toKundliChart(): KundliChart {
        val planetType = object : TypeToken<List<PlanetPosition>>() {}.type
        val houseType = object : TypeToken<List<Int>>() {}.type
        val dashaType = object : TypeToken<List<DashaPeriod>>() {}.type
        val yogaType = object : TypeToken<List<KundliYoga>>() {}.type

        return KundliChart(
            id = id,
            birthDetails = BirthDetails(
                id = id,
                name = name,
                dateOfBirth = Date(dateOfBirth),
                timeOfBirthHour = 0.0,
                placeOfBirth = placeOfBirth,
                latitude = latitude,
                longitude = longitude,
                timezone = timezone
            ),
            lagnaRashi = lagnaRashi,
            lagnaLongitude = lagnaLongitude,
            planetPositions = gson.fromJson(planetPositionsJson, planetType),
            houseRashis = gson.fromJson(houseRashisJson, houseType),
            dashas = gson.fromJson(dashasJson, dashaType),
            yogas = gson.fromJson(yogasJson, yogaType),
            createdAt = Date(createdAt)
        )
    }
}
