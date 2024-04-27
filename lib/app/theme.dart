import 'package:flutter/material.dart';

ThemeData lightTheme(BuildContext context) => ThemeData(
    useMaterial3: true,
    textTheme: TextTheme(
      titleLarge: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            visualDensity: VisualDensity.compact,
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )))));
