import 'package:fbla_22_23_project/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_fields.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailControler = TextEditingController();
  final passwordControler = TextEditingController();

  @override
  void dispose() {
    emailControler.dispose();
    passwordControler.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          LoginField(
            controler: emailControler,
            keyboardType: TextInputType.emailAddress,
            label: 'email',
            isObscurred: false,
          ),
          const SizedBox(
            height: 16,
            width: 0,
          ),
          LoginField(
            controler: passwordControler,
            keyboardType: TextInputType.visiblePassword,
            label: 'password',
            isObscurred: true,
          ),
          const SizedBox(
            height: 16,
            width: 0,
          ),
          ElevatedButton(
            onPressed: signIn,
            child: const Text("Sign In"),
          ),
          const SizedBox(
            height: 16,
            width: 0,
          ),
        ],
      ),
    );
  }

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailControler.text.trim(),
          password: passwordControler.text.trim());
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ((e.message == null) ? "Error, try again later" : e.message)!,
          ),
        ),
      );
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
