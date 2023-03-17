import 'package:bf_web_admin/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            text: TextSpan(
              text: '1',
              style: Theme.of(context).textTheme.bodyMedium,
              children: <TextSpan>[
                TextSpan(text: '-25', style: Theme.of(context).textTheme.displaySmall),
              ],
            ),
          ),
          SvgPicture.asset(AppIcons.icCircleArrowRight),
        ],
      ),
    );
  }
}
