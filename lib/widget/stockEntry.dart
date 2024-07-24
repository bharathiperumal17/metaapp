import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:metaapp/model/medicineMaster.dart';
import 'package:metaapp/model/stock.dart';
import 'package:metaapp/widget/snackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StockEntry extends StatefulWidget {
  const StockEntry({super.key});

  @override
  State<StockEntry> createState() => _StockEntryState();
}

class _StockEntryState extends State<StockEntry> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stockSp();
    medicineMasterSp();
  }

  List stock = [];
  List medicineMaster = [];

  Future<void> stockSp() async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    String? data = ref.getString('stockKey');
    if (data != null) {
      List dummy = jsonDecode(data);
      setState(() {
        stock = List.from(dummy);
        // print('stock==>$stock');
      });
    }
  }
  bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}


  Future<void> medicineMasterSp() async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    String? data = ref.getString('medicineMasterKey');
    if (data != null) {
      List dummy = jsonDecode(data);
      setState(() {
        medicineMaster = List.from(dummy);
        // print('medicinemaster==>$medicineMaster');
      });
    }
  }

  bool isRefillExpanded = false;
  bool isAddExpanded = false;
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  TextEditingController medicineName = TextEditingController();
  TextEditingController brand = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController unitPriceController = TextEditingController();
  String? selectedMedicine;
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();


  bool addNewEntry() {
    if (_formKey1.currentState!.validate()) {
      final newMedicineName = medicineName.text;
      final newBrand = brand.text;

      if (medicineMaster.any((item) =>
          item['medicineName'] == newMedicineName )) {
        ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
          message:  'Medicine with the same name exists already ',
           backgroundColors: Colors.red).asSnackBar(),
        );
      } else {
        setState(() {
          meidicineMaster(newMedicineName, newBrand);
          medicineMasterSp();
        });
        medicineName.clear();
        brand.clear();
        return true;
      }
    }
    return false;
  }


  void updateStockEntry() {
    if (selectedMedicine == null) {
      ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
        message: 'Please select a medicine before updating', 
        backgroundColors: Colors.red).asSnackBar()
      );
      return;
    }
    if (_formKey2.currentState!.validate()) {
      final selectedMedicineName = selectedMedicine;

      if (selectedMedicineName != null) {
        final quantity = int.tryParse(quantityController.text) ?? 0;
        final unitPrice = double.tryParse(unitPriceController.text) ?? 0.0;

        final existingEntryIndex = stock.indexWhere(
          (entry) => entry['medicineName'] == selectedMedicineName,
        );

        if (existingEntryIndex != -1) {
          setState(() {
            stock[existingEntryIndex]['quantity'] += quantity;
            stock[existingEntryIndex]['unitPrice'] = unitPrice;
          });
        } else {
          setState(() {
            stockMedicine(selectedMedicineName, quantity, unitPrice);
            stockSp();
          });
        }
        SharedPreferences.getInstance().then((ref) {
          ref.setString('stockKey', jsonEncode(stock));
        });

        ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
          message: 'Stock entry updated successfully',
          backgroundColors: Colors.green).asSnackBar());

        quantityController.clear();
        unitPriceController.clear();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(CustomSnackBar(
             message: 'Please select a medicine',
             backgroundColors: Colors.red).asSnackBar());
      }
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:CrossAxisAlignment.stretch ,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 30,
        ),
        Text(
          'Stock Entry',
          style: TextStyle(
            color:Theme.of(context).colorScheme.primary,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
         Container(
           padding: const EdgeInsets.all(16.0),
           color: Theme.of(context).colorScheme.background,
           child: ExpansionTile(
             title: const Text('Refill Stock'),
             onExpansionChanged: (expanded) {
               setState(() {
                 isRefillExpanded = expanded;
               });
             },
             children: <Widget>[
               if (isRefillExpanded)
           Form(
             key: _formKey1,
             child: Column(
               children: [
                 const SizedBox(
                   height: 10,
                 ),
                 TextFormField(
                   controller: medicineName,
                   validator: (value) {
                     if (value!.isEmpty) {
                       return 'Please enter the Medicine Name';
                     }
                     
                     return null;
                   },
                   decoration: InputDecoration(
                       border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(30.0)),
                       hintText: 'Medicine Name'),
                 ),
                 const SizedBox(
                   height: 10,
                 ),
                 TextFormField(
                   controller: brand,
                   validator: (value) {
                     if (value!.isEmpty) {
                       return 'Please enter the Brand Name';
                     }
                     return null;
                   },
                   decoration: InputDecoration(
                       border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(30.0)),
                       hintText: 'Brand'),
                 ),
                 const SizedBox(
                   height: 15,
                 ),
                 Center(
                   child: OutlinedButton(
                     style: ButtonStyle(
                       elevation: MaterialStateProperty.all(5),
                       side: MaterialStateProperty.all(const BorderSide(
                           color: Color.fromARGB(255, 111, 148, 173), width: 2)),
                     ),
                     onPressed: () {
                       if (addNewEntry()) {
                         ScaffoldMessenger.of(context).showSnackBar(
                        CustomSnackBar(
                          message: 'New Stock added successfully', 
                          backgroundColors: Colors.green).asSnackBar()
                         );
                       } 
                     },
                     child: const Text(
                       'Add new Stock',
                       style: TextStyle(
                         fontWeight: FontWeight.w600,
                       ),
                     ),
                      ),
                 ),
             
                 const SizedBox(height: 15,)
               ],
             ),
           ),
             ]
               ),
         ),
        const SizedBox(height: 10),
       Container(
          padding: const EdgeInsets.all(16.0),
          color:Theme.of(context).colorScheme.background,
         child: ExpansionTile(
           title: const Text('Add Stock'),
           onExpansionChanged: (expanded) {
             setState(() {
               isAddExpanded = expanded;
             });
           },
           children: <Widget>[
             if (isAddExpanded)
         Form(
           key: _formKey2,
           child: Column(
             children: [
               DropdownButton<String>(
                 hint: const Text('Medicine Name'),
                 value: selectedMedicine,
                 items: medicineMaster
                     .map((item) => DropdownMenuItem<String>(
                           value: item['medicineName'],
                           child: Text(item['medicineName']!),
                         ))
                     .toList(),
                 onChanged: (String? newValue) {
                   setState(() {
                     selectedMedicine = newValue;
                   });
                 },
               ),
               const SizedBox(height: 20),
               Text(
                 'Brand: ${selectedMedicine != null ? medicineMaster.firstWhere((item) => item['medicineName'] == selectedMedicine)['brand'] : ""}',
                 style: const TextStyle(fontWeight: FontWeight.bold),
               ),
               const SizedBox(height: 20),
               TextFormField(
                 controller: quantityController,
                  keyboardType: TextInputType.number, 
                 validator: (value) {
                   if (value!.isEmpty) {
                     return 'Please enter quantity';
                   } if (!isNumeric(value)) {
                       return 'quantity should contain numbers only';
                     }
                   return null;
                 },
                 decoration: InputDecoration(
                     border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(30.0)),
                     hintText: 'Quantity'),
               ),
               const SizedBox(height: 20),
       
               TextFormField(
                 validator: (value) {
                   if (value!.isEmpty) {
                     return 'Please enter price';
                   } if (!isNumeric(value)) {
                      return 'Price should contain numbers only';
                    }
                   return null;
                 },
                 controller: unitPriceController,
                  keyboardType: TextInputType.number, 
                 decoration: InputDecoration(
                     border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(30.0)),
                     hintText: 'Unit Price'),
               ),
               const SizedBox(height: 20),
               OutlinedButton(
                   style: ButtonStyle(
                     elevation: MaterialStateProperty.all(5),
                     side: MaterialStateProperty.all(const BorderSide(
                         color: Color.fromARGB(255, 111, 148, 173), width: 2)),
                   ),
                   onPressed: () {
                      if (_formKey2.currentState!.validate()) {
                        updateStockEntry();
                      }
                   },
                   child: const Text(
                     'Update',
                     style: TextStyle(
                       fontWeight: FontWeight.w600,
                     ),
                   ),
                    ),
               const SizedBox(height: 30),
             ],
           ),
         ),
           ],
           ),
       ),
      ]);
    
  }
}
