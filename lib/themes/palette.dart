import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor primarySwatch = MaterialColor(
    0xff87d7e0, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff87D7E0), //10%
      100: Color(0xff78BFC7), //20%
      200: Color(0xff69A7AE), //30%
      300: Color(0xff5A8F95), //40%
      400: Color(0xff4B777C), //50%
      500: Color(0xff3C5F63), //60%
      600: Color(0xff2D474A), //70%
      700: Color(0xff1E2F31), //80%
      800: Color(0xff0F1718), //90%
      900: Color(0xff000000), //100%
    },
  );
}
