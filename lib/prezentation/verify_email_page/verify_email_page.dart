import 'dart:async';

import 'package:bf_network_module/bf_network_module.dart';
import 'package:bf_web_admin/prezentation/auth_page/auth_bloc.dart';
import 'package:bf_web_admin/prezentation/auth_page/details/auth_detais.dart';
import 'package:bf_web_admin/prezentation/verify_email_page/verify_email_bloc.dart';
import 'package:bf_web_admin/prezentation/widgets/rounded_button.dart';
import 'package:bf_web_admin/utils/app_colors.dart';
import 'package:bf_web_admin/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  late VerifyEmailBloc _verifyEmailBloc;
  final List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();

    _verifyEmailBloc = getIt<VerifyEmailBloc>();
    // _verifyEmailBloc.createAdmin();
    _verifyEmailBloc.sendEmailVerification();

    _subscriptions.addAll([
      _verifyEmailBloc.errorMessage.listen((error) {
        _showError(error);
      }),
      _verifyEmailBloc.errorUserCreation.listen((error) {
        FirebaseAuth.instance.signOut();
        _showError(error);
      }),
    ]);
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.errorColorLight,
        content: Text(error),
        duration: const Duration(seconds: 6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ScreenTypeLayout.builder(
            mobile: _mobileView,
            desktop: _desktopView,
            tablet: _mobileView,
          ),
          // Container(
          //   height: double.infinity,
          //   width: double.infinity,
          //   color: Colors.black.withOpacity(0.5),
          //   child: Center(
          //     child: CircularProgressIndicator(
          //       color: Theme.of(context).primaryColor,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _mobileView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          mobileBackground(context),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _desktopView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          desktopBackground(context),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "B&F",
                      style: TextStyle(color: Colors.white, fontSize: 80, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      "Be Beautiful & Be Free",
                      style: TextStyle(
                          color: AppTheme.isDark ? Colors.white : AppColors.textColor,
                          fontSize: 40,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: _buildContent(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        RoundedButton(
          text: "Logout",
          onPressed: getIt<AuthBloc>().logout,
        )
      ],
    );
  }

  @override
  void dispose() {
    for (var element in _subscriptions) {
      element.cancel();
    }
    _verifyEmailBloc.dispose();

    super.dispose();
  }
}
