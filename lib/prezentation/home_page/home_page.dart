import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salons_adminka/injection_container_web.dart';
import 'package:salons_adminka/prezentation/calendar_page/calendar_widget.dart';
import 'package:salons_adminka/prezentation/calendar_page/orders_bloc.dart';
import 'package:salons_adminka/prezentation/widgets/custom_app_bar.dart';
import 'package:salons_adminka/prezentation/widgets/info_container.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:salons_adminka/utils/app_images.dart';
import 'package:salons_adminka/utils/app_text_style.dart';
import 'package:salons_adminka/utils/app_theme.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HomePage extends StatefulWidget {
  final Salon? salon;

  const HomePage({Key? key, this.salon}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _currentSalonId;
  late String _currentSalonName;
  late OrdersBloc _ordersBloc;

  final ValueNotifier<Widget?> _showInfoNotifier = ValueNotifier<Widget?>(null);

  @override
  void initState() {
    super.initState();

    LocalStorage localStorage = getItWeb<LocalStorage>();
    _currentSalonId = localStorage.getSalonId() ?? "";
    _currentSalonName = (localStorage.getSalon() as Salon?)?.name ?? "";

    _ordersBloc = getIt<OrdersBloc>();
    _ordersBloc.getOrders(_currentSalonId);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(title: _currentSalonName),
                _buildWelcomeWidget(),
                const SizedBox(height: 15),
                _buildStatsItems(),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.isDark ? AppColors.darkBlue : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: StreamBuilder<List<OrderEntity>>(
                stream: _ordersBloc.ordersLoaded,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  var orders = snapshot.data ?? [];
                  print("orders main page: $orders");

                  return CustomCalendar(
                    orders: orders,
                    isEnabled: false,
                    calendarView: CalendarView.day,
                    onUpdateOrder: (order) {
                      // _ordersBloc.updateOrder(order);
                    },
                    onClickOrder: (order) {
                      // _showInfoView(InfoAction.view, order, null);
                    },
                  );
                }),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeWidget() {
    return Container(
      // constraints: const BoxConstraints(minWidth: double.infinity, minHeight: 130),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppTheme.isDark ? AppColors.darkBlue : Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.blurColor.withOpacity(0.25),
            blurRadius: 2,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
              constraints: const BoxConstraints(minWidth: double.infinity, minHeight: 130),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome",
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.hintColor, fontWeight: FontWeight.w300),
                    maxLines: 8,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Image.asset(
              AppIcons.welcomePlaceholder,
              height: 173,
              width: 285,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsItems() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStatsItem(
            title: "Всего записей на сегодня",
            icon: AppIcons.icCalendar,
            count: 25,
            accentColor: AppColors.darkRose,
            bgColor: AppColors.lightRose,
            onTap: () {}),
        const SizedBox(width: 8),
        _buildStatsItem(
            title: "Новые записи",
            icon: AppIcons.icBall,
            count: 4,
            accentColor: AppColors.darkTurquoise,
            bgColor: AppColors.lightTurquoise,
            onTap: () {}),
        const SizedBox(width: 8),
        _buildStatsItem(
            title: "Наши клиенты",
            icon: AppIcons.icUserWithHeart,
            count: 136,
            accentColor: AppColors.darkPurple,
            bgColor: AppColors.lightPurple,
            onTap: () {}),
      ],
    );
  }

  Widget _buildStatsItem({
    required Color accentColor,
    required Color bgColor,
    required String title,
    required String icon,
    required int count,
    required VoidCallback onTap,
  }) {
    return Flexible(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 144,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:  AppTheme.isDark ? AppColors.darkBlue : bgColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                icon,
                color: AppTheme.isDark ? Colors.white : accentColor,
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.hintText,
                    ),
                  ),
                  Text(
                    count.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.isDark ? Colors.white : accentColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showInfoView(InfoAction infoAction, BaseEntity? item, int? index) {}
}

