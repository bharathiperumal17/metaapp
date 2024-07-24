import 'package:flutter/material.dart';
import 'package:metaapp/model/dashboard.dart';
import 'package:metaapp/model/submit.dart';
import 'package:metaapp/model/theme.dart';
import 'package:metaapp/widget/snackBar.dart';
import 'package:provider/provider.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({
    Key? key,
    required this.role,
    required this.userId,
    required this.password,
  }) : super(key: key);

  final String? role;
  final String? userId;
  final String? password;

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  int _selectedOption = 0;

  void handleTabTapped(int index) {
    setState(() {
      _selectedOption = index;
    });
  }

  void handleLogout() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                submit(widget.userId!, widget.password!, widget.role!,
                    isLogin: false);
                ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                        message: 'logout  ${widget.userId}',
                        backgroundColors: Colors.blue)
                    .asSnackBar());
                Navigator.pushNamed(context, '/');
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  
  @override
  Widget build(BuildContext context) {
    bool isDarkTheme =  Provider.of<ThemeProvider>(context).themeModeValue == ThemeMode.light;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(' ${widget.role} Page'),
        actions: [
          Switch(
            // activeColor: whiteColor,
            // activeTrackColor: primaryColor,
            thumbColor:
                MaterialStatePropertyAll(Theme.of(context).colorScheme.primary),
            thumbIcon: MaterialStatePropertyAll(
              Icon(
                isDarkTheme ? Icons.wb_sunny : Icons.nightlight_round,
                opticalSize: 10,
              ),
            ),
            value: isDarkTheme,
            onChanged: (value) {
              print(value);
              Provider.of<ThemeProvider>(context,listen: false)
                  .switchThemeData(value);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('${widget.userId}'),
              accountEmail: Text((widget.role).toString().toUpperCase()),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.background,
                child: Icon(Icons.person),
              ),
            ),
            ListTile(
                leading: const Icon(Icons.password_sharp),
                title: const Text(
                  'Change Password',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Map<String, String> arguments = {
                    'role': widget.role!,
                    'userId': widget.userId!,
                    'password': widget.password!,
                  };
                  Navigator.pushNamed(context, '/changePassword',
                      arguments: arguments);
                }),
            const Divider(),
            ListTile(
              onTap: () => handleLogout(),
              title: const Text(
                'logout',
                style: TextStyle(color: Colors.red),
              ),
              trailing: const Icon(
                Icons.arrow_forward,
                size: 18,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: getDashBoard(widget.userId!, widget.role!, _selectedOption),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedOption,
        items: getBottomNavBarItems(widget.role!),
        onTap: handleTabTapped,
      ),
    );
  }

  List<BottomNavigationBarItem> getBottomNavBarItems(String? role) {
    List<BottomNavigationBarItem> items = [];

    switch (role) {
      case 'biller':
        items = [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Stock View',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Bill Entry',
          ),
        ];
        break;

      case 'manager':
        items = [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.dashboard,
            ),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Stock\nView',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward_ios),
            label: 'Stock\nEntry',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Sales\nReport',
          ),
        ];
        break;

      case 'inventry':
        items = [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Stock View',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward),
            label: 'Stock Entry',
          ),
        ];
        break;

      case 'systemAdmin':
        items = [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Login History',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.verified_user),
            label: 'Add User',
          ),
        ];
        break;

      default:
        items = [
          const BottomNavigationBarItem(
            icon: Icon(Icons.error),
            label: 'Not Implemented',
          ),
        ];
        break;
    }

    return items;
  }
}
