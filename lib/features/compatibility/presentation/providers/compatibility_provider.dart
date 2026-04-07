import 'package:flutter/foundation.dart';
import '../../domain/entities/compatibility_entity.dart';
import '../../domain/services/gun_milan_calculator.dart';

enum CompatibilityStatus { initial, loading, success, error }

class CompatibilityProvider extends ChangeNotifier {
  CompatibilityStatus _status = CompatibilityStatus.initial;
  CompatibilityEntity? _result;
  String? _errorMessage;

  // Person 1
  String _person1Name = '';
  int _person1Nakshatra = 0;
  int _person1Pada = 1;

  // Person 2
  String _person2Name = '';
  int _person2Nakshatra = 0;
  int _person2Pada = 1;

  CompatibilityStatus get status => _status;
  CompatibilityEntity? get result => _result;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == CompatibilityStatus.loading;

  String get person1Name => _person1Name;
  int get person1Nakshatra => _person1Nakshatra;
  int get person1Pada => _person1Pada;
  String get person2Name => _person2Name;
  int get person2Nakshatra => _person2Nakshatra;
  int get person2Pada => _person2Pada;

  void setPerson1(String name, int nakshatra, int pada) {
    _person1Name = name;
    _person1Nakshatra = nakshatra;
    _person1Pada = pada;
    notifyListeners();
  }

  void setPerson2(String name, int nakshatra, int pada) {
    _person2Name = name;
    _person2Nakshatra = nakshatra;
    _person2Pada = pada;
    notifyListeners();
  }

  Future<void> calculate() async {
    if (_person1Name.isEmpty || _person2Name.isEmpty) {
      _errorMessage = 'Please enter names for both persons';
      notifyListeners();
      return;
    }

    _status = CompatibilityStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _result = GunMilanCalculator.calculate(
        _person1Name,
        _person1Nakshatra,
        _person1Pada,
        _person2Name,
        _person2Nakshatra,
        _person2Pada,
      );
      _status = CompatibilityStatus.success;
    } catch (e) {
      _status = CompatibilityStatus.error;
      _errorMessage = 'Calculation failed: $e';
      debugPrint('Compatibility calculation error: $e');
    }
    notifyListeners();
  }

  void reset() {
    _result = null;
    _status = CompatibilityStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }
}
