import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:metaapp/model/barChart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:metaapp/model/weekLineChart.dart';
import 'package:metaapp/model/pieChart.dart';
import 'package:metaapp/model/monthlyLineChart.dart';
import 'package:flutter/material.dart';

class ManagerDashBoard extends StatefulWidget {
  ManagerDashBoard(this.userId, {Key? key}) : super(key: key);
  final String userId;

  @override
  _ManagerDashBoardState createState() => _ManagerDashBoardState();
}

class _ManagerDashBoardState extends State<ManagerDashBoard> {
  bool animate = false;
  final GlobalKey<SfCircularChartState> pieChartKey =
      GlobalKey<SfCircularChartState>();

  List<Map<String, dynamic>> billMasterList = [];
  String? date;
  double sum = 0;
  List<Map<String, dynamic>> stockList = [];
  double? product;
  double inventryTotal = 0;

  @override
  void initState() {
    super.initState();
    managerSales();
    managerInventory();

  }

  Future<void> managerSales() async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    String? data = ref.getString('billMaster');
    if (data != null) {
      List<dynamic> dummy = jsonDecode(data);
      setState(() {
        billMasterList = List<Map<String, dynamic>>.from(dummy);
      });
      date = getCurrentDate();
      finalTotal();
    }
  }

  Future<void> managerInventory() async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    String? data = ref.getString('stockKey');
    if (data != null) {
      List<dynamic> dummy = jsonDecode(data);
      setState(() {
        stockList = List<Map<String, dynamic>>.from(dummy);
      });
      totalInventory();
    }
  }

  Future<void> totalInventory() async {
    for (var element in stockList) {
      product = element['quantity'] * element['unitPrice'];
      inventryTotal += product!;
    }
  }

  String? getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    return formattedDate;
  }

  void finalTotal() {
    sum = 0;
    for (var element in billMasterList) {
      String billDate = element['billDate'];
      if (billDate == date) {
        sum += element['billAmount'];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20,),
        Container(
          width: 300,
          height: 130,
           decoration: BoxDecoration(
          boxShadow: [
           BoxShadow(
              color: Theme.of(context).colorScheme.background,
              blurRadius: 6,
              offset: const Offset(0, 3),
              spreadRadius: 3
            )
          ]
        ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Padding(padding: EdgeInsets.all(12)),
                const Text(
                  'Your today sales',
                  style: TextStyle(
                   
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  'Rs. ${sum.toStringAsFixed(2)}',
                  style:  TextStyle(
                    color:Theme.of(context).colorScheme.primary,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 200,
        width: 300,
           decoration: BoxDecoration(
          boxShadow: [
           BoxShadow(
              color: Theme.of(context).colorScheme.background,
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
                'Current Inventory\nValue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                'Rs.${inventryTotal.toStringAsFixed(2)}',
                style:  TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          child: SfCartesianChart(
            title: const ChartTitle(text: 'Sales'),
            primaryXAxis: const CategoryAxis(),
            primaryYAxis: const NumericAxis(),
            series:[
              ColumnSeries<dynamic, String>(
                dataSource: getColumnData(
                    billMasterList), 
                xValueMapper: (data, index) => data['userId'],
                yValueMapper: (data, index) => data['totalAmount'],
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          child: SfCartesianChart(
            primaryXAxis: const CategoryAxis(maximumLabels: 7),
            primaryYAxis: const NumericAxis(),
            title: const ChartTitle(
              text: 'Weekly Sale',
            ),
            series: [
              LineSeries<dynamic, String>(
                dataSource: getWeekData(billMasterList,DateTime.now()),
                xValueMapper: (data, _) => data['days'],
                yValueMapper: (data, _) => data['total'],
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          child: SfCartesianChart(
            primaryXAxis: const CategoryAxis(maximumLabels: 12),
            primaryYAxis: const NumericAxis(),
            title: const ChartTitle(
              text: 'Monthly Sale',
            ),
            series: [
              LineSeries<dynamic, String>(
                dataSource: getMonthlyData(billMasterList,DateTime.now()),
                xValueMapper: (data, _) => data.month,
                yValueMapper: (data, _) => data.monthlyTotal,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
              ),
            ],
          ),
        ),
        // Pie Chart
        SizedBox(
          height: 300,
          child: SfCircularChart(
            legend: const Legend(
              isVisible: true
            ),
            title: const ChartTitle(text: "Today's Sale"),
            series: <CircularSeries>[
              PieSeries<dynamic, String>(
                dataSource: getPieChartValue(billMasterList),
                xValueMapper: (data, index) => data.salesMan,
                yValueMapper: (data, index) => data.eachDayTotal,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ],
    );
  }
}