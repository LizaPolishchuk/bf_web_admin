import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:intl/intl.dart';
import 'package:salons_adminka/injection_container_web.dart';
import 'package:salons_adminka/prezentation/widgets/info_container.dart';
import 'package:salons_adminka/prezentation/widgets/rounded_button.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:salons_adminka/utils/app_text_style.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class PromoInfoView extends StatefulWidget {
  final String salonId;
  final Promo? promo;
  final InfoAction infoAction;
  final Function(Promo promo, InfoAction action, PickedFile? pickedFile) onClickAction;

  const PromoInfoView({
    Key? key,
    this.promo,
    required this.infoAction,
    required this.salonId,
    required this.onClickAction,
  }) : super(key: key);

  @override
  State<PromoInfoView> createState() => _PromoInfoViewState();
}

class _PromoInfoViewState extends State<PromoInfoView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ValueNotifier<DateTime?> _expiredDateNotifier = ValueNotifier<DateTime?>(null);

  final ValueNotifier<bool> _enableButtonNotifier = ValueNotifier<bool>(false);

  late InfoAction _infoAction;
  late Promo? _promoForUpdate;

  final ImagePickerPlugin _picker = ImagePickerPlugin();
  final ValueNotifier<PickedFile?> _pickedPhotoNotifier = ValueNotifier<PickedFile?>(null);

  late String _currentSalonId;

  @override
  void initState() {
    super.initState();

    LocalStorage localStorage = getItWeb<LocalStorage>();
    _currentSalonId = localStorage.getSalonId();

    _infoAction = widget.infoAction;
    _promoForUpdate = widget.promo;

    if (_promoForUpdate != null) {
      _nameController.text = _promoForUpdate!.name;
      _descriptionController.text = _promoForUpdate!.description ?? "";
      _expiredDateNotifier.value = _promoForUpdate!.expiredDate;
      if (_promoForUpdate!.photoUrl?.isNotEmpty == true) {
        _pickedPhotoNotifier.value = PickedFile(_promoForUpdate!.photoUrl!);
      }

      _enableButtonNotifier.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 110, left: 20, right: 20, bottom: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
              _infoAction == InfoAction.view
                  ? "Просмотр"
                  : _infoAction == InfoAction.edit
                      ? "Редактировать"
                      : "Добавить акцию",
              style: AppTextStyle.titleText),
          const SizedBox(height: 35),
          _infoAction == InfoAction.view ? _buildForViewMode() : _buildForEditMode(),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int lines = 1}) {
    return TextField(
      controller: controller,
      onChanged: (text) {
        _checkIfEnableButton();
      },
      maxLines: lines,
      minLines: lines,
      enabled: _infoAction != InfoAction.view,
      style: AppTextStyle.bodyText,
      decoration: InputDecoration(
        hintStyle: AppTextStyle.hintText,
        counterText: "",
        hintText: hint,
      ),
    );
  }

  Widget _buildForViewMode() {
    return Column(children: [
      Text(
        _nameController.text,
        style: AppTextStyle.bodyText,
      ),
      const SizedBox(height: 15),
      SizedBox(
        width: 180,
        height: 180,
        child: Image.network(
          _pickedPhotoNotifier.value?.path ?? "",
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
      ),
      const SizedBox(height: 15),
      SingleChildScrollView(
        child: Text(
          "${_descriptionController.text}\n\n\n\n\n",
          maxLines: 6,
          textAlign: TextAlign.center,
          style: AppTextStyle.bodyText.copyWith(color: AppColors.hintColor),
        ),
      ),
      const SizedBox(height: 15),
      Text(
        _expiredDateNotifier.value != null
            ? "Действует до: ${DateFormat('dd-MMM-yyyy').format(_expiredDateNotifier.value!)}"
            : "Без срока действия",
        style: AppTextStyle.hintText,
      ),
      const SizedBox(height: 120),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                _infoAction = InfoAction.edit;
              });
            },
            child: Text(
              "Изменить",
              style: AppTextStyle.bodyText.copyWith(
                color: AppColors.hintColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              widget.onClickAction(_promoForUpdate!, InfoAction.delete, null);
            },
            child: Text(
              "Удалить",
              style: AppTextStyle.bodyText.copyWith(
                color: AppColors.red,
              ),
            ),
          ),
        ],
      ),
    ]);
  }

  Widget _buildForEditMode() {
    return Column(
      children: [
        ValueListenableBuilder<PickedFile?>(
          valueListenable: _pickedPhotoNotifier,
          builder: (context, pickedPhoto, child) {
            return Column(
              children: [
                SizedBox(
                  width: 110,
                  height: 110,
                  child: Image.network(
                    pickedPhoto?.path ?? "",
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
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    if (pickedPhoto == null) {
                      var photo = await _picker.pickImage(source: ImageSource.gallery);
                      _pickedPhotoNotifier.value = photo;
                    } else {
                      _pickedPhotoNotifier.value = null;
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (pickedPhoto == null)
                        const Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.attach_file,
                            size: 16,
                            color: AppColors.hintColor,
                          ),
                        ),
                      Text(
                        pickedPhoto == null ? "Прикрепить изображение" : "Удалить изображение",
                        style: AppTextStyle.hintText,
                      ),
                      if (pickedPhoto != null)
                        const Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(
                            Icons.delete_outline,
                            size: 16,
                            color: AppColors.hintColor,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 15),
        _buildTextField(_nameController, "Название"),
        const SizedBox(height: 15),
        _buildTextField(_descriptionController, "Описание", lines: 6),
        const SizedBox(height: 15),
        ValueListenableBuilder<DateTime?>(
            valueListenable: _expiredDateNotifier,
            builder: (context, expiredDate, child) {
              return InkWell(
                onTap: () {
                  _selectExpiredDate(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: AppColors.textInputBgGrey,
                  ),
                  child: Text(
                    expiredDate != null ? DateFormat('dd-MMM-yyyy').format(expiredDate) : "Срок действия",
                    style: expiredDate != null ? AppTextStyle.bodyText : AppTextStyle.hintText,
                  ),
                ),
              );
            }),
        const SizedBox(height: 40),
        ValueListenableBuilder<bool>(
          valueListenable: _enableButtonNotifier,
          builder: (context, value, child) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: RoundedButton(
                text: "Сохранить",
                buttonColor: value ? AppColors.darkRose : AppColors.disabledColor,
                onPressed: () {
                  Promo? promoToUpdate;
                  if (_infoAction == InfoAction.add) {
                    promoToUpdate =
                        Promo("", _nameController.text, _descriptionController.text, "", _expiredDateNotifier.value, _currentSalonId);

                  } else {
                    if (_promoForUpdate != null) {
                      promoToUpdate = _promoForUpdate!.copy(
                        name: _nameController.text,
                        description: _descriptionController.text,
                        expiredDate: _expiredDateNotifier.value,
                        creatorSalon: _currentSalonId,
                      );

                    }

                    assert(promoToUpdate != null);
                    widget.onClickAction(promoToUpdate!, _infoAction, _pickedPhotoNotifier.value);
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }

  _selectExpiredDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _expiredDateNotifier.value ?? DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 1)),
        lastDate: DateTime(2101));
    if (picked != null && picked != _expiredDateNotifier.value) {
      _expiredDateNotifier.value = picked;
    }
  }

  void _checkIfEnableButton() {
    if (_nameController.text.length > 2 && _descriptionController.text.length > 2) {
      _enableButtonNotifier.value = true;
    } else {
      _enableButtonNotifier.value = false;
    }
  }

  @override
  void dispose() {
    _enableButtonNotifier.dispose();
    super.dispose();
  }
}
