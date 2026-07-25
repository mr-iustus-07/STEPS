import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Riverpod Provider for UI to listen to settings changes
final settingsProvider = Provider<SettingsService>((ref) {
  return SettingsService.instance;
});

class SettingsService {
  SettingsService._();

  static late final SharedPreferences _prefs;
  
  static SettingsService get instance => SettingsService._();

  /// Bootstraps SharedPreferences. Called in main.dart.
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- Keys ---
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyUserName = 'user_name';
  static const String _keyHasCompletedOnboarding = 'has_completed_onboarding';

  // --- Getters & Setters ---

  /// App Theme (You are using strict monochrome, but this allows a dark/light toggle if you ever want pure white mode)
  bool get isDarkMode => _prefs.getBool(_keyThemeMode) ?? true; // Default true for STEPS
  Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool(_keyThemeMode, isDark);
  }

  /// Master switch for notifications
  bool get notificationsEnabled => _prefs.getBool(_keyNotificationsEnabled) ?? true;
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_keyNotificationsEnabled, enabled);
  }

  /// User Name for Dashboard ("Good Evening, Spidy")
  String get userName => _prefs.getString(_keyUserName) ?? 'Commander';
  Future<void> setUserName(String name) async {
    await _prefs.setString(_keyUserName, name);
  }

  /// First Launch Detection (to show an intro/setup screen later)
  bool get hasCompletedOnboarding => _prefs.getBool(_keyHasCompletedOnboarding) ?? false;
  Future<void> setCompletedOnboarding() async {
    await _prefs.setBool(_keyHasCompletedOnboarding, true);
  }
}