import 'package:fbla_22_23_project/functions/absence.dart';
import 'package:fbla_22_23_project/functions/parents.dart';
import 'package:fbla_22_23_project/functions/students.dart';
import 'package:fbla_22_23_project/functions/teachers.dart';
import 'package:fbla_22_23_project/themes/palette.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AbsenceScreen extends StatefulWidget {
  const AbsenceScreen({super.key});

  @override
  State<AbsenceScreen> createState() => _AbsenceScreenState();
}

class _AbsenceScreenState extends State<AbsenceScreen> {
  bool alreadyAbsent = false;

  final bool _isWeekend = ((DateTime.now().weekday == DateTime.saturday) ||
      (DateTime.now().weekday == DateTime.sunday));

  Stream<List<Student>> getStudentSnapshot() {
    return FirebaseFirestore.instance.collection('students').snapshots().map(
        (user) =>
            user.docs.map((doc) => Student.fromJson(doc.data())).toList());
  }

  Stream<List<Teacher>> getTeacherSnapshot() {
    return FirebaseFirestore.instance.collection('teachers').snapshots().map(
        (user) =>
            user.docs.map((doc) => Teacher.fromJson(doc.data())).toList());
  }

  Stream<List<Absence>> getAbsenceSnapshot() {
    return FirebaseFirestore.instance.collection('absences').snapshots().map(
        (user) =>
            user.docs.map((doc) => Absence.fromJson(doc.data())).toList());
  }

  Stream<List<Parent>> getParentSnapshot() {
    return FirebaseFirestore.instance.collection('parents').snapshots().map(
        (user) => user.docs.map((doc) => Parent.fromJson(doc.data())).toList());
  }

  List<String> getTeachers(AsyncSnapshot<List<Student>> student,
      AsyncSnapshot<List<Teacher>> teacher, String studentId) {
    List<String> value = [];
    for (var element in student.data!) {
      if (element.id == studentId) {
        for (var data in element.classes) {
          for (var teacherData in teacher.data!) {
            if (teacherData.id == data) {
              value.add(teacherData.id);
            }
          }
        }
      }
    }
    return value;
  }

  void reportAbsence(
      AsyncSnapshot<List<Student>> student,
      AsyncSnapshot<List<Parent>> parent,
      AsyncSnapshot<List<Teacher>> teacher) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String studentId = '';
    for (var element in parent.data!) {
      if (element.id == uid) {
        studentId = element.studentId;
      }
    }
    List<String> teachers = getTeachers(student, teacher, studentId);
    final absence = <String, dynamic>{
      'studentId': studentId,
      'classes': teachers,
      'date': Timestamp.now(),
    };
    FirebaseFirestore.instance.collection('absences').add(absence);
  }

  void getAlreadyAbsent(AsyncSnapshot<List<Absence>> absence,
      AsyncSnapshot<List<Parent>> parent) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String studentid = '';
    for (var element in parent.data!) {
      if (uid == element.id) {
        studentid = element.studentId;
      }
    }
    for (var element in absence.data!) {
      print('${element.studentId} $studentid');
      if ((element.studentId == studentid) &&
          (isSameDay(
              DateTime.fromMillisecondsSinceEpoch(
                  (element.date.millisecondsSinceEpoch)),
              DateTime.now()))) {
        alreadyAbsent = true;
      }
    }
  }

  String getAccountType(
      AsyncSnapshot<List<Student>> student,
      AsyncSnapshot<List<Teacher>> teacher,
      AsyncSnapshot<List<Parent>> parent) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String value = "student";
    for (var element in student.data!) {
      if (element.id == uid) {
        value = 'student';
      }
    }
    for (var element in teacher.data!) {
      if (element.id == uid) {
        value = 'teacher';
      }
    }
    for (var element in parent.data!) {
      if (element.id == uid) {
        value = 'parent';
      }
    }
    return value;
  }

  List<String> getAbsencesForTeacher(AsyncSnapshot<List<Absence>> absences,
      AsyncSnapshot<List<Student>> students) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    List<String> studentsAbsent = [];
    for (var element in absences.data!) {
      for (var classes in element.classes) {
        if (classes == uid) {
          for (var studentData in students.data!) {
            if ((studentData.id == element.studentId) &&
                (isSameDay(
                    DateTime.fromMillisecondsSinceEpoch(
                        element.date.millisecondsSinceEpoch),
                    DateTime.now()))) {
              studentsAbsent.add(studentData.name);
            }
          }
        }
      }
    }
    return studentsAbsent;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: StreamBuilder(
          stream: getStudentSnapshot(),
          builder: (context, snapshotStudent) {
            if (snapshotStudent.hasData == true) {
              return StreamBuilder(
                stream: getTeacherSnapshot(),
                builder: (context, snapshotTeachers) {
                  if (snapshotTeachers.hasData == true) {
                    return StreamBuilder(
                      stream: getAbsenceSnapshot(),
                      builder: (context, snapshotAbsence) {
                        return StreamBuilder(
                          stream: getParentSnapshot(),
                          builder: (context, snapshotParents) {
                            if (snapshotParents.hasData) {
                              if (snapshotAbsence.hasData == true) {
                                getAlreadyAbsent(
                                    snapshotAbsence, snapshotParents);
                                String accountType = getAccountType(
                                    snapshotStudent,
                                    snapshotTeachers,
                                    snapshotParents);
                                if (accountType == 'student') {
                                  return const Center(
                                    child: Text(
                                      'You must have a parent account to mark yourself absent. Please contanct your parent to have them mark you absent.',
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                } else if (accountType == 'parent') {
                                  return Column(
                                    children: [
                                      const Spacer(),
                                      Text(
                                        'By clicking the button below, you are marking your child as absent for today, ${DateFormat('EEEE, MMM d, yyyy').format(DateTime.now())}. This will mark your child absent for the entire day If your child signs in late, they will be marked present for the remaining part of the day.',
                                        textAlign: TextAlign.center,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor: (_isWeekend ||
                                                        alreadyAbsent)
                                                    ? MaterialStateProperty.all<
                                                        Color>(Colors.grey)
                                                    : MaterialStateProperty.all<
                                                            Color>(
                                                        Palette.primarySwatch)),
                                            onPressed: () {
                                              print(
                                                  'Is weekend: $_isWeekend \n Already absent: $alreadyAbsent');
                                              if ((!_isWeekend &&
                                                  !alreadyAbsent)) {
                                                reportAbsence(
                                                    snapshotStudent,
                                                    snapshotParents,
                                                    snapshotTeachers);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(_isWeekend
                                                        ? "You can't mark your student absent on a weekend"
                                                        : "Your student is already marked absent"),
                                                  ),
                                                );
                                              }
                                            },
                                            child: const Text(
                                                'Mark my student absent today')),
                                      ),
                                      const Spacer(),
                                    ],
                                  );
                                } else if (accountType == 'teacher') {
                                  List<dynamic> absences =
                                      getAbsencesForTeacher(
                                          snapshotAbsence, snapshotStudent);
                                  int length = absences.length;
                                  for (var i = 0; i < (30 - length); i++) {
                                    absences.add('');
                                  }
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          'Your Absences Today:\n(${DateFormat('EEEE, MMM d, yyyy').format(DateTime.now())})',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: absences.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              color: (index % 2 == 1)
                                                  ? Colors.white
                                                  : Colors.grey[400],
                                              child: ListTile(
                                                title: Text(
                                                    '${index + 1}. ${absences.elementAt(index)}'),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  );
                                } else {
                                  return const Text('Error');
                                }
                              } else {
                                return const CircularProgressIndicator();
                              }
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
