import 'package:flutter/material.dart';
import 'package:todo_list/constants.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: kDarkBlue),
      useMaterial3: false,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
      ),
      scaffoldBackgroundColor: kLightGrey,
      snackBarTheme: const SnackBarThemeData(
        shape: StadiumBorder(),
        backgroundColor: Color(0xff007E6A),
        behavior: SnackBarBehavior.floating,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: kDarkPurple),
        ),
      ),
      textTheme: TextTheme(
        titleMedium: TextStyle(color: kPurple),
      ),
    );
  }
}
