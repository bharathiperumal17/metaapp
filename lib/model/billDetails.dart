import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

List<Map<String, dynamic>> saveBillDetails = [];

billDetails(int billNo, String medicineName, int quantity, double unitPrice, double amount) async {
  final bill = {
    'billNo': billNo,
    'medicineName': medicineName,
    'quantity': quantity,
    'unitPrice': unitPrice,
    'amount': amount,
  };

  
  SharedPreferences sref = await SharedPreferences.getInstance();
  String? savedData = sref.getString('billKey');

  if (savedData != null) {
    
    List<dynamic> savedList = jsonDecode(savedData);
    saveBillDetails = savedList.cast<Map<String, dynamic>>();
  }

  
  saveBillDetails.add(bill);

  // saveBillDetails.clear();
  sref.setString('billKey', jsonEncode(saveBillDetails));
  // print("saveBillDetails =>  $saveBillDetails");
}
intializeBillDetails()async{
  SharedPreferences ref =await SharedPreferences.getInstance();
  String? data=ref.getString('billKey');

  if(data==null){
 List<Map<String, dynamic>> billDetailMap = [
  {
    'billNo': 001,
    'medicineName': 'Med 5',
    'quantity': 4,
    'unitPrice': 4.99,
    'amount': 19.96,
  },
   {
    'billNo': 002,
    'medicineName': 'Med 2',
    'quantity': 23,
    'unitPrice': 3.49,
    'amount': 80.27,
  },
  {
    'billNo': 003,
    'medicineName': 'Med 2',
    'quantity': 23,
    'unitPrice': 3.49,
    'amount': 80.27,
  },
  {
    'billNo': 004,
    'medicineName': 'Med 3',
    'quantity': 4,
    'unitPrice': 7.99,
    'amount': 31.96,
  },
  {
    'billNo': 005,
    'medicineName': 'Med 4',
    'quantity': 2,
    'unitPrice': 2.99,
    'amount': 5.98,
  },
  {
    'billNo': 006,
    'medicineName': 'Med 5',
    'quantity': 2,
    'unitPrice': 4.99,
    'amount': 9.98,
  },
  {
    'billNo': 007,
    'medicineName': 'Med 1',
    'quantity': 4,
    'unitPrice': 5.99,
    'amount': 23.96,
  },
  {
    'billNo': 008,
    'medicineName': 'Med 1',
    'quantity': 2,
    'unitPrice': 5.99,
    'amount': 11.98,
  },
  {
    'billNo': 009,
    'medicineName': 'Med 2',
    'quantity': 3,
    'unitPrice': 3.49,
    'amount': 10.47,
  },
  {
    'billNo': 010,
    'medicineName': 'Med 5',
    'quantity': 4,
    'unitPrice': 4.99,
    'amount': 19.96,
  },
];

  ref.setString('billKey', jsonEncode(billDetailMap));
  }else {
    List<dynamic> savedList = jsonDecode(data);
    saveBillDetails = savedList.cast<Map<String, dynamic>>();
  }
}


