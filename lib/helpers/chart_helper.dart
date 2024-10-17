import 'package:intl/intl.dart';
import 'package:quickcare/models/devicemodel.dart';
import 'package:quickcare/widgets/web/data_chart.dart';
import 'package:quickcare/widgets/web/devices_tab.dart';

class ChartDateRange {
  final DateTime start;
  final DateTime end;
  ChartDateRange(this.start, this.end);
}

ChartDateRange getDateRange(String frequency, int offset) {
  final now = DateTime.now();
  switch (frequency) {
    case 'Daily':
      final date = now.subtract(Duration(days: offset));
      return ChartDateRange(
        DateTime(date.year, date.month, date.day),
        DateTime(date.year, date.month, date.day, 23, 59, 59),
      );
    case 'Weekly':
      final weekStart =
          now.subtract(Duration(days: now.weekday - 1 + 7 * offset));
      final weekEnd = weekStart.add(const Duration(days: 6));
      return ChartDateRange(
        DateTime(weekStart.year, weekStart.month, weekStart.day),
        DateTime(weekEnd.year, weekEnd.month, weekEnd.day, 23, 59, 59),
      );
    case 'Monthly':
      final monthStart = DateTime(now.year, now.month - offset, 1);
      final monthEnd =
          DateTime(now.year, now.month - offset + 1, 0, 23, 59, 59);
      return ChartDateRange(monthStart, monthEnd);
    default:
      return ChartDateRange(now, now);
  }
}

List<ChartSampleData> filterChartData(
    List<History> history, String frequency, int offset) {
  final dateRange = getDateRange(frequency, offset);

  List<History> filteredHistory = history
      .where((h) =>
          h.time.isAfter(dateRange.start) && h.time.isBefore(dateRange.end))
      .toList();

  return filteredHistory
      .map((h) => ChartSampleData(
            x: _getFormattedDate(h.time, frequency),
            y: h.battRem,
            secondSeriesYValue: h.cupsRem,
            thirdSeriesYValue: h.washRem1,
          ))
      .toList();
}

String _getFormattedDate(DateTime date, String frequency) {
  switch (frequency) {
    case 'Daily':
      return DateFormat('HH:mm').format(date);
    case 'Weekly':
      return DateFormat('EEE').format(date);
    case 'Monthly':
      return DateFormat('MMM d').format(date);
    default:
      return DateFormat('MMM d').format(date);
  }
}
