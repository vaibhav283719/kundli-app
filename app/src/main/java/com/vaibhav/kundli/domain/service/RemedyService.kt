package com.vaibhav.kundli.domain.service

import com.vaibhav.kundli.domain.model.Remedy
import java.util.UUID
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class RemedyService @Inject constructor() {

    private val remedies = listOf(
        // Career
        Remedy(UUID.randomUUID().toString(), "Donate Red Lentils on Tuesday",
            "Donate red lentils (masoor dal) to needy people on Tuesday. This appeases Mars and removes obstacles from career path. Do this for 7 consecutive Tuesdays for best results.",
            "Mars", "Career", "Easy"),
        Remedy(UUID.randomUUID().toString(), "Recite Surya Mantra at Sunrise",
            "Chant 'Om Hraam Hreem Hraum Sah Suryaya Namah' 108 times daily at sunrise facing east. This strengthens Sun and boosts authority, recognition and career success.",
            "Sun", "Career", "Medium"),
        Remedy(UUID.randomUUID().toString(), "Wear Yellow Sapphire for Jupiter Blessings",
            "Wear a natural Yellow Sapphire (Pukhraj) of minimum 3 carats in gold ring on index finger of right hand on Thursday morning. This invokes Jupiter's blessings for career growth.",
            "Jupiter", "Career", "Hard"),
        Remedy(UUID.randomUUID().toString(), "Offer Water to Sun Daily",
            "Offer water from a copper vessel to the rising Sun every morning. Chant Sun's name while offering. This removes career obstacles and brings recognition.",
            "Sun", "Career", "Easy"),
        Remedy(UUID.randomUUID().toString(), "Feed Green Grass to Cows on Wednesday",
            "Offer fresh green grass to cows every Wednesday. This strengthens Mercury and improves communication skills, business acumen and career prospects.",
            "Mercury", "Career", "Easy"),

        // Health
        Remedy(UUID.randomUUID().toString(), "Offer Water to Sun at Sunrise",
            "Every morning, stand facing east and pour water from a copper vessel towards the Sun. This strengthens vitality, boosts immunity and overall health.",
            "Sun", "Health", "Easy"),
        Remedy(UUID.randomUUID().toString(), "Fast on Saturdays for Saturn",
            "Observe fast on Saturdays consuming only fruits and one meal. This appeases Saturn and reduces chronic ailments, joint problems and digestive issues.",
            "Saturn", "Health", "Medium"),
        Remedy(UUID.randomUUID().toString(), "Wear Red Coral for Mars Energy",
            "Wear a natural Red Coral (Moonga) of minimum 5 carats in copper or gold ring on ring finger of right hand. This boosts vitality, reduces blood disorders and strengthens constitution.",
            "Mars", "Health", "Hard"),
        Remedy(UUID.randomUUID().toString(), "Recite Mahamrityunjaya Mantra",
            "Chant 'Om Tryambakam Yajamahe Sugandhim Pushtivardhanam...' 108 times daily for health protection. Best chanted at dawn for maximum benefit.",
            "Moon", "Health", "Medium"),
        Remedy(UUID.randomUUID().toString(), "Donate Yellow Items on Thursday",
            "Donate yellow clothes, yellow food items like turmeric, chana dal on Thursdays. This strengthens Jupiter and improves liver health, immunity and overall wellbeing.",
            "Jupiter", "Health", "Easy"),

        // Marriage
        Remedy(UUID.randomUUID().toString(), "Perform Rudrabhishek on Mondays",
            "Perform Rudrabhishek puja on Mondays with milk, honey and water. Offer white flowers to Lord Shiva. This removes marriage obstacles and ensures marital bliss.",
            "Moon", "Marriage", "Hard"),
        Remedy(UUID.randomUUID().toString(), "Donate White Items on Friday",
            "Donate white rice, white clothes, milk or sweets to needy women on Friday. This appeases Venus and removes obstacles in marriage. Do for 7 consecutive Fridays.",
            "Venus", "Marriage", "Easy"),
        Remedy(UUID.randomUUID().toString(), "Recite Gayatri Mantra 108 Times Daily",
            "Chant the Gayatri Mantra 108 times every morning after bath. This purifies the aura, improves marriage prospects and brings a compatible life partner.",
            "Sun", "Marriage", "Medium"),
        Remedy(UUID.randomUUID().toString(), "Wear Diamond or White Sapphire",
            "Wear a natural Diamond or White Sapphire in silver ring on middle finger of right hand on Friday morning. This strengthens Venus for marital happiness.",
            "Venus", "Marriage", "Hard"),
        Remedy(UUID.randomUUID().toString(), "Perform Mangal Dosha Remedies",
            "If having Mangal Dosha, perform special puja at Mangal temple on Tuesday. Offer red items, red flowers and sindoor to Lord Hanuman to neutralize effects.",
            "Mars", "Marriage", "Medium"),

        // Finance
        Remedy(UUID.randomUUID().toString(), "Offer Green Grass to Cow on Wednesday",
            "Feed green grass or vegetables to a cow every Wednesday. This pleases Mercury and improves financial intelligence, business success and overall wealth.",
            "Mercury", "Finance", "Easy"),
        Remedy(UUID.randomUUID().toString(), "Donate Yellow Items on Thursday",
            "Donate yellow colored items such as yellow cloth, turmeric, yellow sweets to Brahmins on Thursday. This appeases Jupiter for financial growth.",
            "Jupiter", "Finance", "Easy"),
        Remedy(UUID.randomUUID().toString(), "Keep Silver Coin in Wallet",
            "Keep a pure silver coin in your wallet or purse. Change it with a new one on every Diwali. This attracts Moon's blessings for financial stability and wealth accumulation.",
            "Moon", "Finance", "Easy"),
        Remedy(UUID.randomUUID().toString(), "Perform Lakshmi Puja on Friday",
            "Worship Goddess Lakshmi every Friday evening with lotus flowers, sweets and incense. Light a ghee lamp. This invokes divine blessings for wealth and prosperity.",
            "Venus", "Finance", "Medium"),
        Remedy(UUID.randomUUID().toString(), "Recite Kubera Mantra for Wealth",
            "Chant 'Om Yakshaya Kuberaya Vaishravanaya Dhan Dhanyadi Padayeh...' 108 times on Thursdays. This invokes Kubera, the god of wealth, for financial abundance.",
            "Jupiter", "Finance", "Medium"),

        // Education
        Remedy(UUID.randomUUID().toString(), "Recite Saraswati Vandana Daily",
            "Chant 'Ya Devi Sarvabhuteshu Vidya Rupena Sansthita...' every morning before studying. This invokes Goddess Saraswati's blessings for intelligence and learning.",
            "Mercury", "Education", "Easy"),
        Remedy(UUID.randomUUID().toString(), "Offer Green Items to Mercury on Wednesday",
            "Offer green moong dal, green cloth or emerald colored items to the needy on Wednesday. This strengthens Mercury for academic success, memory and concentration.",
            "Mercury", "Education", "Easy"),
        Remedy(UUID.randomUUID().toString(), "Wear Emerald for Mercury Strength",
            "Wear a natural Emerald (Panna) of minimum 3 carats in gold or silver ring on little finger on Wednesday morning. This boosts Mercury for enhanced intellect and academic excellence.",
            "Mercury", "Education", "Hard"),
        Remedy(UUID.randomUUID().toString(), "Study Facing East Direction",
            "Always sit facing east while studying. Place a Saraswati Yantra on your study table and light incense before starting studies. This improves focus and retention.",
            "Mercury", "Education", "Easy"),
        Remedy(UUID.randomUUID().toString(), "Perform Vidyarambha Samskara",
            "Visit a Saraswati temple and perform special puja before starting new courses or examinations. Offer white flowers and sweets. This ensures divine guidance in education.",
            "Jupiter", "Education", "Medium"),

        // Family
        Remedy(UUID.randomUUID().toString(), "Light Lamp Under Peepal Tree on Saturday",
            "Light a sesame oil lamp under a Peepal tree on Saturdays in the evening. Circle the tree 7 times chanting Saturn's mantra. This removes ancestral curses and brings family harmony.",
            "Saturn", "Family", "Medium"),
        Remedy(UUID.randomUUID().toString(), "Perform Satyanarayan Katha",
            "Organize Satyanarayan Puja with family on full moon day or on auspicious occasions. This invokes Vishnu's blessings for family prosperity, unity and happiness.",
            "Jupiter", "Family", "Medium"),
        Remedy(UUID.randomUUID().toString(), "Feed Crows on Saturday",
            "Offer cooked rice mixed with sesame seeds and mustard oil to crows every Saturday. Crows are connected to ancestors and Saturn. This brings peace to departed souls and harmony to living family.",
            "Saturn", "Family", "Easy"),
        Remedy(UUID.randomUUID().toString(), "Perform Pitru Tarpan on Amavasya",
            "Offer water, black sesame seeds and white flowers to ancestors on every new moon day (Amavasya). Recite ancestor prayers to receive their blessings for family wellbeing.",
            "Saturn", "Family", "Hard"),
        Remedy(UUID.randomUUID().toString(), "Plant Tulsi at Home",
            "Plant and maintain a Tulsi plant in your home, preferably in the north or northeast direction. Water it daily and light a lamp near it every evening. This purifies home energy and protects family health.",
            "Moon", "Family", "Easy"),

        // Spiritual
        Remedy(UUID.randomUUID().toString(), "Meditate at Sunrise",
            "Practice 20-30 minutes of meditation daily at sunrise facing east. Focus on your breath and inner light. This connects you with divine consciousness and accelerates spiritual growth.",
            "Sun", "Spiritual", "Medium"),
        Remedy(UUID.randomUUID().toString(), "Recite Vishnu Sahasranama",
            "Chant all 1000 names of Lord Vishnu daily or on Thursdays. This creates powerful vibrations that purify the mind, dissolve karma and bring spiritual liberation.",
            "Jupiter", "Spiritual", "Hard"),
        Remedy(UUID.randomUUID().toString(), "Perform Charity on Full Moon Day",
            "Donate food, clothes or money to those in need on every full moon (Purnima) day. This generates powerful positive karma, weakens negative planetary influences and accelerates spiritual progress.",
            "Moon", "Spiritual", "Easy"),
        Remedy(UUID.randomUUID().toString(), "Observe Ekadashi Fast",
            "Fast on Ekadashi (11th day of lunar fortnight) by consuming only fruits and water. Spend the day in prayer and spiritual reading. This purifies the mind and body.",
            "Jupiter", "Spiritual", "Medium"),
        Remedy(UUID.randomUUID().toString(), "Perform Surya Namaskar Daily",
            "Practice 12 rounds of Surya Namaskar every morning. This physical and spiritual practice harmonizes solar energy, strengthens the body and aligns you with divine light.",
            "Sun", "Spiritual", "Medium")
    )

    fun getAllRemedies(): List<Remedy> = remedies

    fun getRemediesByCategory(category: String): List<Remedy> =
        remedies.filter { it.category == category }

    fun getRemediesByPlanet(planet: String): List<Remedy> =
        remedies.filter { it.planet == planet }

    fun getCategories(): List<String> =
        listOf("Career", "Health", "Marriage", "Finance", "Education", "Family", "Spiritual")

    fun getRemedyById(id: String): Remedy? = remedies.find { it.id == id }
}
