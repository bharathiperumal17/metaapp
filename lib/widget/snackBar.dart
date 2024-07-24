import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final String message;
  final backgroundColors;

  CustomSnackBar({required this.message,required this.backgroundColors, Key? key}) : super(key: key);

  SnackBar asSnackBar() {
    return SnackBar(
      content: Text(message,style: TextStyle(color: Colors.white)),
      backgroundColor:backgroundColors ,
      duration: Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
