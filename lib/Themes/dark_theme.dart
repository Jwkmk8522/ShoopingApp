import 'package:flutter/material.dart';

ThemeData customDarkTheme = ThemeData.dark(
  useMaterial3: true,
).copyWith(
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF6200EE), // Vibrant Indigo
    secondary: Colors.black54, // Amber
    surface: Color(0xFF1E1E2C), // Deep Navy
    onPrimary: Colors.white,
    onSecondary: Color(0xFF2C2C38),
    onSurface: Color(0xFFD1D1E0),
    error: Color.fromARGB(255, 9, 47, 239),
    onError: Color.fromARGB(255, 247, 3, 3),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(
      255, 43, 42, 42), // Set a custom Scaffold background color

  cardTheme: CardTheme(
    color: const Color.fromARGB(
        255, 87, 86, 86), // Slightly lighter than Scaffold for contrast
    elevation: 4,
    shadowColor: // Colors.black.withOpacity(0.100),
        Colors.black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  ),
  appBarTheme: const AppBarTheme(
    color: Color(0xFF2C2C38),
    titleTextStyle: TextStyle(
      color: Color(0xFFE0E0FF),
      fontFamily: 'Lato',
      fontWeight: FontWeight.bold,
      fontSize: 25,
    ),
    iconTheme: IconThemeData(color: Color(0xFFE0E0FF)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF6200EE),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
        color: Color(0xFFE0E0FF),
        fontSize: 22,
        fontWeight: FontWeight.bold,
        fontFamily: 'Lato'),
    titleMedium: TextStyle(
        color: Color(0xFFE0E0FF),
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'Lato'),
    titleSmall: TextStyle(
      color: Color(0xFFE0E0FF),
      fontSize: 14,
    ),
  ),
);

ThemeData customLightTheme = ThemeData.light(
  useMaterial3: true,
).copyWith(
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF6200EE), // Vibrant Indigo
    secondary: Colors.black54, // Amber
    surface: Colors.white,
    onPrimary: Colors.black,
    onSecondary: Colors.grey,
    onSurface: Colors.black,
    error: Colors.red,
    onError: Color.fromARGB(255, 247, 3, 3),
  ),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Light gray background

  cardTheme: CardTheme(
    color: Colors.white, // White for light mode
    elevation: 4,
    shadowColor: Colors.grey.withOpacity(0.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.white,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontFamily: 'Lato',
      fontWeight: FontWeight.bold,
      fontSize: 25,
    ),
    iconTheme: IconThemeData(color: Color(0xFF6200EE)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF6200EE),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
        color: Color(0xFF6200EE),
        fontSize: 22,
        fontWeight: FontWeight.bold,
        fontFamily: 'Lato'),
    titleMedium: TextStyle(
        color: Color(0xFF6200EE),
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'Lato'),
    titleSmall: TextStyle(
      color: Colors.black,
      fontSize: 14,
    ),
  ),
);
