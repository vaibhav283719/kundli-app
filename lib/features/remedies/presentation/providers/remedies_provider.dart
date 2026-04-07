import 'package:flutter/foundation.dart';
import '../../domain/entities/remedy_entity.dart';
import '../../domain/services/remedy_service.dart';

class RemediesProvider extends ChangeNotifier {
  List<RemedyEntity> _remedies = [];
  String _selectedPlanet = 'All';
  String? _selectedCategory;
  bool _isLoading = false;

  List<RemedyEntity> get remedies => _remedies;
  String get selectedPlanet => _selectedPlanet;
  String? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  List<String> get planets => RemedyService.getAllPlanets();
  List<String> get categories => RemedyService.getAllCategories();

  RemediesProvider() {
    loadRemedies();
  }

  Future<void> loadRemedies() async {
    _isLoading = true;
    notifyListeners();
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      _remedies = RemedyService.getRemediesByPlanet(_selectedPlanet);
      if (_selectedCategory != null) {
        _remedies = _remedies
            .where((r) => r.categories.contains(_selectedCategory))
            .toList();
      }
    } catch (e) {
      debugPrint('Load remedies error: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  void selectPlanet(String planet) {
    _selectedPlanet = planet;
    _selectedCategory = null;
    loadRemedies();
  }

  void selectCategory(String? category) {
    _selectedCategory = category;
    loadRemedies();
  }

  void clearFilters() {
    _selectedPlanet = 'All';
    _selectedCategory = null;
    loadRemedies();
  }
}
