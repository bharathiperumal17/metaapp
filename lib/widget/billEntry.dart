import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:metaapp/model/billDetails.dart';
import 'package:metaapp/model/billMaster.dart';
import 'package:metaapp/widget/richText.dart';
import 'package:metaapp/widget/snackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class BillEntryPage extends StatefulWidget {
  const BillEntryPage({super.key, required this.userId});
  final String userId;
  @override
  State<BillEntryPage> createState() => _BillEntryPageState();
}

class _BillEntryPageState extends State<BillEntryPage> {
  List<dynamic> savedBillMaster = [];
  List<Map<String, dynamic>> savedBillDetails = [];
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  TextEditingController quantityController = TextEditingController();
  String? selectedMedicine;
  int? generateNewBillNo;
  double calculatedBillAmount = 0;
  double calculatedGstAmount = 0;
  double calculatedNetPrice = 0;
  var quantity;
  var unitPrice;
  var initialQuantity;
  List currentBillDetails = [];
  List stockListSp = [];
  List medicineMaster = [];

  @override
  void initState() {
    super.initState();
    getCurrentDate();
    stockListStored();
    medicineMasterSp();

    generateNewBillNoFun().then((newBillNo) {
      setState(() {
        generateNewBillNo = newBillNo;
      });
    });
  }

  Future<void> stockListStored() async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    String? data = ref.getString('stockKey');
    if (data != null) {
      List dummy = jsonDecode(data);
      setState(() {
        stockListSp = List.from(dummy);
      });
    }
  }

  Future<int> generateNewBillNoFun() async {
    await getBillDataFromSharedPreferences();

    int maxBillNo = 0;

    for (final entry in savedBillMaster) {
      final int billNo = entry['billNo'] as int;
      if (billNo > maxBillNo) {
        maxBillNo = billNo;
      }
    }

    return maxBillNo + 1;
  }

  Future<void> medicineMasterSp() async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    String? data = ref.getString('medicineMasterKey');
    if (data != null) {
      List dummy = jsonDecode(data);
      setState(() {
        medicineMaster = List.from(dummy);
      });
    }
  }

  Future<void> retrieveSavedData() async {
    SharedPreferences sref = await SharedPreferences.getInstance();
    String? savedData = sref.getString('billKey');

    if (savedData != null) {
      List<Map<String, dynamic>> decodedList =
          (jsonDecode(savedData) as List).cast<Map<String, dynamic>>();
      setState(() {
        savedBillDetails = decodedList;
        // print(savedBillDetails);
      });
    }
  }

  Future<void> getBillDataFromSharedPreferences() async {
    SharedPreferences sref = await SharedPreferences.getInstance();
    String? data = sref.getString("billMaster");
    if (data != null) {
      List<dynamic> jsonData = json.decode(data);
      setState(() {
        savedBillMaster = List<Map<String, dynamic>>.from(jsonData);
      });
    }
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    return formattedDate;
  }

  double calculateTotalCost() {
    final index = stockListSp.indexWhere(
      (element) => element['medicineName'] == selectedMedicine,
    );
    if (index >= 0) {
      unitPrice = stockListSp[index]['unitPrice'];
      return unitPrice * quantity;
    }
    return 0.0;
  }

  bool isNumeric(String s) {
    if (s == '') {
      return false;
    }
    return double.tryParse(s) != null;
  }

  reduceQuantity() {
    if (selectedMedicine == null) {
      ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
              message: 'Please select a medicine name',
              backgroundColors: Colors.red)
          .asSnackBar());
    }

    if (_formKey1.currentState!.validate()) {
      final selectedMedicineName = selectedMedicine;
      if (selectedMedicineName != null) {
        final index = stockListSp.indexWhere(
            (element) => element['medicineName'] == selectedMedicineName);

        if (index >= 0) {
          if (stockListSp[index]['quantity'] < quantity) {
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                    message:
                        'Insufficient quantity. Available quantity: ${stockListSp[index]['quantity']}',
                    backgroundColors:Theme.of(context).colorScheme.primary,)
                .asSnackBar());
            return stockListSp[index]['quantity'];
          }
          setState(() {
            stockListSp[index]['quantity'] -= quantity;

            initialQuantity = stockListSp[index]['quantity'];
            saveBillData();
            billDetails(generateNewBillNo!, selectedMedicine!, quantity,
                unitPrice, calculateTotalCost());
            getBillDataFromSharedPreferences();
            retrieveSavedData();

            final amount = calculateTotalCost().toStringAsFixed(2);
            currentBillDetails.add({
              'medicineName': selectedMedicineName,
              'brand': getBrandForMedicine(selectedMedicineName),
              'quantity': quantity,
              'amount': amount,
            });
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                    message:
                        '$selectedMedicineName => $quantity quantity added to cart ',
                    backgroundColors:Theme.of(context).colorScheme.primary,)
                .asSnackBar());
            quantityController.clear();
          });
        }
        SharedPreferences.getInstance().then((ref) {
          ref.setString('stockKey', jsonEncode(stockListSp));
        });
      }
    }
  }

  String getBrandForMedicine(String medicineName) {
    for (final entry in medicineMaster) {
      if (entry['medicineName'] == medicineName) {
        return entry['brand']!;
      }
    }
    return '';
  }

  Future<void> saveBillData() async {
    setState(() {
      calculatedBillAmount += calculateTotalCost();
      calculatedGstAmount = (calculatedBillAmount * (18 / 100));
      calculatedNetPrice = calculatedBillAmount + calculatedGstAmount;
    });

    billMaster(generateNewBillNo, getCurrentDate(), calculatedBillAmount,
        calculatedGstAmount, calculatedNetPrice, widget.userId);
  }

  bool isContainerVisible = false;

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
     const   SizedBox(
          height: 20,
        ),
        Text(
          'Bill Entry',
          style: TextStyle(
            color:Theme.of(context).colorScheme.primary,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
       const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          color:Theme.of(context).colorScheme.background,
          child: ExpansionTile(
              title: Text(
                'Add to cart',
                style: TextStyle(color: Theme.of(context).colorScheme.primary,),
              ),
              onExpansionChanged: (expanded) {
                setState(() {
                  isContainerVisible = expanded;
                });
              },
              children: <Widget>[
                if (isContainerVisible)
                  Column(
                    children: [
                      ConstrainedBox(
                        constraints:
                            const BoxConstraints(minHeight: 220, minWidth: 400),
                        child: Column(children: [
                          SizedBox(
                            width: 200,
                            child: DropdownButtonFormField<String>(
                                borderRadius: BorderRadius.circular(15),
                                hint: const Text('Medicine Name'),
                                value: selectedMedicine,
                                items: stockListSp
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item['medicineName'],
                                          child: Text(item['medicineName']),
                                        ))
                                    .toList(),
                                onChanged: (String? newvalue) {
                                  setState(() {
                                    selectedMedicine = newvalue;
                                  });
                                }),
                          ),
                         const SizedBox(
                            height: 15,
                          ),
                          Form(
                            key: _formKey1,
                            child: ConstrainedBox(
                              constraints:const BoxConstraints(
                                maxWidth: 250,
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: quantityController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'how much quantity do you want?';
                                  }
                                  quantity = int.tryParse(value);
                                  if (!isNumeric(value)) {
                                    return 'This field should contain numbers only';
                                  }
                                  if (quantity == null || quantity <= 0) {
                                    return 'Please enter a valid positive quantity';
                                  }
                                  return null;
                                },
                                decoration:const InputDecoration(
                                    label: Text('Quantity'),
                                    suffixIcon:
                                        Icon(Icons.add_shopping_cart_outlined),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)))),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  try {
                                    if (_formKey1.currentState!.validate()) {
                                      quantity =
                                          int.parse(quantityController.text);
                                      reduceQuantity();
                                      calculateTotalCost();
                                    }
                                  } catch (e) {
                                    return ;
                                  }
                                });
                              },
                              child:const Text('Add'))
                        ]),
                      )
                    ],
                  ),
              ]),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          width: double.infinity,
          color:Theme.of(context).colorScheme.background,
          child: Column(
            children: [
             const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (currentBillDetails.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            clipBehavior: Clip.none,
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                     const Text(
                                        'Bill Preview',
                                        textAlign: TextAlign.center,
                                      ),
                                      IconButton(
                                        onPressed: Navigator.of(context).pop,
                                        icon:const Icon(Icons.close),
                                        alignment: const Alignment(0, 0),
                                      ),
                                    ],
                                  ),
                                 const Text(
                                    'FlatTrade Pharmacy',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                               const   SizedBox(
                                    height: 15,
                                  ),
                                DataTable(
                                    dataRowHeight: 60,
                                    columnSpacing: 10,
                                    columns: const[
                                      DataColumn(
                                        label: Flexible(
                                          child: Text(
                                            'Medicine\nName',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Flexible(
                                          child: Text('Quantity'),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Flexible(
                                          child: Text('Amount'),
                                        ),
                                      ),
                                    ],
                                    rows: currentBillDetails.map((item) {
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            Text(item['medicineName']),
                                          ),
                                          DataCell(
                                            Text(item['quantity'].toString()),
                                          ),
                                          DataCell(
                                            Text(item['amount'].toString()),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                  Text('total =  $calculatedBillAmount'),
                                  Text(
                                      'Gst = ${calculatedGstAmount.toStringAsFixed(2)}'),
                                  Text(
                                      'Net Price = ${calculatedNetPrice.toStringAsFixed(2)}'),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Print'))
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar(
                                    message:
                                        "Add the medicine to see the preview",
                                    backgroundColors: Colors.red)
                                .asSnackBar());
                      }
                    },
                    child: const Text('Preview',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (currentBillDetails.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              CustomSnackBar(
                                      message:
                                          'Before save the bill add the medicine',
                                      backgroundColors: Colors.red)
                                  .asSnackBar());
                        } else {
                          setState(() {
                            generateNewBillNo = (generateNewBillNo! + 1);
                            currentBillDetails.clear();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                              CustomSnackBar(
                                      message: 'medicines saved succesfully',
                                      backgroundColors: Colors.green)
                                  .asSnackBar());
                        }
                      });

                      calculatedGstAmount = 0;
                      calculatedNetPrice = 0;
                      calculatedBillAmount = 0;
                      quantityController.clear();
                    },
                    child: const Text('Save',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextRich(first: 'Bill No : ', second: '$generateNewBillNo'),
              TextRich(first: 'Date : ', second: getCurrentDate()),
              TextRich(
                first: 'GST 18% : ',
                second: calculatedGstAmount.toStringAsFixed(2).toString(),
              ),
              TextRich(
                first: 'Net Payable :',
                second: calculatedNetPrice.toStringAsFixed(2).toString(),
              ),
              TextRich(
                first: ' Total : ',
                second: calculatedBillAmount.toStringAsFixed(2).toString(),
              ),
              const Divider(
                endIndent: 20,
                indent: 10,
                height: 20,
                thickness: 2.5,
              ),
              currentBillDetails.isNotEmpty
                  ? DataTable(
                      dataRowHeight: 60,
                      columnSpacing: 10,
                      columns: const[
                         DataColumn(
                          label: Flexible(child: Text('Medicine Name')),
                        ),
                         DataColumn(
                          label: Flexible(child: Text('Brand')),
                        ),
                         DataColumn(
                          label: Flexible(child: Text('Quantity')),
                          numeric: true, // Align to the right
                        ),
                         DataColumn(
                          label: Flexible(child: Text('Amount')),
                          numeric: true, // Align to the right
                        ),
                      ],
                      rows: currentBillDetails.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(Text(item['medicineName'])),
                            DataCell(Text(item['brand'])),
                            DataCell(
                              Text(item['quantity'].toString()),
                            ),
                            DataCell(
                              Text(item['amount'].toString()),
                            ),
                          ],
                        );
                      }).toList(),
                    )
                  : const Center(
                      child: Text(''),
                    ),
            ],
          ),
        )
      ],
    );
  }
}
