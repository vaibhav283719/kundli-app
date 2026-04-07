import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/compatibility_provider.dart';
import '../../domain/entities/compatibility_entity.dart';
import '../../../../config/constants/app_constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_widget.dart';

class CompatibilityScreen extends StatelessWidget {
  const CompatibilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kundli Matching / Gun Milan')),
      body: Consumer<CompatibilityProvider>(
        builder: (context, provider, _) {
          if (provider.status.name == 'success' && provider.result != null) {
            return _ResultView(provider: provider);
          }
          return _InputView(provider: provider);
        },
      ),
    );
  }
}

class _InputView extends StatefulWidget {
  final CompatibilityProvider provider;

  const _InputView({required this.provider});

  @override
  State<_InputView> createState() => _InputViewState();
}

class _InputViewState extends State<_InputView> {
  final _p1NameController = TextEditingController();
  final _p2NameController = TextEditingController();
  int _p1Nakshatra = 0;
  int _p2Nakshatra = 0;
  int _p1Pada = 1;
  int _p2Pada = 1;

  @override
  void dispose() {
    _p1NameController.dispose();
    _p2NameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header
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
                const Text('💑', style: TextStyle(fontSize: 36)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kundli Matching',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Ashta Koota Gun Milan — Total 36 Points',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _PersonForm(
            title: '👰 Bride / Person 1',
            nameController: _p1NameController,
            selectedNakshatra: _p1Nakshatra,
            selectedPada: _p1Pada,
            onNakshatraChanged: (v) => setState(() => _p1Nakshatra = v),
            onPadaChanged: (v) => setState(() => _p1Pada = v),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('❤️', style: TextStyle(fontSize: 24)),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 16),
          _PersonForm(
            title: '🤵 Groom / Person 2',
            nameController: _p2NameController,
            selectedNakshatra: _p2Nakshatra,
            selectedPada: _p2Pada,
            onNakshatraChanged: (v) => setState(() => _p2Nakshatra = v),
            onPadaChanged: (v) => setState(() => _p2Pada = v),
          ),
          const SizedBox(height: 24),
          if (widget.provider.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                widget.provider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          CustomButton(
            text: 'Calculate Gun Milan',
            onPressed: () {
              widget.provider.setPerson1(
                _p1NameController.text.trim().isEmpty
                    ? 'Person 1'
                    : _p1NameController.text.trim(),
                _p1Nakshatra,
                _p1Pada,
              );
              widget.provider.setPerson2(
                _p2NameController.text.trim().isEmpty
                    ? 'Person 2'
                    : _p2NameController.text.trim(),
                _p2Nakshatra,
                _p2Pada,
              );
              widget.provider.calculate();
            },
            isLoading: widget.provider.isLoading,
            useGradient: true,
            icon: Icons.favorite,
          ),
        ],
      ),
    );
  }
}

class _PersonForm extends StatelessWidget {
  final String title;
  final TextEditingController nameController;
  final int selectedNakshatra;
  final int selectedPada;
  final Function(int) onNakshatraChanged;
  final Function(int) onPadaChanged;

  const _PersonForm({
    required this.title,
    required this.nameController,
    required this.selectedNakshatra,
    required this.selectedPada,
    required this.onNakshatraChanged,
    required this.onPadaChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppConstants.primarySaffron,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            Text(
              'Janma Nakshatra',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<int>(
              value: selectedNakshatra,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.stars, color: AppConstants.primarySaffron),
              ),
              items: AppConstants.nakshatras.asMap().entries.map((e) {
                return DropdownMenuItem(
                  value: e.key,
                  child: Text('${e.key + 1}. ${e.value}', style: const TextStyle(fontSize: 13)),
                );
              }).toList(),
              onChanged: (v) => v != null ? onNakshatraChanged(v) : null,
            ),
            const SizedBox(height: 12),
            Text(
              'Pada (Quarter)',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<int>(
              value: selectedPada,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.dashboard, color: AppConstants.primarySaffron),
              ),
              items: [1, 2, 3, 4].map((p) {
                return DropdownMenuItem(
                  value: p,
                  child: Text('Pada $p'),
                );
              }).toList(),
              onChanged: (v) => v != null ? onPadaChanged(v) : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  final CompatibilityProvider provider;

  const _ResultView({required this.provider});

  @override
  Widget build(BuildContext context) {
    final result = provider.result!;
    final score = result.totalScore;
    final maxScore = result.maxScore;

    Color scoreColor;
    if (score >= 28) {
      scoreColor = const Color(0xFF00C853);
    } else if (score >= 21) {
      scoreColor = Colors.orange;
    } else if (score >= 14) {
      scoreColor = Colors.amber;
    } else {
      scoreColor = Colors.red;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Score card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  scoreColor.withOpacity(0.8),
                  scoreColor,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: scoreColor.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  '${result.person1Name} ❤️ ${result.person2Name}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$score',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        '/$maxScore',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  result.interpretation,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  result.interpretation_hi,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Koota breakdown
          Text(
            'Ashta Koota Breakdown',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...result.kootaResults.map((koota) => _KootaCard(koota: koota)),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Calculate Again',
            onPressed: provider.reset,
            isOutlined: true,
          ),
        ],
      ),
    );
  }
}

class _KootaCard extends StatelessWidget {
  final KootaResult koota;

  const _KootaCard({required this.koota});

  @override
  Widget build(BuildContext context) {
    final percentage = koota.obtainedPoints / koota.maxPoints;
    final color = koota.isCompatible ? const Color(0xFF00C853) : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        koota.isCompatible ? Icons.check_circle : Icons.cancel,
                        color: color,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        koota.name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Text(
                    '${koota.obtainedPoints}/${koota.maxPoints}',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              koota.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
