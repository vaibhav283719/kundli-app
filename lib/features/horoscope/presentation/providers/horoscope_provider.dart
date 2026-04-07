import 'package:flutter/foundation.dart';
import '../../domain/entities/horoscope_entity.dart';
import '../../domain/services/horoscope_service.dart';
import '../../../../config/constants/app_constants.dart';

enum HoroscopeStatus { initial, loading, success, error }

class HoroscopeProvider extends ChangeNotifier {
  HoroscopeStatus _status = HoroscopeStatus.initial;
  String _selectedSign = AppConstants.zodiacSigns[0];
  String _selectedPeriod = 'Daily';
  HoroscopeEntity? _currentHoroscope;
  DateTime _selectedDate = DateTime.now();

  HoroscopeStatus get status => _status;
  String get selectedSign => _selectedSign;
  String get selectedPeriod => _selectedPeriod;
  HoroscopeEntity? get currentHoroscope => _currentHoroscope;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _status == HoroscopeStatus.loading;

  HoroscopeProvider() {
    loadHoroscope();
  }

  void selectSign(String sign) {
    _selectedSign = sign;
    loadHoroscope();
  }

  void selectPeriod(String period) {
    _selectedPeriod = period;
    loadHoroscope();
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    loadHoroscope();
  }

  Future<void> loadHoroscope() async {
    _status = HoroscopeStatus.loading;
    notifyListeners();
    try {
      // Simulate async loading
      await Future.delayed(const Duration(milliseconds: 300));
      _currentHoroscope = HoroscopeService.getHoroscope(
        _selectedSign,
        _selectedPeriod,
        _selectedDate,
      );
      _status = HoroscopeStatus.success;
    } catch (e) {
      _status = HoroscopeStatus.error;
      debugPrint('Load horoscope error: $e');
    }
    notifyListeners();
  }

  List<String> get allSigns => AppConstants.zodiacSigns;
  List<String> get periods => ['Daily', 'Weekly', 'Monthly', 'Yearly'];
}
