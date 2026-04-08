package com.vaibhav.kundli.domain.service

import com.vaibhav.kundli.domain.model.HoroscopeData
import com.vaibhav.kundli.util.Constants
import java.util.*
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class HoroscopeService @Inject constructor() {

    private val luckyNumbers = listOf(9, 6, 5, 2, 1, 5, 6, 9, 3, 8, 4, 7)
    private val luckyColors = listOf("Red", "Green", "Yellow", "White", "Gold", "Navy Blue",
        "Pink", "Maroon", "Orange", "Black", "Electric Blue", "Sea Green")
    private val luckyGems = listOf("Ruby", "Emerald", "Agate", "Pearl", "Ruby", "Emerald",
        "Diamond", "Red Coral", "Yellow Sapphire", "Blue Sapphire", "Amethyst", "Pearl")

    private val compatibleSigns = listOf(
        listOf("Leo", "Sagittarius", "Gemini"),
        listOf("Virgo", "Capricorn", "Cancer"),
        listOf("Libra", "Aquarius", "Aries"),
        listOf("Scorpio", "Pisces", "Taurus"),
        listOf("Aries", "Sagittarius", "Gemini"),
        listOf("Taurus", "Capricorn", "Cancer"),
        listOf("Gemini", "Aquarius", "Leo"),
        listOf("Cancer", "Pisces", "Virgo"),
        listOf("Leo", "Aries", "Aquarius"),
        listOf("Virgo", "Taurus", "Scorpio"),
        listOf("Libra", "Gemini", "Sagittarius"),
        listOf("Scorpio", "Cancer", "Capricorn")
    )

    private val dailyPredictions = mapOf(
        "Aries" to listOf(
            "A new opportunity presents itself today. Seize it with confidence and enthusiasm. Your natural leadership will guide you well.",
            "Financial matters require careful attention today. Avoid impulsive spending and focus on long-term goals.",
            "Your energy levels are high today. Channel this into productive activities and avoid unnecessary conflicts.",
            "Travel or communication brings good news. Stay open to unexpected connections that could benefit your career.",
            "Focus on self-care and wellness today. Rest and reflection will lead to important insights about your life path."
        ),
        "Taurus" to listOf(
            "Stability is your strength today. Financial investments made now will yield good returns in the future.",
            "Relationships need nurturing. Spend quality time with loved ones and express your feelings openly.",
            "A creative project demands your attention. Your practical approach will turn visions into reality.",
            "Health and diet need focus. A small change in your routine will lead to significant improvements.",
            "Trust your instincts in professional matters. Your judgment is sound and colleagues respect your opinion."
        ),
        "Gemini" to listOf(
            "Communication is your superpower today. Use it wisely in both personal and professional settings.",
            "Mental agility helps you solve a complex problem. Share your ideas freely; they'll be well-received.",
            "A social gathering brings unexpected opportunities. Networking opens new doors for career advancement.",
            "Dual energies may cause indecision. Make a firm choice and stick with it for best results.",
            "Creative inspiration strikes strongly today. Document your ideas before they slip away."
        ),
        "Cancer" to listOf(
            "Home and family matters take center stage. Emotional bonds are strengthened through honest conversation.",
            "Intuition guides you correctly today. Trust those gut feelings, especially in financial decisions.",
            "A nurturing gesture towards a friend or family member creates lasting positive karma in your life.",
            "Career opportunities connected to your caring nature emerge. Consider roles where you help others.",
            "Emotions run deep today. Allow yourself to feel without judgment, but maintain perspective."
        ),
        "Leo" to listOf(
            "Your charisma attracts positive attention today. Step into the spotlight with confidence and grace.",
            "Creative endeavors receive recognition. Share your talents generously and watch your reputation grow.",
            "Leadership is called for in a group situation. Your natural authority inspires others to follow.",
            "Romance is highlighted today. Express your feelings boldly and generously for best results.",
            "Financial generosity pays dividends. Give back to those who have supported your journey."
        ),
        "Virgo" to listOf(
            "Attention to detail serves you well today. A thorough approach to work earns appreciation from superiors.",
            "Health routines established today will have lasting benefits. Small consistent efforts compound over time.",
            "Analytical skills help solve a problem others have struggled with. Your expertise is invaluable.",
            "Service to others brings deep satisfaction. Volunteering or helping a friend lifts your own spirits.",
            "Organization and planning for upcoming events reduces stress. Your methodical approach ensures success."
        ),
        "Libra" to listOf(
            "Balance and harmony in relationships are your focus today. Diplomacy resolves a long-standing conflict.",
            "Aesthetic sensibilities are heightened. Artistic pursuits bring joy and creative breakthroughs.",
            "Partnerships, both personal and professional, are favored. Collaboration yields better results than solo efforts.",
            "Justice matters occupy your thoughts. Standing up for fairness earns respect from peers.",
            "Social grace and charm open doors. An important introduction at a social event changes your trajectory."
        ),
        "Scorpio" to listOf(
            "Deep transformation is underway. Embrace change rather than resisting it for personal growth.",
            "Research and investigation bring hidden truths to light. Knowledge gained now proves valuable later.",
            "Intensity in relationships can be channeled productively. Passion directed into creative work yields masterpieces.",
            "Financial acumen is sharp today. Complex investment strategies or negotiations favor you.",
            "Spiritual insights arrive through meditation or dreams. Pay attention to symbolic messages from your subconscious."
        ),
        "Sagittarius" to listOf(
            "Adventure and exploration call to your spirit. Even a mental journey through books broadens your horizons.",
            "Philosophical discussions and higher learning bring fulfillment. Share your wisdom with those who seek it.",
            "Optimism is your greatest asset today. Your positive outlook inspires and motivates those around you.",
            "Travel plans or educational pursuits move forward favorably. Take the next step with enthusiasm.",
            "Freedom and independence are essential to your wellbeing today. Create space for spontaneity in your schedule."
        ),
        "Capricorn" to listOf(
            "Ambition and determination drive you toward important goals. Hard work today lays the foundation for future success.",
            "Professional achievements receive recognition. Your reputation for reliability opens new career opportunities.",
            "Practical wisdom guides financial decisions. Conservative approaches to money management prove wise.",
            "Structure and discipline in your daily routine yield impressive results. Consistency is your key to success.",
            "Long-term planning and goal setting bring clarity. Map out your path to success with concrete steps."
        ),
        "Aquarius" to listOf(
            "Innovation and original thinking set you apart today. Your unconventional approach solves problems others cannot.",
            "Humanitarian concerns motivate meaningful action. Contributing to community welfare brings deep satisfaction.",
            "Technology and digital domains offer opportunities. Stay updated with the latest developments in your field.",
            "Friendships and social networks prove valuable. A connection in your circle provides crucial assistance.",
            "Independence and intellectual freedom fuel your creativity. Trust your unique vision and share it boldly."
        ),
        "Pisces" to listOf(
            "Intuition and spiritual insight are heightened today. Trust the subtle messages that come through your inner voice.",
            "Creative and artistic endeavors flow naturally. Allow imagination to guide your work without overthinking.",
            "Compassion for others opens your heart and theirs. A simple act of kindness creates ripples of positive change.",
            "Dreams may carry important messages. Keep a journal nearby to capture insights from your subconscious mind.",
            "Spiritual practices and meditation bring peace and clarity. Quiet time alone helps you reconnect with your purpose."
        )
    )

    private val lovePredictions = listOf(
        "Venus blesses your relationships. Express love openly and watch bonds deepen.",
        "Communication in relationships is key today. Listen as much as you speak.",
        "A romantic surprise brings joy. Be open to spontaneous moments of connection.",
        "Patience in love matters. Allow things to unfold naturally at their own pace.",
        "New romantic possibilities emerge. Stay open to meeting someone special.",
        "Existing relationships are strengthened through shared experiences today.",
        "Misunderstandings can be cleared with honest conversation. Speak your truth kindly.",
        "Love requires compromise today. Find the middle ground for harmony.",
        "Your charm is magnetic. Social settings bring wonderful romantic possibilities.",
        "Deep emotional connection with a partner brings profound satisfaction today."
    )

    private val careerPredictions = listOf(
        "Career advancements are indicated. Take initiative on important projects.",
        "New professional opportunities present themselves. Evaluate carefully before committing.",
        "Teamwork and collaboration lead to exceptional results. Value others' contributions.",
        "Your expertise is recognized. Share your knowledge generously with colleagues.",
        "Financial gains through career efforts. Negotiate confidently for what you deserve.",
        "Creative thinking solves a workplace challenge. Your innovative approach impresses management.",
        "Networking events bring valuable professional connections. Attend social gatherings.",
        "Focus on skill development. Learning something new enhances your career prospects.",
        "Leadership opportunities arise. Step forward with confidence and clear communication.",
        "Work-life balance needs attention. Setting boundaries improves overall productivity."
    )

    private val healthPredictions = listOf(
        "Physical vitality is strong. Channel this energy into exercise and healthy activities.",
        "Mental health needs attention. Mindfulness practices bring peace and clarity.",
        "Digestive health benefits from lighter, more frequent meals today.",
        "Rest and recovery are important. Don't push yourself beyond reasonable limits.",
        "Outdoor activity brings both physical and mental benefits. Spend time in nature.",
        "Stress management techniques are especially helpful today. Practice deep breathing.",
        "Nutrition choices significantly impact your energy levels. Choose foods wisely.",
        "Joint health and flexibility improve with gentle stretching. Make time for yoga.",
        "Your immune system is strong. Continue healthy habits that support your wellbeing.",
        "Eye strain from screens is possible. Take regular breaks and rest your eyes."
    )

    private val financePredictions = listOf(
        "Financial opportunities knock. Be ready to act decisively on good investments.",
        "Budget review leads to discovering unnecessary expenses. Trim where possible.",
        "Income from an unexpected source brightens your financial picture today.",
        "Long-term financial planning benefits from expert consultation. Seek advice.",
        "Avoid risky financial ventures today. Stick to proven strategies.",
        "Generosity brings its own rewards. Charitable giving creates positive financial karma.",
        "Career and financial matters are linked. Professional advancement improves income.",
        "Real estate or property matters look favorable for investment consideration.",
        "Review your savings strategy. Small adjustments now create significant long-term gains.",
        "Financial discipline is your strength. Avoid impulsive purchases and stay on budget."
    )

    fun getHoroscope(zodiacSign: String, period: String = "daily", date: Date = Date()): HoroscopeData {
        val signIndex = Constants.ZODIAC_SIGNS.indexOf(zodiacSign).takeIf { it >= 0 } ?: 0
        val calendar = Calendar.getInstance()
        calendar.time = date
        val seed = calendar.get(Calendar.DAY_OF_YEAR) + signIndex
        val rand = Random(seed.toLong())

        val predictions = dailyPredictions[zodiacSign] ?: dailyPredictions["Aries"]!!
        val predictionText = predictions[rand.nextInt(predictions.size)]
        val love = lovePredictions[rand.nextInt(lovePredictions.size)]
        val career = careerPredictions[rand.nextInt(careerPredictions.size)]
        val health = healthPredictions[rand.nextInt(healthPredictions.size)]
        val finance = financePredictions[rand.nextInt(financePredictions.size)]
        val rating = 3 + rand.nextInt(3) // 3-5 stars

        return HoroscopeData(
            zodiacSign = zodiacSign,
            zodiacSignHindi = Constants.ZODIAC_SIGNS_HINDI.getOrElse(signIndex) { zodiacSign },
            date = date,
            prediction = predictionText,
            love = love,
            career = career,
            health = health,
            finance = finance,
            luckyNumber = luckyNumbers[signIndex],
            luckyColor = luckyColors[signIndex],
            luckyGem = luckyGems[signIndex],
            compatibleSigns = compatibleSigns[signIndex],
            rating = rating
        )
    }

    fun getAllSignsHoroscope(date: Date = Date()): List<HoroscopeData> {
        return Constants.ZODIAC_SIGNS.map { getHoroscope(it, "daily", date) }
    }
}
