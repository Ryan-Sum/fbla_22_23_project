// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbla_22_23_project/functions/parents.dart';
import 'package:fbla_22_23_project/functions/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../functions/students.dart';
import '../../functions/teachers.dart';

class AddPostScreen extends StatefulWidget {
  final AsyncSnapshot<List<Teacher>> teacherSnapshot;
  final AsyncSnapshot<List<Student>> studentSnapshot;
  final AsyncSnapshot<List<Parent>> parentSnapshot;
  const AddPostScreen(
      {super.key,
      required this.teacherSnapshot,
      required this.studentSnapshot,
      required this.parentSnapshot});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  File? image;
  TextEditingController captionController = TextEditingController();

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ((e.message == null) ? "Error, try again later" : e.message)!,
          ),
        ),
      );
    }
  }

  void addPost() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    String currentId = FirebaseAuth.instance.currentUser!.uid;
    String author = '';
    String url = '';
    String docId = const Uuid().v1();
    if (image == null) return;
    final storageRef =
        FirebaseStorage.instance.ref('posts/').child(const Uuid().v1());

    try {
      await storageRef.putFile(image!);
      url = await storageRef.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            ("Error, try again later"),
          ),
        ),
      );
    }
    for (var element in widget.parentSnapshot.data!) {
      if (element.id == currentId) {
        author = element.name;
      }
    }
    for (var element in widget.studentSnapshot.data!) {
      if (element.id == currentId) {
        author = element.name;
      }
    }
    for (var element in widget.teacherSnapshot.data!) {
      if (element.id == currentId) {
        author = element.name;
      }
    }

    FirebaseFirestore.instance.collection('posts').doc(docId).set(Post(
            author: author,
            caption: captionController.text.trim(),
            date: DateTime.now(),
            imageUrl: url,
            isApproved: false,
            likes: [],
            id: docId)
        .toJson());
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Create New Post',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => pickImage(),
                    child: image != null
                        ? Image.file(image!)
                        : Container(
                            color: Colors.grey,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width,
                            child: Center(
                                child: Row(
                              children: const [
                                Spacer(),
                                Icon(
                                  Icons.photo_library_outlined,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  'Pick Image',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Spacer(),
                              ],
                            )),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: captionController,
                      decoration: const InputDecoration(
                          labelText: 'Caption',
                          floatingLabelBehavior: FloatingLabelBehavior.auto),
                      maxLength: 50,
                      maxLines: 2,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    ),
                  ),
                  const Spacer(),
                  SafeArea(
                      child: ElevatedButton(
                          onPressed: () {
                            addPost();
                          },
                          child: const Text(
                            'Post',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
