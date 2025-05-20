import 'package:hive_flutter/hive_flutter.dart';

class ThemeService {
  static const _boxName = 'settings';
  static const _key = 'isDarkMode';
  static late Box _box;

  /// Викликається у main() перед runApp()
  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox(_boxName);
    } else {
      _box = Hive.box(_boxName);
    }
  }

  /// Отримати збережену тему (true = dark, false = light)
  static bool getTheme() {
    return _box.get(_key, defaultValue: false);
  }

  /// Зберегти вибрану тему
  static Future<void> saveTheme(bool isDarkMode) async {
    await _box.put(_key, isDarkMode);
  }
}
