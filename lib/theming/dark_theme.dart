import 'package:flutter/material.dart';

class DarkTheme {
  static ThemeData get() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        background: Color(0xff1b1b1b),
        brightness: Brightness.dark,
        error: Color(0xffffb4a9),
        errorContainer: Color(0xff930006),
        inversePrimary: Color(0xff0061a6),
        inverseSurface: Color(0xffe2e2e6),
        onBackground: Color(0xffe2e2e6),
        onError: Color(0xff680003),
        onErrorContainer: Color(0xffffb4a9),
        onInverseSurface: Color(0xff2f3033),
        onPrimary: Color(0xff00325a),
        onPrimaryContainer: Color(0xffd0e4ff),
        onSecondary: Color(0xff253140),
        onSecondaryContainer: Color(0xffd6e3f7),
        onSurface: Color(0xffe2e2e6),
        onSurfaceVariant: Color(0xffc3c7d0),
        onTertiary: Color(0xff3b2948),
        onTertiaryContainer: Color(0xfff3daff),
        outline: Color(0xff8d9199),
        primary: Color(0xff9ccaff),
        primaryContainer: Color(0xff00497f),
        secondary: Color(0xffbbc8db),
        secondaryContainer: Color(0xff3c4858),
        shadow: Color(0xff000000),
        surface: Color(0xff1b1b1b),
        surfaceTint: Color(0xff9ccaff),
        surfaceVariant: Color(0xff42474e),
        tertiary: Color(0xffd6bee4),
        tertiaryContainer: Color(0xff523f5f),
      ),
    );
  }
}
