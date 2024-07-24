import 'package:intl/intl.dart';

class WeekChart {
  String days;
  double total;

  WeekChart(this.days, this.total);
}

List<Map<String, dynamic>> getWeekData(List<Map<String, dynamic>> spList, DateTime currentDate) {
  Map<String, double> weeklySalesMap = {
    'Sunday': 0,
    'Monday': 0,
    'Tuesday': 0,
    'Wednesday': 0,
    'Thursday': 0,
    'Friday': 0,
    'Saturday': 0,
  };

  DateTime weekEndDate = currentDate;
  DateTime weekStartDate = weekEndDate.subtract(Duration(days: 6));

  for (var salesData in spList) {
    String billDate = salesData['billDate'];

    try {
      DateTime saleDate = DateFormat('d/M/y').parse(billDate);
      // print(saleDate);

      if (saleDate.isAfter(weekStartDate) && saleDate.isBefore(weekEndDate.add(Duration(days: 1)))) {
        String dayOfWeek = DateFormat('EEEE').format(saleDate);
        double? billAmount = salesData['billAmount'];

        if (billAmount != null) {
          if (weeklySalesMap.containsKey(dayOfWeek)) {
            weeklySalesMap[dayOfWeek] = (weeklySalesMap[dayOfWeek] ?? 0) + billAmount;
          }
        }
      }
    } catch (e) {
      print('Invalid date format: $billDate');
    }
  }

  List<Map<String, dynamic>> chartDataMapList = weeklySalesMap.entries
      .map((entry) => {
            'days': entry.key,
            'total': entry.value,
          })
      .toList();

  return chartDataMapList;
}