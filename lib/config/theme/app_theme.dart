import 'package:flutter/material.dart';

class AppTheme {


  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color(0xff26A5FD),
    brightness: Brightness.dark
  );

}