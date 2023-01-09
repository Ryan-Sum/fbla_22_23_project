import 'package:flutter/material.dart';
import 'palette.dart';

ThemeData lightTheme() {
  return ThemeData(
      primarySwatch: Palette.primarySwatch,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all<TextStyle>(
            const TextStyle(
              color: Colors.black,
            ),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
          elevation: MaterialStateProperty.all<double>(0.0),
          fixedSize: MaterialStateProperty.all<Size>(
            const Size(350, 59),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 135, 215, 224),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color.fromARGB(255, 238, 238, 238),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(0, 255, 255, 255),
            width: 0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(0, 255, 255, 255),
            width: 0,
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ));
}
