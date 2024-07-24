import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:metaapp/model/login.dart';
import 'package:metaapp/widget/snackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    login();
  }

  List loginDetails = [];

  Future<void> login() async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    String? data = ref.getString('loginKey');
    if (data != null) {
      List<dynamic> dummy = jsonDecode(data);
      setState(() {
        loginDetails = List<Map<String, dynamic>>.from(dummy);
      });
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController userId = TextEditingController();
  TextEditingController password = TextEditingController();
  String selectedRole = 'biller'; 
  List<String> roles = ['biller', 'manager', 'systemAdmin', 'inventory'];

  bool isDropdownOpen = false;

  void addUser() {
    if (_formKey.currentState!.validate()) {
       ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                          message: 'New $selectedRole ${userId.text} added succesfully', 
                          backgroundColors: Colors.green).asSnackBar()
                         );
      userLoginDetails(userId.text, password.text, selectedRole);
      login();

      userId.clear();
      password.clear();
      setState(() {
        selectedRole = 'biller';
      });
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 40),
          Text(
            'Add User',
            style: TextStyle(
              color:Theme.of(context).colorScheme.primary,
              fontSize: 30,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          
          Container(
            padding:  EdgeInsets.all(16),
            color:Theme.of(context).colorScheme.background,
            child: ExpansionTile(
              // color:Theme.of(context).colorScheme.background,
              backgroundColor: Theme.of(context).colorScheme.background,
              tilePadding: EdgeInsets.zero,
              title: Text(
                'Add User',
                style: TextStyle(
              color:Theme.of(context).colorScheme.primary,
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              initiallyExpanded: isDropdownOpen,
              onExpansionChanged: (expanded) {
                setState(() {
                  isDropdownOpen = expanded;
                });
              },
              children: [
                Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Container(
                        height: 400,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color:Theme.of(context).colorScheme.background,
                          
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: userId,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a username';
                                }
                                if (loginDetails
                                    .any((item) => item['userId'] == value)) {
                                  return 'This usedID is already exists ';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'UserID',
                                labelText: 'UserID',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: password,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a password';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Password',
                                labelText: 'Password',
                                suffixIcon: const Icon(Icons.lock),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            DropdownButton<String>(
                              value: selectedRole,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedRole = newValue!;
                                });
                              },
                              items: roles.map((String role) {
                                return DropdownMenuItem<String>(
                                  value: role,
                                  child: Text(role),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),

                            ElevatedButton(
                              onPressed: addUser,
                              child: const Text('Add User'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
