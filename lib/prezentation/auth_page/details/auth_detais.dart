import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salons_adminka/utils/app_colors.dart';

const LinearGradient rightGradientDark = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [
    Color(0xff18309D),
    AppColors.blue,
  ],
);

const LinearGradient rightGradientLight = LinearGradient(
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

const LinearGradient leftGradientLight = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    AppColors.darkRose,
    AppColors.rose,
    AppColors.rose,
    AppColors.rose,
  ],
);

const leftGradientDark = AppColors.darkBlue;

// LinearGradient(
//   begin: Alignment.topLeft,
//   end: Alignment.bottomRight,
//   colors: [
//     // Color(0xff1F2937),
//     Color(0xff303A49),
//     // Color(0xff424C5A),
//     // AppColors.darkBlue,
//     // AppColors.darkBackground,
//     // // AppColors.darkBackground,
//     // AppColors.darkBackground,
//   ],
// );

Widget desktopBackground(BuildContext context) {
  return Row(
    children: [
      Flexible(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: Theme.of(context).brightness == Brightness.dark ? null : leftGradientLight,
            color: Theme.of(context).brightness == Brightness.dark ? leftGradientDark : null,
          ),
        ),
      ),
      Flexible(child: mobileBackground(context))
    ],
  );
}

Widget mobileBackground(BuildContext context) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: BoxDecoration(
      gradient: Theme.of(context).brightness == Brightness.dark ? rightGradientDark : rightGradientLight,
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
    ),
  );
}
