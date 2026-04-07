import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/constants/app_constants.dart';
import '../../../../core/widgets/custom_button.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Checking for purchases...')),
              );
            },
            child: const Text('Restore', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A0533), Color(0xFF3D0A6B)],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFF6B00)],
                      ),
                    ),
                    child: const Center(
                      child: Text('👑', style: TextStyle(fontSize: 40)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Kundli Premium',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Unlock the full power of Vedic astrology',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Feature comparison
                  _FeatureComparisonCard(),
                  const SizedBox(height: 24),
                  // Pricing cards
                  const Text(
                    'Choose Your Plan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _PricingCard(
                    title: 'Monthly',
                    price: '₹99',
                    period: 'per month',
                    features: const [
                      'All premium features',
                      'Daily personalized predictions',
                      'Unlimited Kundli storage',
                    ],
                    isRecommended: false,
                    onTap: () => _handlePurchase(context, 'monthly'),
                  ),
                  const SizedBox(height: 12),
                  _PricingCard(
                    title: 'Yearly',
                    price: '₹799',
                    period: 'per year',
                    features: const [
                      'All premium features',
                      'Daily personalized predictions',
                      'Unlimited Kundli storage',
                      'Priority support',
                      'Save 33% vs monthly',
                    ],
                    isRecommended: true,
                    badge: 'Best Value',
                    onTap: () => _handlePurchase(context, 'yearly'),
                  ),
                  const SizedBox(height: 16),
                  // Guarantee
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.verified_user_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        '7-day money-back guarantee',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cancel anytime. No questions asked.',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePurchase(BuildContext context, String plan) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Subscribe'),
        content: Text(
          'You are about to subscribe to the ${plan == 'monthly' ? 'Monthly (₹99/month)' : 'Yearly (₹799/year)'} plan.\n\nIn-app purchase will be available in the release version.',
        ),
        actions: [
          TextButton(onPressed: () => ctx.pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              ctx.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Thank you! In-app purchase coming soon.'),
                ),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}

class _FeatureComparisonCard extends StatelessWidget {
  const _FeatureComparisonCard();

  @override
  Widget build(BuildContext context) {
    const features = [
      ('Basic Kundli Generation', true, true),
      ('Daily Horoscope', true, true),
      ('Gun Milan (Basic)', true, true),
      ('Planetary Remedies', true, true),
      ('Unlimited Kundli Storage', false, true),
      ('Detailed Analysis & Yogas', false, true),
      ('PDF Export', false, true),
      ('Personalized Predictions', false, true),
      ('Consultancy Booking', false, true),
      ('Ad-free Experience', false, true),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(flex: 3, child: SizedBox()),
                Expanded(
                  child: Center(
                    child: Text(
                      'Free',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFF6B00)],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Premium',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            ...features.map(
              (f) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        f.$1,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Icon(
                          f.$2 ? Icons.check : Icons.remove,
                          size: 18,
                          color: f.$2 ? const Color(0xFF00C853) : Colors.grey.shade300,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Icon(
                          f.$3 ? Icons.check : Icons.remove,
                          size: 18,
                          color: f.$3 ? AppConstants.primarySaffron : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final List<String> features;
  final bool isRecommended;
  final String? badge;
  final VoidCallback onTap;

  const _PricingCard({
    required this.title,
    required this.price,
    required this.period,
    required this.features,
    required this.isRecommended,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: isRecommended
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFD700), Color(0xFFFF6B00)],
              )
            : null,
        borderRadius: BorderRadius.circular(16),
        border: !isRecommended
            ? Border.all(
                color: Colors.grey.withOpacity(0.3),
              )
            : null,
        boxShadow: isRecommended
            ? [
                BoxShadow(
                  color: AppConstants.primarySaffron.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isRecommended ? Colors.white : null,
                  ),
                ),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isRecommended
                          ? Colors.white.withOpacity(0.3)
                          : AppConstants.primarySaffron,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badge!,
                      style: TextStyle(
                        color: isRecommended
                            ? Colors.white
                            : Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: price,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isRecommended ? Colors.white : AppConstants.primarySaffron,
                    ),
                  ),
                  TextSpan(
                    text: '  $period',
                    style: TextStyle(
                      fontSize: 13,
                      color: isRecommended ? Colors.white70 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...features.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: isRecommended ? Colors.white : const Color(0xFF00C853),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      f,
                      style: TextStyle(
                        fontSize: 13,
                        color: isRecommended ? Colors.white : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isRecommended
                      ? Colors.white
                      : AppConstants.primarySaffron,
                  foregroundColor: isRecommended
                      ? AppConstants.primarySaffron
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Subscribe Now',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
