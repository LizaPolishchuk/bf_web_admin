import 'package:bf_web_admin/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextStyle {
  static const TextStyle buttonText =
      TextStyle(color: AppColors.lightBackground, fontSize: 16, fontWeight: FontWeight.w500);

  static const TextStyle bodyMediumText =
      TextStyle(color: AppColors.textColor, fontSize: 16, fontWeight: FontWeight.w400);

  static const TextStyle bodySmallText =
      TextStyle(color: AppColors.textColor, fontSize: 12, fontWeight: FontWeight.w400);

  static const TextStyle titleMediumText =
      TextStyle(color: AppColors.textColor, fontSize: 20, fontWeight: FontWeight.w500);

  static const TextStyle titleSmallText = TextStyle(color: AppColors.hintColor, fontSize: 18, fontWeight: FontWeight.w500);

  static const TextStyle hintText = TextStyle(color: AppColors.hintColor, fontSize: 14, fontWeight: FontWeight.w400);

  static const TextStyle appBarText = TextStyle(color: AppColors.darkRose, fontSize: 25, fontWeight: FontWeight.w500);
}
