import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


List <Map<String, dynamic>> stockListSP = [];

stockMedicine(String medicineName,int quantity, double unitPrice)async{
  final stock={
    'medicineName':medicineName,
    'quantity':quantity,
    'unitPrice':unitPrice,
  };

  SharedPreferences ref=await SharedPreferences.getInstance();
  String? data=ref.getString('stockKey');
  if(data!=null){
    List dummy=jsonDecode(data);
    stockListSP=dummy.cast();
  }

  stockListSP.add(stock);

  ref.setString('stockKey', jsonEncode(stockListSP));
  
   
  }
initializeStockData() async {


  SharedPreferences ref=await SharedPreferences.getInstance();
  String? data=ref.getString('stockKey');
  if(data==null){
 List <Map<String, dynamic>> stockList = [
    {
      'medicineName': 'Med 1',
      'quantity': 100,
      'unitPrice': 5.99,
    },
    {
      'medicineName': 'Med 2',
      'quantity': 75,
      'unitPrice': 3.49,
    },
    {
      'medicineName': 'Med 3',
      'quantity': 120,
      'unitPrice': 7.99,
    },
    {
      'medicineName': 'Med 4',
      'quantity': 50,
      'unitPrice': 2.99,
    },
    {
      'medicineName': 'Med 5',
      'quantity': 200,
      'unitPrice': 4.99,
    },
  ];

  
  ref.setString('stockKey', jsonEncode(stockList));
  }
}
