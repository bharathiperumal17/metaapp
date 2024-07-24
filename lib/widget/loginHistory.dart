import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:metaapp/model/submit.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginHistory extends StatefulWidget {
  const LoginHistory({super.key});

  @override
  State<LoginHistory> createState() => _LoginHistoryState();
}

class _LoginHistoryState extends State<LoginHistory> {
  TextEditingController search = TextEditingController();
  List<LoginHistoryEntry> loginHistory = [];

  @override
  void initState() {
    super.initState();
    fetchLoginHistory();
  }

  Future<void> fetchLoginHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final loginHistoryData = prefs.getStringList("loginHistory") ?? [];
    loginHistory = loginHistoryData
        .map((jsonString) => LoginHistoryEntry.fromJson(jsonDecode(jsonString)))
        .toList();
    setState(() {});
  }

  // List<LoginHistoryEntry> getLoginHistory() {
  //   return loginHistory;
  // }

  void filterDetails(String value) {
  final searchValue = value.toLowerCase();
  if (searchValue.isEmpty) {
    fetchLoginHistory(); 
  }else {
  final filteredHistory = loginHistory.where((entry) {
    final userId = entry.userId.toLowerCase();
    final type = entry.type.toLowerCase();
    final date = entry.date.toIso8601String();
    return userId.contains(searchValue) || type.contains(searchValue) || date.contains(searchValue);
  }).toList();
  setState(() {
    loginHistory = filteredHistory;
  });
}

}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          'Login History',
          style: TextStyle(
            fontSize: 30.0,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 20),
        
        Container(
           decoration: BoxDecoration(
            boxShadow: [
             BoxShadow(
                color:Theme.of(context).colorScheme.background,
                blurRadius: 6,
                offset: const Offset(0, 3),
                spreadRadius: 3
              )
            ]
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: search,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    filterDetails(value);
                  },
                ),
              ),
              if (loginHistory.isEmpty) 
                const Text('No login history data available.'),
              if (loginHistory.isNotEmpty) 
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: loginHistory.length,
                  itemBuilder: (context, index) {
                    final entry = loginHistory[index];
                    return ListTile(
                      title: Text("User ID: ${entry.userId}"),
                      subtitle: Text("Type: ${entry.type} \nDate & time: ${entry.date}"),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}