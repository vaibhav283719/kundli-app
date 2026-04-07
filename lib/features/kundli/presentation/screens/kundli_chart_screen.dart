import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/kundli_provider.dart';
import '../widgets/kundli_chart_widget.dart';
import '../widgets/planet_position_card.dart';
import '../widgets/dasha_timeline_widget.dart';
import '../../domain/entities/kundli_entity.dart';
import '../../../../config/constants/app_constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../services/ads/ad_service.dart';

class KundliChartScreen extends StatefulWidget {
  const KundliChartScreen({super.key});

  @override
  State<KundliChartScreen> createState() => _KundliChartScreenState();
}

class _KundliChartScreenState extends State<KundliChartScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<KundliProvider>(
      builder: (context, kundliProvider, _) {
        final kundli = kundliProvider.currentKundli;

        if (kundliProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: LoadingWidget(message: 'Calculating planetary positions...'),
            ),
          );
        }

        if (kundli == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Kundli Chart')),
            body: const Center(child: Text('No kundli data available')),
          );
        }

        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) AdService().showInterstitialAd();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(kundli.birthDetails.name),
              actions: [
                IconButton(
                  icon: const Icon(Icons.save_outlined),
                  onPressed: () async {
                    await kundliProvider.saveCurrentKundli();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Kundli saved successfully'),
                          backgroundColor: Color(0xFF00C853),
                        ),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Share feature coming soon')),
                    );
                  },
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Chart'),
                  Tab(text: 'Planets'),
                  Tab(text: 'Dasha'),
                  Tab(text: 'Yogas'),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                _ChartTab(kundli: kundli),
                _PlanetsTab(kundli: kundli),
                _DashaTab(kundli: kundli),
                _YogasTab(kundli: kundli),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ChartTab extends StatelessWidget {
  final KundliEntity kundli;

  const _ChartTab({required this.kundli});

  @override
  Widget build(BuildContext context) {
    final zodiacSigns = AppConstants.zodiacSignsHindi;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Birth info card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _infoItem(context, 'Name', kundli.birthDetails.name),
                      _infoItem(context, 'Date', kundli.birthDetails.formattedDate),
                      _infoItem(context, 'Time', kundli.birthDetails.formattedTime),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _infoItem(
                        context,
                        'Lagna',
                        zodiacSigns[kundli.lagnaRashi],
                      ),
                      _infoItem(
                        context,
                        'Rashi',
                        zodiacSigns[kundli.moonRashi],
                      ),
                      _infoItem(
                        context,
                        'Nakshatra',
                        AppConstants.nakshatras[kundli.moonNakshatra],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Kundli chart
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: KundliChartWidget(kundli: kundli),
            ),
          ),
          const SizedBox(height: 16),
          // Place info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: AppConstants.primarySaffron),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          kundli.birthDetails.placeOfBirth,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          'Lat: ${kundli.birthDetails.latitude.toStringAsFixed(4)}, '
                          'Lon: ${kundli.birthDetails.longitude.toStringAsFixed(4)}, '
                          'TZ: UTC${kundli.birthDetails.timezone >= 0 ? '+' : ''}${kundli.birthDetails.timezone}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppConstants.primarySaffron,
          ),
        ),
      ],
    );
  }
}

class _PlanetsTab extends StatelessWidget {
  final KundliEntity kundli;

  const _PlanetsTab({required this.kundli});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: kundli.planetPositions.length,
      itemBuilder: (context, index) {
        return PlanetPositionCard(
          position: kundli.planetPositions[index],
        );
      },
    );
  }
}

class _DashaTab extends StatelessWidget {
  final KundliEntity kundli;

  const _DashaTab({required this.kundli});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current dasha highlight
          if (kundli.currentDasha != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B00), Color(0xFFFFD700)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Text('🌟', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Maha Dasha',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          kundli.currentDasha!.planet,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_formatDate(kundli.currentDasha!.startDate)} - '
                          '${_formatDate(kundli.currentDasha!.endDate)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          Text(
            'Vimshottari Dasha Periods',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          DashaTimelineWidget(dashas: kundli.dashas),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _YogasTab extends StatelessWidget {
  final KundliEntity kundli;

  const _YogasTab({required this.kundli});

  @override
  Widget build(BuildContext context) {
    final presentYogas = kundli.yogas.where((y) => y.isPresent).toList();
    final absentYogas = kundli.yogas.where((y) => !y.isPresent).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (presentYogas.isNotEmpty) ...[
          Text(
            'Present Yogas (${presentYogas.length})',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF00C853),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...presentYogas.map((y) => _YogaCard(yoga: y)),
          const SizedBox(height: 20),
        ],
        if (absentYogas.isNotEmpty) ...[
          Text(
            'Other Yogas',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...absentYogas.map((y) => _YogaCard(yoga: y)),
        ],
      ],
    );
  }
}

class _YogaCard extends StatelessWidget {
  final KundliYoga yoga;

  const _YogaCard({required this.yoga});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: yoga.isPresent
                    ? const Color(0xFF00C853).withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                yoga.isPresent ? Icons.check_circle : Icons.cancel_outlined,
                color: yoga.isPresent ? const Color(0xFF00C853) : Colors.grey,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    yoga.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: yoga.isPresent ? AppConstants.primarySaffron : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    yoga.description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    children: yoga.involvedPlanets
                        .map((p) => Chip(
                              label: Text(p, style: const TextStyle(fontSize: 10)),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
