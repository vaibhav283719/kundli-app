import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/kundli_entity.dart';
import '../../../../config/constants/app_constants.dart';
import '../../../../services/firebase/firebase_service.dart';

class KundliRepository {
  final FirebaseService _firebaseService = FirebaseService();
  static const String _collection = 'kundlis';

  Future<void> saveKundli(KundliEntity kundli) async {
    try {
      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      final List<String> existing = prefs.getStringList(AppConstants.keyKundliList) ?? [];
      final Map<String, dynamic> data = kundli.toMap();
      final jsonStr = json.encode(data);

      // Remove old version if exists
      final updated = existing.where((s) {
        try {
          final decoded = json.decode(s) as Map<String, dynamic>;
          return decoded['id'] != kundli.id;
        } catch (_) {
          return false;
        }
      }).toList();
      updated.add(jsonStr);
      await prefs.setStringList(AppConstants.keyKundliList, updated);

      // Sync to Firestore
      await _firebaseService.saveDocument(_collection, kundli.id, data);
    } catch (e) {
      debugPrint('Save kundli error: $e');
    }
  }

  Future<KundliEntity?> getKundli(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> existing = prefs.getStringList(AppConstants.keyKundliList) ?? [];
      for (final s in existing) {
        final decoded = json.decode(s) as Map<String, dynamic>;
        if (decoded['id'] == id) {
          return KundliEntity.fromMap(decoded);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Get kundli error: $e');
      return null;
    }
  }

  Future<List<KundliEntity>> getAllKundlis() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> existing = prefs.getStringList(AppConstants.keyKundliList) ?? [];
      return existing.map((s) {
        final decoded = json.decode(s) as Map<String, dynamic>;
        return KundliEntity.fromMap(decoded);
      }).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      debugPrint('Get all kundlis error: $e');
      return [];
    }
  }

  Future<void> deleteKundli(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> existing = prefs.getStringList(AppConstants.keyKundliList) ?? [];
      final updated = existing.where((s) {
        try {
          final decoded = json.decode(s) as Map<String, dynamic>;
          return decoded['id'] != id;
        } catch (_) {
          return false;
        }
      }).toList();
      await prefs.setStringList(AppConstants.keyKundliList, updated);
      await _firebaseService.deleteDocument(_collection, id);
    } catch (e) {
      debugPrint('Delete kundli error: $e');
    }
  }

  Future<void> updateNotes(String id, String notes) async {
    try {
      final kundli = await getKundli(id);
      if (kundli == null) return;
      final updated = KundliEntity(
        id: kundli.id,
        birthDetails: kundli.birthDetails,
        lagnaRashi: kundli.lagnaRashi,
        lagnaLongitude: kundli.lagnaLongitude,
        planetPositions: kundli.planetPositions,
        houseRashis: kundli.houseRashis,
        dashas: kundli.dashas,
        yogas: kundli.yogas,
        createdAt: kundli.createdAt,
        notes: notes,
      );
      await saveKundli(updated);
    } catch (e) {
      debugPrint('Update notes error: $e');
    }
  }
}
