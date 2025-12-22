import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavProvider extends ChangeNotifier {
  int _currentIndex = 0;
  bool _isLoading = true;

  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;

  BottomNavProvider() {
    _loadIndex();
  }

  Future<void> _loadIndex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentIndex = prefs.getInt('last_tab') ?? 0;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _currentIndex = 0;
      _isLoading = false;
      notifyListeners();
    }
  }

  void changeIndex(int index) async {
    if (_currentIndex == index) return;

    _currentIndex = index;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('last_tab', index);
    } catch (e) {
      // Hata durumunda sessizce devam et
    }
  }
}
