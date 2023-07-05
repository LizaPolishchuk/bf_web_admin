import 'package:bf_web_admin/utils/app_theme.dart';
import 'package:bf_web_admin/utils/constants.dart';
import 'package:bf_web_admin/utils/page_content_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../utils/app_colors.dart';
import '../utils/app_images.dart';

class HomeContainer extends StatefulWidget {
  final PageContentType currentPageType;

  const HomeContainer({Key? key, required this.currentPageType}) : super(key: key);

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (BuildContext context, SizingInformation size) => Scaffold(
        body: Stack(
          children: [
            Positioned(left: _getDrawerWidth(size) - 4, top: 0, right: 0, bottom: 0, child: widget.currentPageType.getPage()),
            Positioned(left: 0, top: 0, bottom: 0, child: _buildDrawer(context, size)),
          ],
        ),
      ),
    );
  }

  double _getDrawerWidth(SizingInformation size) {
    return size.isDesktop ? Constants.drawerBigWidth : Constants.drawerSmallWidth;
  }

  Widget _buildDrawer(BuildContext context, SizingInformation size) {
    final isDesktop = size.isDesktop;
    return Container(
      width: _getDrawerWidth(size),
      height: double.infinity,
      padding: const EdgeInsets.only(bottom: 12, top: 42),
      decoration: BoxDecoration(
        color: AppTheme.isDark ? AppColors.darkBlue : AppColors.darkRose,
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
                Expanded(child: _buildDrawerButtons(context, isDesktop)),

                // _buildDrawerItem(context, 0, AppLocalizations.of(context)!.main, AppIcons.icHome,
                //     routeToGo: Routes.initial, isDesktop: isDesktop),
                // _buildDrawerItem(context, 1, AppLocalizations.of(context)!.services, AppIcons.icServices,
                //     routeToGo: Routes.services, isDesktop: isDesktop),
                // _buildDrawerItem(context, 2, AppLocalizations.of(context)!.masters, AppIcons.icMasters,
                //     routeToGo: Routes.masters, isDesktop: isDesktop),
                // _buildDrawerItem(context, 3, AppLocalizations.of(context)!.clients, AppIcons.icClients,
                //     routeToGo: Routes.clients, isDesktop: isDesktop),
                // _buildDrawerItem(
                //     context,
                //     4,
                //     "${AppLocalizations.of(context)!.promos}/${AppLocalizations.of(context)!.bonusCards}",
                //     AppIcons.icPromos,
                //     routeToGo: Routes.promos,
                //     isDesktop: isDesktop),
                // _buildDrawerItem(context, 5, AppLocalizations.of(context)!.feedbacks, AppIcons.icFeedbacks,
                //     routeToGo: Routes.feedbacks, isDesktop: isDesktop),
                // const Spacer(),
                // _buildDrawerItem(context, 6, AppLocalizations.of(context)!.profile, AppIcons.icProfile,
                //     routeToGo: Routes.profile, isDesktop: isDesktop),
                // // _buildDrawerItem(context, 7, AppLocalizations.of(context)!.support, AppIcons.icSupport,
                // //     routeToGo: Routes.support, isDesktop: isDesktop),
                // _buildDrawerItem(context, 7, AppLocalizations.of(context)!.settings, AppIcons.icSettings,
                //     routeToGo: Routes.settings, isDesktop: isDesktop),
                // _buildDrawerItem(context, 8, AppLocalizations.of(context)!.logout, AppIcons.icLogout,
                //     onClick: getIt<AuthBloc>().logout, isDesktop: isDesktop),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerButtons(BuildContext context, bool isDesktop) {
    return Column(
      children: PageContentType.values.map((e) => _buildDrawerItem(context, e, isDesktop: isDesktop)).toList()
        ..insert(6, const Spacer()),
    );
  }

  Widget _buildDrawerItem(BuildContext context, PageContentType pageType,
      {VoidCallback? onClick, required bool isDesktop}) {
    return InkWell(
      onTap: () {
        if (onClick != null) {
          onClick();
        } else {
          Get.rootDelegate.toNamed("/${pageType.name}");
        }
      },
      //todo add hover effect
      onHover: (value) {
        // value ? state?.onHover(menuItem.route) : state?.onHover('not hovering');
      },
      child: ColoredBox(
        color: pageType == widget.currentPageType
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
                AppIcons.getIconForPage(pageType),
                color: pageType == widget.currentPageType && Theme.of(context).brightness == Brightness.light
                    ? AppColors.darkRose
                    : AppColors.lightRose,
              ),
              if (isDesktop) const SizedBox(width: 20),
              if (isDesktop)
                Flexible(
                  child: Text(
                    pageType.getPageTitle(context),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: pageType == widget.currentPageType && Theme.of(context).brightness == Brightness.light
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
