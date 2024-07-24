import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

List<Map<String, dynamic>> medicineMasterListSP = [];


meidicineMaster(String medicineName,String brand)async{
  final medicineList={
    'medicineName':medicineName,
    'brand':brand,
  };

  SharedPreferences ref =await SharedPreferences.getInstance();
  String? data=ref.getString('medicineMasterKey');
  if(data!=null){
    List dummy=jsonDecode(data);
    medicineMasterListSP=dummy.cast();
  }

  medicineMasterListSP.add(medicineList);

  ref.setString('medicineMasterKey', jsonEncode(medicineMasterListSP));
}

Future<void> initializeMedicineMaster() async {

  SharedPreferences ref =await SharedPreferences.getInstance();
  String? data=ref.getString('medicineMasterKey');
  if(data==null){

List<Map<String, dynamic>> medicineMasterList = [
  {
    'medicineName': 'Med 1',
    'brand': 'Brand A',
  },
  {
    'medicineName': 'Med 2',
    'brand': 'Brand B',
  },
  {
    'medicineName': 'Med 3',
    'brand': 'Brand C',
  },
  {
    'medicineName': 'Med 4',
    'brand': 'Brand D',
  },
  {
    'medicineName': 'Med 5',
    'brand': 'Brand E',
  },
];


ref.setString('medicineMasterKey', jsonEncode(medicineMasterList));
  }
}