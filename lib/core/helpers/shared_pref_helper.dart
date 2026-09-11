import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static const String _userCodeKey = 'user_code';
  static const String _userEmailKey = 'user_email';
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';

  static Future<void> saveUserCode(String userCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userCodeKey, userCode);
  }

  static Future<String?> getUserCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userCodeKey);
  }

  static Future<void> removeUserCode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userCodeKey);
  }

  static Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, email);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userCodeKey);
    await prefs.remove(_userEmailKey);
  }

  static Future<bool> hasUserSession() async {
    final code = await getUserCode();
    return code != null && code.isNotEmpty;
  }

  static Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenOnboardingKey, true);
  }

  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSeenOnboardingKey) ?? false;
  }
}