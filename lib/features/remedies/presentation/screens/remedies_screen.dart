import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/remedies_provider.dart';
import '../../domain/entities/remedy_entity.dart';
import '../../../../config/constants/app_constants.dart';
import '../../../../core/widgets/loading_widget.dart';

class RemediesScreen extends StatelessWidget {
  const RemediesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Remedies / Upay')),
      body: Consumer<RemediesProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              // Planet filter chips
              Container(
                height: 52,
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1E0A3C)
                    : const Color(0xFFFFF0E0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  children: provider.planets.map((planet) {
                    final isSelected = provider.selectedPlanet == planet;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(
                          planet == 'All'
                              ? 'All'
                              : '${_getPlanetEmoji(planet)} $planet',
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.white : null,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (_) => provider.selectPlanet(planet),
                        selectedColor: AppConstants.primarySaffron,
                        checkmarkColor: Colors.white,
                        backgroundColor: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF2A0F4A)
                            : Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
              // Category filter
              Container(
                height: 44,
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF0D0221)
                    : Colors.white,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: const Text('All Categories', style: TextStyle(fontSize: 11)),
                        selected: provider.selectedCategory == null,
                        onSelected: (_) => provider.selectCategory(null),
                        selectedColor: AppConstants.primarySaffron.withOpacity(0.2),
                      ),
                    ),
                    ...provider.categories.map((cat) {
                      final isSelected = provider.selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(cat, style: const TextStyle(fontSize: 11)),
                          selected: isSelected,
                          onSelected: (_) =>
                              provider.selectCategory(isSelected ? null : cat),
                          selectedColor: AppConstants.primarySaffron.withOpacity(0.2),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Remedies list
              Expanded(
                child: provider.isLoading
                    ? const Center(child: LoadingWidget())
                    : provider.remedies.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('🔮', style: TextStyle(fontSize: 48)),
                                SizedBox(height: 12),
                                Text('No remedies found for selected filters'),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: provider.remedies.length,
                            itemBuilder: (context, index) {
                              return _RemedyCard(remedy: provider.remedies[index]);
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getPlanetEmoji(String planet) {
    const emojis = {
      'Sun': '☀️', 'Moon': '🌙', 'Mars': '🔴', 'Mercury': '💚',
      'Jupiter': '💛', 'Venus': '💗', 'Saturn': '🪐', 'Rahu': '🌑', 'Ketu': '⚫',
    };
    return emojis[planet] ?? '⭐';
  }
}

class _RemedyCard extends StatefulWidget {
  final RemedyEntity remedy;

  const _RemedyCard({required this.remedy});

  @override
  State<_RemedyCard> createState() => _RemedyCardState();
}

class _RemedyCardState extends State<_RemedyCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final color =
        AppConstants.planetColors[widget.remedy.planet] ?? AppConstants.primarySaffron;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.remedy.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                widget.remedy.planet,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Wrap(
                                spacing: 4,
                                children: widget.remedy.categories
                                    .take(2)
                                    .map((c) => Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 1,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            c,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.remedy.issue,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          // Expanded details
          if (_expanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.remedy.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      height: 1.6,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _DetailRow('💎', 'Gemstone', widget.remedy.gemstone, color),
                  _DetailRow('🙏', 'Mantra', widget.remedy.mantra, color),
                  _DetailRow('🔯', 'Yantra', widget.remedy.yantra, color),
                  _DetailRow('🍽️', 'Fasting Day', widget.remedy.fastingDay, color),
                  _DetailRow('🎨', 'Lucky Color', widget.remedy.color, color),
                  _DetailRow('🤲', 'Donation', widget.remedy.donation, color),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color accentColor;

  const _DetailRow(this.emoji, this.label, this.value, this.accentColor);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
