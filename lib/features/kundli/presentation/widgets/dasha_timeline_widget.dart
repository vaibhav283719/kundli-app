import 'package:flutter/material.dart';
import '../../domain/entities/kundli_entity.dart';
import '../../../../config/constants/app_constants.dart';

class DashaTimelineWidget extends StatelessWidget {
  final List<DashaPeriod> dashas;

  const DashaTimelineWidget({super.key, required this.dashas});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: dashas.asMap().entries.map((entry) {
        final index = entry.key;
        final dasha = entry.value;
        final isCurrent = dasha.isCurrent;
        final color = _getDashaColor(dasha.planet);

        return _DashaItem(
          dasha: dasha,
          isCurrent: isCurrent,
          color: color,
          isLast: index == dashas.length - 1,
        );
      }).toList(),
    );
  }

  Color _getDashaColor(String planet) {
    return AppConstants.planetColors[planet] ?? AppConstants.primarySaffron;
  }
}

class _DashaItem extends StatefulWidget {
  final DashaPeriod dasha;
  final bool isCurrent;
  final Color color;
  final bool isLast;

  const _DashaItem({
    required this.dasha,
    required this.isCurrent,
    required this.color,
    required this.isLast,
  });

  @override
  State<_DashaItem> createState() => _DashaItemState();
}

class _DashaItemState extends State<_DashaItem> {
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _expanded = widget.isCurrent;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line and dot
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: widget.isCurrent ? 16 : 12,
                  height: widget.isCurrent ? 16 : 12,
                  decoration: BoxDecoration(
                    color: widget.isCurrent ? widget.color : widget.color.withOpacity(0.5),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.color,
                      width: widget.isCurrent ? 2.5 : 1.5,
                    ),
                    boxShadow: widget.isCurrent
                        ? [BoxShadow(color: widget.color.withOpacity(0.4), blurRadius: 8)]
                        : null,
                  ),
                ),
                if (!widget.isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isDark
                          ? Colors.white12
                          : Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          ),
          // Dasha content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _expanded = !_expanded),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: widget.isCurrent
                            ? widget.color.withOpacity(0.12)
                            : (isDark
                                ? const Color(0xFF1E0A3C)
                                : Colors.grey.shade50),
                        borderRadius: BorderRadius.circular(10),
                        border: widget.isCurrent
                            ? Border.all(color: widget.color.withOpacity(0.4))
                            : null,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${widget.dasha.planet} Mahadasha',
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: widget.isCurrent ? widget.color : null,
                                      ),
                                    ),
                                    if (widget.isCurrent) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: widget.color,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          'Active',
                                          style: TextStyle(
                                            fontSize: 9,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${_formatDate(widget.dasha.startDate)} → ${_formatDate(widget.dasha.endDate)}',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '${widget.dasha.years} years',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: widget.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            _expanded ? Icons.expand_less : Icons.expand_more,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Antardasha
                  if (_expanded && widget.dasha.antarDashas.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ...widget.dasha.antarDashas.map(
                      (ad) => Padding(
                        padding: const EdgeInsets.only(left: 12, bottom: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: _getAntarColor(ad.planet),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${ad.planet}: ${_formatDate(ad.startDate)} - ${_formatDate(ad.endDate)}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: ad.isCurrent ? FontWeight.bold : null,
                                  color: ad.isCurrent ? widget.color : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Color _getAntarColor(String planet) {
    return AppConstants.planetColors[planet] ?? Colors.grey;
  }
}
