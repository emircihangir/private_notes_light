import 'package:flutter/material.dart';

final lightAppTheme = appTheme(Brightness.light);
final darkAppTheme = appTheme(Brightness.dark);

ThemeData appTheme(Brightness brightness) {
  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: brightness,
  );

  return ThemeData(
    colorScheme: colorScheme,
    brightness: brightness,

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(colorScheme.primary),
        elevation: const WidgetStatePropertyAll(0),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(3))),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationThemeData(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: colorScheme.primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: BorderSide(color: colorScheme.primary, width: 3),
      ),
      errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: colorScheme.error)),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 3, color: colorScheme.error),
      ),
      contentPadding: const EdgeInsets.only(left: 5, top: 10, bottom: 10),
      isDense: true,
      hintStyle: TextStyle(fontWeight: FontWeight.w200, color: colorScheme.onSurfaceVariant),
    ),

    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStatePropertyAll(colorScheme.primary),
        elevation: const WidgetStatePropertyAll(0),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(colorScheme.primary)),
    ),

    listTileTheme: ListTileThemeData(
      shape: Border(bottom: BorderSide(width: 1, color: colorScheme.onSurface)),
    ),

    searchBarTheme: SearchBarThemeData(
      constraints: const BoxConstraints(maxHeight: 45, minHeight: 45),
      elevation: const WidgetStatePropertyAll(0),
      padding: const WidgetStatePropertyAll(EdgeInsets.only(left: 12, right: 12)),
      backgroundColor: WidgetStatePropertyAll(colorScheme.surface),
      shape: WidgetStateOutlinedBorder.resolveWith((states) {
        if (states.contains(WidgetState.focused)) {
          return RoundedRectangleBorder(
            side: BorderSide(width: 3, color: colorScheme.primary),
            borderRadius: const BorderRadiusGeometry.all(Radius.circular(3)),
          );
        }
        return RoundedRectangleBorder(
          side: BorderSide(width: 2, color: colorScheme.primary),
          borderRadius: const BorderRadiusGeometry.all(Radius.circular(3)),
        );
      }),
    ),

    dialogTheme: const DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(3))),
    ),

    segmentedButtonTheme: const SegmentedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(3))),
        ),
      ),
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(3))),
    ),

    cardTheme: const CardThemeData(elevation: 0),
  );
}
