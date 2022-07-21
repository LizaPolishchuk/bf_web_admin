import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salons_adminka/injection_container_web.dart';
import 'package:salons_adminka/prezentation/settings_page/settings_bloc.dart';
import 'package:salons_adminka/prezentation/widgets/custom_app_bar.dart';
import 'package:salons_adminka/prezentation/widgets/rounded_button.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:salons_adminka/utils/app_images.dart';
import 'package:salons_adminka/utils/app_text_style.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _passwordFormKey = GlobalKey<FormState>();

  String? _errorText;

  late SettingsBloc _settingsBloc;
  final List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();

    LocalStorage localStorage = getIt<LocalStorage>();
    String? salonId = localStorage.getSalonId();

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
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomAppBar(title: "Настройки"),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInputTextField("E-mail", "", _emailController, false),
                            const SizedBox(height: 22),
                            _buildInputTextField("Пароль", "", _emailController, false),
                            const SizedBox(height: 42),
                            TextButton(
                              onPressed: () {},
                              child: Row(
                                children: [
                                  const Icon(Icons.delete_outline, color: AppColors.red),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Удалить аккаунт",
                                    style: AppTextStyle.buttonText.copyWith(color: AppColors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 60),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Подписка",
                              style: AppTextStyle.bodyText,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              constraints: const BoxConstraints(minHeight: 128),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 24),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      AppIcons.subscriptionPlaceholder,
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 18),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Ваша платная подписка “Топ-салон”",
                                        style: AppTextStyle.bodyText.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      const Text(
                                        "Дата окончания подписки 12.03.2022",
                                        style: AppTextStyle.hintText,
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          RoundedButton(
                                            height: 40,
                                            text: "Продолжить",
                                            onPressed: () {},
                                          ),
                                          const SizedBox(width: 16),
                                          RoundedButton(
                                            height: 40,
                                            text: "Отменить",
                                            onPressed: () {},
                                            buttonColor: AppColors.disabledColor,
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),
                            const Text(
                              "Синхронизировать данные с YClients",
                              style: AppTextStyle.bodyText,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  height: 61,
                                  width: 182,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(AppIcons.icYclientsLogo),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Container(
                                    height: 61,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffFFCF00),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    alignment: Alignment.center,
                                    child:  Text("Подключить", style: AppTextStyle.buttonText.copyWith(color: AppColors.textColor)),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputTextField(String label, String hint, TextEditingController controller, bool isEnable,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.bodyText,
        ),
        const SizedBox(height: 8),
        TextField(
          maxLines: 1,
          controller: controller,
          style: AppTextStyle.bodyText,
          enabled: isEnable,
          obscureText: isPassword,
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            fillColor: Colors.white,
            hintText: hint,
            hintStyle: AppTextStyle.hintText,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
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
