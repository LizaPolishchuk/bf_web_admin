import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:salons_adminka/navigation/routes.dart';
import 'package:salons_adminka/prezentation/auth_page/auth_bloc.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../utils/app_text_style.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({Key? key}) : super(key: key);

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  int _currentIndex = 0;

  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _buildDrawer(),
          Expanded(
            child: WillPopScope(
              onWillPop: () async {
                print("WillPopScope navigator");
                if (_navigatorKey.currentState?.canPop() == true) {
                  _navigatorKey.currentState?.pop();
                }
                return false;
              },
              child: Navigator(
                key: _navigatorKey,
                onGenerateRoute: onGenerateRoute,
                initialRoute: Routes.home,
              ),
            ),
          )
          // _pages[_currentIndex],
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Container(
      width: 264,
      padding: const EdgeInsets.only(bottom: 12, top: 42),
      decoration: const BoxDecoration(
        color: AppColors.darkRose,
        borderRadius: BorderRadius.only(
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
                          style: TextStyle(
                              color: AppColors.lightRose,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Be Beautiful & Be Free",
                              style: TextStyle(
                                  color: AppColors.lightRose,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "WorkPlace",
                              style: TextStyle(
                                  color: AppColors.lightRose,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 54),
                _buildDrawerItem(0, "Главная", AppIcons.icHome, () {
                  _navigatorKey.currentState?.pushReplacementNamed(Routes.home);
                }),
                _buildDrawerItem(1, "Услуги", AppIcons.icServices, null),
                _buildDrawerItem(2, "Мастера", AppIcons.icMasters, null),
                _buildDrawerItem(3, "Клиенты", AppIcons.icClients, null),
                _buildDrawerItem(
                    4, "Акции/Бонусные карты", AppIcons.icPromos, null),
                _buildDrawerItem(5, "Отзывы", AppIcons.icFeedbacks, null),
                const Spacer(),
                _buildDrawerItem(6, "Проофиль", AppIcons.icProfile, () {
                  print("clicked profile: ${_navigatorKey.currentState}");
                  _navigatorKey.currentState?.pushNamed(Routes.salonDetails);
                }),
                _buildDrawerItem(7, "Поддержка", AppIcons.icSupport, null),
                _buildDrawerItem(8, "Настройки", AppIcons.icSettings, null),
                _buildDrawerItem(9, "Выйти", AppIcons.icLogout, () {
                  getIt<AuthBloc>().logout();
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      int index, String title, String icon, VoidCallback? onClick) {
    return InkWell(
      onTap: () {
        if (onClick != null) {
          onClick();
        }
        setState(() {
          _currentIndex = index;
        });
      },
      //todo add hover effect
      onHover: (value) {
        // value ? state?.onHover(menuItem.route) : state?.onHover('not hovering');
      },
      child: ColoredBox(
        color:
            index == _currentIndex ? AppColors.lightRose : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                icon,
                color: _currentIndex == index
                    ? AppColors.darkRose
                    : AppColors.lightRose,
              ),
              const SizedBox(width: 20),
              Flexible(
                child: Text(
                  title,
                  style: AppTextStyle.buttonText.copyWith(
                      color: _currentIndex == index
                          ? AppColors.darkRose
                          : AppColors.lightRose),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
