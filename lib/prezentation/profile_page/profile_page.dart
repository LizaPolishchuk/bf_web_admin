import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:salons_adminka/injection_container_web.dart';
import 'package:salons_adminka/prezentation/profile_page/profile_bloc.dart';
import 'package:salons_adminka/prezentation/widgets/custom_app_bar.dart';
import 'package:salons_adminka/prezentation/widgets/rounded_button.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:salons_adminka/utils/app_images.dart';
import 'package:salons_adminka/utils/app_text_style.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _scheduleController = TextEditingController();

  final _nameFormKey = GlobalKey<FormState>();
  final _descriptionFormKey = GlobalKey<FormState>();
  final _addressFormKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();
  final _scheduleFormKey = GlobalKey<FormState>();

  String? _errorText;
  final List<TextEditingController> _controllersList = [];

  late ProfileBloc _profileBloc;
  final List<StreamSubscription> _subscriptions = [];

  final ImagePickerPlugin _picker = ImagePickerPlugin();
  PickedFile? _pickedPhoto;

  @override
  void initState() {
    super.initState();

    LocalStorage localStorage = getIt<LocalStorage>();
    String? salonId = localStorage.getSalonId();

    print("salonId: $salonId");

    _profileBloc = getItWeb<ProfileBloc>();
    _profileBloc.loadSalon(salonId ?? "");

    _subscriptions.addAll([
      _profileBloc.salonUpdated.listen((event) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Salon updated success")));
      }),
      _profileBloc.errorMessage.listen((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(error),
        ));
      }),
    ]);

    _controllersList
        .addAll([_nameController, _descriptionController, _addressController, _phoneController, _scheduleController]);
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
    return Scaffold(
      body:Padding(
        padding: const EdgeInsets.only(left: 42, right: 50, bottom: 35),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomAppBar(title: "Profile settings"),
                  Expanded(
                    child: StreamBuilder<Salon>(
                      stream: _profileBloc.salonLoaded,
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          return _buildSalonDetails(snapshot.data!);
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSalonDetails(Salon salon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 640,
          height: 182,
          child: _pickedPhoto != null ? _buildPhotoWidget(_pickedPhoto!.path) : _buildPhotoWidget(salon.photo ?? ""),
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildSettingsTitle("Фото"),
                      const Spacer(),
                      IconButton(
                        splashRadius: 18,
                        onPressed: () async {
                          final PickedFile image = await _picker.pickImage(source: ImageSource.gallery);
                          setState(() {
                            _pickedPhoto = image;
                          });
                        },
                        icon: SvgPicture.asset(AppIcons.icEditCircle),
                      ),
                      // const SizedBox(width: 8),
                      IconButton(
                        splashRadius: 18,
                        onPressed: () {
                          setState(() {
                            if (_pickedPhoto != null) {
                              _pickedPhoto = null;
                            } else if (salon.photo != null) {
                              salon.photo = null;
                            }
                          });
                        },
                        icon: SvgPicture.asset(AppIcons.icDeleteCircle),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSettingsRow("Название салона", salon.name, _nameController, _nameFormKey),
                  const SizedBox(height: 15),
                  _buildSettingsRow("Описание", salon.description, _descriptionController, _descriptionFormKey,
                      hint: "Краткое описание салона"),
                  const SizedBox(height: 15),
                  _buildSettingsRow("Адрес", salon.address, _addressController, _addressFormKey),
                  const SizedBox(height: 15),
                  _buildSettingsRow("Номер телефона", salon.phoneNumber, _phoneController, _phoneFormKey),
                ],
              ),
            ),
            const SizedBox(width: 50),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 45),
                child: _buildSettingsRow("График работы", null, _scheduleController, _scheduleFormKey),
              ),
            ),
          ],
        ),
        const Spacer(),
        Center(
          child: RoundedButton(
            text: "Сохранить изменения",
            onPressed: () {
              _errorText = "";

              if (_nameFormKey.currentState?.validate() == true &&
                  _descriptionFormKey.currentState?.validate() == true &&
                  _addressFormKey.currentState?.validate() == true &&
                  _phoneFormKey.currentState?.validate() == true) {
                salon.name = _nameController.text;
                salon.description = _descriptionController.text;
                salon.address = _addressController.text;
                salon.phoneNumber = _phoneController.text;

                _profileBloc.updateSalon(salon, _pickedPhoto);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoWidget(String source) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        source,
        errorBuilder: (context, obj, stackTrace) {
          return Container(
            color: AppColors.lightRose,
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Container(
            color: AppColors.lightRose,
          );
        },
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildSettingsRow(
    String title,
    String? text,
    TextEditingController controller,
    GlobalKey<FormState> formKey, {
    String? hint,
  }) {
    controller.text = text ?? "";

    return Row(
      children: [
        SizedBox(width: 160, child: _buildSettingsTitle(title)),
        const SizedBox(width: 6),
        Expanded(
          child: Form(
            key: formKey,
            child: TextFormField(
              // maxLength: 500,
              maxLines: formKey == _descriptionFormKey ? 3 : 1,
              minLines: formKey == _descriptionFormKey ? 3 : 1,
              controller: controller,
              style: AppTextStyle.bodyText,
              textAlignVertical: TextAlignVertical.center,
              readOnly: formKey == _scheduleFormKey,
              onTap: () {
                print("on tap");
              },
              validator: (text) {
                if (_errorText == null) {
                  return _errorText;
                }
                if ((text == null || text.isEmpty) && formKey != _nameFormKey && formKey != _phoneFormKey) {
                  return null;
                }
                if (text == null || text.isEmpty) {
                  return 'Это поле не может быть пустым';
                }
                if (text.length < 3) {
                  return 'Поле должно содержать больше, чем 3 символа';
                }
                if (formKey == _phoneFormKey) {
                  if (!RegExp(r"^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$").hasMatch(text)) {
                    return "Пожалуйста, введите правильный номер телефона в формате +xx(xxx)xxx..";
                  }
                }
                if (formKey == _addressFormKey) {
                  if (!RegExp(r"(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+").hasMatch(text)) {
                    return "Пожалуйста, введите ссылку Google Maps";
                  }
                }
                return null;
              },
              decoration: InputDecoration(
                counterText: "",
                hintText: hint ?? title,
                hintStyle: AppTextStyle.hintText,
                fillColor: Colors.white,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSettingsTitle(String title) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        maxLines: 1,
        style: AppTextStyle.appBarText.copyWith(fontSize: 18),
      ),
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
