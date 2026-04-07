import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/kundli_provider.dart';
import '../../domain/entities/birth_details_entity.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../../../../config/constants/app_constants.dart';

class BirthDetailsScreen extends StatefulWidget {
  const BirthDetailsScreen({super.key});

  @override
  State<BirthDetailsScreen> createState() => _BirthDetailsScreenState();
}

class _BirthDetailsScreenState extends State<BirthDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _placeController = TextEditingController();
  final _latController = TextEditingController();
  final _lonController = TextEditingController();
  final _timezoneController = TextEditingController(text: '5.5');

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _nameController.dispose();
    _placeController.dispose();
    _latController.dispose();
    _lonController.dispose();
    _timezoneController.dispose();
    super.dispose();
  }

  Future<void> _handleGenerate() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date of birth')),
      );
      return;
    }
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select time of birth')),
      );
      return;
    }

    final timeHour =
        _selectedTime!.hour + _selectedTime!.minute / 60.0;
    final lat = double.tryParse(_latController.text) ?? 28.6139;
    final lon = double.tryParse(_lonController.text) ?? 77.2090;
    final tz = double.tryParse(_timezoneController.text) ?? 5.5;

    final birth = BirthDetailsEntity(
      name: _nameController.text.trim(),
      dateOfBirth: _selectedDate!,
      timeOfBirthHour: timeHour,
      placeOfBirth: _placeController.text.trim(),
      latitude: lat,
      longitude: lon,
      timezone: tz,
    );

    final kundliProvider = context.read<KundliProvider>();
    await kundliProvider.generateKundli(birth);

    if (mounted && kundliProvider.status.name == 'success') {
      context.push('/kundli-chart');
    } else if (mounted && kundliProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(kundliProvider.errorMessage!), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Birth Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF1A0533), const Color(0xFF0D0221)]
                : [const Color(0xFFFFF8F0), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B00), Color(0xFFFF9500)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Text('🌟', style: TextStyle(fontSize: 32)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Generate Your Kundli',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'Enter accurate birth details for precise calculations',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle('Personal Information'),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'Full Name',
                    hint: 'Enter name',
                    controller: _nameController,
                    prefixIcon: Icons.person_outlined,
                    validator: Validators.validateName,
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Birth Date & Time'),
                  const SizedBox(height: 12),
                  DatePickerField(
                    label: 'Date of Birth',
                    selectedDate: _selectedDate,
                    onDateSelected: (d) => setState(() => _selectedDate = d),
                    lastDate: DateTime.now(),
                  ),
                  const SizedBox(height: 16),
                  TimePickerField(
                    label: 'Time of Birth',
                    selectedTime: _selectedTime,
                    onTimeSelected: (t) => setState(() => _selectedTime = t),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Birth Place'),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'Place of Birth',
                    hint: 'City, State, Country',
                    controller: _placeController,
                    prefixIcon: Icons.location_on_outlined,
                    validator: Validators.validatePlace,
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'Latitude',
                          hint: 'e.g. 28.6139',
                          controller: _latController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          prefixIcon: Icons.my_location,
                          validator: Validators.validateLatitude,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          label: 'Longitude',
                          hint: 'e.g. 77.2090',
                          controller: _lonController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          prefixIcon: Icons.my_location,
                          validator: Validators.validateLongitude,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Timezone (UTC offset)',
                    hint: 'e.g. 5.5 for IST',
                    controller: _timezoneController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    prefixIcon: Icons.access_time,
                  ),
                  const SizedBox(height: 16),
                  // Quick location presets
                  Text(
                    'Quick Location Presets:',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _locationChip('New Delhi', 28.6139, 77.2090, 5.5),
                      _locationChip('Mumbai', 19.0760, 72.8777, 5.5),
                      _locationChip('Kolkata', 22.5726, 88.3639, 5.5),
                      _locationChip('Chennai', 13.0827, 80.2707, 5.5),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Consumer<KundliProvider>(
                    builder: (context, kundli, _) => CustomButton(
                      text: 'Generate Kundli',
                      onPressed: _handleGenerate,
                      isLoading: kundli.isLoading,
                      useGradient: true,
                      icon: Icons.auto_awesome,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppConstants.primarySaffron,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _locationChip(
    String city,
    double lat,
    double lon,
    double tz,
  ) {
    return ActionChip(
      label: Text(city, style: const TextStyle(fontSize: 12)),
      onPressed: () {
        _placeController.text = city;
        _latController.text = lat.toString();
        _lonController.text = lon.toString();
        _timezoneController.text = tz.toString();
      },
      backgroundColor: AppConstants.primarySaffron.withOpacity(0.1),
      side: const BorderSide(color: AppConstants.primarySaffron, width: 0.5),
    );
  }
}
