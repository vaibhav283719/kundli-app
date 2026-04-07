import 'package:flutter/foundation.dart';
import '../../domain/entities/kundli_entity.dart';
import '../../domain/entities/birth_details_entity.dart';
import '../../domain/services/astrology_calculator.dart';
import '../../data/repositories/kundli_repository.dart';

enum KundliStatus { initial, loading, success, error }

class KundliProvider extends ChangeNotifier {
  final KundliRepository _repository = KundliRepository();

  KundliStatus _status = KundliStatus.initial;
  KundliEntity? _currentKundli;
  List<KundliEntity> _savedKundlis = [];
  String? _errorMessage;

  KundliStatus get status => _status;
  KundliEntity? get currentKundli => _currentKundli;
  List<KundliEntity> get savedKundlis => _savedKundlis;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == KundliStatus.loading;

  KundliProvider() {
    loadSavedKundlis();
  }

  Future<void> generateKundli(BirthDetailsEntity birthDetails) async {
    _status = KundliStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final id = 'kundli_${DateTime.now().millisecondsSinceEpoch}';
      _currentKundli = AstrologyCalculator.calculateKundli(id, birthDetails);
      _status = KundliStatus.success;
    } catch (e) {
      _status = KundliStatus.error;
      _errorMessage = 'Failed to generate kundli: $e';
      debugPrint('Generate kundli error: $e');
    }
    notifyListeners();
  }

  Future<void> saveCurrentKundli() async {
    if (_currentKundli == null) return;
    try {
      await _repository.saveKundli(_currentKundli!);
      await loadSavedKundlis();
      notifyListeners();
    } catch (e) {
      debugPrint('Save kundli error: $e');
    }
  }

  Future<void> loadSavedKundlis() async {
    try {
      _savedKundlis = await _repository.getAllKundlis();
      notifyListeners();
    } catch (e) {
      debugPrint('Load kundlis error: $e');
    }
  }

  Future<void> loadKundli(String id) async {
    _status = KundliStatus.loading;
    notifyListeners();
    try {
      _currentKundli = await _repository.getKundli(id);
      _status = _currentKundli != null ? KundliStatus.success : KundliStatus.error;
      if (_currentKundli == null) _errorMessage = 'Kundli not found';
    } catch (e) {
      _status = KundliStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> deleteKundli(String id) async {
    try {
      await _repository.deleteKundli(id);
      if (_currentKundli?.id == id) _currentKundli = null;
      await loadSavedKundlis();
      notifyListeners();
    } catch (e) {
      debugPrint('Delete kundli error: $e');
    }
  }

  void setCurrentKundli(KundliEntity kundli) {
    _currentKundli = kundli;
    _status = KundliStatus.success;
    notifyListeners();
  }

  void clearCurrent() {
    _currentKundli = null;
    _status = KundliStatus.initial;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
