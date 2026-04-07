import '../entities/remedy_entity.dart';

class RemedyService {
  static final List<RemedyEntity> _allRemedies = [
    const RemedyEntity(
      id: 'sun_career',
      planet: 'Sun',
      issue: 'Career & Authority',
      gemstone: 'Ruby (Manik)',
      mantra: 'Om Hraam Hreem Hraum Sah Suryaya Namah',
      yantra: 'Surya Yantra',
      fastingDay: 'Sunday',
      color: 'Orange/Red',
      donation: 'Wheat, jaggery, copper on Sunday',
      description:
          'Sun governs authority, government, father, and career. Strengthen the Sun for professional success and recognition.',
      categories: ['Career', 'Health', 'Family'],
      emoji: '☀️',
    ),
    const RemedyEntity(
      id: 'moon_mental',
      planet: 'Moon',
      issue: 'Mental Peace & Emotions',
      gemstone: 'Pearl (Moti)',
      mantra: 'Om Shraam Shreem Shraum Sah Chandraya Namah',
      yantra: 'Chandra Yantra',
      fastingDay: 'Monday',
      color: 'White/Silver',
      donation: 'Rice, white cloth, milk on Monday',
      description:
          'Moon governs mind, emotions, mother, and intuition. Strengthen the Moon for mental peace and emotional stability.',
      categories: ['Health', 'Family', 'Spiritual'],
      emoji: '🌙',
    ),
    const RemedyEntity(
      id: 'mars_courage',
      planet: 'Mars',
      issue: 'Courage & Property',
      gemstone: 'Red Coral (Moonga)',
      mantra: 'Om Kraam Kreem Kraum Sah Bhaumaya Namah',
      yantra: 'Mangal Yantra',
      fastingDay: 'Tuesday',
      color: 'Red',
      donation: 'Red lentils, copper, sindoor on Tuesday',
      description:
          'Mars governs courage, property, siblings, and energy. Strengthen Mars for success in competitive fields and real estate.',
      categories: ['Career', 'Finance', 'Family'],
      emoji: '🔴',
    ),
    const RemedyEntity(
      id: 'mercury_education',
      planet: 'Mercury',
      issue: 'Education & Communication',
      gemstone: 'Emerald (Panna)',
      mantra: 'Om Braam Breem Braum Sah Budhaya Namah',
      yantra: 'Budha Yantra',
      fastingDay: 'Wednesday',
      color: 'Green',
      donation: 'Green vegetables, moong dal on Wednesday',
      description:
          'Mercury governs intelligence, communication, business, and education. Strengthen Mercury for academic success.',
      categories: ['Education', 'Career'],
      emoji: '💚',
    ),
    const RemedyEntity(
      id: 'jupiter_wisdom',
      planet: 'Jupiter',
      issue: 'Wisdom & Marriage',
      gemstone: 'Yellow Sapphire (Pukhraj)',
      mantra: 'Om Graam Greem Graum Sah Gurave Namah',
      yantra: 'Guru Yantra',
      fastingDay: 'Thursday',
      color: 'Yellow/Gold',
      donation: 'Yellow clothes, turmeric, gram dal on Thursday',
      description:
          'Jupiter governs wisdom, children, marriage, and spirituality. Strengthen Jupiter for marital happiness and spiritual growth.',
      categories: ['Marriage', 'Education', 'Spiritual', 'Finance'],
      emoji: '💛',
    ),
    const RemedyEntity(
      id: 'venus_love',
      planet: 'Venus',
      issue: 'Love & Marriage',
      gemstone: 'Diamond (Heera) / White Sapphire',
      mantra: 'Om Draam Dreem Draum Sah Shukraya Namah',
      yantra: 'Shukra Yantra',
      fastingDay: 'Friday',
      color: 'White/Pink',
      donation: 'White sweets, rice, perfume on Friday',
      description:
          'Venus governs love, beauty, marriage, arts, and luxury. Strengthen Venus for harmonious relationships and artistic success.',
      categories: ['Marriage', 'Finance', 'Career'],
      emoji: '💗',
    ),
    const RemedyEntity(
      id: 'saturn_karma',
      planet: 'Saturn',
      issue: 'Karma & Discipline',
      gemstone: 'Blue Sapphire (Neelam)',
      mantra: 'Om Praam Preem Praum Sah Shanaye Namah',
      yantra: 'Shani Yantra',
      fastingDay: 'Saturday',
      color: 'Black/Dark Blue',
      donation: 'Mustard oil, black sesame, iron items on Saturday',
      description:
          'Saturn governs discipline, karma, longevity, and service. A strong Saturn brings success through hard work and persistence.',
      categories: ['Career', 'Health', 'Spiritual'],
      emoji: '🪐',
    ),
    const RemedyEntity(
      id: 'rahu_ambition',
      planet: 'Rahu',
      issue: 'Ambition & Foreign Success',
      gemstone: 'Hessonite (Gomed)',
      mantra: 'Om Raam Rahave Namah',
      yantra: 'Rahu Yantra',
      fastingDay: 'Saturday (some traditions: Wednesday)',
      color: 'Dark Blue/Black',
      donation: 'Black sesame, urad dal, blue cloth on Saturday',
      description:
          'Rahu governs ambition, foreign travel, technology, and unconventional success. Remedies help channel Rahu\'s energy positively.',
      categories: ['Career', 'Finance', 'Spiritual'],
      emoji: '🌑',
    ),
    const RemedyEntity(
      id: 'ketu_spiritual',
      planet: 'Ketu',
      issue: 'Spirituality & Liberation',
      gemstone: "Cat's Eye (Lehsunia)",
      mantra: 'Om Hraam Hreem Hraum Sah Ketave Namah',
      yantra: 'Ketu Yantra',
      fastingDay: 'Tuesday (some traditions: Thursday)',
      color: 'Grey/Smoke',
      donation: 'Sesame seeds, blanket, grey cloth on Tuesday',
      description:
          'Ketu governs spirituality, occult, liberation, and past karma. Strengthening Ketu aids spiritual progress and psychic abilities.',
      categories: ['Spiritual', 'Health'],
      emoji: '⚫',
    ),
    const RemedyEntity(
      id: 'sun_health',
      planet: 'Sun',
      issue: 'Health & Vitality',
      gemstone: 'Ruby (Manik)',
      mantra: 'Aditya Hridayam Stotra',
      yantra: 'Surya Yantra',
      fastingDay: 'Sunday',
      color: 'Saffron/Orange',
      donation: 'Wheat and jaggery to the needy',
      description:
          'Surya (Sun) is the Atma (soul) of all. For vitality, immunity and eye health, Sun remedies are essential.',
      categories: ['Health'],
      emoji: '🌞',
    ),
    const RemedyEntity(
      id: 'jupiter_finance',
      planet: 'Jupiter',
      issue: 'Financial Growth',
      gemstone: 'Yellow Sapphire (Pukhraj)',
      mantra: 'Om Shreem Hreem Kleem Greem Grihapatinam Kuber Lakshmi Mamgrihe Dhanam Samriddham Kuru Swaha',
      yantra: 'Guru Yantra',
      fastingDay: 'Thursday',
      color: 'Yellow',
      donation: 'Yellow gram dal, turmeric to Brahmins',
      description:
          'Jupiter rules wealth, abundance and prosperity. These remedies attract financial blessings and material comforts.',
      categories: ['Finance'],
      emoji: '💰',
    ),
    const RemedyEntity(
      id: 'venus_marriage',
      planet: 'Venus',
      issue: 'Marriage Delay',
      gemstone: 'Diamond / Opal',
      mantra: 'Om Katyayanaya Vidmahe Kanyakumari Cha Dheemahi Tanno Durga Prachodayat',
      yantra: 'Shukra Yantra',
      fastingDay: 'Friday',
      color: 'Pink/White',
      donation: 'White rice, white sweets, white clothes on Friday',
      description:
          'Delays in marriage are often linked to Venus or 7th house afflictions. These remedies help remove obstacles.',
      categories: ['Marriage'],
      emoji: '💍',
    ),
  ];

  static List<RemedyEntity> getAllRemedies() => _allRemedies;

  static List<RemedyEntity> getRemediesByPlanet(String planet) {
    if (planet == 'All') return _allRemedies;
    return _allRemedies.where((r) => r.planet == planet).toList();
  }

  static List<RemedyEntity> getRemediesByCategory(String category) {
    return _allRemedies
        .where((r) => r.categories.contains(category))
        .toList();
  }

  static List<String> getAllPlanets() {
    return ['All', 'Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn', 'Rahu', 'Ketu'];
  }

  static List<String> getAllCategories() {
    return ['Career', 'Health', 'Marriage', 'Finance', 'Education', 'Family', 'Spiritual'];
  }
}
