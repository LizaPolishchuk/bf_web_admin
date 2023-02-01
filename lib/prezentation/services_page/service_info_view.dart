import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:salons_adminka/prezentation/widgets/colored_circle.dart';
import 'package:salons_adminka/prezentation/widgets/info_container.dart';
import 'package:salons_adminka/prezentation/widgets/rounded_button.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class ServiceInfoView extends StatefulWidget {
  final String salonId;
  final Service? service;
  final InfoAction infoAction;
  final List<Category> categories;
  final Function(Service service, InfoAction action) onClickAction;

  const ServiceInfoView({
    Key? key,
    this.service,
    required this.infoAction,
    required this.categories,
    required this.salonId,
    required this.onClickAction,
  }) : super(key: key);

  @override
  State<ServiceInfoView> createState() => _ServiceInfoViewState();
}

class _ServiceInfoViewState extends State<ServiceInfoView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  final ValueNotifier<bool> _enableButtonNotifier = ValueNotifier<bool>(false);

  late InfoAction _infoAction;
  late Service? _serviceForUpdate;

  Category? _selectedCategory;

  // final _emailFormKey = GlobalKey<FormState>();
  // final _nameFormKey = GlobalKey<FormState>();
  // final _passwordFormKey = GlobalKey<FormState>();
  // final _repeatPasswordFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _infoAction = widget.infoAction;
    _serviceForUpdate = widget.service;

    if (_serviceForUpdate != null) {
      if (_serviceForUpdate!.categoryId != null && widget.categories.isNotEmpty) {
        _selectedCategory = widget.categories.firstWhere((element) => element.id == _serviceForUpdate!.categoryId);
      }
      _nameController.text = _serviceForUpdate!.name;
      _priceController.text = _serviceForUpdate!.price?.toString() ?? "";
      _durationController.text = _serviceForUpdate!.duration?.toString() ?? "";

      _enableButtonNotifier.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
            _infoAction == InfoAction.view
                ? AppLocalizations.of(context)!.view
                : _infoAction == InfoAction.edit
                    ? AppLocalizations.of(context)!.redact
                    : AppLocalizations.of(context)!.addService,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 35),
        _buildTextField(_nameController, AppLocalizations.of(context)!.serviceName),
        const SizedBox(height: 15),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: AppColors.textInputBgGrey,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              hint: Text(
                AppLocalizations.of(context)!.category,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              items: widget.categories
                  .map(
                    (category) => DropdownMenuItem<Category>(
                      value: category,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ColoredCircle(color: (category.color != null) ? Color(category.color!) : Colors.grey),
                          Flexible(
                            child: Text(
                              category.name,
                              style: _selectedCategory == category
                                  ? Theme.of(context).textTheme.bodyMedium
                                  : Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              value: _selectedCategory,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value as Category;
                  _checkIfEnableButton();
                });
              },
              itemHeight: 40,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Flexible(
              child: _buildTextField(_priceController, AppLocalizations.of(context)!.price, isPrice: true),
            ),
            const SizedBox(width: 15),
            Flexible(
              child: _buildTextField(_durationController, AppLocalizations.of(context)!.time, isDuration: true),
            ),
          ],
        ),
        const SizedBox(height: 120),
        if (_infoAction == InfoAction.view)
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
                  AppLocalizations.of(context)!.edit,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.hintColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.onClickAction(_serviceForUpdate!, InfoAction.delete);
                },
                child: Text(
                  AppLocalizations.of(context)!.delete,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.red,
                  ),
                ),
              ),
            ],
          ),
        if (_infoAction != InfoAction.view)
          ValueListenableBuilder<bool>(
            valueListenable: _enableButtonNotifier,
            builder: (context, value, child) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: RoundedButton(
                  text: AppLocalizations.of(context)!.save,
                  isEnabled: value,
                  onPressed: () {
                    Service serviceToUpdate;
                    if (_infoAction == InfoAction.add) {
                      serviceToUpdate = Service(
                          "id",
                          _nameController.text,
                          "",
                          double.tryParse(_priceController.text),
                          widget.salonId,
                          _selectedCategory?.id,
                          _selectedCategory?.name,
                          _selectedCategory?.color,
                          int.tryParse(_durationController.text));

                      widget.onClickAction(serviceToUpdate, _infoAction);
                    } else {
                      if (_serviceForUpdate != null) {
                        serviceToUpdate = _serviceForUpdate!.copy(
                            name: _nameController.text,
                            categoryId: _selectedCategory?.id,
                            categoryColor: _selectedCategory?.color,
                            categoryName: _selectedCategory?.name,
                            price: double.tryParse(_priceController.text),
                            duration: int.tryParse(_durationController.text));

                        widget.onClickAction(serviceToUpdate, _infoAction);
                      }
                    }
                  },
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool isPrice = false, bool isDuration = false}) {
    return TextField(
      controller: controller,
      onChanged: (text) {
        _checkIfEnableButton();
      },
      maxLines: 1,
      maxLength: isPrice || isDuration ? 5 : null,
      enabled: _infoAction != InfoAction.view,
      style: Theme.of(context).textTheme.bodyMedium,
      inputFormatters: [
        if (isPrice) FilteringTextInputFormatter.digitsOnly,
        if (isDuration) FilteringTextInputFormatter.digitsOnly,
        //TimeTextInputFormatter(),
      ],
      decoration: InputDecoration(
        counterText: "",
        hintText: hint,
        suffixText: isPrice ? AppLocalizations.of(context)!.uah : null,
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  void _checkIfEnableButton() {
    if (_nameController.text.length > 2 &&
        _selectedCategory != null &&
        _priceController.text.isNotEmpty &&
        _durationController.text.isNotEmpty) {
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
