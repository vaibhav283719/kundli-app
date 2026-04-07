import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/horoscope_provider.dart';
import '../../../../config/constants/app_constants.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../services/ads/ad_service.dart';

class HoroscopeScreen extends StatelessWidget {
  const HoroscopeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Horoscope / Rashifal')),
      body: Consumer<HoroscopeProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              // Period tabs
              Container(
                color: Theme.of(context).appBarTheme.backgroundColor,
                child: Row(
                  children: provider.periods.map((period) {
                    final isSelected = provider.selectedPeriod == period;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => provider.selectPeriod(period),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 2.5,
                              ),
                            ),
                          ),
                          child: Text(
                            period,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.6),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              // Zodiac sign selector
              Container(
                height: 90,
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1E0A3C)
                    : const Color(0xFFFFF0E0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  itemCount: AppConstants.zodiacSigns.length,
                  itemBuilder: (context, index) {
                    final sign = AppConstants.zodiacSigns[index];
                    final isSelected = provider.selectedSign == sign;
                    final gradient = AppConstants.zodiacGradients[index];

                    return GestureDetector(
                      onTap: () => provider.selectSign(sign),
                      child: AnimatedContainer(
                        duration: AppConstants.animationFast,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 64,
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(colors: gradient)
                              : null,
                          color: isSelected
                              ? null
                              : (Theme.of(context).brightness == Brightness.dark
                                  ? const Color(0xFF2A0F4A)
                                  : Colors.white),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : Colors.grey.withOpacity(0.2),
                          ),
                          boxShadow: isSelected
                              ? [BoxShadow(
                                  color: gradient[0].withOpacity(0.4),
                                  blurRadius: 8,
                                )]
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppConstants.zodiacSymbols[index],
                              style: TextStyle(
                                fontSize: 22,
                                color: isSelected ? Colors.white : null,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              sign.substring(0, 3),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Horoscope content
              Expanded(
                child: provider.isLoading
                    ? const Center(child: LoadingWidget())
                    : provider.currentHoroscope == null
                        ? const Center(child: Text('No horoscope available'))
                        : _HoroscopeContent(provider: provider),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HoroscopeContent extends StatefulWidget {
  final HoroscopeProvider provider;

  const _HoroscopeContent({required this.provider});

  @override
  State<_HoroscopeContent> createState() => _HoroscopeContentState();
}

class _HoroscopeContentState extends State<_HoroscopeContent> {
  bool _yearlyUnlocked = false;

  void _watchAdForYearlyPrediction() async {
    if (!AdService().isGracePeriodOver) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Yearly prediction will unlock after exploring the app a bit 🙏'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    if (!AdService().isRewardedAdReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ad is loading, please try again in a moment...'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    await AdService().showRewardedAd(
      onRewarded: (_) {
        if (mounted) setState(() => _yearlyUnlocked = true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final horoscope = widget.provider.currentHoroscope!;
    final signIndex = AppConstants.zodiacSigns.indexOf(horoscope.zodiacSign);
    final gradient = AppConstants.zodiacGradients[signIndex >= 0 ? signIndex : 0];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      AppConstants.zodiacSymbols[signIndex >= 0 ? signIndex : 0],
                      style: const TextStyle(fontSize: 48, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            horoscope.zodiacSign,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            horoscope.zodiacSignHindi,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                i < horoscope.rating ? Icons.star : Icons.star_border,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  horoscope.prediction,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Lucky info
          Row(
            children: [
              Expanded(
                child: _LuckyCard(
                  icon: '🔢',
                  label: 'Lucky Number',
                  value: horoscope.luckyNumber.toString(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _LuckyCard(
                  icon: '🎨',
                  label: 'Lucky Color',
                  value: horoscope.luckyColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _LuckyCard(
                  icon: '💎',
                  label: 'Lucky Gem',
                  value: horoscope.luckyGem,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Detailed sections
          _DetailCard(icon: '❤️', title: 'Love & Relationships', content: horoscope.love),
          const SizedBox(height: 8),
          _DetailCard(icon: '💼', title: 'Career & Finance', content: '${horoscope.career}\n${horoscope.finance}'),
          const SizedBox(height: 8),
          _DetailCard(icon: '🏥', title: 'Health & Wellness', content: horoscope.health),
          const SizedBox(height: 8),
          // Compatible signs
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('💫', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        'Compatible Signs',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: horoscope.compatibleSigns.map((sign) {
                      final idx = AppConstants.zodiacSigns.indexOf(sign);
                      return Chip(
                        avatar: Text(idx >= 0 ? AppConstants.zodiacSymbols[idx] : '♈'),
                        label: Text(sign),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Yearly prediction — unlocked via rewarded ad
          if (_yearlyUnlocked)
            _DetailCard(
              icon: '🗓️',
              title: 'Yearly Prediction',
              content:
                  'This year brings transformative energy for ${horoscope.zodiacSign}. '
                  'The first half favours career growth and financial gains. '
                  'Relationships deepen around mid-year. '
                  'Health remains stable; prioritise rest in the latter months. '
                  'Overall, a year of expansion and new beginnings awaits you. 🌟',
            )
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Column(
                  children: [
                    const Text('🗓️ Yearly Prediction', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      'Watch a short ad to unlock your full yearly horoscope for ${horoscope.zodiacSign}.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _watchAdForYearlyPrediction,
                      icon: const Icon(Icons.play_circle_outline),
                      label: const Text('Watch Ad — Unlock Yearly Prediction'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primarySaffron,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _LuckyCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _LuckyCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppConstants.primarySaffron,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String icon;
  final String title;
  final String content;

  const _DetailCard({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.6,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
