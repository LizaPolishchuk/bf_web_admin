import 'package:flutter/material.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

import 'app_colors.dart';
import 'app_text_style.dart';

abstract class AppTheme {
  static Brightness get brightness {
    final isLight = getIt<LocalStorage>().getThemeMode;
    print("AppTheme isLight: ${getIt<LocalStorage>().getThemeMode}");
    return isLight ? Brightness.light : Brightness.dark;
  }

  static ThemeData get theme => brightness == Brightness.dark ? dark : light;

  static bool get isDark => brightness == Brightness.dark;

  static final light = ThemeData(
    primaryColor: AppColors.darkRose,
    colorScheme: const ColorScheme.light(
      primary: AppColors.darkRose,
      secondary: AppColors.darkTurquoise,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: AppColors.lightBackground,
    textTheme: const TextTheme(
      //bodies
      bodySmall: AppTextStyle.bodySmallText,
      bodyMedium: AppTextStyle.bodyMediumText,
      //buttons
      labelMedium: AppTextStyle.buttonText,
      //titles
      titleSmall: AppTextStyle.titleSmallText,
      titleMedium: AppTextStyle.titleMediumText,
      titleLarge: AppTextStyle.appBarText,
      //hints
      displaySmall: AppTextStyle.hintText,
    ),
    inputDecorationTheme: getInputDecorationTheme(isDark: false),
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
    colorScheme: const ColorScheme.dark(
      primary: AppColors.blue,
      secondary: AppColors.darkBlue,
    ),
    primaryColor: AppColors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    hintColor: AppColors.hintColor,
    scaffoldBackgroundColor: AppColors.darkBackground,
    textTheme: TextTheme(
      //bodies
      bodySmall: AppTextStyle.bodySmallText.copyWith(color: Colors.white),
      bodyMedium: AppTextStyle.bodyMediumText.copyWith(color: Colors.white),
      //buttons
      labelMedium: AppTextStyle.buttonText.copyWith(color: Colors.white),
      //titles
      titleSmall: AppTextStyle.titleSmallText.copyWith(color: Colors.white),
      titleMedium: AppTextStyle.titleMediumText.copyWith(color: Colors.white),
      titleLarge: AppTextStyle.appBarText.copyWith(color: Colors.white),
      //hints
      displaySmall: AppTextStyle.hintText,
    ),
    inputDecorationTheme: getInputDecorationTheme(isDark: true),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        textStyle: MaterialStateProperty.all(AppTextStyle.buttonText.copyWith(color: Colors.white)),
        foregroundColor: MaterialStateProperty.all(AppColors.hintColor),
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

getInputDecorationTheme({required bool isDark}) {
  return InputDecorationTheme(
    filled: true,
    fillColor: AppColors.textInputBgGrey ,
    // labelStyle: AppTextStyle.bodyMediumText.copyWith(color: Colors.white) ,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    hintStyle: AppTextStyle.hintText,
    errorStyle: AppTextStyle.hintText.copyWith(color: isDark ? AppColors.errorColorDark : AppColors.errorColorLight),
    errorMaxLines: 1,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none),
      borderRadius: BorderRadius.all(Radius.circular(25)),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none),
      borderRadius: BorderRadius.all(Radius.circular(25)),
    ),
    errorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none),
      borderRadius: BorderRadius.all(Radius.circular(25)),
    ),
    disabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none),
      borderRadius: BorderRadius.all(Radius.circular(25)),
    ),
  );
}

// static ThemeData getTheme(bool isDark, BuildContext context) {
//   return
// }
