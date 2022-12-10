import 'package:flutter/cupertino.dart';
import 'package:salons_adminka/utils/app_colors.dart';

LinearGradient rightGradient() {
  return const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      AppColors.lightTurquoise,
      AppColors.lightTurquoise,
      AppColors.lightTurquoise,
      AppColors.lightTurquoise,
      AppColors.darkTurquoise,
    ],
  );
}

LinearGradient leftGradient() {
  return const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      AppColors.darkRose,
      AppColors.rose,
      AppColors.rose,
      AppColors.rose,
    ],
  );
}

Widget desktopBackground() {
  return Row(
    children: [
      Flexible(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: leftGradient(),
          ),
        ),
      ),
      Flexible(child: mobileBackground())
    ],
  );
}

Widget mobileBackground() {
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: BoxDecoration(
      gradient: rightGradient(),
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
    ),
  );
}
