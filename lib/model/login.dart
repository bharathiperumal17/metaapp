import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

 userLoginDetails(String userId, String password, String role) async {
    final login = {
      'userId': userId,
      'password': password,
      'role': role,
    };

    SharedPreferences ref = await SharedPreferences.getInstance();
    String? data = ref.getString('loginKey');
    if (data != null) {
      List dummy = jsonDecode(data);
      List loginDetails = dummy.cast();
      loginDetails.add(login);
      ref.setString('loginKey', jsonEncode(loginDetails));
    }
  }


Future<void> initializeUserLoginInfo() async {
  SharedPreferences ref = await SharedPreferences.getInstance();
  String? data = ref.getString('loginKey');

  if (data == null) {
    List<Map<String, dynamic>> userLoginInfo = [
      {
        'userId': 'user1',
        'password': '123',
        'role': 'biller',
      },
      {
        'userId': 'user2',
        'password': '123',
        'role': 'manager',
      },
      {
        'userId': 'user3',
        'password': '123',
        'role': 'inventry',
      },
      {
        'userId': 'user4',
        'password': '123',
        'role': 'systemAdmin',
      },
    ];
    ref.setString('loginKey', jsonEncode(userLoginInfo));
  }
}