import '../entities/horoscope_entity.dart';
import '../../../../config/constants/app_constants.dart';

class HoroscopeService {
  static final Map<String, Map<String, dynamic>> _signData = {
    'Aries': {
      'hindi': 'मेष',
      'luckyNumber': 9,
      'luckyColor': 'Red',
      'luckyGem': 'Red Coral',
      'compatible': ['Leo', 'Sagittarius', 'Gemini'],
      'predictions': [
        'Mars energizes you today. Seize new opportunities with courage.',
        'Your dynamic nature attracts attention. Lead with confidence.',
        'A challenging but rewarding day lies ahead. Stay determined.',
      ],
    },
    'Taurus': {
      'hindi': 'वृषभ',
      'luckyNumber': 6,
      'luckyColor': 'Green',
      'luckyGem': 'Diamond',
      'compatible': ['Virgo', 'Capricorn', 'Cancer'],
      'predictions': [
        'Venus blesses your relationships today. Show your appreciation.',
        'Financial opportunities emerge. Trust your practical instincts.',
        'Patience is your greatest virtue. Steady progress continues.',
      ],
    },
    'Gemini': {
      'hindi': 'मिथुन',
      'luckyNumber': 5,
      'luckyColor': 'Yellow',
      'luckyGem': 'Emerald',
      'compatible': ['Libra', 'Aquarius', 'Aries'],
      'predictions': [
        'Mercury sharpens your communication. Express your ideas boldly.',
        'Social connections bring unexpected benefits today.',
        'Your curious mind leads to fascinating discoveries.',
      ],
    },
    'Cancer': {
      'hindi': 'कर्क',
      'luckyNumber': 2,
      'luckyColor': 'White',
      'luckyGem': 'Pearl',
      'compatible': ['Scorpio', 'Pisces', 'Taurus'],
      'predictions': [
        'The Moon illuminates your emotional intelligence. Trust your intuition.',
        'Family matters require gentle attention. Your empathy heals.',
        'Home and security feel especially important. Nurture your foundations.',
      ],
    },
    'Leo': {
      'hindi': 'सिंह',
      'luckyNumber': 1,
      'luckyColor': 'Gold',
      'luckyGem': 'Ruby',
      'compatible': ['Aries', 'Sagittarius', 'Libra'],
      'predictions': [
        'The Sun empowers your natural leadership. Shine brightly today.',
        'Creative projects flourish under your enthusiastic touch.',
        'Recognition and praise come your way. Accept graciously.',
      ],
    },
    'Virgo': {
      'hindi': 'कन्या',
      'luckyNumber': 5,
      'luckyColor': 'Navy Blue',
      'luckyGem': 'Emerald',
      'compatible': ['Taurus', 'Capricorn', 'Cancer'],
      'predictions': [
        'Mercury aids your analytical abilities. Details matter today.',
        'Health and wellness focus brings positive results.',
        'Practical solutions emerge from careful observation.',
      ],
    },
    'Libra': {
      'hindi': 'तुला',
      'luckyNumber': 6,
      'luckyColor': 'Pink',
      'luckyGem': 'Diamond',
      'compatible': ['Gemini', 'Aquarius', 'Leo'],
      'predictions': [
        'Venus harmonizes your relationships. Balance is your strength.',
        'Diplomatic skills resolve long-standing conflicts gracefully.',
        'Beauty and aesthetics bring joy. Indulge your artistic senses.',
      ],
    },
    'Scorpio': {
      'hindi': 'वृश्चिक',
      'luckyNumber': 9,
      'luckyColor': 'Deep Red',
      'luckyGem': 'Red Coral',
      'compatible': ['Cancer', 'Pisces', 'Capricorn'],
      'predictions': [
        'Mars intensifies your focus. Transformation is underway.',
        'Hidden truths surface, bringing clarity to complex situations.',
        'Your magnetic presence draws powerful allies to your cause.',
      ],
    },
    'Sagittarius': {
      'hindi': 'धनु',
      'luckyNumber': 3,
      'luckyColor': 'Purple',
      'luckyGem': 'Yellow Sapphire',
      'compatible': ['Aries', 'Leo', 'Aquarius'],
      'predictions': [
        'Jupiter expands your horizons. Adventure beckons you today.',
        'Philosophical insights lead to profound understanding.',
        'Travel or higher learning brings exciting opportunities.',
      ],
    },
    'Capricorn': {
      'hindi': 'मकर',
      'luckyNumber': 8,
      'luckyColor': 'Black',
      'luckyGem': 'Blue Sapphire',
      'compatible': ['Taurus', 'Virgo', 'Scorpio'],
      'predictions': [
        'Saturn rewards your disciplined efforts with lasting success.',
        'Career advancement is highlighted. Showcase your expertise.',
        'Long-term planning pays off. Your patience bears fruit.',
      ],
    },
    'Aquarius': {
      'hindi': 'कुम्भ',
      'luckyNumber': 4,
      'luckyColor': 'Blue',
      'luckyGem': 'Blue Sapphire',
      'compatible': ['Gemini', 'Libra', 'Sagittarius'],
      'predictions': [
        'Saturn and Rahu bring innovative thinking. Embrace change.',
        'Social causes and humanitarian efforts gain momentum.',
        'Original ideas set you apart. Think outside conventions.',
      ],
    },
    'Pisces': {
      'hindi': 'मीन',
      'luckyNumber': 3,
      'luckyColor': 'Sea Green',
      'luckyGem': 'Yellow Sapphire',
      'compatible': ['Cancer', 'Scorpio', 'Capricorn'],
      'predictions': [
        'Jupiter and Neptune enhance your spiritual sensitivity.',
        'Creative and artistic pursuits bring deep fulfillment.',
        'Compassion and healing abilities are at their peak today.',
      ],
    },
  };

  static final Map<String, List<String>> _lovePredictions = {
    'Daily': [
      'Romance is in the air. Express your feelings openly.',
      'A special connection deepens today. Cherish every moment.',
      'Misunderstandings clear up with honest communication.',
      'Your partner appreciates your thoughtful gestures today.',
      'New romantic possibilities emerge unexpectedly.',
    ],
    'Weekly': [
      'This week brings emotional clarity in relationships.',
      'Open your heart to new possibilities in love.',
      'Communication with your partner improves significantly.',
      'A week of romantic moments and deeper bonds.',
      'Trust builds stronger foundations in your relationship.',
    ],
  };

  static final Map<String, List<String>> _careerPredictions = {
    'Daily': [
      'Professional recognition comes from consistent effort.',
      'A senior colleague offers valuable guidance today.',
      'New project opportunities align with your skills.',
      'Decision-making abilities are sharp. Act decisively.',
      'Team collaboration leads to breakthrough results.',
    ],
    'Weekly': [
      'Career advancement is on the horizon this week.',
      'Financial gains through professional expertise.',
      'Leadership qualities shine in team settings.',
      'An important business meeting yields positive outcomes.',
      'New career opportunities deserve serious consideration.',
    ],
  };

  static HoroscopeEntity getHoroscope(
    String zodiacSign,
    String period,
    DateTime date,
  ) {
    final data = _signData[zodiacSign] ?? _signData['Aries']!;
    final predictions = data['predictions'] as List<String>;
    final dayIndex = date.day % predictions.length;

    // Generate varied predictions based on date
    final seed = date.day + date.month * 31 + AppConstants.zodiacSigns.indexOf(zodiacSign);

    final lovePreds = _lovePredictions['Daily']!;
    final careerPreds = _careerPredictions['Daily']!;

    final mainPrediction = _buildPrediction(zodiacSign, period, date, predictions[dayIndex]);

    return HoroscopeEntity(
      zodiacSign: zodiacSign,
      zodiacSignHindi: data['hindi'] as String,
      date: date,
      prediction: mainPrediction,
      love: lovePreds[seed % lovePreds.length],
      career: careerPreds[(seed + 2) % careerPreds.length],
      health: _buildHealthPrediction(seed),
      finance: _buildFinancePrediction(seed),
      luckyNumber: data['luckyNumber'] as int,
      luckyColor: data['luckyColor'] as String,
      luckyGem: data['luckyGem'] as String,
      compatibleSigns: List<String>.from(data['compatible'] as List),
      rating: (seed % 3) + 3, // 3-5 stars
    );
  }

  static String _buildPrediction(
    String sign,
    String period,
    DateTime date,
    String base,
  ) {
    final periodText = switch (period) {
      'Daily' => 'Today',
      'Weekly' => 'This week',
      'Monthly' => 'This month',
      'Yearly' => 'This year',
      _ => 'Today',
    };

    final extras = [
      '$periodText, the cosmic energies favor bold decisions. $base',
      'The stars align in your favor. $base Your efforts will be rewarded.',
      '$base Maintain focus and stay grounded as opportunities unfold.',
      'Planetary movements bring positive changes. $base Trust the cosmic plan.',
      '$base $periodText brings clarity and renewed purpose to your journey.',
    ];

    final idx = (date.day + AppConstants.zodiacSigns.indexOf(sign)) % extras.length;
    return extras[idx];
  }

  static String _buildHealthPrediction(int seed) {
    const preds = [
      'Energy levels are high. Channel them into physical activity.',
      'Rest and relaxation are essential today. Listen to your body.',
      'A good day for starting a health routine. Small steps matter.',
      'Mental wellness deserves attention. Practice mindfulness.',
      'Avoid overexertion. Pace yourself through the day.',
    ];
    return preds[seed % preds.length];
  }

  static String _buildFinancePrediction(int seed) {
    const preds = [
      'Avoid impulsive spending. Save for long-term goals.',
      'A favorable day for investments and financial planning.',
      'Unexpected income is possible. Manage it wisely.',
      'Review your budget and cut unnecessary expenses.',
      'Business ventures initiated today show promising returns.',
    ];
    return preds[(seed + 3) % preds.length];
  }

  static List<String> getAllZodiacSigns() {
    return AppConstants.zodiacSigns;
  }
}
