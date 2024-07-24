
class ManagerSalesData {
  final String userId;
  final double totalAmount;

  ManagerSalesData(this.userId, this.totalAmount);
}

List<ManagerSalesData> salesData = [];

List<Map<String, dynamic>> getColumnData(List<Map<String, dynamic>> savedBillMaster) {
  DateTime now = DateTime.now();
  String currentMonthYear = '${now.month}/${now.year}';
  Map<String, double> monthlySalesData = {};

  for (var billData in savedBillMaster) {
    String userId = billData['userId'];
    String billDate = billData['billDate'];
    double billAmount = billData['billAmount'];
    List<String> dateParts = billDate.split('/');
    String monthYear = '${dateParts[1]}/${dateParts[2]}';

    if (monthYear == currentMonthYear) {
      monthlySalesData.update(userId, (value) => value + billAmount, ifAbsent: () => billAmount);
    }
  }

  List<Map<String, dynamic>> result = [];
  monthlySalesData.forEach((userId, totalAmount) {
    result.add({
      'userId': userId,
      'totalAmount': totalAmount,
    });
  });

  return result;
}

