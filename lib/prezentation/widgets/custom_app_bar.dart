import 'package:bf_web_admin/injection_container_web.dart';
import 'package:bf_web_admin/utils/app_images.dart';
import 'package:bf_web_admin/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class CustomAppBar extends StatelessWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
              onPressed: () async => getItWeb<UserRepository>().switchThemeMode(),
              icon: SvgPicture.asset(AppTheme.isDark ? AppIcons.icSun : AppIcons.icMoon))
        ],
      ),
    );
  }
}
