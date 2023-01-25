import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:salons_adminka/injection_container_web.dart';
import 'package:salons_adminka/prezentation/auth_page/auth_bloc.dart';
import 'package:salons_adminka/utils/app_images.dart';
import 'package:salons_adminka/utils/app_text_style.dart';
import 'package:salons_adminka/utils/app_theme.dart';

import '../../utils/app_colors.dart';
import '../widgets/rounded_button.dart';
import 'details/auth_detais.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();

  final _emailFormKey = GlobalKey<FormState>();
  final _nameFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _repeatPasswordFormKey = GlobalKey<FormState>();

  bool _hidePassword = true;
  bool _hideRepeatedPassword = true;
  bool _registrationMode = false;

  String? _errorText;
  final List<TextEditingController> _controllersList = [];

  late AuthBloc _authBloc;
  final List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();

    print("isDark: ${AppTheme.isDark},brightness: ${AppTheme.brightness}");

    _authBloc = getItWeb<AuthBloc>();
    _subscriptions.addAll([
      _authBloc.errorMessage.listen((event) {
        String error = event;
        if (event == "user_not_found") {
          error = AppLocalizations.of(context)!.userNotFound;
        } else if (event == "wrong_password") {
          error = AppLocalizations.of(context)!.wrongPassword;
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.errorColorLight,
          content: Text(error),
        ));
      }),
    ]);

    _controllersList.addAll([_emailController, _nameController, _passwordController, _repeatPasswordController]);
    for (var controller in _controllersList) {
      controller.addListener(() {
        if (_errorText != null) {
          _errorText = null;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("isDarkTheme: ${Theme.of(context).brightness}");

    return WillPopScope(
      onWillPop: () async {
        if (_registrationMode) {
          setState(() {
            _registrationMode = !_registrationMode;
          });
        }
        return false;
      },
      child: Scaffold(
          body: ScreenTypeLayout.builder(
        mobile: _mobileView,
        desktop: _desktopView,
        tablet: _mobileView,
      )),
    );
  }

  Widget _mobileView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          mobileBackground(context),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _desktopView(BuildContext context) {
    // final theme = Theme.of(context);
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
    return FractionallySizedBox(
        widthFactor: 0.7,
        heightFactor: 0.9,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Stack(
                alignment: Alignment.topLeft,
                children: [
                  if (_registrationMode)
                    InkWell(
                      onTap: () {
                        setState(() {
                          _registrationMode = false;
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppIcons.icCircleArrowLeft,
                            color: AppColors.hintColor,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            AppLocalizations.of(context)!.back,
                            style: Theme.of(context).textTheme.displaySmall,
                          )
                        ],
                      ),
                    ),
                  Center(
                    child: ResponsiveBuilder(builder: (context, size) {
                      if (!size.isDesktop) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            children: [
                              Text(
                                "B&F",
                                style: TextStyle(
                                    color: AppTheme.isDark
                                        ? Colors.white
                                        : AppColors.textColor,
                                    fontSize: 50,
                                    fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Be Beautiful & Be Free",
                                style: TextStyle(
                                    color: AppTheme.isDark
                                        ? Colors.white
                                        : AppColors.textColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                  )
                ],
              ),
              Center(
                child: Text(
                  _registrationMode ? AppLocalizations.of(context)!.registration : AppLocalizations.of(context)!.login,
                  style: TextStyle(
                      color: AppTheme.isDark ? Colors.white : AppColors.textColor,
                      fontSize: 36,
                      fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: () {
                  _authBloc.loginViaGoogle();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppIcons.icGoogle),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        AppLocalizations.of(context)!.loginViaGoogle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: _registrationMode ? _buildRegistrationInput() : _buildLoginInput(),
              ),
              _buildLoginButton(),
              const SizedBox(height: 24),
              if (!_registrationMode) _buildForgotPassword(),
            ],
          ),
        ));
  }

  Widget _buildLoginInput() {
    return Column(
      children: [
        _buildInputTextField(_emailFormKey, AppLocalizations.of(context)!.enterEmail,
            AppLocalizations.of(context)!.email, _emailController),
        const SizedBox(height: 15),
        _buildInputTextField(
            _passwordFormKey, AppLocalizations.of(context)!.enterPassword, "******", _passwordController,
            isPassword: true),
      ],
    );
  }

  Widget _buildRegistrationInput() {
    return Column(
      children: [
        _buildInputTextField(
            _nameFormKey, AppLocalizations.of(context)!.enterName, AppLocalizations.of(context)!.name, _nameController),
        const SizedBox(height: 15),
        _buildInputTextField(_emailFormKey, AppLocalizations.of(context)!.enterEmail,
            AppLocalizations.of(context)!.email, _emailController),
        const SizedBox(height: 15),
        _buildInputTextField(
            _passwordFormKey, AppLocalizations.of(context)!.enterPassword, "******", _passwordController,
            isPassword: true),
        const SizedBox(height: 15),
        _buildInputTextField(
            _repeatPasswordFormKey, AppLocalizations.of(context)!.repeatPassword, "******", _repeatPasswordController,
            isPassword: true),
      ],
    );
  }

  Widget _buildForgotPassword() {
    return Column(
      children: [
        InkWell(
          child: Text(AppLocalizations.of(context)!.forgotPassword, style: Theme.of(context).textTheme.bodyMedium),
          onTap: () {},
        ),
        const SizedBox(height: 58),
        Row(
          children: [
            Text(AppLocalizations.of(context)!.noAccount,
                style: Theme.of(context).textTheme.bodyMedium, overflow: TextOverflow.ellipsis),
            const Spacer(),
            InkWell(
              onTap: () {
                setState(() {
                  _registrationMode = true;
                });
              },
              child: Text(AppLocalizations.of(context)!.register,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                      ),
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildLoginButton() {
    return RoundedButton(
        text: _registrationMode ? AppLocalizations.of(context)!.registration : AppLocalizations.of(context)!.login,
        // width: 230,
        buttonColor: AppTheme.isDark ? AppColors.textInputBgDarkGrey : AppColors.rose,
        textColor: AppColors.textColor,
        onPressed: () {
          _errorText = "";

          if (_registrationMode) {
            if (_emailFormKey.currentState?.validate() == true &&
                _nameFormKey.currentState?.validate() == true &&
                _passwordFormKey.currentState?.validate() == true &&
                _repeatPasswordFormKey.currentState?.validate() == true) {
              _authBloc.register(_emailController.text, _passwordController.text);
            }
          } else if (_emailFormKey.currentState?.validate() == true &&
              _passwordFormKey.currentState?.validate() == true) {
            _authBloc.login(_emailController.text, _passwordController.text);
          }
        });
  }

  Widget _buildInputTextField(GlobalKey formKey, String label, String hint, TextEditingController controller,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 6),
        Form(
          key: formKey,
          child: TextFormField(
            maxLength: 60,
            maxLines: 1,
            validator: (text) {
              if (_errorText == null) {
                return _errorText;
              }
              if (text == null || text.isEmpty) {
                return AppLocalizations.of(context)!.fieldCannotBeEmpty;
              }
              if (text.length < 3) {
                return AppLocalizations.of(context)!.fieldMustContainMoreThanCharacters;
              }
              if (formKey == _emailFormKey) {
                if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(text)) {
                  return AppLocalizations.of(context)!.pleaseEnterValidEmail;
                }
              }
              if (formKey == _repeatPasswordFormKey) {
                if (text != _passwordController.text) {
                  return AppLocalizations.of(context)!.passwordsDoNotMatch;
                }
              }
              return null;
            },
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: AppTextStyle.bodyMediumText,
            obscureText: ((controller == _passwordController) ? _hidePassword : _hideRepeatedPassword) && isPassword,
            decoration: InputDecoration(
              counterText: "",
              hintText: hint,
              fillColor: AppTheme.isDark ? Colors.white : Colors.white.withAlpha(50),
              suffixIconConstraints: const BoxConstraints(maxHeight: 24, maxWidth: 30),
              suffixIcon: isPassword
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          if (controller == _passwordController) {
                            _hidePassword = !_hidePassword;
                          } else {
                            _hideRepeatedPassword = !_hideRepeatedPassword;
                          }
                        });
                      },
                      child: SvgPicture.asset(
                        ((controller == _passwordController) ? _hidePassword : _hideRepeatedPassword)
                            ? AppIcons.icEyeClosed
                            : AppIcons.icEyePassword,
                        alignment: Alignment.centerLeft,
                        color: AppColors.textColor,
                        width: 30,
                      ),
                    )
                  : null,
            ).applyDefaults(Theme.of(context).inputDecorationTheme),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    for (var element in _controllersList) {
      element.dispose();
    }
    for (var element in _subscriptions) {
      element.cancel();
    }
    super.dispose();
  }
}
