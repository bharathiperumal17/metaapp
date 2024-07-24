import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StockViewPage extends StatefulWidget {
  const StockViewPage({Key? key}) : super(key: key);

  @override
  _StockViewPageState createState() => _StockViewPageState();
}

class _StockViewPageState extends State<StockViewPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stockSp();
    medicineMasterSp();
    filteredStockList=stock;
   
  }
  int rowsToDisplay = 10; 
  List <Map<String, dynamic>> stock=[];
  List <Map<String, dynamic>> medicineMaster=[];
  List <Map<String, dynamic>>filteredStockList = [];


  Future<void> stockSp()async{
    SharedPreferences ref=await SharedPreferences.getInstance();
    String? data=ref.getString('stockKey');
    if(data!=null){
      List dummy=jsonDecode(data);
      setState(() {
        stock=List.from(dummy);
        // print('1====>$stock');
        // filterStockList('');
      });
    }
  }
  
  Future<void> medicineMasterSp()async{
    SharedPreferences ref=await SharedPreferences.getInstance();
    String? data=ref.getString('medicineMasterKey');
    if(data!=null){
      List dummy=jsonDecode(data);
      setState(() {
        medicineMaster=List.from(dummy);
        //  print('2 =====>$medicineMaster');
        filterStockList('');
      });
    }
  }

  TextEditingController searchController = TextEditingController();

  void filterStockList(String query) {
    setState(() {
     
      filteredStockList = stock.where((stock) {
        final masterData = medicineMaster.firstWhere(
            (master) => master['medicineName'] == stock['medicineName']);
        return masterData['medicineName'].toString().toLowerCase().contains(query.toLowerCase()) ||
               masterData['brand'].toString().toLowerCase().contains(query.toLowerCase()) ||
               stock['quantity'].toString().contains(query) ||
               stock['unitPrice'].toString().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (query){
                  filterStockList(searchController.text);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text('Show Rows: '),
                  DropdownButton<int>(
                    value: rowsToDisplay,
                    items: [5, 10, 15, -1].map((value) { 
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value == -1 ? 'All' : value.toString()), 
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          rowsToDisplay = newValue;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
             DataTable(
              columnSpacing: MediaQuery.of(context).size.width * 0.05,
              columns:const [
                 DataColumn(label: Text('Medicine\nName', textAlign: TextAlign.center), numeric: false),
                 DataColumn(label: Text('Brand', textAlign: TextAlign.center), numeric: false),
                 DataColumn(label: Text('Quantity', textAlign: TextAlign.center), numeric: false),
                 DataColumn(label: Text('Unit\nPrice', textAlign: TextAlign.center), numeric: false),
              ],
              rows: filteredStockList
                  .take(rowsToDisplay == -1 ? filteredStockList.length : rowsToDisplay) 
                  .map((stock) {
                final masterData = medicineMaster.firstWhere(
                    (master) => master['medicineName'] == stock['medicineName']);
                return DataRow(cells: [
                  DataCell(Text(masterData['medicineName']!)),
                  DataCell(Text(masterData['brand']!)),
                  DataCell(Text(stock['quantity'].toString())),
                  DataCell(Text(stock['unitPrice'].toString())),
                ]);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}