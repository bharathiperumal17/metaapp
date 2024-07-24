import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:metaapp/model/submit.dart';
import 'package:metaapp/widget/snackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userLogin();
  }

  String? role;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  List userLoginInfo = [];

  userLogin() async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    String? data = ref.getString('loginKey');
    if (data != null) {
      List dummy = jsonDecode(data);
      setState(() {
        userLoginInfo = dummy;
      });
    }
    // print('userLoginInfo==>$userLoginInfo');
  }
 

  bool _obscureText = true;

  bool verification() {
    String? enteredName = username.text;
    String? enteredPassword = password.text;

    for (var user in userLoginInfo) {
      // print(user);
      if (user['userId'] == enteredName &&
          user['password'] == enteredPassword) {
        role = user['role'];
        // print(user['userId']);

        if (role == 'biller' ||
            role == 'manager' ||
            role == 'systemAdmin' ||
            role == 'inventry') {
          submit(enteredName, enteredPassword, role!, isLogin: true);
           Map<String, String> arguments = {
          'role': role!, 
          'userId': enteredName, 
          'password': enteredPassword, 
};
          Navigator.of(context).pushNamed('/second', arguments: arguments);
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        
        child: SizedBox(
          // color: Theme.of(context).colorScheme.primary,
          height: 320,
            width: 250,
          child: Card(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: username,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a username';
                          }
                          if (!userLoginInfo
                              .any((item) => item['userId'] == value)) {
                                verification();
                            return 'Invalid username';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'username',
                          hintText: 'Enter your username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                     const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: password,
                        validator: (value) {
                          // print(userLoginInfo);
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (!userLoginInfo
                              .any((item) => item['password'] == value)) {
                                verification();
                            return 'wrong password';
                          }
                          return null;
                        },
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (verification()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                CustomSnackBar(
                                  message: 'login Successfull ${username.text}', 
                                  backgroundColors: Colors.green).asSnackBar()
                              );
                            } else {
                               ScaffoldMessenger.of(context).showSnackBar(
                                CustomSnackBar(
                                  message: 'login failed ${username.text} enter new password ', 
                                  backgroundColors: Colors.red).asSnackBar()
                              );
                            
                            }
                          }
                        },
                        child: Text('Login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
