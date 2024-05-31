import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/expenses.dart';

var kColorSheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 96, 59, 181));

var kDarkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark, seedColor: const Color.fromARGB(255, 5, 99, 125));

void main() {
  runApp(MaterialApp(
    darkTheme: ThemeData.dark().copyWith(
      colorScheme: kDarkColorScheme,
      cardTheme: const CardTheme().copyWith(
        color: kDarkColorScheme.secondaryContainer,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: kDarkColorScheme.primaryContainer,
              foregroundColor: kDarkColorScheme.onPrimaryContainer)),
    ),
    theme: ThemeData().copyWith(
        colorScheme: kColorSheme,
        appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorSheme.onPrimaryContainer,
            foregroundColor: kColorSheme.primaryContainer),
        cardTheme: const CardTheme().copyWith(
          color: kColorSheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: kColorSheme.primaryContainer)),
        textTheme: ThemeData().textTheme.copyWith(
            titleLarge: TextStyle(
                fontWeight: FontWeight.normal,
                color: kColorSheme.secondary,
                fontSize: 20))),
    themeMode: ThemeMode.system,
    home: const Expenses(),
  ));
}
