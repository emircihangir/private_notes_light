import 'package:flutter/material.dart';

ThemeData appTheme() {
  final Brightness brightness = .light;
  final ColorScheme colorScheme = .fromSeed(seedColor: Colors.blue, brightness: brightness);

  return ThemeData(
    colorScheme: colorScheme,
    brightness: brightness,

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) return colorScheme.inversePrimary;
          if (states.contains(WidgetState.disabled)) return colorScheme.primaryContainer;
          return colorScheme.primary;
        }),
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        elevation: WidgetStatePropertyAll(0),
        animationDuration: Duration.zero,
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(3))),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationThemeData(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: colorScheme.primary),
      ),
      contentPadding: EdgeInsets.only(left: 5, top: 10, bottom: 10),
      isDense: true,
      hintStyle: TextStyle(fontWeight: FontWeight.w200, color: colorScheme.onSurfaceVariant),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: BorderSide(color: colorScheme.primary, width: 3),
      ),
    ),

    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) return colorScheme.inversePrimary;
          if (states.contains(WidgetState.disabled)) return colorScheme.primaryFixed;
          return colorScheme.primary;
        }),
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        elevation: WidgetStatePropertyAll(0),
        animationDuration: Duration.zero,
      ),
    ),
  );
}
