import 'package:shared_preferences/shared_preferences.dart';

class SimpleCache {
  final Map<String, String> _memory = {};

  Future<void> write(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } catch (_) {
      _memory[key] = value;
    }
  }

  Future<String?> read(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key) ?? _memory[key];
    } catch (_) {
      return _memory[key];
    }
  }
}
