import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbla_22_23_project/functions/event.dart';

class GetEvents {
  Stream<List<Event>>? getEvents() {
    return FirebaseFirestore.instance.collection('events').snapshots().map(
        (event) =>
            event.docs.map((doc) => Event.fromJson(doc.data())).toList());
  }
}
