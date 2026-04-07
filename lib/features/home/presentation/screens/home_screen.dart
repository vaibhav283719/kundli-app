import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/feature_card.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../horoscope/presentation/providers/horoscope_provider.dart';
import '../../../../config/constants/app_constants.dart';
import '../../../../core/widgets/banner_ad_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
    _NavItem(icon: Icons.auto_awesome_outlined, activeIcon: Icons.auto_awesome, label: 'Kundli'),
    _NavItem(icon: Icons.stars_outlined, activeIcon: Icons.stars, label: 'Horoscope'),
    _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0
          ? _HomeTab(onNavigate: _navigate)
          : _KundliTab(),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BannerAdWidget(),
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              if (index == 0) {
                setState(() => _currentIndex = 0);
              } else if (index == 1) {
                setState(() => _currentIndex = 1);
              } else if (index == 2) {
                context.push('/horoscope');
              } else if (index == 3) {
                context.push('/profile');
              }
            },
            items: _navItems
                .map((item) => BottomNavigationBarItem(
                      icon: Icon(item.icon),
                      activeIcon: Icon(item.activeIcon),
                      label: item.label,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  void _navigate(String route) {
    context.push(route);
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class _HomeTab extends StatelessWidget {
  final Function(String) onNavigate;

  const _HomeTab({required this.onNavigate});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = context.watch<AuthProvider>();
    final userName = authProvider.currentUser?.name ?? 'Friend';

    return CustomScrollView(
      slivers: [
        // Header
        SliverAppBar(
          expandedHeight: 160,
          floating: false,
          pinned: true,
          backgroundColor: AppConstants.primarySaffron,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1A0533),
                    Color(0xFF3D0A6B),
                    Color(0xFF1A0533),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_getGreeting()} 🙏',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                userName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                                onPressed: () => context.push('/settings'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Explore the cosmic wisdom of Vedic astrology',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: const [],
          title: const Text('Instant Kundli Maker', style: TextStyle(color: Colors.white)),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Today's Rashifal
                _DailyRashifalCard(onTap: () => onNavigate('/horoscope')),
                const SizedBox(height: 20),
                // Feature grid
                Text(
                  'Features',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: [
                    FeatureCard(
                      title: 'Janm Kundli',
                      subtitle: 'Birth Chart',
                      icon: Icons.auto_awesome,
                      gradient: const [Color(0xFFFF6B00), Color(0xFFFF9500)],
                      emoji: '🔮',
                      onTap: () => onNavigate('/birth-details'),
                    ),
                    FeatureCard(
                      title: 'Horoscope',
                      subtitle: 'Daily Rashifal',
                      icon: Icons.stars,
                      gradient: const [Color(0xFF7E57C2), Color(0xFF512DA8)],
                      emoji: '⭐',
                      onTap: () => onNavigate('/horoscope'),
                    ),
                    FeatureCard(
                      title: 'Gun Milan',
                      subtitle: 'Kundli Matching',
                      icon: Icons.favorite,
                      gradient: const [Color(0xFFEC407A), Color(0xFFE91E63)],
                      emoji: '💑',
                      onTap: () => onNavigate('/compatibility'),
                    ),
                    FeatureCard(
                      title: 'Remedies',
                      subtitle: 'Planet Upay',
                      icon: Icons.spa,
                      gradient: const [Color(0xFF388E3C), Color(0xFF2E7D32)],
                      emoji: '🙏',
                      onTap: () => onNavigate('/remedies'),
                    ),
                    FeatureCard(
                      title: 'Profiles',
                      subtitle: 'Save Charts',
                      icon: Icons.people,
                      gradient: const [Color(0xFF29B6F6), Color(0xFF0288D1)],
                      emoji: '👥',
                      onTap: () => onNavigate('/profile'),
                    ),
                    FeatureCard(
                      title: 'Premium',
                      subtitle: 'Unlock All',
                      icon: Icons.workspace_premium,
                      gradient: const [Color(0xFFFFD700), Color(0xFFFF8F00)],
                      emoji: '👑',
                      onTap: () => onNavigate('/premium'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Auspicious timing
                _AuspiciousTimingWidget(),
                const SizedBox(height: 20),
                // Nakshatra of the day
                _NakshatraWidget(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DailyRashifalCard extends StatelessWidget {
  final VoidCallback onTap;

  const _DailyRashifalCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final horoscopeProvider = context.watch<HoroscopeProvider>();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF7E57C2), Color(0xFF512DA8)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7E57C2).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '⭐ Today\'s Rashifal',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 14),
              ],
            ),
            const SizedBox(height: 10),
            if (horoscopeProvider.currentHoroscope != null) ...[
              Text(
                '${horoscopeProvider.selectedSign} - ${horoscopeProvider.currentHoroscope!.zodiacSignHindi}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                horoscopeProvider.currentHoroscope!.prediction,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ] else ...[
              const Text(
                'Tap to see your daily horoscope',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AuspiciousTimingWidget extends StatelessWidget {
  const _AuspiciousTimingWidget();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('🕐', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  'Today\'s Auspicious Timings',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Rahu Kaal
            _TimingRow(
              label: 'Rahu Kaal',
              time: _getRahuKaal(now.weekday),
              color: Colors.red,
              isAuspicious: false,
            ),
            const Divider(height: 12),
            _TimingRow(
              label: 'Brahma Muhurta',
              time: '4:24 AM - 5:12 AM',
              color: const Color(0xFF00C853),
              isAuspicious: true,
            ),
            const Divider(height: 12),
            _TimingRow(
              label: 'Abhijit Muhurta',
              time: '11:48 AM - 12:36 PM',
              color: AppConstants.primarySaffron,
              isAuspicious: true,
            ),
          ],
        ),
      ),
    );
  }

  String _getRahuKaal(int weekday) {
    const rahuKaalTimes = [
      '4:30 PM - 6:00 PM', // Sunday
      '7:30 AM - 9:00 AM', // Monday
      '3:00 PM - 4:30 PM', // Tuesday
      '12:00 PM - 1:30 PM', // Wednesday
      '1:30 PM - 3:00 PM', // Thursday
      '10:30 AM - 12:00 PM', // Friday
      '9:00 AM - 10:30 AM', // Saturday
    ];
    return rahuKaalTimes[(weekday - 1) % 7];
  }
}

class _TimingRow extends StatelessWidget {
  final String label;
  final String time;
  final Color color;
  final bool isAuspicious;

  const _TimingRow({
    required this.label,
    required this.time,
    required this.color,
    required this.isAuspicious,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isAuspicious ? Icons.check_circle : Icons.cancel,
          color: color,
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Text(
          time,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _NakshatraWidget extends StatelessWidget {
  const _NakshatraWidget();

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final nakshatraIndex = today.day % 27;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppConstants.primarySaffron.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🌙', style: TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Nakshatra',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    AppConstants.nakshatras[nakshatraIndex],
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppConstants.primarySaffron,
                    ),
                  ),
                  Text(
                    AppConstants.nakshatrasHindi[nakshatraIndex],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  AppConstants.weekdays[today.weekday % 7],
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '${today.day}/${today.month}/${today.year}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder tabs for bottom nav
class _KundliTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const BirthDetailsRedirect();
  }
}

class BirthDetailsRedirect extends StatelessWidget {
  const BirthDetailsRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kundli')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🔮', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            const Text(
              'Generate Your Kundli',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter birth details to see your birth chart',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/birth-details'),
              icon: const Icon(Icons.add),
              label: const Text('New Kundli'),
            ),
          ],
        ),
      ),
    );
  }
}
