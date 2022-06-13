import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'app_colors.dart';
import 'app_text_style.dart';

abstract class AppTheme {
  static Brightness get brightness =>
      SchedulerBinding.instance!.window.platformBrightness;

  static ThemeData get theme => brightness == Brightness.dark ? dark : light;

  static bool get isDark => brightness == Brightness.dark;

  static final light = ThemeData(
    // colorScheme: const ColorScheme.light(primary: AppColors.colorRose), //for date picker
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: AppColors.lightBackground,
    // canvasColor: AppColors.colorMainText,
    // iconTheme: const IconThemeData(color: AppColors.colorSecondText),
    // textTheme: const TextTheme(
    //   bodyText2: TextStyle(color: AppColors.colorMainText),
    // ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppColors.textInputBgGrey,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(style: BorderStyle.none),
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(style: BorderStyle.none),
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        textStyle: MaterialStateProperty.all(AppTextStyle.buttonText),
        foregroundColor: MaterialStateProperty.all(AppColors.lightBackground),
        backgroundColor: MaterialStateProperty.all(AppColors.darkRose),
        minimumSize: MaterialStateProperty.all(const Size(228, 50)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    ),
  );

  static final dark = ThemeData(
    // colorScheme: const ColorScheme.light(primary: AppColors.colorRose), //for date picker
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: AppColors.darkBackground,
    // canvasColor: AppColors.colorMainText,
    // iconTheme: const IconThemeData(color: AppColors.colorSecondText),
    // textTheme: const TextTheme(
    //   bodyText2: TextStyle(color: AppColors.colorMainText),
    // ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppColors.textInputBgGrey,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(style: BorderStyle.none),
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(style: BorderStyle.none),
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        textStyle: MaterialStateProperty.all(AppTextStyle.buttonText),
        foregroundColor: MaterialStateProperty.all(AppColors.hintText),
        backgroundColor: MaterialStateProperty.all(AppColors.darkBackground),
        minimumSize: MaterialStateProperty.all(const Size(228, 50)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    ),
  );
}
