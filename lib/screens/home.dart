import 'package:fbla_22_23_project/screens/calendar/calendar.dart';
import 'package:fbla_22_23_project/screens/absence/absence.dart';
import 'package:fbla_22_23_project/screens/profile/profile_screen.dart';
import 'package:fbla_22_23_project/screens/share_images/share_images.dart';
import 'package:fbla_22_23_project/screens/social_media/social_media.dart';
import 'package:fbla_22_23_project/themes/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget screen = const SocialMediaScreen();
  String title = 'Social Media';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
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
              leading: const Icon(Icons.share),
              title: const Text('Social Media'),
              onTap: () {
                setState(() {
                  screen = const SocialMediaScreen();
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
                leading: const Icon(Icons.checklist),
                title: const Text('Attendence'),
                onTap: () {
                  setState(() {
                    screen = const AbsenceScreen();
                    title = 'Attendance';
                    Navigator.pop(context);
                  });
                }),
            ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Share Images'),
                onTap: () {
                  setState(() {
                    screen = const ShareImagesScreen();
                    title = 'Share Images';
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
