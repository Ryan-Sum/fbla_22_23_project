// Application Programmed For FBLA 22-23 By: Ryan Sumiantoro
// Creative Commons License: CC BY-SA 4.0

import 'package:fbla_22_23_project/functions/event.dart';
import 'package:fbla_22_23_project/functions/get_events.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fbla_22_23_project/themes/palette.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<bool> isActive = [];
  late ValueListenable<List<Event>> _selectedEvents;
  late AsyncSnapshot<List<Event>> _snapshot;

  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _focusedDay = DateTime.now();
  final DateTime _firstDay = DateTime.utc(2022, 8, 10);
  final DateTime _lastDay = DateTime.utc(2023, 5, 26);

  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier([]);
  }

  List<Event> _getEventsForDay(
      DateTime day, AsyncSnapshot<List<Event>> snapshot) {
    List<Event> values = [];
    for (var element in snapshot.data!) {
      if (isSameDay(element.date, day)) {
        values.add(element);
      }
    }
    return values;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _focusedDay = focusedDay;
        _selectedDay = selectedDay;
        _selectedEvents =
            ValueNotifier(_getEventsForDay(selectedDay, _snapshot));
      });
    }
  }

  CalendarStyle _calendarStyle() {
    return CalendarStyle(
        selectedDecoration: const BoxDecoration(
            color: Palette.primarySwatch, shape: BoxShape.circle),
        todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Palette.primarySwatch, width: 3.0),
        ),
        todayTextStyle: const TextStyle(color: Colors.black));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<List<Event>>(
        stream: GetEvents().getEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _snapshot = snapshot;
            snapshot.data!.sort((a, b) => a.date.compareTo(b.date));
            return Column(
              children: [
                Center(
                  child: TableCalendar(
                    firstDay: _firstDay,
                    lastDay: _lastDay,
                    onFormatChanged: (format) => setState(() {
                      _calendarFormat = format;
                    }),
                    onPageChanged: (focusedDay) => setState(() {
                      _focusedDay = focusedDay;
                    }),
                    eventLoader: (day) => _getEventsForDay(day, snapshot),
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    focusedDay: _focusedDay,
                    onDaySelected: _onDaySelected,
                    calendarFormat: _calendarFormat,
                    calendarStyle: _calendarStyle(),
                  ),
                ),
                const Divider(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: ValueListenableBuilder<List<Event>>(
                    valueListenable: _selectedEvents,
                    builder: (context, value, child) {
                      return ListView.separated(
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: _selectedEvents.value.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(value.elementAt(index).name +
                                (value.elementAt(index).isWeek
                                    ? ' (All Week)'
                                    : '')),
                            trailing: Text(
                              DateFormat('EEEE, MMM d, yyyy')
                                  .format(value.elementAt(index).date),
                            ),
                            onTap: () => showModalBottomSheet(
                              context: context,
                              builder: (context) => buildSheet(
                                _selectedEvents.value.elementAt(index).imageUrl,
                                _selectedEvents.value.elementAt(index),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buildSheet(String url, Event data) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                data.name,
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text(
                  '${(data.isWeek ? 'The week of' : 'On')} ${DateFormat('EEEE, MMM d, yyyy').format(data.date)}'),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Text(
                  data.content,
                  textAlign: TextAlign.center,
                ),
              ),
              FutureBuilder(
                future: getImage(url),
                builder: (context, snapshot) {
                  if (snapshot.hasData == true) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              snapshot.data!,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> getImage(String gsPath) async {
    final gsReference = FirebaseStorage.instance.refFromURL(gsPath);
    String? value;
    try {
      value = await gsReference.getDownloadURL();
    } on FirebaseException catch (e) {
      value = e.message;
    }
    return value;
  }
}
