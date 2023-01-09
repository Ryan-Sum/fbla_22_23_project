import 'package:cloud_firestore/cloud_firestore.dart';

class Absence {
  final List<dynamic> classes;
  final Timestamp date;
  final String studentId;

  Absence({
    required this.classes,
    required this.date,
    required this.studentId,
  });

  static Absence fromJson(Map<String, dynamic> json) => Absence(
        classes: json['classes'],
        date: json['date'],
        studentId: json['studentId'],
      );
}
