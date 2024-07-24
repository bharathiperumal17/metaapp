import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';



List<Map<String, dynamic>> savedBillMaster = [];

 billMaster(int? billNo,String billDate,double billAmount,double billGst,double netPrice,String userId) async {
  final billData = {
    'billNo': billNo,
    'billDate':billDate,
    'billAmount':billAmount,
    'billGst':billGst,
    'netPrice':netPrice,
    'userId':userId
  };

  
  SharedPreferences sref = await SharedPreferences.getInstance();
  String? savedData = sref.getString('billMaster');

  if (savedData != null) {
    
    List<dynamic> savedList = jsonDecode(savedData);
    savedBillMaster = savedList.cast<Map<String, dynamic>>();
  }

  
 savedBillMaster.add(billData);

  // savedBillMaster.clear();
  sref.setString('billMaster', jsonEncode(savedBillMaster));
  // print("savedBillMaster ==>             $savedBillMaster");
  
}

initializeBillMaster ()async{
   SharedPreferences sref = await SharedPreferences.getInstance();
  String? savedData = sref.getString('billMaster');

  if (savedData == null) {
  List<Map<String, dynamic>> billMasterList = [
    {
    'billNo': 1,
    'billDate': '16/5/2023',
    'billAmount': 42.41,
    'billGst': 7.6338,
    'netPrice': 50.0438,
    'userId': 'user1',
  },
    {
    'billNo': 2,
    'billDate': '17/6/2023',
    'billAmount': 80.27,
    'billGst': 14.4486,
    'netPrice': 94.7186,
    'userId': 'user1',
  },
  {
    'billNo': 3,
    'billDate': '18/6/2023',
    'billAmount': 80.27,
    'billGst': 14.4486,
    'netPrice': 94.7186,
    'userId': 'user1',
  },
  {
    'billNo': 4,
    'billDate': '18/6/2023',
    'billAmount': 112.23,
    'billGst': 20.2014,
    'netPrice': 132.4314,
    'userId': 'user1',
  },
  {
    'billNo': 5,
    'billDate': '18/7/2023',
    'billAmount': 118.21,
    'billGst': 21.2778,
    'netPrice': 139.4878,
    'userId': 'user1',
  },
  {
    'billNo': 6,
    'billDate': '18/8/2023',
    'billAmount': 128.19,
    'billGst': 23.0742,
    'netPrice': 151.2642,
    'userId': 'user1',
  },
  {
    'billNo': 7,
    'billDate': '21/10/2023',
    'billAmount': 152.15,
    'billGst': 27.387,
    'netPrice': 179.537,
    'userId': 'user1',
  },
  {
    'billNo': 8,
    'billDate': '31/10/2023',
    'billAmount': 11.98,
    'billGst': 2.1564,
    'netPrice': 14.1364,
    'userId': 'user1',
  },
  {
    'billNo': 9,
    'billDate': '29/10/2023',
    'billAmount': 22.45,
    'billGst': 4.041,
    'netPrice': 26.491,
    'userId': 'user2',
  },
  {
    'billNo': 10,
    'billDate': '1/11/2023',
    'billAmount': 42.41,
    'billGst': 7.6338,
    'netPrice': 50.0438,
    'userId': 'user1',
  },
];


sref.setString('billMaster', jsonEncode(billMasterList));

  }
}


