import 'package:flutter/material.dart';
import 'package:metaapp/model/billDetails.dart';
import 'package:metaapp/model/billMaster.dart';
import 'package:metaapp/model/login.dart';
import 'package:metaapp/model/medicineMaster.dart';
import 'package:metaapp/model/stock.dart';
import 'package:metaapp/model/theme.dart';
import 'package:metaapp/widget/routr.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeUserLoginInfo();
  initializeBillMaster();
  intializeBillDetails();
  initializeMedicineMaster();
  await initializeStockData();
   runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => ThemeProvider(),)],
      child: Builder(
        builder: (context) {
          return MetaApp();
        }
      ));

  }
}

class MetaApp extends StatelessWidget {
  const MetaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode:  context.watch<ThemeProvider>().themeModeValue,
        theme: ThemeDataClass.lightTheme,
        darkTheme: ThemeDataClass.darkTheme,
      // home:SecondScreen(role: 'manager', userId: 'user2', password: '123'),
    
      // home: MyHomePage(),
      initialRoute: '/',
     onGenerateRoute: RouteGenerator.generateRoute,
  //      (settings) {
  //       if(settings.name=='/'){
  //         return MaterialPageRoute(builder: (context) => MyHomePage(),);

  //       }
  //       if (settings.name == '/second') {
   
  //   final Map<String, String>? arguments = settings.arguments as Map<String, String>?;

  //   return MaterialPageRoute(
  //     builder: (context) => SecondScreen(
  //       role: arguments?['role'],
  //       userId: arguments?['userId'],
  //       password: arguments?['password'],
  //     ),
  //   );
  // }if (settings.name == '/changePassword') {
   
  //   final Map<String, String>? arguments = settings.arguments as Map<String, String>?;

  //   return MaterialPageRoute(
  //     builder: (context) => ForgotPassword(
  //       role: arguments?['role'],
  //       userId: arguments?['userId'],
  //       password: arguments?['password'],
  //     ),
  //   );
  // }
  //       return MaterialPageRoute(
  //     builder: (context) {
  //       return Scaffold(
  //         body: Center(
  //           child: Text('Error: Page not found'),
  //         ),
  //       );
  //     },
  //   ); 
  //     },
    );
  }
}