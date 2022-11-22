import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpcommingEvents extends StatefulWidget {
  const UpcommingEvents({super.key});

  @override
  State<UpcommingEvents> createState() => _UpcommingEventsState();
}

class _UpcommingEventsState extends State<UpcommingEvents> {
  @override
  Widget build(BuildContext context) {
    final email = context.read<String>();
    return Scaffold(
      body: SafeArea(
        child: Center(
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
        ),
      ),
    );
  }

  Future logOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
