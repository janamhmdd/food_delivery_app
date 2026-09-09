import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static const String _userCodeKey = 'user_code';

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
}