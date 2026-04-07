import 'package:flutter/material.dart';
import '../../domain/entities/kundli_entity.dart';
import '../../../../config/constants/app_constants.dart';

class PlanetPositionCard extends StatelessWidget {
  final PlanetPosition position;

  const PlanetPositionCard({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    final planet = position.planet;
    final color = AppConstants.planetColors[planet] ?? AppConstants.primarySaffron;
    final planetIdx = AppConstants.planets.indexOf(planet);
    final hindiName = planetIdx >= 0
        ? AppConstants.planetsHindi[planetIdx]
        : planet;
    final symbol = planetIdx >= 0 ? AppConstants.planetSymbols[planetIdx] : '★';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Planet icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.4), width: 1.5),
              ),
              child: Center(
                child: Text(
                  symbol,
                  style: TextStyle(fontSize: 20, color: color),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Planet info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        planet,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '($hindiName)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _Badge(
                        text: AppConstants.zodiacSignsHindi[position.rashi],
                        color: color,
                      ),
                      const SizedBox(width: 6),
                      _Badge(
                        text: '${position.rashiDegree.toStringAsFixed(2)}°',
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      _Badge(
                        text: 'H${position.house}',
                        color: AppConstants.primarySaffron,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${AppConstants.nakshatras[position.nakshatra]} Pada ${position.nakshatraPada}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Status indicators
            Column(
              children: [
                if (position.isRetrograde)
                  _StatusChip(label: 'R', color: Colors.orange),
                if (position.isCombust)
                  _StatusChip(label: 'C', color: Colors.red),
                if (position.isExalted)
                  _StatusChip(label: 'Ex', color: const Color(0xFF00C853)),
                if (position.isDebilitated)
                  _StatusChip(label: 'Db', color: Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 3),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 9,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
