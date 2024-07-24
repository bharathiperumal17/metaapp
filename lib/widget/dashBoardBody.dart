import 'package:flutter/material.dart';
import 'package:metaapp/widget/manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';



class DashBoardBody extends StatefulWidget {
 DashBoardBody({required this.loggedInUserRole,required this.userId});
 final String loggedInUserRole;
 final String userId;
  @override
  State<DashBoardBody> createState() => _DashBoardBodyState();
}

class _DashBoardBodyState extends State<DashBoardBody> {
  @override
  Widget build(BuildContext context) {
    if (widget.loggedInUserRole == "manager") {
      return ManagerDashBoard(widget.userId);
    } else if (widget.loggedInUserRole == "biller") {
      return BillerStockView(widget.userId);
    } else {
      return WelcomeDashBoard();
    }
  }
}

class BillerStockView extends StatefulWidget {
  BillerStockView(this.userId);
  final String userId;

  @override
  State<BillerStockView> createState() => _BillerStockViewState();
}

class _BillerStockViewState extends State<BillerStockView> {
  String? date;
  String? previousDate;
   
  @override 
  void initState() {
    // TODO: implement initState
    super.initState();
    dashboardBillMaster();
    date = getCurrentDate();
    previousDate = previousDateFunction();
    //  print('$date==> $previousDate');
  }

  String? getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    return formattedDate;
  }

  String previousDateFunction() {
    DateTime current = DateTime.now();
    DateTime previous = current.subtract(Duration(days: 1));
    String formatePreviousDate = DateFormat('dd/MM/yyyy').format(previous);
    return formatePreviousDate;
  }

  List<dynamic> savedBillMaster = [];

  Future<void> dashboardBillMaster() async {
    SharedPreferences sref = await SharedPreferences.getInstance();
    String? data = sref.getString("billMaster");
    if (data != null) {
      List<dynamic> jsonData = json.decode(data);
      setState(() {
        savedBillMaster = List<Map<String, dynamic>>.from(jsonData);
        // print(savedBillMaster);
      });
      finalTotal();
      // finalPreviousTotal();
    }
  }

  double sum = 0;

  finalTotal() {
    sum = 0;
    for (var element in savedBillMaster) {
      String billDate = element['billDate'];
      String onId=element['userId'];
      // print("$billDate==>$onId");
      if (billDate == date && onId==widget.userId ) {
        sum += element['billAmount'];
        
        // print(sum);
      }
    }
  }

  double previousSum=0 ;
  finalPreviousTotal() {
    previousSum = 0;
    for (var element in savedBillMaster) {
      String billDate = element['billDate'];
      String onId=element ['userId'];
      if (billDate == previousDate && onId==widget.userId) {
        previousSum = previousSum + element['billAmount'];
      }
    }
  }

  Widget arrowIcon() {
    if (previousSum > sum) {
      return Icon(
        Icons.arrow_downward,
        color: Colors.red[600],
      );
    } else if (sum > previousSum) {
      return Icon(
        Icons.arrow_upward_rounded,
        color: Colors.green[300],
      );
    }
    return Text('');
  }

  String percentage() {
    num absoluteChange = sum - previousSum;
    num percentageValue;
    if (sum == 0 && previousSum == 0) {
      return '';
    } else if (sum == 0 || previousSum == 0) {
      percentageValue = 100;
    } else {
      percentageValue = absoluteChange / previousSum * 100;
    }
    return '(${percentageValue.toStringAsFixed(1)}%)';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 200,
        width: 300,
        child: Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Your today sales',
                style: TextStyle(
                  color:Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    sum.toStringAsFixed(2),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                const  SizedBox(
                    width: 10,
                  ),
                  arrowIcon(),
                  Text(percentage()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeDashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Center(
        child: Text(
          'Welcome!',
          style: TextStyle(
              color:Theme.of(context).colorScheme.primary,
              fontSize: 30.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
