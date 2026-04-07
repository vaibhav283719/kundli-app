import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../../domain/entities/profile_entity.dart';
import '../../../kundli/domain/entities/birth_details_entity.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../../../../config/constants/app_constants.dart';

class EditProfileScreen extends StatefulWidget {
  final String? profileId;

  const EditProfileScreen({super.key, this.profileId});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _placeController = TextEditingController();
  final _latController = TextEditingController();
  final _lonController = TextEditingController();
  final _timezoneController = TextEditingController(text: '5.5');
  final _notesController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.profileId != null) {
      _loadProfile();
    }
  }

  void _loadProfile() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProfileProvider>();
      final profile = provider.getProfileById(widget.profileId!);
      if (profile != null) {
        setState(() {
          _isEditing = true;
          _nameController.text = profile.name;
          _notesController.text = profile.notes ?? '';
          if (profile.birthDetails != null) {
            final bd = profile.birthDetails!;
            _placeController.text = bd.placeOfBirth;
            _latController.text = bd.latitude.toString();
            _lonController.text = bd.longitude.toString();
            _timezoneController.text = bd.timezone.toString();
            _selectedDate = bd.dateOfBirth;
            final hour = bd.timeOfBirthHour.floor();
            final minute = ((bd.timeOfBirthHour - hour) * 60).round();
            _selectedTime = TimeOfDay(hour: hour, minute: minute);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _placeController.dispose();
    _latController.dispose();
    _lonController.dispose();
    _timezoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    BirthDetailsEntity? birthDetails;
    if (_selectedDate != null && _selectedTime != null) {
      birthDetails = BirthDetailsEntity(
        name: _nameController.text.trim(),
        dateOfBirth: _selectedDate!,
        timeOfBirthHour:
            _selectedTime!.hour + _selectedTime!.minute / 60.0,
        placeOfBirth: _placeController.text.trim(),
        latitude: double.tryParse(_latController.text) ?? 28.6139,
        longitude: double.tryParse(_lonController.text) ?? 77.2090,
        timezone: double.tryParse(_timezoneController.text) ?? 5.5,
      );
    }

    final profile = ProfileEntity(
      id: widget.profileId ?? 'profile_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      birthDetails: birthDetails,
      createdAt: DateTime.now(),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    await context.read<ProfileProvider>().saveProfile(profile);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing ? 'Profile updated' : 'Profile saved'),
          backgroundColor: const Color(0xFF00C853),
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Profile' : 'Add Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo area
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: AppConstants.primarySaffron.withOpacity(0.1),
                      child: Text(
                        _nameController.text.isNotEmpty
                            ? _nameController.text[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 36,
                          color: AppConstants.primarySaffron,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppConstants.primarySaffron,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
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
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Notes (optional)',
                hint: 'Add notes about this profile...',
                controller: _notesController,
                prefixIcon: Icons.notes,
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              _sectionTitle('Birth Details (Optional)'),
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
              CustomTextField(
                label: 'Place of Birth',
                hint: 'City, Country',
                controller: _placeController,
                prefixIcon: Icons.location_on_outlined,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Latitude',
                      hint: '28.6139',
                      controller: _latController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      label: 'Longitude',
                      hint: '77.2090',
                      controller: _lonController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Timezone (UTC)',
                hint: '5.5 for IST',
                controller: _timezoneController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
              ),
              const SizedBox(height: 28),
              Consumer<ProfileProvider>(
                builder: (context, provider, _) => CustomButton(
                  text: _isEditing ? 'Update Profile' : 'Save Profile',
                  onPressed: _handleSave,
                  isLoading: provider.isLoading,
                  useGradient: true,
                  icon: Icons.save,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: AppConstants.primarySaffron,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
