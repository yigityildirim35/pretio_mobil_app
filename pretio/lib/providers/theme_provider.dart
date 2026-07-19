import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';
class ThemeProvider with ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();
  int _themeIndex = 1;
  bool _is3DEnabled = false;
  bool _isEmotionModuleEnabled = true;
  bool _isNeedWantModuleEnabled = true;

  int get themeIndex => _themeIndex;
  bool get is3DEnabled => _is3DEnabled;
  bool get isEmotionModuleEnabled => _isEmotionModuleEnabled;
  bool get isNeedWantModuleEnabled => _isNeedWantModuleEnabled;

  Future<void> loadTheme() async {
    final index = await _storage.loadThemeIndex();
    if (index != null) {
      _themeIndex = index;
    }
    _is3DEnabled = await _storage.load3DEnabled();
    _isEmotionModuleEnabled = await _storage.loadBoolSetting('settings_emotions_enabled', defaultValue: true);
    _isNeedWantModuleEnabled = await _storage.loadBoolSetting('settings_needs_enabled', defaultValue: true);
    notifyListeners();
  }

  void setTheme(int index) {
    _themeIndex = index;
    _storage.saveThemeIndex(index);
    notifyListeners();
  }

  void set3DEnabled(bool enabled) {
    _is3DEnabled = enabled;
    _storage.save3DEnabled(enabled);
    notifyListeners();
  }

  void setEmotionModuleEnabled(bool enabled) {
    _isEmotionModuleEnabled = enabled;
    _storage.saveBoolSetting('settings_emotions_enabled', enabled);
    notifyListeners();
  }

  void setNeedWantModuleEnabled(bool enabled) {
    _isNeedWantModuleEnabled = enabled;
    _storage.saveBoolSetting('settings_needs_enabled', enabled);
    notifyListeners();
  }
}
