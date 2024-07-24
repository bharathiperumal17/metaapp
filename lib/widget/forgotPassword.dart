import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:metaapp/screens/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key, required this.userId, required this.role,required this.password});
  final String? userId;
  final String? role;
  final String? password;
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  void initState() {
    super.initState();
    getLoginDetails();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController password1 = TextEditingController();
  TextEditingController password2 = TextEditingController();

  close() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage(),));
  }

  List loginDetails = [];

  getLoginDetails() async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    String? data = ref.getString('loginKey');
    if (data != null) {
      List dummy = jsonDecode(data);
      setState(() {
        loginDetails = List.from(dummy);
      });
    }
    // print(loginDetails);
  }

  void affect(String newPassword) async {

    if(widget.password==newPassword){

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Don't enter your previous password",style: TextStyle(
            color: Colors.white
          ),),backgroundColor: Colors.red,));

    }else{

    int userIndex = loginDetails
        .indexWhere((element) => element['userId'] == widget.userId);

    if (userIndex != -1) {
      loginDetails[userIndex]['password'] = newPassword;
      SharedPreferences ref = await SharedPreferences.getInstance();
      ref.setString('loginKey', jsonEncode(loginDetails));
      getLoginDetails();
      setState(() {
        
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password updated successfully your new password $newPassword',style: const TextStyle(
            color: Colors.white
          ),),backgroundColor: Colors.green,));
          password1.clear();
          password2.clear();

          await Future.delayed(const Duration(seconds: 3));
          close();
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
                TextFormField(
                  controller: password1,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'enter new password';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'New Password'),
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter confirm password field';
                    }
                    if (value != password1.text) {
                      return "Password doesn't match";
                    }
                    return null;
                  },
                  controller: password2, 
                  decoration: const InputDecoration(labelText: 'Confirm Password'),
                ),
                const SizedBox(
                  height: 20,
                ),
                OutlinedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (password1.text == password2.text) {
                          setState(() {
                            String newPassword = password1.text;
                            affect(newPassword);
                            
                          });
                        }
                      }
                    },
                    child: const Text('confirm'))
              ],
            )),
      ),
    );
  }
}
