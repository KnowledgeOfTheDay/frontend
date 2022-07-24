import 'package:flutter/material.dart';

class LightTheme {
  static ThemeData get() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        background: Color(0xfffdfcff),
        brightness: Brightness.light,
        error: Color(0xffba1b1b),
        errorContainer: Color(0xffffdad4),
        inversePrimary: Color(0xff9ccaff),
        inverseSurface: Color(0xff2f3033),
        onBackground: Color(0xff1b1b1b),
        onError: Color(0xffffffff),
        onErrorContainer: Color(0xff410001),
        onInverseSurface: Color(0xfff1f0f4),
        onPrimary: Color(0xffffffff),
        onPrimaryContainer: Color(0xff001d36),
        onSecondary: Color(0xffffffff),
        onSecondaryContainer: Color(0xff101c2b),
        onSurface: Color(0xff1b1b1b),
        onSurfaceVariant: Color(0xff42474e),
        onTertiary: Color(0xffffffff),
        onTertiaryContainer: Color(0xff251432),
        outline: Color(0xff73777f),
        primary: Color(0xff0061a6),
        primaryContainer: Color(0xffd0e4ff),
        secondary: Color(0xff2196f3),
        secondaryContainer: Color(0xffd6e3f7),
        shadow: Color(0xff000000),
        surface: Color(0xfffdfcff),
        surfaceTint: Color(0xff0061a6),
        surfaceVariant: Color(0xffdfe2eb),
        tertiary: Color(0xff6b5778),
        tertiaryContainer: Color(0xfff3daff),
      ),
    );
  }
}
