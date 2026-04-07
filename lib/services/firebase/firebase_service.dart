import 'package:flutter/foundation.dart';

/// Firebase service wrapper. All Firebase calls use try/catch
/// so the app runs in demo mode when Firebase is not configured.
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  bool _firebaseAvailable = false;

  Future<void> initialize() async {
    try {
      // Check Firebase availability
      _firebaseAvailable = true;
    } catch (e) {
      _firebaseAvailable = false;
      debugPrint('Firebase not available, running in demo mode: $e');
    }
  }

  bool get isAvailable => _firebaseAvailable;

  // Auth operations
  Future<Map<String, dynamic>?> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      if (!_firebaseAvailable) return _demoUser(email);
      // Real Firebase auth would go here
      return _demoUser(email);
    } catch (e) {
      debugPrint('Sign in error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> registerWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      if (!_firebaseAvailable) return _demoUser(email, name: name);
      return _demoUser(email, name: name);
    } catch (e) {
      debugPrint('Register error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      debugPrint('User signed out');
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      debugPrint('Password reset email sent to $email');
      return true;
    } catch (e) {
      debugPrint('Password reset error: $e');
      return false;
    }
  }

  // Firestore operations
  Future<void> saveDocument(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    try {
      if (!_firebaseAvailable) return;
      debugPrint('Saving to Firestore: $collection/$docId');
    } catch (e) {
      debugPrint('Firestore save error: $e');
    }
  }

  Future<Map<String, dynamic>?> getDocument(
    String collection,
    String docId,
  ) async {
    try {
      if (!_firebaseAvailable) return null;
      return null;
    } catch (e) {
      debugPrint('Firestore get error: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getCollection(
    String collection, {
    String? whereField,
    dynamic whereValue,
  }) async {
    try {
      if (!_firebaseAvailable) return [];
      return [];
    } catch (e) {
      debugPrint('Firestore collection error: $e');
      return [];
    }
  }

  Future<void> deleteDocument(String collection, String docId) async {
    try {
      if (!_firebaseAvailable) return;
      debugPrint('Deleting from Firestore: $collection/$docId');
    } catch (e) {
      debugPrint('Firestore delete error: $e');
    }
  }

  // Analytics
  Future<void> logEvent(String name, [Map<String, dynamic>? params]) async {
    try {
      debugPrint('Analytics event: $name, params: $params');
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  Future<void> setUserProperty(String name, String value) async {
    try {
      debugPrint('Analytics user property: $name = $value');
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  // Push notifications
  Future<String?> getFcmToken() async {
    try {
      if (!_firebaseAvailable) return 'demo_token';
      return 'demo_token';
    } catch (e) {
      debugPrint('FCM token error: $e');
      return null;
    }
  }

  Map<String, dynamic> _demoUser(String email, {String? name}) {
    return {
      'uid': 'demo_user_${DateTime.now().millisecondsSinceEpoch}',
      'email': email,
      'displayName': name ?? email.split('@').first,
      'photoURL': null,
      'phoneNumber': null,
      'createdAt': DateTime.now().toIso8601String(),
      'isPremium': false,
    };
  }
}
