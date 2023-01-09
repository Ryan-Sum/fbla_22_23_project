import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../login/forgot_password.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? imageFile;
  TextEditingController nameController = TextEditingController();
  String imageUrl = "";

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() => imageFile = imageTemporary);
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ((e.message == null) ? "Error, try again later" : e.message)!,
          ),
        ),
      );
    }
    final storageRef = FirebaseStorage.instance
        .ref('profilePictures/')
        .child(const Uuid().v1());
    await storageRef.putFile(imageFile!);
    imageUrl = await storageRef.getDownloadURL();
    await FirebaseAuth.instance.currentUser!.updatePhotoURL(imageUrl);
    setState(() {
      imageUrl = FirebaseAuth.instance.currentUser!.photoURL!;
    });
  }

  void getImage() {
    if (FirebaseAuth.instance.currentUser?.photoURL != null) {
      setState(() {
        imageUrl = FirebaseAuth.instance.currentUser!.photoURL!;
      });
    }
  }

  void updateUsername() {
    FirebaseAuth.instance.currentUser!
        .updateDisplayName(nameController.text.trim());
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    nameController.text =
        ((FirebaseAuth.instance.currentUser!.displayName == null)
            ? ''
            : FirebaseAuth.instance.currentUser!.displayName)!;
    getImage();
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            Spacer(),
            SizedBox(
              width: 128,
              height: 128,
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        (imageUrl == '') ? null : NetworkImage(imageUrl),
                    radius: 64,
                    child: (imageUrl == '')
                        ? const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 64,
                          )
                        : null,
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      Column(
                        children: [
                          const Spacer(),
                          FloatingActionButton(
                            mini: true,
                            onPressed: () {
                              pickImage();
                            },
                            child: const Icon(Icons.camera_alt_outlined),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    label: Text('Username'),
                    floatingLabelBehavior: FloatingLabelBehavior.auto),
                onEditingComplete: () {
                  updateUsername();
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
            ),
            Spacer(),
            Text(
              "To change other aspects of your account, please contact your school's admin.",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ForgotPasswordScreen(),
                  ),
                );
              },
              child: const Text('Forgot password'),
            ),
            TextButton(
              onPressed: () {
                launchUrl(Uri(
                    scheme: 'mailto',
                    path: 'sumiantororyan@gmail.com',
                    query: encodeQueryParameters(<String, String>{
                      'subject': 'Bug Report',
                      'body':
                          'Please be descriptive when reporting a bug. Include how the bug occured, what the bug effected, and screenshots of what happened. \n \n Thank you, The SkyChatter Team'
                    })));
              },
              child: const Text('Report a Bug'),
            ),
            ElevatedButton(
                onPressed: () {
                  logOut();
                },
                child: Text('Sign Out')),
          ],
        ),
      ),
    );
  }

  Future logOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
