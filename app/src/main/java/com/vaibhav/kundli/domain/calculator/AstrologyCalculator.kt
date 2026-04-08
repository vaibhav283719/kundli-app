package com.vaibhav.kundli.domain.calculator

import com.vaibhav.kundli.domain.model.*
import com.vaibhav.kundli.util.Constants
import java.util.*
import kotlin.math.*

object AstrologyCalculator {

    fun julianDayNumber(year: Int, month: Int, day: Int, hour: Double): Double {
        val y = if (month <= 2) year - 1 else year
        val m = if (month <= 2) month + 12 else month
        val a = (y / 100).toInt()
        val b = 2 - a + (a / 4).toInt()
        return floor(365.25 * (y + 4716)) + floor(30.6001 * (m + 1)) + day + hour / 24.0 + b - 1524.5
    }

    fun julianCenturies(jd: Double): Double = (jd - 2451545.0) / 36525.0

    fun lahiriAyanamsa(jd: Double): Double {
        val t = julianCenturies(jd)
        return 23.85 + t * 50.2388 / 3600.0
    }

    fun normalizeAngle(angle: Double): Double {
        var a = angle % 360.0
        if (a < 0) a += 360.0
        return a
    }

    fun getRashi(longitude: Double): Int = (longitude / 30).toInt() % 12

    fun getRashiDegree(longitude: Double): Double = longitude % 30

    fun getNakshatra(longitude: Double): Int = (longitude * 27 / 360).toInt() % 27

    fun getNakshatraPada(longitude: Double): Int = ((longitude * 108 / 360) % 4).toInt() + 1

    fun gmst(jd: Double): Double {
        val t = julianCenturies(jd)
        val g = 100.4606184 + 36000.77004 * t + 0.000387933 * t * t - t * t * t / 38710000.0
        return normalizeAngle(g)
    }

    fun localSiderealTime(jd: Double, longitude: Double): Double {
        return normalizeAngle(gmst(jd) + longitude)
    }

    fun calculateAscendant(jd: Double, latitude: Double, longitude: Double): Double {
        val lst = localSiderealTime(jd, longitude)
        val latRad = Math.toRadians(latitude)
        val lstRad = Math.toRadians(lst)
        val obliquity = Math.toRadians(23.4397)
        val asc = Math.toDegrees(atan2(cos(lstRad), -(sin(lstRad) * cos(obliquity) + tan(latRad) * sin(obliquity))))
        return normalizeAngle(asc)
    }

    fun sunLongitude(jd: Double): Double {
        val t = julianCenturies(jd)
        val l0 = 280.46646 + 36000.76983 * t
        val mRad = Math.toRadians(357.52911 + 35999.05029 * t)
        val c = (1.914602 - 0.004817 * t) * sin(mRad) + 0.019993 * sin(2 * mRad) + 0.000289 * sin(3 * mRad)
        return normalizeAngle(l0 + c)
    }

    fun moonLongitude(jd: Double): Double {
        val t = julianCenturies(jd)
        val l = 218.3165 + 481267.8813 * t
        val m = Math.toRadians(357.5291 + 35999.0503 * t)
        val mp = Math.toRadians(134.9634 + 477198.8676 * t)
        val d = Math.toRadians(297.8502 + 445267.1115 * t)
        val f = Math.toRadians(93.2721 + 483202.0175 * t)
        val correction = 6.2888 * sin(mp) + 1.2740 * sin(2 * d - mp) + 0.6583 * sin(2 * d) +
                0.2136 * sin(2 * mp) - 0.1851 * sin(m) - 0.1143 * sin(2 * f) +
                0.0588 * sin(2 * d - 2 * mp) + 0.0572 * sin(2 * d - m - mp)
        return normalizeAngle(l + correction)
    }

    fun marsLongitude(jd: Double): Double {
        val t = julianCenturies(jd)
        val l = 355.433 + 19140.2993 * t
        val mRad = Math.toRadians(l)
        val c = 10.6912 * sin(mRad) + 0.6228 * sin(2 * mRad)
        return normalizeAngle(l + c)
    }

    fun mercuryLongitude(jd: Double): Double {
        val t = julianCenturies(jd)
        val l = 252.2508 + 149472.6746 * t
        val mRad = Math.toRadians(l)
        val c = 23.44 * sin(mRad) + 2.9818 * sin(2 * mRad)
        return normalizeAngle(l + c)
    }

    fun jupiterLongitude(jd: Double): Double {
        val t = julianCenturies(jd)
        val l = 34.3515 + 3034.9057 * t
        val mRad = Math.toRadians(l)
        val c = 5.5549 * sin(mRad) + 0.1683 * sin(2 * mRad)
        return normalizeAngle(l + c)
    }

    fun venusLongitude(jd: Double): Double {
        val t = julianCenturies(jd)
        val l = 181.9798 + 58517.8156 * t
        val mRad = Math.toRadians(l)
        val c = 0.7758 * sin(mRad) + 0.0033 * sin(2 * mRad)
        return normalizeAngle(l + c)
    }

    fun saturnLongitude(jd: Double): Double {
        val t = julianCenturies(jd)
        val l = 50.0774 + 1222.1138 * t
        val mRad = Math.toRadians(l)
        val c = 6.3585 * sin(mRad) + 0.2204 * sin(2 * mRad)
        return normalizeAngle(l + c)
    }

    fun rahuLongitude(jd: Double): Double {
        val t = julianCenturies(jd)
        return normalizeAngle(125.0445 - 1934.1363 * t)
    }

    fun toSidereal(tropical: Double, ayanamsa: Double): Double = normalizeAngle(tropical - ayanamsa)

    fun calculateHouseCusps(ascendant: Double): List<Double> {
        return (0 until 12).map { i -> normalizeAngle(ascendant + i * 30.0) }
    }

    fun getPlanetHouse(planetLong: Double, ascendant: Double): Int {
        return (normalizeAngle(planetLong - ascendant) / 30).toInt() + 1
    }

    fun isExalted(planet: String, rashi: Int): Boolean {
        val exaltations = mapOf(
            "Sun" to 0, "Moon" to 1, "Mars" to 9, "Mercury" to 5,
            "Jupiter" to 3, "Venus" to 11, "Saturn" to 6
        )
        return exaltations[planet] == rashi
    }

    fun isDebilitated(planet: String, rashi: Int): Boolean {
        val debilitations = mapOf(
            "Sun" to 6, "Moon" to 7, "Mars" to 3, "Mercury" to 11,
            "Jupiter" to 9, "Venus" to 5, "Saturn" to 0
        )
        return debilitations[planet] == rashi
    }

    fun isCombust(planet: String, planetLong: Double, sunLong: Double): Boolean {
        val orbs = mapOf(
            "Moon" to 12.0, "Mars" to 17.0, "Mercury" to 14.0,
            "Jupiter" to 11.0, "Venus" to 10.0, "Saturn" to 15.0
        )
        val orb = orbs[planet] ?: return false
        val diff = abs(normalizeAngle(planetLong - sunLong))
        val actualDiff = if (diff > 180) 360 - diff else diff
        return actualDiff < orb
    }

    fun calculateAllPlanets(jd: Double, latitude: Double, longitude: Double): List<PlanetPosition> {
        val ayanamsa = lahiriAyanamsa(jd)
        val ascendant = calculateAscendant(jd, latitude, longitude)
        val ascSidereal = toSidereal(ascendant, ayanamsa)

        val tropicalLongs = mapOf(
            "Sun" to sunLongitude(jd),
            "Moon" to moonLongitude(jd),
            "Mars" to marsLongitude(jd),
            "Mercury" to mercuryLongitude(jd),
            "Jupiter" to jupiterLongitude(jd),
            "Venus" to venusLongitude(jd),
            "Saturn" to saturnLongitude(jd),
            "Rahu" to rahuLongitude(jd),
            "Ketu" to normalizeAngle(rahuLongitude(jd) + 180.0)
        )

        val sunSidereal = toSidereal(tropicalLongs["Sun"]!!, ayanamsa)
        val retrogradeplanets = setOf("Rahu", "Ketu")

        return Constants.PLANETS.map { planet ->
            val tropical = tropicalLongs[planet]!!
            val sidereal = toSidereal(tropical, ayanamsa)
            val rashi = getRashi(sidereal)
            val rashiDeg = getRashiDegree(sidereal)
            val nakshatra = getNakshatra(sidereal)
            val pada = getNakshatraPada(sidereal)
            val house = getPlanetHouse(sidereal, ascSidereal)
            val combust = if (planet != "Sun") isCombust(planet, sidereal, sunSidereal) else false
            val exalted = isExalted(planet, rashi)
            val debilitated = isDebilitated(planet, rashi)
            val retrograde = planet in retrogradeplanets

            PlanetPosition(
                planet = planet,
                longitude = sidereal,
                rashi = rashi,
                rashiDegree = rashiDeg,
                nakshatra = nakshatra,
                nakshatraPada = pada,
                house = house,
                isRetrograde = retrograde,
                isCombust = combust,
                isExalted = exalted,
                isDebilitated = debilitated
            )
        }
    }

    fun calculateVimshottariDasha(
        moonNakshatra: Int,
        birthDate: Date,
        moonLongitudeSidereal: Double
    ): List<DashaPeriod> {
        val dashaOrder = Constants.DASHA_ORDER
        val dashaYears = Constants.DASHA_YEARS

        // Find starting dasha lord based on nakshatra
        val nakshatraIndex = moonNakshatra % 9
        val startDashaIndex = nakshatraIndex

        // Calculate elapsed time in nakshatra
        val nakshatraSpan = 360.0 / 27.0
        val nakshatraStart = moonNakshatra * nakshatraSpan
        val elapsed = moonLongitudeSidereal - nakshatraStart
        val fraction = elapsed / nakshatraSpan
        val startYears = dashaYears[startDashaIndex]
        val elapsedYears = fraction * startYears
        val remainingYears = startYears - elapsedYears

        val calendar = Calendar.getInstance()
        calendar.time = birthDate

        val result = mutableListOf<DashaPeriod>()
        var currentIndex = startDashaIndex
        var isFirst = true

        repeat(dashaOrder.size) {
            val planet = dashaOrder[currentIndex]
            val years = dashaYears[currentIndex]
            val actualYears = if (isFirst) remainingYears else years.toDouble()

            val start = calendar.time
            calendar.add(Calendar.DAY_OF_YEAR, (actualYears * 365.25).toInt())
            val end = calendar.time

            val antarDashas = calculateAntarDasha(planet, start, end, currentIndex)
            result.add(DashaPeriod(planet, start, end, years, antarDashas))

            isFirst = false
            currentIndex = (currentIndex + 1) % dashaOrder.size
        }

        return result
    }

    private fun calculateAntarDasha(
        mahadashaLord: String,
        startDate: Date,
        endDate: Date,
        mahaIndex: Int
    ): List<DashaPeriod> {
        val totalMs = endDate.time - startDate.time
        val antarDashas = mutableListOf<DashaPeriod>()
        var currentTime = startDate.time
        val dashaYears = Constants.DASHA_YEARS
        val totalMahaYears = dashaYears[mahaIndex].toDouble()

        for (i in Constants.DASHA_ORDER.indices) {
            val idx = (mahaIndex + i) % Constants.DASHA_ORDER.size
            val antarPlanet = Constants.DASHA_ORDER[idx]
            val antarYears = dashaYears[idx].toDouble()
            val fraction = antarYears / totalMahaYears
            val durationMs = (totalMs * fraction).toLong()
            val endTime = currentTime + durationMs

            antarDashas.add(
                DashaPeriod(
                    planet = antarPlanet,
                    startDate = Date(currentTime),
                    endDate = Date(endTime),
                    years = dashaYears[idx]
                )
            )
            currentTime = endTime
        }
        return antarDashas
    }

    fun detectYogas(planets: List<PlanetPosition>, lagnaRashi: Int): List<KundliYoga> {
        val yogas = mutableListOf<KundliYoga>()
        val planetMap = planets.associateBy { it.planet }

        // Gaja Kesari Yoga: Jupiter in kendra from Moon
        val jupiter = planetMap["Jupiter"]
        val moon = planetMap["Moon"]
        if (jupiter != null && moon != null) {
            val kendraFromMoon = listOf(1, 4, 7, 10)
            val houseFromMoon = ((jupiter.house - moon.house + 12) % 12) + 1
            val isGajaKesari = houseFromMoon in kendraFromMoon
            yogas.add(
                KundliYoga(
                    "Gaja Kesari Yoga",
                    "Jupiter in kendra from Moon brings wisdom, wealth and fame.",
                    isGajaKesari,
                    listOf("Jupiter", "Moon")
                )
            )
        }

        // Raj Yoga: lords of kendra and trikona conjunct or exchange
        val sun = planetMap["Sun"]
        if (jupiter != null && sun != null) {
            val isRajYoga = jupiter.house == sun.house || (jupiter.rashi == lagnaRashi)
            yogas.add(
                KundliYoga(
                    "Raj Yoga",
                    "Combination of lords of kendra and trikona bestows power and authority.",
                    isRajYoga,
                    listOf("Jupiter", "Sun")
                )
            )
        }

        // Budha Aditya Yoga: Mercury conjunct Sun
        val mercury = planetMap["Mercury"]
        if (mercury != null && sun != null) {
            val isBudhaAditya = mercury.house == sun.house
            yogas.add(
                KundliYoga(
                    "Budha Aditya Yoga",
                    "Mercury conjunct Sun brings intelligence, communication skills and success in education.",
                    isBudhaAditya,
                    listOf("Mercury", "Sun")
                )
            )
        }

        // Shasha Yoga: Saturn in own sign or exaltation in kendra
        val saturn = planetMap["Saturn"]
        if (saturn != null) {
            val isShashaRashi = saturn.rashi in listOf(6, 7, 9) // Libra, Scorpio, Capricorn
            val isKendra = saturn.house in listOf(1, 4, 7, 10)
            val isShasha = (isShashaRashi) && isKendra
            yogas.add(
                KundliYoga(
                    "Shasha Yoga",
                    "Saturn in own sign or exaltation in kendra gives authority and longevity.",
                    isShasha,
                    listOf("Saturn")
                )
            )
        }

        // Hamsa Yoga: Jupiter in own sign or exaltation in kendra
        if (jupiter != null) {
            val isJupiterStrong = jupiter.rashi in listOf(8, 11, 3) // Sagittarius, Pisces, Cancer
            val isKendra = jupiter.house in listOf(1, 4, 7, 10)
            val isHamsa = isJupiterStrong && isKendra
            yogas.add(
                KundliYoga(
                    "Hamsa Yoga",
                    "Jupiter in own sign or exaltation in kendra bestows wisdom and spiritual knowledge.",
                    isHamsa,
                    listOf("Jupiter")
                )
            )
        }

        // Malavya Yoga: Venus in own sign or exaltation in kendra
        val venus = planetMap["Venus"]
        if (venus != null) {
            val isVenusStrong = venus.rashi in listOf(1, 6, 11) // Taurus, Libra, Pisces
            val isKendra = venus.house in listOf(1, 4, 7, 10)
            val isMalavya = isVenusStrong && isKendra
            yogas.add(
                KundliYoga(
                    "Malavya Yoga",
                    "Venus in own sign or exaltation in kendra brings beauty, wealth and marital bliss.",
                    isMalavya,
                    listOf("Venus")
                )
            )
        }

        // Chandra Mangala Yoga: Moon and Mars conjunct
        val mars = planetMap["Mars"]
        if (moon != null && mars != null) {
            val isChandraMangala = moon.house == mars.house
            yogas.add(
                KundliYoga(
                    "Chandra Mangala Yoga",
                    "Moon and Mars conjunct gives financial gains and business acumen.",
                    isChandraMangala,
                    listOf("Moon", "Mars")
                )
            )
        }

        // Kemadruma Yoga: No planets in 2nd or 12th from Moon
        if (moon != null) {
            val moonHouse = moon.house
            val secondFromMoon = (moonHouse % 12) + 1
            val twelfthFromMoon = ((moonHouse - 2 + 12) % 12) + 1
            val hasKemadruma = planets.none { p ->
                p.planet !in listOf("Moon", "Rahu", "Ketu") &&
                        (p.house == secondFromMoon || p.house == twelfthFromMoon)
            }
            yogas.add(
                KundliYoga(
                    "Kemadruma Yoga",
                    "No planets on either side of Moon causes challenges and hardships in life.",
                    hasKemadruma,
                    listOf("Moon")
                )
            )
        }

        return yogas
    }
}
