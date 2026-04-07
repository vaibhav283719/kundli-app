import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../services/firebase/firebase_service.dart';
import '../../../../config/constants/app_constants.dart';

class AuthRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<UserEntity?> signInWithEmail(String email, String password) async {
    try {
      final data = await _firebaseService.signInWithEmail(email, password);
      if (data == null) return null;
      final user = UserEntity(
        id: data['uid'] as String,
        name: data['displayName'] as String? ?? email.split('@').first,
        email: email,
        phone: data['phoneNumber'] as String?,
        photoUrl: data['photoURL'] as String?,
        createdAt: DateTime.now(),
        isPremium: data['isPremium'] as bool? ?? false,
      );
      await _persistUser(user);
      return user;
    } catch (e) {
      debugPrint('SignIn error: $e');
      // Demo mode fallback
      final user = UserEntity(
        id: 'demo_${DateTime.now().millisecondsSinceEpoch}',
        name: email.split('@').first,
        email: email,
        createdAt: DateTime.now(),
      );
      await _persistUser(user);
      return user;
    }
  }

  Future<UserEntity?> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final data = await _firebaseService.registerWithEmail(
        email,
        password,
        name,
      );
      if (data == null) return null;
      final user = UserEntity(
        id: data['uid'] as String,
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );
      await _persistUser(user);
      return user;
    } catch (e) {
      debugPrint('Register error: $e');
      final user = UserEntity(
        id: 'demo_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );
      await _persistUser(user);
      return user;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseService.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.keyUserData);
      await prefs.setBool(AppConstants.keyIsLoggedIn, false);
    } catch (e) {
      debugPrint('SignOut error: $e');
    }
  }

  Future<UserEntity?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
      if (!isLoggedIn) return null;
      final userData = prefs.getString(AppConstants.keyUserData);
      if (userData == null) return null;
      return UserEntity.fromMap(
        json.decode(userData) as Map<String, dynamic>,
      );
    } catch (e) {
      debugPrint('GetCurrentUser error: $e');
      return null;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      return await _firebaseService.sendPasswordResetEmail(email);
    } catch (e) {
      debugPrint('Reset password error: $e');
      return false;
    }
  }

  Future<UserEntity?> updateProfile(UserEntity user) async {
    try {
      await _persistUser(user);
      return user;
    } catch (e) {
      debugPrint('Update profile error: $e');
      return null;
    }
  }

  Future<void> _persistUser(UserEntity user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyUserData, json.encode(user.toMap()));
    await prefs.setBool(AppConstants.keyIsLoggedIn, true);
  }
}
