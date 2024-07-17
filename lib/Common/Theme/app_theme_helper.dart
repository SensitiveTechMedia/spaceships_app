import 'dart:ui';

import 'package:flutter/material.dart';

import '../Constants/color_helper.dart';

class AppTheme {
  static ColorScheme darkTheme = ColorScheme.dark(
    primary: ColorCodes.white,
    onPrimary: Color(0xff404040),
    // primaryContainer: Color(0xFFD0C000),
    // onPrimaryContainer: ColorCodes.tint,
    secondary: ColorCodes.black,

    background: ColorCodes.black,

  );

  static ColorScheme lightTheme = ColorScheme.light(
    primary: ColorCodes.indigo,
    onPrimary: Color(0xffF5F4F8),

    secondary: ColorCodes.white,

    background: ColorCodes.white,
    //onBackground: const Color(0xFF333333),
    // surface: const Color(0xFF333333),
    // onSurface: const Color(0xFF333333),
    // surfaceVariant: const Color(0xFF57545B),
    // onSurfaceVariant: const Color(0xFF757575),
  );

  static final light = ThemeData(
      useMaterial3: true,
      fontFamily: 'Outfit',
      colorScheme: lightTheme,
      brightness: Brightness.light);
  static final dark = ThemeData(
      useMaterial3: true,
      fontFamily: 'Outfit',
      colorScheme: darkTheme,
      brightness: Brightness.dark);
}
