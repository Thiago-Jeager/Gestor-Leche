import 'package:flutter/material.dart';
import 'package:flutter_milk_app/const/colors.dart';
import 'package:intl/intl.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;
  final VoidCallback onTodayButtonTap;
  final VoidCallback onAddButtonTap;
  final bool addButtonVisible;

  const CalendarHeader({
    super.key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
    required this.onTodayButtonTap,
    required this.onAddButtonTap,
    required this.addButtonVisible,
  });

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM().format(focusedDay);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 16.0),
          SizedBox(
            width: 120.0,
            child: Text(
              headerText,
              style: const TextStyle(fontSize: 26.0),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today, size: 20.0),
            visualDensity: VisualDensity.compact,
            onPressed: onTodayButtonTap,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onLeftArrowTap,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onRightArrowTap,
          ),
          if (addButtonVisible)
            IconButton(
              icon: const Icon(Icons.add, size: 20.0),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(hunterGreen),
                foregroundColor: WidgetStateProperty.all(backgroundWhite),
              ),
              visualDensity: VisualDensity.compact,
              onPressed: onAddButtonTap,
            ),
        ],
      ),
    );
  }
}
