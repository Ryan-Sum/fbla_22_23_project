import 'package:fbla_22_23_project/screens/calendar/calendar.dart';
import 'package:fbla_22_23_project/screens/messages/messages.dart';
import 'package:fbla_22_23_project/screens/profile/profile_screen.dart';
import 'package:fbla_22_23_project/screens/upcomming_events/upcomming_events.dart';
import 'package:fbla_22_23_project/themes/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget screen = const Calendar();
  String title = 'Calendar';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Palette.primarySwatch,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 64,
                      ),
                      Spacer(),
                    ],
                  ),
                  Text(
                    context.read<String>(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Upcomming Events'),
              onTap: () {
                setState(() {
                  screen = const UpcommingEvents();
                  title = 'Upcomming Events';
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Calendar'),
              onTap: () {
                setState(() {
                  screen = const Calendar();
                  title = 'Calendar';
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
                leading: const Icon(Icons.message),
                title: const Text('Messages'),
                onTap: () {
                  setState(() {
                    screen = const MessagesScreen();
                    title = 'Messages';
                    Navigator.pop(context);
                  });
                }),
            ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  setState(() {
                    screen = const ProfileScreen();
                    title = 'Profile';
                    Navigator.pop(context);
                  });
                }),
          ],
        ),
      ),
      body: screen,
    );
  }
}
