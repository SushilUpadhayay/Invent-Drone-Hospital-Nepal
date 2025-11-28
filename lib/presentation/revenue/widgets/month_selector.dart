// lib/presentation/revenue/widgets/month_selector.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthSelector extends StatelessWidget {
  final DateTime currentMonth;
  final Function(DateTime) onMonthChanged;

  const MonthSelector(
      {super.key, required this.currentMonth, required this.onMonthChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => onMonthChanged(
                DateTime(currentMonth.year, currentMonth.month - 1)),
          ),
          Text(
            DateFormat('MMMM yyyy').format(currentMonth),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: DateTime.now().isAfter(currentMonth)
                ? () => onMonthChanged(
                    DateTime(currentMonth.year, currentMonth.month + 1))
                : null,
          ),
        ],
      ),
    );
  }
}
