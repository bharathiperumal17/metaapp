import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginHistoryEntry {
  final String userId;
  final String type;
  final DateTime date;

  LoginHistoryEntry(this.userId, this.type, this.date);

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'type': type,
      'date': date.toIso8601String(),
    };
  }

  factory LoginHistoryEntry.fromJson(Map<String, dynamic> json) {
    return LoginHistoryEntry(
      json['userId'],
      json['type'],
      DateTime.parse(json['date']),
    );
  }
}

Future<void> submit(String username, String password, String role, {required bool isLogin}) async {
  final prefs = await SharedPreferences.getInstance();
  final loginHistoryData = prefs.getStringList("loginHistory") ?? [];

  final entry = LoginHistoryEntry(username, isLogin ? "login" : "logout", DateTime.now());
  loginHistoryData.add(jsonEncode(entry.toJson()));

  prefs.setStringList("loginHistory", loginHistoryData);
}
