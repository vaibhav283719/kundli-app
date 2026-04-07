import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/profile_entity.dart';
import '../../../../config/constants/app_constants.dart';
import '../../../../services/firebase/firebase_service.dart';

class ProfileRepository {
  final FirebaseService _firebaseService = FirebaseService();
  static const String _collection = 'profiles';

  Future<void> saveProfile(ProfileEntity profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> existing =
          prefs.getStringList(AppConstants.keyProfileList) ?? [];
      final updated = existing.where((s) {
        try {
          return (json.decode(s) as Map<String, dynamic>)['id'] != profile.id;
        } catch (_) {
          return false;
        }
      }).toList();
      updated.add(json.encode(profile.toMap()));
      await prefs.setStringList(AppConstants.keyProfileList, updated);
      await _firebaseService.saveDocument(_collection, profile.id, profile.toMap());
    } catch (e) {
      debugPrint('Save profile error: $e');
    }
  }

  Future<ProfileEntity?> getProfile(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> existing =
          prefs.getStringList(AppConstants.keyProfileList) ?? [];
      for (final s in existing) {
        final decoded = json.decode(s) as Map<String, dynamic>;
        if (decoded['id'] == id) return ProfileEntity.fromMap(decoded);
      }
      return null;
    } catch (e) {
      debugPrint('Get profile error: $e');
      return null;
    }
  }

  Future<List<ProfileEntity>> getAllProfiles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> existing =
          prefs.getStringList(AppConstants.keyProfileList) ?? [];
      return existing.map((s) {
        return ProfileEntity.fromMap(json.decode(s) as Map<String, dynamic>);
      }).toList()
        ..sort((a, b) {
          if (a.isPrimary) return -1;
          if (b.isPrimary) return 1;
          return b.createdAt.compareTo(a.createdAt);
        });
    } catch (e) {
      debugPrint('Get all profiles error: $e');
      return [];
    }
  }

  Future<void> deleteProfile(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> existing =
          prefs.getStringList(AppConstants.keyProfileList) ?? [];
      final updated = existing.where((s) {
        try {
          return (json.decode(s) as Map<String, dynamic>)['id'] != id;
        } catch (_) {
          return false;
        }
      }).toList();
      await prefs.setStringList(AppConstants.keyProfileList, updated);
      await _firebaseService.deleteDocument(_collection, id);
    } catch (e) {
      debugPrint('Delete profile error: $e');
    }
  }

  Future<void> setPrimary(String id) async {
    try {
      final profiles = await getAllProfiles();
      for (final p in profiles) {
        final updated = p.copyWith(isPrimary: p.id == id);
        await saveProfile(updated);
      }
    } catch (e) {
      debugPrint('Set primary error: $e');
    }
  }
}
