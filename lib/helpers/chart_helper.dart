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
  final filteredHistory = history
      .where((h) =>
          h.time.isAfter(dateRange.start) && h.time.isBefore(dateRange.end))
      .toList();

  switch (frequency) {
    case 'Daily':
      return _processDailyData(filteredHistory, dateRange.start);
    case 'Weekly':
      return _processWeeklyData(filteredHistory, dateRange.start);
    case 'Monthly':
      return _processMonthlyData(filteredHistory, dateRange.start);
    default:
      return [];
  }
}

List<ChartSampleData> _processDailyData(List<History> history, DateTime date) {
  return List.generate(24, (hour) {
    final hourStart = DateTime(date.year, date.month, date.day, hour);
    final hourEnd = hourStart.add(const Duration(hours: 1));
    final hourData = history
        .where((h) => h.time.isAfter(hourStart) && h.time.isBefore(hourEnd))
        .toList();

    if (hourData.isEmpty) {
      return ChartSampleData(x: '$hour:00');
    }

    final first = hourData.first;
    final last = hourData.last;

    return ChartSampleData(
      x: '$hour:00',
      startBattRem: first.battRem,
      startCupsRem: first.cupsRem,
      startWashRem1: first.washRem1,
      endBattRem: last.battRem,
      endCupsRem: last.cupsRem,
      endWashRem1: last.washRem1,
    );
  });
}

List<ChartSampleData> _processWeeklyData(
    List<History> history, DateTime weekStart) {
  return List.generate(7, (dayIndex) {
    final dayStart = weekStart.add(Duration(days: dayIndex));
    final dayEnd = dayStart.add(const Duration(days: 1));
    final dayData = history
        .where((h) => h.time.isAfter(dayStart) && h.time.isBefore(dayEnd))
        .toList();

    if (dayData.isEmpty) {
      return ChartSampleData(x: DateFormat('EEE').format(dayStart));
    }

    final first = dayData.first;
    final last = dayData.last;

    return ChartSampleData(
      x: DateFormat('EEE').format(dayStart),
      startBattRem: first.battRem,
      startCupsRem: first.cupsRem,
      startWashRem1: first.washRem1,
      endBattRem: last.battRem,
      endCupsRem: last.cupsRem,
      endWashRem1: last.washRem1,
    );
  });
}

List<ChartSampleData> _processMonthlyData(
    List<History> history, DateTime monthStart) {
  final daysInMonth = DateTime(monthStart.year, monthStart.month + 1, 0).day;

  return List.generate(daysInMonth, (dayIndex) {
    final dayStart = DateTime(monthStart.year, monthStart.month, dayIndex + 1);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final dayData = history
        .where((h) => h.time.isAfter(dayStart) && h.time.isBefore(dayEnd))
        .toList();

    if (dayData.isEmpty) {
      return ChartSampleData(x: DateFormat('d').format(dayStart));
    }

    final first = dayData.first;
    final last = dayData.last;

    return ChartSampleData(
      x: DateFormat('d').format(dayStart),
      startBattRem: first.battRem,
      startCupsRem: first.cupsRem,
      startWashRem1: first.washRem1,
      endBattRem: last.battRem,
      endCupsRem: last.cupsRem,
      endWashRem1: last.washRem1,
    );
  });
}

// List<ChartSampleData> filterChartData(
//     List<History> history, String frequency, int offset) {
//   final dateRange = getDateRange(frequency, offset);

//   List<History> filteredHistory = history
//       .where((h) =>
//           h.time.isAfter(dateRange.start) && h.time.isBefore(dateRange.end))
//       .toList();

//   return filteredHistory
//       .map((h) => ChartSampleData(
//             x: _getFormattedDate(h.time, frequency),
//             y: h.battRem,
//             secondSeriesYValue: h.cupsRem,
//             thirdSeriesYValue: h.washRem1,
//           ))
//       .toList();
// }

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
