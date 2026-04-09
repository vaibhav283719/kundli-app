package com.vaibhav.kundli.domain.calculator

import com.vaibhav.kundli.domain.model.CompatibilityResult
import com.vaibhav.kundli.domain.model.KootaResult
import java.util.Date

object GunMilanCalculator {

    private val nakshatraVarna = intArrayOf(2,3,1,2,1,3,0,2,3,1,2,1,3,2,1,0,2,3,3,1,2,1,2,3,0,2,1)
    private val nakshatraVashya = intArrayOf(0,4,1,0,0,4,2,2,2,3,3,3,1,1,1,3,3,3,0,0,0,1,2,4,4,4,0)
    private val nakshatraYoni = intArrayOf(0,7,7,11,11,13,13,5,5,8,8,3,3,6,6,4,4,9,9,12,12,10,10,2,2,0,14)
    private val yoniGender = intArrayOf(0,1,0,1,0,1,0,1,0,1,0,1,0,1,0)

    // Friendly yoni pairs
    private val friendlyYoniPairs = setOf(
        Pair(0,0), Pair(1,1), Pair(2,2), Pair(3,3), Pair(4,4), Pair(5,5),
        Pair(6,6), Pair(7,7), Pair(8,8), Pair(9,9), Pair(10,10), Pair(11,11),
        Pair(12,12), Pair(13,13), Pair(14,14)
    )
    private val enemyYoniPairs = setOf(
        Pair(0,7), Pair(7,0), Pair(1,6), Pair(6,1), Pair(2,8), Pair(8,2),
        Pair(3,9), Pair(9,3), Pair(4,10), Pair(10,4), Pair(5,11), Pair(11,5)
    )

    private val nakshatraGana = intArrayOf(0,2,0,1,0,2,0,0,2,2,1,0,0,2,0,1,0,2,2,1,0,0,1,2,0,0,0)
    private val nakshatraNadi = intArrayOf(0,0,0,1,1,1,2,2,2,0,0,0,1,1,1,2,2,2,0,0,0,1,1,1,2,2,2)

    // Planet lords for each nakshatra (for Graha Maitri)
    private val nakshatraLord = intArrayOf(
        7,0,1,2,6,3,4,5,8, // 0-8: Ketu,Venus,Sun,Moon,Mars,Rahu,Jupiter,Saturn,Mercury
        7,0,1,2,6,3,4,5,8,
        7,0,1,2,6,3,4,5,8
    )

    // Planet friendship matrix [planet1][planet2]: 2=friend, 1=neutral, 0=enemy
    private val planetFriendship = arrayOf(
        //Su Mo Ma Me Ju Ve Sa Ra Ke
        intArrayOf(0, 2, 2, 1, 2, 0, 0, 0, 0), // Sun
        intArrayOf(2, 0, 0, 1, 2, 2, 0, 0, 0), // Moon
        intArrayOf(2, 2, 0, 0, 2, 0, 1, 0, 0), // Mars
        intArrayOf(2, 0, 1, 0, 0, 2, 1, 0, 0), // Mercury
        intArrayOf(2, 2, 2, 0, 0, 0, 0, 0, 0), // Jupiter
        intArrayOf(0, 2, 0, 2, 1, 0, 2, 0, 0), // Venus
        intArrayOf(0, 0, 1, 2, 1, 2, 0, 0, 0), // Saturn
        intArrayOf(0, 0, 2, 2, 1, 2, 2, 0, 0), // Rahu
        intArrayOf(2, 1, 2, 1, 2, 0, 1, 0, 0)  // Ketu
    )

    fun calculate(
        person1Name: String, person1Nakshatra: Int,
        person2Name: String, person2Nakshatra: Int
    ): CompatibilityResult {
        val n1 = person1Nakshatra % 27
        val n2 = person2Nakshatra % 27

        val kootaResults = listOf(
            calculateVarna(n1, n2),
            calculateVashya(n1, n2),
            calculateTara(n1, n2),
            calculateYoni(n1, n2),
            calculateGrahaMaitri(n1, n2),
            calculateGana(n1, n2),
            calculateBhakoot(n1, n2),
            calculateNadi(n1, n2)
        )

        return CompatibilityResult(
            person1Name = person1Name,
            person1Nakshatra = person1Nakshatra,
            person2Name = person2Name,
            person2Nakshatra = person2Nakshatra,
            kootaResults = kootaResults,
            calculatedAt = Date()
        )
    }

    private fun calculateVarna(n1: Int, n2: Int): KootaResult {
        val groomVarna = nakshatraVarna[n1]
        val brideVarna = nakshatraVarna[n2]
        val points = if (groomVarna >= brideVarna) 1 else 0
        val varnaNames = listOf("Shudra", "Vaishya", "Kshatriya", "Brahmin")
        return KootaResult(
            name = "Varna",
            maxPoints = 1,
            obtainedPoints = points,
            description = "Groom: ${varnaNames[groomVarna]}, Bride: ${varnaNames[brideVarna]}. Spiritual compatibility.",
            isCompatible = points == 1
        )
    }

    private fun calculateVashya(n1: Int, n2: Int): KootaResult {
        val v1 = nakshatraVashya[n1]
        val v2 = nakshatraVashya[n2]
        val vashyaNames = listOf("Manav", "Chatushpad", "Jalchar", "Vanchar", "Keeta")
        val points = when {
            v1 == v2 -> 2
            isFriendlyVashya(v1, v2) -> 1
            else -> 0
        }
        return KootaResult(
            name = "Vashya",
            maxPoints = 2,
            obtainedPoints = points,
            description = "Person1: ${vashyaNames.getOrElse(v1){"Unknown"}}, Person2: ${vashyaNames.getOrElse(v2){"Unknown"}}. Dominance and control compatibility.",
            isCompatible = points >= 1
        )
    }

    private fun isFriendlyVashya(v1: Int, v2: Int): Boolean {
        val friendlyPairs = setOf(Pair(0,1), Pair(1,0), Pair(2,3), Pair(3,2))
        return Pair(v1,v2) in friendlyPairs
    }

    private fun calculateTara(n1: Int, n2: Int): KootaResult {
        val diff = ((n2 - n1) + 27) % 27
        val taraGroup = diff % 9 + 1
        val auspicious = taraGroup in listOf(1, 3, 5, 7)
        val points = if (auspicious) 3 else 0
        return KootaResult(
            name = "Tara",
            maxPoints = 3,
            obtainedPoints = points,
            description = "Tara group $taraGroup. ${if (auspicious) "Auspicious" else "Inauspicious"} for long-term prosperity.",
            isCompatible = auspicious
        )
    }

    private fun calculateYoni(n1: Int, n2: Int): KootaResult {
        val y1 = nakshatraYoni[n1]
        val y2 = nakshatraYoni[n2]
        val g1 = yoniGender.getOrElse(y1) { 0 }
        val g2 = yoniGender.getOrElse(y2) { 0 }

        val points = when {
            y1 == y2 && g1 != g2 -> 4 // Same yoni, opposite gender
            y1 == y2 -> 3             // Same yoni, same gender
            Pair(y1,y2) in friendlyYoniPairs -> 2
            Pair(y1,y2) in enemyYoniPairs -> 0
            else -> 1
        }
        return KootaResult(
            name = "Yoni",
            maxPoints = 4,
            obtainedPoints = points,
            description = "Sexual and physical compatibility. Score: $points/4.",
            isCompatible = points >= 2
        )
    }

    private fun calculateGrahaMaitri(n1: Int, n2: Int): KootaResult {
        val lord1 = nakshatraLord[n1] % planetFriendship.size
        val lord2 = nakshatraLord[n2] % planetFriendship.size

        val friendship12 = planetFriendship[lord1][lord2]
        val friendship21 = planetFriendship[lord2][lord1]

        val points = when {
            friendship12 == 2 && friendship21 == 2 -> 5
            friendship12 == 2 || friendship21 == 2 -> 4
            friendship12 == 1 && friendship21 == 1 -> 3
            friendship12 == 1 || friendship21 == 1 -> 1
            else -> 0
        }
        return KootaResult(
            name = "Graha Maitri",
            maxPoints = 5,
            obtainedPoints = points,
            description = "Planetary friendship and mental compatibility.",
            isCompatible = points >= 3
        )
    }

    private fun calculateGana(n1: Int, n2: Int): KootaResult {
        val g1 = nakshatraGana[n1]
        val g2 = nakshatraGana[n2]
        val ganaNames = listOf("Deva", "Manav", "Rakshasa")

        val points = when {
            g1 == g2 -> 6
            (g1 == 0 && g2 == 1) || (g1 == 1 && g2 == 0) -> 5
            (g1 == 1 && g2 == 2) || (g1 == 2 && g2 == 1) -> 1
            else -> 0
        }
        return KootaResult(
            name = "Gana",
            maxPoints = 6,
            obtainedPoints = points,
            description = "Person1: ${ganaNames[g1]}, Person2: ${ganaNames[g2]}. Temperament compatibility.",
            isCompatible = points >= 4
        )
    }

    private fun calculateBhakoot(n1: Int, n2: Int): KootaResult {
        val rashi1 = (n1 / 2.25).toInt() % 12
        val rashi2 = (n2 / 2.25).toInt() % 12

        val diff = ((rashi2 - rashi1) + 12) % 12 + 1
        val inauspicious = diff in listOf(2, 6, 8, 9, 12) // 2-12, 6-8, 5-9 patterns
        val actualDiff2 = ((rashi1 - rashi2) + 12) % 12 + 1

        val hasInauspiciousCombination = when {
            (diff == 2 && actualDiff2 == 12) || (diff == 12 && actualDiff2 == 2) -> true
            (diff == 6 && actualDiff2 == 8) || (diff == 8 && actualDiff2 == 6) -> true
            (diff == 5 && actualDiff2 == 9) || (diff == 9 && actualDiff2 == 5) -> true
            else -> false
        }

        val points = if (hasInauspiciousCombination) 0 else 7
        return KootaResult(
            name = "Bhakoot",
            maxPoints = 7,
            obtainedPoints = points,
            description = "Rashi relationship for overall health and family prosperity.",
            isCompatible = points == 7
        )
    }

    private fun calculateNadi(n1: Int, n2: Int): KootaResult {
        val nadi1 = nakshatraNadi[n1]
        val nadi2 = nakshatraNadi[n2]
        val nadiNames = listOf("Adi (Vata)", "Madhya (Pitta)", "Antya (Kapha)")
        val points = if (nadi1 != nadi2) 8 else 0
        return KootaResult(
            name = "Nadi",
            maxPoints = 8,
            obtainedPoints = points,
            description = "Person1: ${nadiNames[nadi1]}, Person2: ${nadiNames[nadi2]}. Health and progeny compatibility.",
            isCompatible = nadi1 != nadi2
        )
    }

    fun getTotalScore(result: CompatibilityResult): Int = result.kootaResults.sumOf { it.obtainedPoints }
    fun getMaxScore(): Int = 36
}
