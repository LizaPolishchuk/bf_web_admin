import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salons_adminka/injection_container_web.dart';
import 'package:salons_adminka/navigation/routes.dart';
import 'package:salons_adminka/prezentation/widgets/custom_app_bar.dart';
import 'package:salons_adminka/prezentation/widgets/info_container.dart';
import 'package:salons_adminka/utils/app_theme.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class HomePage extends StatefulWidget {
  final Salon? salon;

  const HomePage({Key? key, this.salon}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _currentSalonId;
  late String _currentSalonName;

  final ValueNotifier<Widget?> _showInfoNotifier = ValueNotifier<Widget?>(null);

  @override
  void initState() {
    super.initState();

    LocalStorage localStorage = getItWeb<LocalStorage>();
    _currentSalonId = localStorage.getSalonId() ?? "";
    _currentSalonName = (localStorage.getSalon() as Salon?)?.name ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        Row(
          children: [
            InkWell(
              child: Container(
                color: Theme.of(context).colorScheme.primary,
                width: 100,
                height: 100,
                child: const Text(
                  "Click here to open calendar",
                ),
              ),
              onTap: () {
                Get.rootDelegate.toNamed(Routes.calendar);
              },
            ),
            IconButton(
                onPressed: () async => SwitchThemeModeUseCase(getItWeb()).call(),
                icon: Icon(AppTheme.isDark ? Icons.nightlight : Icons.sunny))
          ],
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(padding: const EdgeInsets.only(left: 42), child: CustomAppBar(title: _currentSalonName));
  }

  void _showInfoView(InfoAction infoAction, BaseEntity? item, int? index) {}
}
