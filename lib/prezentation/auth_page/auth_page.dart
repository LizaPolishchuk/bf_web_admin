import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salons_adminka/injection_container_web.dart';
import 'package:salons_adminka/prezentation/auth_page/auth_bloc.dart';
import 'package:salons_adminka/utils/app_images.dart';
import 'package:salons_adminka/utils/app_text_style.dart';

import '../../utils/app_colors.dart';
import '../widgets/rounded_button.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

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

    _authBloc = getItWeb<AuthBloc>();
    _subscriptions.addAll([
      _authBloc.errorMessage.listen((event) {
        String error = event;
        if (event == "user_not_found") {
          error =
              "Такого юзера не существует, пожалуйста, проверьте введенные данные";
        } else if (event == "wrong_password") {
          error = "Не верный пароль";
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(error),
        ));
      }),
    ]);

    _controllersList.addAll([
      _emailController,
      _nameController,
      _passwordController,
      _repeatPasswordController
    ]);
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
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(AppIcons.loginBackground),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "B&F",
                          style: TextStyle(
                              color: AppColors.lightBackground,
                              fontSize: 80,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 22),
                        Text(
                          "Be Beautiful & Be Free",
                          style: TextStyle(
                              color: AppColors.textColor,
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
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 150, vertical: 50),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Вход",
                  style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 36,
                      fontWeight: FontWeight.w700),
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
                      const Text(
                        "Войти с помощью Google",
                        style: AppTextStyle.bodyText,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: _registrationMode
                      ? _buildRegistrationInput()
                      : _buildLoginInput(),
                ),
                _buildLoginButton(),
                const SizedBox(height: 24),
                if (!_registrationMode) _buildForgotPassword(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginInput() {
    return Column(
      children: [
        _buildInputTextField(
            _emailFormKey, "Введите ваш E-mail", "E-mail", _emailController),
        const SizedBox(height: 15),
        _buildInputTextField(
            _passwordFormKey, "Введите пароль", "******", _passwordController,
            isPassword: true),
      ],
    );
  }

  Widget _buildRegistrationInput() {
    return Column(
      children: [
        _buildInputTextField(
            _nameFormKey, "Введите ваше Имя", "Имя", _nameController),
        const SizedBox(height: 15),
        _buildInputTextField(
            _emailFormKey, "Введите ваш E-mail", "E-mail", _emailController),
        const SizedBox(height: 15),
        _buildInputTextField(
            _passwordFormKey, "Введите пароль", "******", _passwordController,
            isPassword: true),
        const SizedBox(height: 15),
        _buildInputTextField(_repeatPasswordFormKey, "Повторите пароль",
            "******", _repeatPasswordController,
            isPassword: true),
      ],
    );
  }

  Widget _buildForgotPassword() {
    return Column(
      children: [
        InkWell(
          child: const Text("Забыли пароль?", style: AppTextStyle.bodyText),
          onTap: () {},
        ),
        const SizedBox(height: 58),
        Row(
          children: [
            const Text("Нет аккаунта?", style: AppTextStyle.bodyText),
            const Spacer(),
            InkWell(
              onTap: () {
                setState(() {
                  _registrationMode = true;
                });
              },
              child: Text(
                "Зарегистрироваться",
                style: AppTextStyle.bodyText.copyWith(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildLoginButton() {
    return RoundedButton(
        text: _registrationMode ? "Регистрация" : "Вход",
        width: 230,
        textColor: AppColors.textColor,
        onPressed: () {
          setState(() {
            _errorText = "";
          });

          if (_registrationMode) {
            if (_emailFormKey.currentState?.validate() == true &&
                _nameFormKey.currentState?.validate() == true &&
                _passwordFormKey.currentState?.validate() == true &&
                _repeatPasswordFormKey.currentState?.validate() == true) {
              _authBloc.register(
                  _emailController.text, _passwordController.text);
            }
          } else if (_emailFormKey.currentState?.validate() == true &&
              _passwordFormKey.currentState?.validate() == true) {
            _authBloc.login(_emailController.text, _passwordController.text);
          }
        });
  }

  Widget _buildInputTextField(GlobalKey formKey, String label, String hint,
      TextEditingController controller,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.bodyText,
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
                return 'Это поле не может быть пустым';
              }
              if (text.length < 3) {
                return 'Поле должно содержать больше, чем 3 символа';
              }
              if (formKey == _emailFormKey) {
                if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(text)) {
                  return "Пожалуйста, введите правильный E-mail";
                }
              }
              if (formKey == _repeatPasswordFormKey) {
                if (text != _passwordController.text) {
                  return "Пароли не совпадают";
                }
              }
              return null;
            },
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: AppTextStyle.bodyText,
            obscureText: ((controller == _passwordController)
                    ? _hidePassword
                    : _hideRepeatedPassword) &&
                isPassword,
            decoration: InputDecoration(
              counterText: "",
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              fillColor: Colors.white.withAlpha(50),
              hintText: hint,
              hintStyle: AppTextStyle.hintText,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              suffixIconConstraints:
                  const BoxConstraints(maxHeight: 24, maxWidth: 30),
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
                        ((controller == _passwordController)
                                ? _hidePassword
                                : _hideRepeatedPassword)
                            ? AppIcons.icEyeClosed
                            : AppIcons.icEye,
                        alignment: Alignment.centerLeft,
                        color: AppColors.textColor,
                        width: 30,
                      ),
                    )
                  : null,
            ),
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
