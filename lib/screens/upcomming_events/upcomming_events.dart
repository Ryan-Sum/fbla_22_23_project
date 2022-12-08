import 'package:fbla_22_23_project/functions/get_events.dart';
import 'package:fbla_22_23_project/screens/upcomming_events/local_widgets/event_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fbla_22_23_project/functions/event.dart';
import 'local_widgets/event_card.dart';

class UpcommingEvents extends StatefulWidget {
  const UpcommingEvents({super.key});

  @override
  State<UpcommingEvents> createState() => _UpcommingEventsState();
}

class _UpcommingEventsState extends State<UpcommingEvents> {
  List<String> eventNames = [
    'No School',
    'Lacrosse Tryouts',
    'Volleyball Tryouts',
    'Book Fair',
    'Report Cards',
    'JV Football Game',
    'No School',
    'Exam Week'
  ];
  List<bool> isActive = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<String> subtitle = [
    'On Monday 11/28',
    'On Tuesday 11/29',
    'On Tuesday 11/29',
    'The week of 12/5',
    'On Monday 12/5',
    'On Wednasday 12/7',
    'On Friday 12/9',
    'The week of 12/19'
  ];
  List<String> content = [
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce convallis auctor congue. Suspendisse pulvinar vestibulum iaculis. Proin blandit maximus est, molestie dapibus mi. Maecenas dapibus nec tortor quis finibus. Sed velit ipsum, volutpat facilisis efficitur et, tempor ac turpis. Mauris accumsan dignissim dignissim. Aliquam faucibus venenatis felis finibus interdum. Proin.',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce convallis auctor congue. Suspendisse pulvinar vestibulum iaculis. Proin blandit maximus est, molestie dapibus mi. Maecenas dapibus nec tortor quis finibus. Sed velit ipsum, volutpat facilisis efficitur et, tempor ac turpis. Mauris accumsan dignissim dignissim. Aliquam faucibus venenatis felis finibus interdum. Proin.',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce convallis auctor congue. Suspendisse pulvinar vestibulum iaculis. Proin blandit maximus est, molestie dapibus mi. Maecenas dapibus nec tortor quis finibus. Sed velit ipsum, volutpat facilisis efficitur et, tempor ac turpis. Mauris accumsan dignissim dignissim. Aliquam faucibus venenatis felis finibus interdum. Proin.',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce convallis auctor congue. Suspendisse pulvinar vestibulum iaculis. Proin blandit maximus est, molestie dapibus mi. Maecenas dapibus nec tortor quis finibus. Sed velit ipsum, volutpat facilisis efficitur et, tempor ac turpis. Mauris accumsan dignissim dignissim. Aliquam faucibus venenatis felis finibus interdum. Proin.',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce convallis auctor congue. Suspendisse pulvinar vestibulum iaculis. Proin blandit maximus est, molestie dapibus mi. Maecenas dapibus nec tortor quis finibus. Sed velit ipsum, volutpat facilisis efficitur et, tempor ac turpis. Mauris accumsan dignissim dignissim. Aliquam faucibus venenatis felis finibus interdum. Proin.',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce convallis auctor congue. Suspendisse pulvinar vestibulum iaculis. Proin blandit maximus est, molestie dapibus mi. Maecenas dapibus nec tortor quis finibus. Sed velit ipsum, volutpat facilisis efficitur et, tempor ac turpis. Mauris accumsan dignissim dignissim. Aliquam faucibus venenatis felis finibus interdum. Proin.',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce convallis auctor congue. Suspendisse pulvinar vestibulum iaculis. Proin blandit maximus est, molestie dapibus mi. Maecenas dapibus nec tortor quis finibus. Sed velit ipsum, volutpat facilisis efficitur et, tempor ac turpis. Mauris accumsan dignissim dignissim. Aliquam faucibus venenatis felis finibus interdum. Proin.',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce convallis auctor congue. Suspendisse pulvinar vestibulum iaculis. Proin blandit maximus est, molestie dapibus mi. Maecenas dapibus nec tortor quis finibus. Sed velit ipsum, volutpat facilisis efficitur et, tempor ac turpis. Mauris accumsan dignissim dignissim. Aliquam faucibus venenatis felis finibus interdum. Proin.',
  ];
  List<String> imageUrls = [
    'gs://sky-chatter.appspot.com/events/noschool.jpg',
    'gs://sky-chatter.appspot.com/events/lacrosse.jpg',
    'gs://sky-chatter.appspot.com/events/volleyball.jpg',
    'gs://sky-chatter.appspot.com/events/bookfair.jpg',
    'gs://sky-chatter.appspot.com/events/reportcards.jpg',
    'gs://sky-chatter.appspot.com/events/football.jpg',
    'gs://sky-chatter.appspot.com/events/noschool.jpg',
    'gs://sky-chatter.appspot.com/events/exam.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: StreamBuilder<List<Event>>(
        stream: GetEvents().getEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('has data');
            snapshot.data!.sort((a, b) => a.date.compareTo(b.date));
            return EventList(snapshot: snapshot);
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
