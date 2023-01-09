import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  final String name;
  final String content;
  final String imageUrl;
  final DateTime date;
  final bool isWeek;

  Event({
    required this.isWeek,
    this.id = '',
    required this.name,
    required this.content,
    required this.imageUrl,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'content': content,
        'imageUrl': imageUrl,
        'date': date,
        'isWeek': isWeek,
      };

  static Event fromJson(Map<String, dynamic> json) => Event(
      id: json['id'],
      name: json['name'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      date: (json['date'] as Timestamp).toDate(),
      isWeek: json['isWeek']);
}
