import 'package:fbla_22_23_project/functions/get_events.dart';
import 'package:fbla_22_23_project/screens/upcomming_events/local_widgets/event_list.dart';
import 'package:flutter/material.dart';
import 'package:fbla_22_23_project/functions/event.dart';

class UpcommingEvents extends StatefulWidget {
  const UpcommingEvents({super.key});

  @override
  State<UpcommingEvents> createState() => _UpcommingEventsState();
}

class _UpcommingEventsState extends State<UpcommingEvents> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: StreamBuilder<List<Event>>(
        stream: GetEvents().getEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            snapshot.data!.sort((a, b) => a.date.compareTo(b.date));
            return EventList(snapshot: snapshot);
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
