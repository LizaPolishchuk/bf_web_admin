import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salons_adminka/utils/app_images.dart';
import 'package:salons_adminka/utils/app_text_style.dart';

class PaginationCounter extends StatelessWidget {
  const PaginationCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppIcons.icCircleArrowLeft),
          RichText(
            text: const TextSpan(
              text: '1',
              style: AppTextStyle.bodyText,
              children: <TextSpan>[
                TextSpan(text: '-25', style: AppTextStyle.hintText),
              ],
            ),
          ),
          SvgPicture.asset(AppIcons.icCircleArrowRight),
        ],
      ),
    );
  }
}
