import 'package:fbla_22_23_project/screens/home.dart';
import 'package:fbla_22_23_project/screens/login/login.dart';
import 'package:fbla_22_23_project/themes/light_them.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  //Build Method
  Widget build(BuildContext context) {
    //Root of the App
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: lightTheme(),
      //Get stream of User auth state
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //Checks if user is currently logged in
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong. Try restarting the app.'),
            );
          }
          if (snapshot.hasData) {
            return Provider(
              create: (email) => FirebaseAuth.instance.currentUser?.email,
              child: const HomePage(),
            );
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
