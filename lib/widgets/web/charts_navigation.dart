import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickcare/constants/color_constants.dart';

class ChartNavigation extends StatelessWidget {
  final String frequency;
  final int offset;
  final Function(int) onOffsetChanged;

  const ChartNavigation({
    Key? key,
    required this.frequency,
    required this.offset,
    required this.onOffsetChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: DarkTheme.primaryWhite,
          ),
          onPressed: () => onOffsetChanged(offset + 1),
        ),
        Text(
          _getDisplayText(),
          style: const TextStyle(
            color: DarkTheme.primaryWhite,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.arrow_forward,
            color: DarkTheme.primaryWhite,
          ),
          onPressed: offset > 0 ? () => onOffsetChanged(offset - 1) : null,
        ),
      ],
    );
  }

  String _getDisplayText() {
    final now = DateTime.now();
    final date = now.subtract(Duration(days: offset * _getDaysMultiplier()));

    switch (frequency) {
      case 'Daily':
        return DateFormat('MMM d, yyyy').format(date);
      case 'Weekly':
        final weekStart = date.subtract(Duration(days: date.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 6));
        return 'Week ${DateFormat('w').format(date)}: ${DateFormat('MMM d').format(weekStart)} - ${DateFormat('MMM d').format(weekEnd)}';
      case 'Monthly':
        return DateFormat('MMMM yyyy').format(date);
      default:
        return '';
    }
  }

  int _getDaysMultiplier() {
    switch (frequency) {
      case 'Daily':
        return 1;
      case 'Weekly':
        return 7;
      case 'Monthly':
        return 30;
      default:
        return 1;
    }
  }
}
