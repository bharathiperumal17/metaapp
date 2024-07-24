import 'package:intl/intl.dart';

class PieChart {
  String salesMan;
  double eachDayTotal;
  PieChart(this.salesMan, this.eachDayTotal);
}

List<PieChart> getPieChartValue(List<Map<String, dynamic>> spList) {
 
  Map<String, double> dailySalesMap = {};

  DateTime currentDate = DateTime.now();
  String currentDay = DateFormat('dd/MM/yyyy').format(currentDate);


  for (var element in spList) {
    String salesMan = element['userId'];
    double? billAmount = element['billAmount'];
    String billDate = element['billDate'];

    if (billDate == currentDay) {
      if (billAmount != null) {
        if (dailySalesMap.containsKey(salesMan)) {
          dailySalesMap[salesMan] = (dailySalesMap[salesMan] ?? 0) + billAmount;
        } else {
          dailySalesMap[salesMan] = billAmount;
        }
      }
    }
  }

  List<PieChart> pieChartData = dailySalesMap.entries
      .map((entry) => PieChart(entry.key, entry.value.roundToDouble()))
      .toList();
  return pieChartData;
}
