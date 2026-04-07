import 'package:flutter/foundation.dart';
import '../../domain/entities/user_entity.dart';
import '../../data/repositories/auth_repository.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  AuthStatus _status = AuthStatus.initial;
  UserEntity? _currentUser;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserEntity? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _status == AuthStatus.loading;

  AuthProvider() {
    checkAuthState();
  }

  Future<void> checkAuthState() async {
    _status = AuthStatus.loading;
    notifyListeners();
    try {
      _currentUser = await _authRepository.getCurrentUser();
      _status = _currentUser != null
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      debugPrint('Check auth state error: $e');
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authRepository.signInWithEmail(email, password);
      if (_currentUser != null) {
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.error;
        _errorMessage = 'Invalid credentials. Please try again.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authRepository.register(name, email, password);
      if (_currentUser != null) {
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.error;
        _errorMessage = 'Registration failed. Please try again.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _authRepository.sendPasswordResetEmail(email);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return success;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      await _authRepository.signOut();
      _currentUser = null;
      _status = AuthStatus.unauthenticated;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> updateUser(UserEntity user) async {
    try {
      _currentUser = await _authRepository.updateProfile(user);
      notifyListeners();
    } catch (e) {
      debugPrint('Update user error: $e');
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
