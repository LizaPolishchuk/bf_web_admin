import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:salons_adminka/injection_container_web.dart';
import 'package:salons_adminka/prezentation/settings_page/settings_bloc.dart';
import 'package:salons_adminka/prezentation/widgets/custom_app_bar.dart';
import 'package:salons_adminka/prezentation/widgets/rounded_button.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:salons_adminka/utils/app_images.dart';
import 'package:salons_adminka/utils/app_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //final _passwordFormKey = GlobalKey<FormState>();

  //String? _errorText;

  late SettingsBloc _settingsBloc;
  final List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();

    //LocalStorage localStorage = getIt<LocalStorage>();
    //String? salonId = localStorage.getSalonId();

    _settingsBloc = getItWeb<SettingsBloc>();

    _subscriptions.addAll([
      _settingsBloc.passwordChanged.listen((event) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password changed success")));
      }),
      _settingsBloc.errorMessage.listen((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(error),
        ));
      }),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 42, right: 50, bottom: 35),
        child: SingleChildScrollView(
          child: ResponsiveBuilder(
            builder: (context, size) {
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CustomAppBar(title: AppLocalizations.of(context)!.settings),
                size.isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _firstColumnContent(),
                            ),
                          ),
                          const SizedBox(width: 60),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _secondColumnContent(size.isDesktop),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ..._firstColumnContent(),
                          const SizedBox(height: 10),
                          ..._secondColumnContent(size.isDesktop),
                        ],
                      )
              ]);
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _firstColumnContent() {
    return [
      _buildInputTextField(AppLocalizations.of(context)!.email, "", _emailController, false),
      const SizedBox(height: 22),
      _buildInputTextField(AppLocalizations.of(context)!.password, "", _emailController, false),
      const SizedBox(height: 42),
      TextButton(
        onPressed: () {},
        child: Row(
          children: [
            const Icon(Icons.delete_outline, color: AppColors.red),
            const SizedBox(width: 4),
            Text(
              AppLocalizations.of(context)!.deleteAccount,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.red),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _secondColumnContent(bool isDesktop) {
    return [
      Text(
        AppLocalizations.of(context)!.subscription,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 8),
      Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 128),
        decoration: BoxDecoration(
          color: AppTheme.isDark ? AppColors.darkBlue : Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      AppIcons.subscriptionPlaceholder,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Flexible(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.yourCurrentSubscription,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${AppLocalizations.of(context)!.subscriptionEndDate} 12.03.2022",
                        style: Theme.of(context).textTheme.displaySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
            isDesktop
                ? Row(
                    children: _subscriptionsButtons(),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _subscriptionsButtons(),
                  )
          ],
        ),
      ),
      const SizedBox(height: 28),
      Text(
        AppLocalizations.of(context)!.syncDataWithYClients,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 8),
      isDesktop
          ? Row(
              children: _buttons(),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: _buttons(),
            )
    ];
  }

  List<Widget> _subscriptionsButtons() {
    return [
      Flexible(
        child: RoundedButton(
          height: 40,
          text: AppLocalizations.of(context)!.continueTxt,
          onPressed: () {},
        ),
      ),
      const SizedBox(width: 16, height: 5),
      Flexible(
        child: RoundedButton(
          height: 40,
          text: AppLocalizations.of(context)!.cancel,
          onPressed: () {},
          buttonColor: AppColors.disabledColor,
        ),
      ),
    ];
  }

  List<Widget> _buttons() {
    return [
      Flexible(
        flex: 2,
        child: Container(
          height: 61,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: SvgPicture.asset(AppIcons.icYclientsLogo),
          ),
        ),
      ),
      const SizedBox(width: 8, height: 8),
      Flexible(
        flex: 3,
        child: Container(
          height: 61,
          decoration: BoxDecoration(
            color: const Color(0xffFFCF00),
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(AppLocalizations.of(context)!.connect,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.textColor)),
        ),
      ),
    ];
  }

  Widget _buildInputTextField(String label, String hint, TextEditingController controller, bool isEnable,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        TextField(
          maxLines: 1,
          controller: controller,
          style: Theme.of(context).textTheme.bodyMedium,
          enabled: isEnable,
          obscureText: isPassword,
          decoration: InputDecoration(
            counterText: "",
            hintText: hint,
          ).applyDefaults(Theme.of(context).inputDecorationTheme),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    for (var element in _subscriptions) {
      element.cancel();
    }
    super.dispose();
  }
}
