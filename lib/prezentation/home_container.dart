import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:salons_adminka/navigation/routes.dart';
import 'package:salons_adminka/prezentation/auth_page/auth_bloc.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

import '../utils/app_colors.dart';
import '../utils/app_images.dart';

class HomeContainer extends StatelessWidget {
  final Widget child;
  final int selectedMenuIndex;
  final double _drawerBigWidth = 264;
  final double _drawerSmallWidth = 68;

  const HomeContainer({Key? key, required this.child, this.selectedMenuIndex = -1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (BuildContext context, SizingInformation size) => Scaffold(
        body: Stack(
          children: [
            Positioned(left: _getDrawerWidth(size) - 4, top: 0, right: 0, bottom: 0, child: child),
            Positioned(left: 0, top: 0, bottom: 0, child: _buildDrawer(context, size)),
          ],
        ),
      ),
    );
  }

  double _getDrawerWidth(SizingInformation size) {
    return size.isDesktop ? _drawerBigWidth : _drawerSmallWidth;
  }

  Widget _buildDrawer(BuildContext context, SizingInformation size) {
    final isDesktop = size.isDesktop;
    return Container(
      width: _getDrawerWidth(size),
      height: double.infinity,
      padding: const EdgeInsets.only(bottom: 12, top: 42),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: FittedBox(
                    child: Row(
                      children: [
                        const Text(
                          "B&F",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        if (isDesktop) const SizedBox(width: 16),
                        if (isDesktop)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Be Beautiful & Be Free",
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "WorkPlace",
                                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 54),
                _buildDrawerItem(context, 0, AppLocalizations.of(context)!.main, AppIcons.icHome,
                    routeToGo: Routes.initial, isDesktop: isDesktop),
                _buildDrawerItem(context, 1, AppLocalizations.of(context)!.services, AppIcons.icServices,
                    routeToGo: Routes.services, isDesktop: isDesktop),
                _buildDrawerItem(context, 2, AppLocalizations.of(context)!.masters, AppIcons.icMasters,
                    routeToGo: Routes.masters, isDesktop: isDesktop),
                _buildDrawerItem(context, 3, AppLocalizations.of(context)!.clients, AppIcons.icClients,
                    routeToGo: Routes.clients, isDesktop: isDesktop),
                _buildDrawerItem(
                    context,
                    4,
                    "${AppLocalizations.of(context)!.promos}/${AppLocalizations.of(context)!.bonusCards}",
                    AppIcons.icPromos,
                    routeToGo: Routes.promos,
                    isDesktop: isDesktop),
                _buildDrawerItem(context, 5, AppLocalizations.of(context)!.feedbacks, AppIcons.icFeedbacks,
                    routeToGo: Routes.feedbacks, isDesktop: isDesktop),
                const Spacer(),
                _buildDrawerItem(context, 6, AppLocalizations.of(context)!.profile, AppIcons.icProfile,
                    routeToGo: Routes.profile, isDesktop: isDesktop),
                _buildDrawerItem(context, 7, AppLocalizations.of(context)!.support, AppIcons.icSupport,
                    routeToGo: Routes.support, isDesktop: isDesktop),
                _buildDrawerItem(context, 8, AppLocalizations.of(context)!.settings, AppIcons.icSettings,
                    routeToGo: Routes.settings, isDesktop: isDesktop),
                _buildDrawerItem(context, 9, AppLocalizations.of(context)!.logout, AppIcons.icLogout,
                    onClick: getIt<AuthBloc>().logout, isDesktop: isDesktop),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, int index, String title, String icon,
      {VoidCallback? onClick, String? routeToGo, required bool isDesktop}) {
    return InkWell(
      onTap: () {
        if (onClick != null) {
          onClick();
        } else if (routeToGo != null) {
          Get.rootDelegate.toNamed(routeToGo);
        }
      },
      //todo add hover effect
      onHover: (value) {
        // value ? state?.onHover(menuItem.route) : state?.onHover('not hovering');
      },
      child: ColoredBox(
        color: index == selectedMenuIndex
            ? Theme.of(context).brightness == Brightness.light
                ? AppColors.lightRose
                : AppColors.darkBackground
            : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                icon,
                color: selectedMenuIndex == index && Theme.of(context).brightness == Brightness.light ? AppColors.darkRose : AppColors.lightRose,
              ),
              if (isDesktop) const SizedBox(width: 20),
              if (isDesktop)
                Flexible(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: selectedMenuIndex == index && Theme.of(context).brightness == Brightness.light
                            ? AppColors.darkRose
                            : Colors.white),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
