import 'package:flutter/material.dart';

import '../../utils/app_text_style.dart';

class CustomAppBar extends StatelessWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Text(
        title,
        style: AppTextStyle.appBarText,
      ),
    );
  }
}
