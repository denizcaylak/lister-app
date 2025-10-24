import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.indigo,
  appBarTheme: const AppBarTheme(elevation: 0),
  scaffoldBackgroundColor: Colors.grey[50],
  cardColor: Colors.white,
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
  appBarTheme: const AppBarTheme(elevation: 0),
  scaffoldBackgroundColor: Colors.black,
  cardColor: const Color(0xFF121212),
);
