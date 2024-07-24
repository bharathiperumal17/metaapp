import 'package:intl/intl.dart';

class MonthlyChart {
  String month;
  double monthlyTotal;

  MonthlyChart(this.month, this.monthlyTotal);

  @override
  String toString() {
    return '$month: $monthlyTotal';
  }
}

List<MonthlyChart> getMonthlyData(List<Map<String, dynamic>> dataList, DateTime currentDate) {
  Map<String, double> monthlySalesMap = {
   
    'jan': 0.0,
    'feb': 0.0,
    'mar': 0.0,
    'apr': 0.0,
    'may': 0.0,
    'jun': 0.0,
    'jul': 0.0,
    'aug': 0.0,
    'sep': 0.0,
    'oct': 0.0,
    'nov': 0.0,
    'dec': 0.0,
  };

  DateTime startDate = currentDate.subtract(Duration(days: 365));

  for (var data in dataList) {
    String billDate = data['billDate'];
    double billAmount = data['billAmount'];

    try {
      DateTime saleDate = DateFormat('d/M/y').parse(billDate);

      if (saleDate.isAfter(startDate) && saleDate.isBefore(currentDate)) {
        String month = DateFormat('MMM').format(saleDate).toLowerCase();
        monthlySalesMap[month] = (monthlySalesMap[month] ?? 0.0) + billAmount;
      }
    } catch (e) {
      print('Invalid date format: $billDate');
    }
  }
  List<MonthlyChart> chartData = monthlySalesMap.entries
      .map((entry) => MonthlyChart(entry.key, entry.value))
      .toList();
// print(chartData);
  return chartData;
}
