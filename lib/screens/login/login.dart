import 'package:fbla_22_23_project/screens/login/forgot_password.dart';
import 'package:flutter/material.dart';
import 'local_widgets/login_form.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: (MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                (MediaQuery.of(context).padding.bottom)),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 64.0,
                  ),
                  const Spacer(),
                  Image.asset('assets/images/cloud.png'),
                  const Spacer(),
                  const LoginForm(),
                  TextButton(
                    onPressed: () async {
                      if (!await launchUrl(Uri.parse(
                          'https://drive.google.com/file/d/1U_0OX2j0veQuuvZloneOABin5wd5VG9Q/view?usp=sharing'))) {
                        throw 'Could not launch https://drive.google.com/file/d/1U_0OX2j0veQuuvZloneOABin5wd5VG9Q/view?usp=sharing';
                      }
                    },
                    style: ButtonStyle(
                        textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(color: Colors.black))),
                    child: const Text('Terms of service'),
                  ),
                  const SizedBox(
                    height: 16,
                    width: 0,
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
