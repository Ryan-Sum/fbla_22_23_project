import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final email = context.read<String>();
    return Center(
      child: Column(
        children: [
          const Spacer(),
          Text("You're logged in as: $email"),
          const Spacer(),
          ElevatedButton(
            onPressed: logOut,
            style: ButtonStyle(
                maximumSize:
                    MaterialStateProperty.all<Size>(const Size(150, 59))),
            child: const Text('Log Out'),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Future logOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
