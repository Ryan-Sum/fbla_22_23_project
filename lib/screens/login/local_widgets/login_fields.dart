import 'package:flutter/material.dart';

class LoginField extends StatefulWidget {
  final String label;
  final bool isObscurred;
  final TextInputType keyboardType;
  final TextEditingController controler;
  const LoginField({
    super.key,
    required this.label,
    required this.isObscurred,
    required this.keyboardType,
    required this.controler,
  });

  @override
  State<LoginField> createState() => _LoginFieldState();
}

class _LoginFieldState extends State<LoginField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controler,
      keyboardType: widget.keyboardType,
      obscureText: widget.isObscurred,
      decoration: InputDecoration(
        hintText: widget.label,
      ),
    );
  }
}
