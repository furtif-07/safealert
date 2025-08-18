import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static late SharedPreferences _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs => _prefs;

  // Getters pour les préférences
  static bool get isFirstLaunch => _prefs.getBool('is_first_launch') ?? true;
  static String? get userToken => _prefs.getString('user_token');
  static String? get userRole => _prefs.getString('user_role');

  // Setters pour les préférences
  static Future<void> setFirstLaunch(bool value) async {
    await _prefs.setBool('is_first_launch', value);
  }

  static Future<void> setUserToken(String token) async {
    await _prefs.setString('user_token', token);
  }

  static Future<void> setUserRole(String role) async {
    await _prefs.setString('user_role', role);
  }

  static Future<void> clearUserData() async {
    await _prefs.remove('user_token');
    await _prefs.remove('user_role');
  }
}