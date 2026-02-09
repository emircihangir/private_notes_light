import 'package:flutter/material.dart';

ThemeData appTheme(Brightness brightness) {
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

    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        animationDuration: Duration.zero,
        foregroundColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.inversePrimary;
          }
          return colorScheme.primary;
        }),
      ),
    ),

    appBarTheme: AppBarTheme(scrolledUnderElevation: 0),

    listTileTheme: ListTileThemeData(
      shape: Border(bottom: BorderSide(width: 1, color: colorScheme.onSurface)),
    ),

    searchBarTheme: SearchBarThemeData(
      constraints: BoxConstraints(maxHeight: 45, minHeight: 45),
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      elevation: WidgetStatePropertyAll(0),
      padding: WidgetStatePropertyAll(EdgeInsets.only(left: 12, right: 12)),
      backgroundColor: WidgetStatePropertyAll(colorScheme.surface),
      shape: WidgetStateOutlinedBorder.resolveWith((states) {
        if (states.contains(WidgetState.focused)) {
          return RoundedRectangleBorder(
            side: BorderSide(width: 3, color: colorScheme.primary),
            borderRadius: BorderRadiusGeometry.all(Radius.circular(3)),
          );
        }
        return RoundedRectangleBorder(
          side: BorderSide(width: 2, color: colorScheme.primary),
          borderRadius: BorderRadiusGeometry.all(Radius.circular(3)),
        );
      }),
    ),

    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(3))),
    ),

    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(3))),
        ),
      ),
    ),

    bottomSheetTheme: BottomSheetThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(3))),
    ),
  );
}
