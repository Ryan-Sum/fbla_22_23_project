import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbla_22_23_project/screens/share_images/add_post_screen.dart';
import 'package:fbla_22_23_project/themes/palette.dart';
import 'package:flutter/material.dart';

import '../../functions/parents.dart';
import '../../functions/post.dart';
import '../../functions/students.dart';
import '../../functions/teachers.dart';
import 'local_widgets/image_tile.dart';

class ShareImagesScreen extends StatefulWidget {
  const ShareImagesScreen({super.key});

  @override
  State<ShareImagesScreen> createState() => _ShareImagesScreenState();
}

class _ShareImagesScreenState extends State<ShareImagesScreen> {
  Stream<List<Post>> getPosts() {
    return FirebaseFirestore.instance.collection('posts').snapshots().map(
        (user) => user.docs.map((doc) => Post.fromJson(doc.data())).toList());
  }

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

  Stream<List<Parent>> getParentSnapshot() {
    return FirebaseFirestore.instance.collection('parents').snapshots().map(
        (user) => user.docs.map((doc) => Parent.fromJson(doc.data())).toList());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: getTeacherSnapshot(),
        builder: (context, teacherStream) {
          if (teacherStream.hasData) {
            return StreamBuilder(
                stream: getStudentSnapshot(),
                builder: (context, studentStream) {
                  if (studentStream.hasData) {
                    return StreamBuilder(
                        stream: getParentSnapshot(),
                        builder: (context, parentStream) {
                          if (parentStream.hasData) {
                            return StreamBuilder(
                                stream: getPosts(),
                                builder: (context, stream) {
                                  if (stream.hasData) {
                                    stream.data!.sort(
                                      (a, b) => b.date.compareTo(a.date),
                                    );
                                    return Stack(
                                      children: [
                                        ListView.builder(
                                          addAutomaticKeepAlives: true,
                                          itemCount: stream.data!.length,
                                          itemBuilder: (context, index) {
                                            return ImageTile(
                                              author: stream.data!
                                                  .elementAt(index)
                                                  .author,
                                              imageUrl: stream.data!
                                                  .elementAt(index)
                                                  .imageUrl,
                                              caption: stream.data!
                                                  .elementAt(index)
                                                  .caption,
                                              likes: stream.data!
                                                  .elementAt(index)
                                                  .likes,
                                              id: stream.data!
                                                  .elementAt(index)
                                                  .id,
                                              index: index,
                                              posts: stream,
                                              date: stream.data!
                                                  .elementAt(index)
                                                  .date,
                                            );
                                          },
                                        ),
                                        SafeArea(
                                          child: Column(
                                            children: [
                                              const Spacer(),
                                              Row(
                                                children: [
                                                  const Spacer(),
                                                  FloatingActionButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddPostScreen(
                                                            parentSnapshot:
                                                                parentStream,
                                                            studentSnapshot:
                                                                studentStream,
                                                            teacherSnapshot:
                                                                teacherStream,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    backgroundColor:
                                                        Palette.primarySwatch,
                                                    child:
                                                        const Icon(Icons.add),
                                                  ),
                                                  const SizedBox(
                                                    width: 16,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                });
                          } else {
                            return const CircularProgressIndicator();
                          }
                        });
                  } else {
                    return const CircularProgressIndicator();
                  }
                });
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
