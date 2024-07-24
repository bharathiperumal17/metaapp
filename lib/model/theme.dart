

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeModeKey = 'themeMode';

  ThemeMode themeModeValue = ThemeMode.system;

  ThemeProvider() {
    _loadThemeMode();
  }

  bool get isDarkMode => themeModeValue == ThemeMode.dark;

  void switchThemeData(bool isOn) {
    themeModeValue = isOn ? ThemeMode.light : ThemeMode.dark;
    _saveThemeMode(themeModeValue);
    notifyListeners();
  }

  void switchToSystemTheme() {
    themeModeValue = ThemeMode.system;
    _saveThemeMode(themeModeValue);
    notifyListeners();
  }

  Future<void> _saveThemeMode(ThemeMode themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, themeMode.index);
  }

  Future<void> _loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? themeModeIndex = prefs.getInt(_themeModeKey);
    if (themeModeIndex != null) {
      themeModeValue = ThemeMode.values[themeModeIndex];
      notifyListeners();
    } else {
      Brightness platformBrightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      themeModeValue = platformBrightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light;
      notifyListeners();
    }
  }
}

class ThemeDataClass {
  static final darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.grey.shade700,
    colorScheme: ColorScheme.dark(
      primary: Colors.blue.shade800,
      background: const Color.fromRGBO(85, 85, 85, 1),
        inversePrimary:Colors.white,
  
    ),
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(
          primary:  Colors.blue.shade800,
          background: Colors.white54,
              inversePrimary: const Color.fromRGBO(27, 27, 27, 1),
         ));
}