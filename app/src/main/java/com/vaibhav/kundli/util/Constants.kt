package com.vaibhav.kundli.util

object Constants {
    // Preferences
    const val PREF_NAME = "kundli_prefs"
    const val KEY_IS_LOGGED_IN = "is_logged_in"
    const val KEY_USER_ID = "user_id"
    const val KEY_USER_NAME = "user_name"
    const val KEY_USER_EMAIL = "user_email"
    const val KEY_THEME = "theme"
    const val KEY_LANGUAGE = "language"
    const val KEY_NOTIFICATIONS = "notifications"
    const val KEY_IS_PREMIUM = "is_premium"

    // Theme values
    const val THEME_DARK = "dark"
    const val THEME_LIGHT = "light"
    const val THEME_SYSTEM = "system"

    // Language values
    const val LANG_ENGLISH = "en"
    const val LANG_HINDI = "hi"

    val ZODIAC_SIGNS = listOf(
        "Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo",
        "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces"
    )

    val ZODIAC_SIGNS_HINDI = listOf(
        "मेष", "वृषभ", "मिथुन", "कर्क", "सिंह", "कन्या",
        "तुला", "वृश्चिक", "धनु", "मकर", "कुम्भ", "मीन"
    )

    val ZODIAC_SYMBOLS = listOf(
        "♈", "♉", "♊", "♋", "♌", "♍",
        "♎", "♏", "♐", "♑", "♒", "♓"
    )

    val NAKSHATRAS = listOf(
        "Ashwini", "Bharani", "Krittika", "Rohini", "Mrigashira", "Ardra",
        "Punarvasu", "Pushya", "Ashlesha", "Magha", "Purva Phalguni", "Uttara Phalguni",
        "Hasta", "Chitra", "Swati", "Vishakha", "Anuradha", "Jyeshtha",
        "Moola", "Purva Ashadha", "Uttara Ashadha", "Shravana", "Dhanishtha",
        "Shatabhisha", "Purva Bhadrapada", "Uttara Bhadrapada", "Revati"
    )

    val PLANETS = listOf("Sun", "Moon", "Mars", "Mercury", "Jupiter", "Venus", "Saturn", "Rahu", "Ketu")

    val PLANETS_HINDI = listOf(
        "सूर्य", "चंद्र", "मंगल", "बुध", "गुरु", "शुक्र", "शनि", "राहु", "केतु"
    )

    val PLANET_ABBREVIATIONS = mapOf(
        "Sun" to "Su", "Moon" to "Mo", "Mars" to "Ma", "Mercury" to "Me",
        "Jupiter" to "Ju", "Venus" to "Ve", "Saturn" to "Sa", "Rahu" to "Ra", "Ketu" to "Ke"
    )

    val HOUSES = listOf(
        "Lagna (Ascendant)", "Dhana (Wealth)", "Sahaja (Siblings)", "Sukha (Happiness)",
        "Putra (Children)", "Ripu (Enemies)", "Kalatra (Spouse)", "Mrityu (Death)",
        "Bhagya (Fortune)", "Karma (Career)", "Labha (Gains)", "Vyaya (Expenditure)"
    )

    val DASHA_ORDER = listOf("Ketu", "Venus", "Sun", "Moon", "Mars", "Rahu", "Jupiter", "Saturn", "Mercury")
    val DASHA_YEARS = listOf(7, 20, 6, 10, 7, 18, 16, 19, 17)

    val PLANET_GEMSTONES = mapOf(
        "Sun" to "Ruby (Manik)",
        "Moon" to "Pearl (Moti)",
        "Mars" to "Red Coral (Moonga)",
        "Mercury" to "Emerald (Panna)",
        "Jupiter" to "Yellow Sapphire (Pukhraj)",
        "Venus" to "Diamond (Heera)",
        "Saturn" to "Blue Sapphire (Neelam)",
        "Rahu" to "Hessonite (Gomed)",
        "Ketu" to "Cat's Eye (Lehsunia)"
    )

    val RASHI_NAMES = listOf(
        "Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo",
        "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces"
    )

    // Common cities for birth place
    val COMMON_CITIES = mapOf(
        "Mumbai" to Pair(19.0760, 72.8777),
        "Delhi" to Pair(28.7041, 77.1025),
        "Bangalore" to Pair(12.9716, 77.5946),
        "Chennai" to Pair(13.0827, 80.2707),
        "Kolkata" to Pair(22.5726, 88.3639),
        "Hyderabad" to Pair(17.3850, 78.4867),
        "Pune" to Pair(18.5204, 73.8567),
        "Ahmedabad" to Pair(23.0225, 72.5714),
        "Jaipur" to Pair(26.9124, 75.7873),
        "Lucknow" to Pair(26.8467, 80.9462)
    )
}
