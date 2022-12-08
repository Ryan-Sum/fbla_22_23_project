import 'package:fbla_22_23_project/functions/event.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'event_card.dart';

class EventList extends StatefulWidget {
  final AsyncSnapshot<List<Event>> snapshot;

  const EventList({super.key, required this.snapshot});
  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  List<bool> isActive = [];
  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < widget.snapshot.data!.length; i++) {
      isActive.add(false);
    }
    print(isActive);
    print(widget.snapshot.data!.length);
    return ListView.builder(
      itemCount: widget.snapshot.data!.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            setState(
              () {
                for (var i = 0; i < isActive.length; i++) {
                  isActive[i] = false;
                }
              },
            );
            isActive[index] = true;
            showModalBottomSheet(
                context: context,
                builder: (context) =>
                    buildSheet(widget.snapshot.data!.elementAt(index).imageUrl),
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16))));
          },
          child: EventCards(
            title: widget.snapshot.data!.elementAt(index).name,
            isActive: isActive.elementAt(index),
          ),
        );
      },
    );
  }

  String subtitleFunc() {
    String val = 'Error';
    for (var i = 0; i < isActive.length; i++) {
      if (isActive.elementAt(i) == true) {
        val =
            '${(widget.snapshot.data!.elementAt(i).isWeek ? 'The week of' : 'On')} ${DateFormat('EEEE, MMM d, yyyy').format(widget.snapshot.data!.elementAt(i).date)}';
      } else if (val == 'Error') {
        val = 'Error 2';
      }
    }
    return val;
  }

  String titleFunc() {
    String val = 'Error';
    for (var i = 0; i < isActive.length; i++) {
      if (isActive.elementAt(i) == true) {
        val = widget.snapshot.data!.elementAt(i).name;
      } else if (val == 'Error') {
        val = 'Error 2';
      }
    }
    return val;
  }

  String contentFunc() {
    String val = 'Error';
    for (var i = 0; i < isActive.length; i++) {
      if (isActive.elementAt(i) == true) {
        val = widget.snapshot.data!.elementAt(i).content;
      } else if (val == 'Error') {
        val = 'Error 2';
      }
    }
    return val;
  }

  Future<String?> getImage(String gsPath) async {
    final gsReference = FirebaseStorage.instance.refFromURL(gsPath);
    String? value;
    try {
      value = await gsReference.getDownloadURL();
    } on FirebaseException catch (e) {
      value = null;
    }
    return value;
  }

  Widget buildSheet(String url) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16))),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  titleFunc(),
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Text(subtitleFunc()),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: Text(contentFunc()),
                ),
                FutureBuilder(
                  future: getImage(url),
                  builder: (context, snapshot) {
                    if (snapshot.hasData == true) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            snapshot.data!,
                            height: 243,
                          ),
                        ),
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
      ],
    );
  }
}
