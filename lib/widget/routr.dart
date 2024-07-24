import 'package:flutter/material.dart';
import 'package:metaapp/screens/homePage.dart';
import 'package:metaapp/screens/secondscreen.dart';
import 'package:metaapp/widget/forgotPassword.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => MyHomePage());

      case '/second':
        if (args is Map<String, String>) {
          return MaterialPageRoute(
            builder: (context) => SecondScreen(
              role: args['role'],
              userId: args['userId'],
              password: args['password'],
            ),
          );
        }
        
        return _errorRoute();

      case '/changePassword':
        if (args is Map<String, String>) {
          print('working');
          return MaterialPageRoute(
            builder: (context) => ForgotPassword(
              userId: args['userId'],
              role: args['role'],
              password: args['password'],
            ),
          );
        }
       
        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          body: Center(
            child: Text('Error: Page not found'),
          ),
        );
      },
    );
  }
}
