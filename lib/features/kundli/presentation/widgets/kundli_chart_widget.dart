import 'package:flutter/material.dart';
import '../../domain/entities/kundli_entity.dart';
import '../../../../config/constants/app_constants.dart';

/// Draws a North Indian style Kundli chart using CustomPainter.
/// The chart is a 3x3 grid where the center cell is blank and
/// the outer 12 cells represent the 12 houses.
class KundliChartWidget extends StatelessWidget {
  final KundliEntity kundli;
  final double size;

  const KundliChartWidget({
    super.key,
    required this.kundli,
    this.size = 320,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: _NorthIndianChartPainter(
          kundli: kundli,
          isDark: isDark,
        ),
      ),
    );
  }
}

class _NorthIndianChartPainter extends CustomPainter {
  final KundliEntity kundli;
  final bool isDark;

  _NorthIndianChartPainter({required this.kundli, required this.isDark});

  static const List<String> _zodiacHindi = [
    'मे', 'वृ', 'मि', 'क', 'सि', 'क',
    'तु', 'वृ', 'ध', 'म', 'कु', 'मी',
  ];

  // North Indian house layout: which grid cell [row][col] maps to which house
  // Houses are numbered 1-12; house 1 is top-center diamond
  // Grid positions for 12 houses (row, col) — 0-indexed in a 4x4 grid of triangles
  // Using the standard North Indian square arrangement

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bgPaint = Paint()
      ..color = isDark ? const Color(0xFF1E0A3C) : const Color(0xFFFFF8F0)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    final borderPaint = Paint()
      ..color = AppConstants.primarySaffron
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final linePaint = Paint()
      ..color = isDark
          ? AppConstants.primarySaffron.withOpacity(0.5)
          : AppConstants.primarySaffron.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Draw outer rectangle
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      borderPaint,
    );

    // Draw inner rectangle (center area)
    final insetX = w / 3;
    final insetY = h / 3;
    canvas.drawRect(
      Rect.fromLTWH(insetX, insetY, insetX, insetY),
      borderPaint,
    );

    // Draw diagonal lines inside outer cells to create house triangles
    // Top row
    canvas.drawLine(Offset(0, 0), Offset(insetX, insetY), linePaint);
    canvas.drawLine(Offset(insetX, 0), Offset(insetX, insetY), linePaint);
    canvas.drawLine(Offset(2 * insetX, 0), Offset(2 * insetX, insetY), linePaint);
    canvas.drawLine(Offset(w, 0), Offset(2 * insetX, insetY), linePaint);

    // Bottom row
    canvas.drawLine(Offset(0, h), Offset(insetX, 2 * insetY), linePaint);
    canvas.drawLine(Offset(insetX, h), Offset(insetX, 2 * insetY), linePaint);
    canvas.drawLine(Offset(2 * insetX, h), Offset(2 * insetX, 2 * insetY), linePaint);
    canvas.drawLine(Offset(w, h), Offset(2 * insetX, 2 * insetY), linePaint);

    // Left column
    canvas.drawLine(Offset(0, 0), Offset(insetX, insetY), linePaint);
    canvas.drawLine(Offset(0, insetY), Offset(insetX, insetY), linePaint);
    canvas.drawLine(Offset(0, 2 * insetY), Offset(insetX, 2 * insetY), linePaint);
    canvas.drawLine(Offset(0, h), Offset(insetX, 2 * insetY), linePaint);

    // Right column
    canvas.drawLine(Offset(w, 0), Offset(2 * insetX, insetY), linePaint);
    canvas.drawLine(Offset(w, insetY), Offset(2 * insetX, insetY), linePaint);
    canvas.drawLine(Offset(w, 2 * insetY), Offset(2 * insetX, 2 * insetY), linePaint);
    canvas.drawLine(Offset(w, h), Offset(2 * insetX, 2 * insetY), linePaint);

    // Draw house numbers and planet abbreviations
    _drawHouseContents(canvas, size, insetX, insetY);
  }

  void _drawHouseContents(Canvas canvas, Size size, double insetX, double insetY) {
    final w = size.width;
    final h = size.height;

    // House centers in North Indian layout (house 1 = top middle)
    // Format: (centerX, centerY) for each house 1-12
    final houseCenters = <int, Offset>{
      1: Offset(w / 2, insetY / 2),
      2: Offset(insetX / 2, insetY / 2),
      3: Offset(insetX / 4, insetY + insetY / 2),
      4: Offset(insetX / 2, insetY + insetY / 2 + insetY / 2),
      5: Offset(insetX / 2, h - insetY / 2),
      6: Offset(w / 2, h - insetY / 2),
      7: Offset(w - insetX / 2, h - insetY / 2),
      8: Offset(w - insetX / 2, insetY + insetY / 2 + insetY / 2),
      9: Offset(w - insetX / 4, insetY + insetY / 2),
      10: Offset(w - insetX / 2, insetY / 2),
      11: Offset(3 * insetX / 2, insetY / 2),
      12: Offset(w / 2 + insetX / 2, insetY / 2),
    };

    // More accurate North Indian house centers
    final centers = <int, Offset>{
      1: Offset(w / 2, insetY * 0.45),
      2: Offset(insetX * 0.45, insetY * 0.45),
      3: Offset(insetX * 0.3, h / 2),
      4: Offset(insetX * 0.45, h - insetY * 0.45),
      5: Offset(w / 2, h - insetY * 0.45),
      6: Offset(w - insetX * 0.45, h - insetY * 0.45),
      7: Offset(w - insetX * 0.3, h / 2),
      8: Offset(w - insetX * 0.45, insetY * 0.45),
      9: Offset(w / 2 + insetX * 0.5, insetY * 0.45),
      10: Offset(w / 2, h / 2 - insetY * 0.1),
      11: Offset(insetX * 1.5, h / 2),
      12: Offset(insetX * 0.45, h / 2 - insetY * 0.5),
    };

    // Get house rashis (house 1 = lagna rashi)
    final houseRashis = kundli.houseRashis;

    // Build planet-to-house mapping
    final housePlanets = <int, List<String>>{};
    for (final planet in kundli.planetPositions) {
      housePlanets.putIfAbsent(planet.house, () => []).add(_abbreviate(planet.planet));
    }

    for (int house = 1; house <= 12; house++) {
      final center = centers[house]!;
      final rashiIdx = houseRashis[(house - 1) % 12];
      final rashiText = _zodiacHindi[rashiIdx];

      // Draw rashi sign
      _drawText(
        canvas,
        rashiText,
        center.translate(0, -8),
        fontSize: 11,
        color: AppConstants.primarySaffron,
        bold: true,
      );

      // Draw house number
      _drawText(
        canvas,
        '$house',
        center,
        fontSize: 9,
        color: isDark ? Colors.white54 : Colors.black38,
      );

      // Draw planets
      final planets = housePlanets[house] ?? [];
      if (planets.isNotEmpty) {
        _drawText(
          canvas,
          planets.join(' '),
          center.translate(0, 10),
          fontSize: 9,
          color: isDark ? AppConstants.primaryGold : AppConstants.deepPurple,
          bold: planets.length <= 3,
        );
      }
    }

    // Draw OM symbol in center
    _drawText(
      canvas,
      'ॐ',
      Offset(size.width / 2, size.height / 2),
      fontSize: 24,
      color: AppConstants.primarySaffron.withOpacity(0.6),
      bold: true,
    );
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset, {
    double fontSize = 12,
    Color? color,
    bool bold = false,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          color: color ?? (isDark ? Colors.white : Colors.black87),
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        offset.dx - textPainter.width / 2,
        offset.dy - textPainter.height / 2,
      ),
    );
  }

  String _abbreviate(String planet) {
    const abbr = {
      'Sun': 'Su',
      'Moon': 'Mo',
      'Mars': 'Ma',
      'Mercury': 'Me',
      'Jupiter': 'Ju',
      'Venus': 'Ve',
      'Saturn': 'Sa',
      'Rahu': 'Ra',
      'Ketu': 'Ke',
    };
    return abbr[planet] ?? planet.substring(0, 2);
  }

  @override
  bool shouldRepaint(_NorthIndianChartPainter oldDelegate) {
    return oldDelegate.kundli != kundli || oldDelegate.isDark != isDark;
  }
}
