import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _isTitleBelow = true;
  bool _isGridView = false;

  bool get isTitleBelow => _isTitleBelow;
  bool get isGridView => _isGridView;

  SettingsProvider() {
    _loadPreferences();
  }

  void _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isTitleBelow = prefs.getBool('isTitleBelow') ?? true;
    _isGridView = prefs.getBool('isGridView') ?? false;
    notifyListeners();
  }

  void _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isTitleBelow', _isTitleBelow);
    prefs.setBool('isGridView', _isGridView);
  }

  void toggleTitlePosition() {
    _isTitleBelow = !_isTitleBelow;
    _savePreferences();
    notifyListeners();
  }

  void setTitlePosition(bool value) {
    _isTitleBelow = value;
    _savePreferences();
    notifyListeners();
  }

  void toggleViewChange() {
    _isGridView = !_isGridView;
    _savePreferences();
    notifyListeners();
  }

  void setViewChange(bool value) {
    _isGridView = value;
    _savePreferences();
    notifyListeners();
  }
}
