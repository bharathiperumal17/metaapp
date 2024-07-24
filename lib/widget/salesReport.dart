import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SalesReport extends StatefulWidget {
  const SalesReport({super.key});

  @override
  State<SalesReport> createState() => _SalesReportState();
}

class _SalesReportState extends State<SalesReport> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    masterFunction();
    detailsFunction();
    dateInputStart.text = '';
    dateInputEnd.text = '';
  }

  TextEditingController dateInputStart = TextEditingController();
  TextEditingController dateInputEnd = TextEditingController();
  TextEditingController searchController = TextEditingController();

  bool isContainerVisible = false;
  List billMaster = [];
  List billDetails = [];

  masterFunction() async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    String? data = ref.getString('billMaster');
    if (data != null) {
      List dummy = jsonDecode(data);
      setState(() {
        billMaster = dummy;
      });
    }
    // print(billMaster);
  }

  detailsFunction() async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    String? data = ref.getString('billKey');
    if (data != null) {
      List dummy = jsonDecode(data);
      setState(() {
        billDetails = dummy;
      });
    }
    // print(billDetails);
    finalList();
  }

  List mergeList = [];

  finalList() {
    for (var master in billMaster) {
      var billNo = master['billNo'];
      var details = billDetails.where((details) => details['billNo'] == billNo);
      // print(details);

      if (details.isNotEmpty) {
        for (var detail in details) {
          mergeList.add(<String, dynamic>{
            ...master,
            ...detail,
          });
        }
      }
    }
    // print(mergeList);
  }

//-----------------------sp end------------------------//
   toggleContainer() {
    setState(() {
      isContainerVisible = !isContainerVisible;
    });
  }

//--------------------------UI----------------------------//
  String? firstDate;
  String? endDate;
  List filteredList = [];

  List filterMergeListByDateRange(String? startDate, String? endDate) {
    if (startDate == null || endDate == null) {
      return mergeList; 
    }

    DateTime selectedStartDate = DateFormat('dd/MM/yyyy').parse(startDate);
    DateTime selectedEndDate = DateFormat('dd/MM/yyyy').parse(endDate);

    return mergeList.where((item) {
      DateTime itemDate = DateFormat('dd/MM/yyyy').parse(item['billDate']);
      return itemDate.isAfter(selectedStartDate) &&
          itemDate.isBefore(selectedEndDate);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: TextField(
              controller: dateInputStart,
              decoration: InputDecoration(
                icon: Icon(Icons.calendar_today),
                labelText: "From",
              ),
              readOnly: true,
              onTap: () async {
                DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2100));
                if (date != null) {
                  setState(() {
                    firstDate = DateFormat('dd/MM/yyyy').format(date);
                    dateInputStart.text = firstDate!;
                  });
                }
              }),
        ),
        Center(
          child: TextField(
            controller: dateInputEnd,
            decoration: InputDecoration(
                icon: Icon(Icons.calendar_today), labelText: 'To'),
            readOnly: true,
            onTap: () async {
              DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime(2100));
              if (date != null) {
                setState(() {
                  endDate = DateFormat('dd/MM/yyyy').format(date);
                  dateInputEnd.text = endDate!;
                });
              }
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        OutlinedButton(
            onPressed: () {
              toggleContainer();
              filteredList = filterMergeListByDateRange(firstDate, endDate);
            },
         child: Text(isContainerVisible ? 'Hide' : 'Show'),
        ), 
        if (isContainerVisible)
          Container(
             decoration: BoxDecoration(
            boxShadow: [
             BoxShadow(
                color:Colors.transparent.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 3),
                spreadRadius: 3
              )
            ]
          ),
            child: Column(
              children: [
              
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
          
                onChanged: (query) {
                  setState(() {
                    filteredList = mergeList.where((item) {
                      return item['medicineName'].toString().toLowerCase().contains(query.toLowerCase()) ||
                          item['billNo'].toString().contains(query);
                    }).toList();
                  });
                },
              ),
            ),
            DataTable(columnSpacing: 15, columns: [
              DataColumn(label: Text('BillNo')),
              DataColumn(label: Text('BillDate')),
              DataColumn(
                  label: Text(
                'Medicine\nName',
                textAlign: TextAlign.center,
              )),
              DataColumn(label: Text('Qty')),
              DataColumn(label: Text('Amount')),
            ], rows: [
              for (var item in filteredList)
                DataRow(
                  cells: [
                    DataCell(Text(item['billNo'].toString())),
                    DataCell(Text(item['billDate'].toString())),
                    DataCell(Text(item['medicineName'].toString())),
                    DataCell(Text(item['quantity'].toString())),
                    DataCell(
                      Text(NumberFormat.decimalPattern()
                          .format(item['amount'])),
                    )
                  ],
                )
            ]),
              ],
            ),
          ),
      ],
    );
  }
}
