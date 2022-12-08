import 'package:fbla_22_23_project/themes/palette.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TableCalendar(
        firstDay: DateTime.utc(2022, 8, 10),
        lastDay: DateTime.utc(2023, 5, 26),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        calendarFormat: _calendarFormat,
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarStyle: CalendarStyle(
            selectedDecoration: const BoxDecoration(
                color: Palette.primarySwatch, shape: BoxShape.circle),
            todayDecoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Palette.primarySwatch, width: 3.0),
            ),
            todayTextStyle: const TextStyle(color: Colors.black)),
      ),
    );
  }
}
