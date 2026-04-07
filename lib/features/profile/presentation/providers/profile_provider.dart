import 'package:flutter/foundation.dart';
import '../../domain/entities/profile_entity.dart';
import '../../data/repositories/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository = ProfileRepository();

  List<ProfileEntity> _profiles = [];
  ProfileEntity? _selectedProfile;
  bool _isLoading = false;

  List<ProfileEntity> get profiles => _profiles;
  ProfileEntity? get selectedProfile => _selectedProfile;
  bool get isLoading => _isLoading;

  ProfileProvider() {
    loadProfiles();
  }

  Future<void> loadProfiles() async {
    _isLoading = true;
    notifyListeners();
    try {
      _profiles = await _repository.getAllProfiles();
    } catch (e) {
      debugPrint('Load profiles error: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveProfile(ProfileEntity profile) async {
    try {
      await _repository.saveProfile(profile);
      await loadProfiles();
    } catch (e) {
      debugPrint('Save profile error: $e');
    }
  }

  Future<void> deleteProfile(String id) async {
    try {
      await _repository.deleteProfile(id);
      if (_selectedProfile?.id == id) _selectedProfile = null;
      await loadProfiles();
    } catch (e) {
      debugPrint('Delete profile error: $e');
    }
  }

  Future<void> setPrimary(String id) async {
    try {
      await _repository.setPrimary(id);
      await loadProfiles();
    } catch (e) {
      debugPrint('Set primary error: $e');
    }
  }

  void selectProfile(ProfileEntity profile) {
    _selectedProfile = profile;
    notifyListeners();
  }

  ProfileEntity? getProfileById(String id) {
    try {
      return _profiles.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
