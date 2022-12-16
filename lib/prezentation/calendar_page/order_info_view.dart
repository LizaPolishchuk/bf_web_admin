import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:salons_adminka/prezentation/widgets/info_container.dart';
import 'package:salons_adminka/prezentation/widgets/rounded_button.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:salons_adminka/utils/app_text_style.dart';
import 'package:salons_adminka/utils/extentions.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

enum OrderStatus { active, reserved, cancelled }

class OrderInfoView extends StatefulWidget {
  final Salon? salon;
  final OrderEntity? order;
  final InfoAction infoAction;
  final List<Service> services;
  final List<Master> masters;
  final Function(OrderEntity order, InfoAction action) onClickAction;

  const OrderInfoView({
    Key? key,
    this.order,
    required this.infoAction,
    required this.services,
    required this.masters,
    required this.salon,
    required this.onClickAction,
  }) : super(key: key);

  @override
  State<OrderInfoView> createState() => _OrderInfoViewState();
}

class _OrderInfoViewState extends State<OrderInfoView> {
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _clientPhoneController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final ValueNotifier<DateTime?> _orderDateNotifier = ValueNotifier<DateTime?>(null);
  final ValueNotifier<TimeOfDay?> _orderTimeNotifier = ValueNotifier<TimeOfDay?>(null);

  final ValueNotifier<bool> _enableButtonNotifier = ValueNotifier<bool>(false);

  late InfoAction _infoAction;
  late OrderEntity? _orderForUpdate;

  Service? _selectedService;
  Master? _selectedMaster;

  @override
  void initState() {
    super.initState();

    _infoAction = widget.infoAction;
    _orderForUpdate = widget.order;

    if (_orderForUpdate != null) {
      _selectedService = widget.services.isNotEmpty && _orderForUpdate!.serviceId.isNotEmpty
          ? widget.services.firstWhere((element) => element.id == _orderForUpdate!.serviceId)
          : null;
      _selectedMaster = widget.services.isNotEmpty && _orderForUpdate!.masterId.isNotEmpty
          ? widget.masters.firstWhere((element) => element.id == _orderForUpdate!.masterId)
          : null;

      _orderDateNotifier.value = _orderForUpdate!.date;
      _orderTimeNotifier.value = TimeOfDay.fromDateTime(_orderForUpdate!.date);

      _clientNameController.text = _orderForUpdate!.clientName ?? "";
      _priceController.text = _orderForUpdate!.price.toString();
      // _clientPhoneController.text = _orderForUpdate!.cli ?? "";

      _enableButtonNotifier.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
            _infoAction == InfoAction.view
                ? AppLocalizations.of(context)!.view
                : _infoAction == InfoAction.edit
                    ? AppLocalizations.of(context)!.redact
                    : AppLocalizations.of(context)!.addOrder,
            style: AppTextStyle.titleText),
        const SizedBox(height: 35),
        _buildTextField(_clientNameController, AppLocalizations.of(context)!.clientName),
        const SizedBox(height: 15),
        _buildTextField(_clientPhoneController, AppLocalizations.of(context)!.phoneNumber),
        const SizedBox(height: 15),
        _buildTextField(_priceController, AppLocalizations.of(context)!.price.capitalize(), onlyDigits: true),
        const SizedBox(height: 15),
        _buildDropDownSelector(AppLocalizations.of(context)!.service, widget.services, _selectedService),
        const SizedBox(height: 15),
        _buildDropDownSelector(AppLocalizations.of(context)!.master, widget.masters, _selectedMaster),
        const SizedBox(height: 15),
        _buildOrderDate(),
        const SizedBox(height: 15),
        _buildOrderTime(),
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
                  style: AppTextStyle.bodyText.copyWith(
                    color: AppColors.hintColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.onClickAction(_orderForUpdate!, InfoAction.delete);
                },
                child: Text(
                  AppLocalizations.of(context)!.delete,
                  style: AppTextStyle.bodyText.copyWith(
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
                  buttonColor: value ? AppColors.darkRose : AppColors.disabledColor,
                  onPressed: () {
                    var selectedDate = _orderDateNotifier.value!;
                    var selectedTime = _orderTimeNotifier.value!;
                    print("selectedDate: $selectedDate");

                    var newDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour,
                        selectedTime.minute);

                    print("newDate: $newDate");

                    // ..hour = _orderTimeNotifier.value!.hour
                    OrderEntity orderToUpdate;
                    if (_infoAction == InfoAction.add) {
                      orderToUpdate = OrderEntity(
                        "",
                        "",
                        _clientNameController.text,
                        widget.salon?.id ?? "",
                        widget.salon?.name ?? "",
                        _selectedMaster?.id ?? "",
                        _selectedMaster?.name ?? "",
                        _selectedMaster?.avatar ?? "",
                        _selectedService?.id ?? "",
                        _selectedService?.name ?? "",
                        newDate,
                        60,
                        _selectedService?.categoryColor,
                        double.tryParse(_priceController.text) ?? 0,
                      );

                      print("orderToUpdate: $orderToUpdate");

                      widget.onClickAction(orderToUpdate, _infoAction);
                    } else {
                      if (_orderForUpdate != null) {
                        orderToUpdate = _orderForUpdate!.copy(
                          clientName: _clientNameController.text,
                          masterId: _selectedMaster?.id,
                          masterName: _selectedMaster?.name,
                          masterAvatar: _selectedMaster?.avatar,
                          serviceId: _selectedService?.id,
                          serviceName: _selectedService?.name,
                          price: double.tryParse(_priceController.text),
                          durationInMin: 60,
                          date: newDate,
                        );

                        widget.onClickAction(orderToUpdate, _infoAction);
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

  Widget _buildOrderDate() {
    return ValueListenableBuilder<DateTime?>(
        valueListenable: _orderDateNotifier,
        builder: (context, date, child) {
          return InkWell(
            onTap: () {
              if (_infoAction != InfoAction.view) {
                _showOrderDatePicker(context);
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: AppColors.textInputBgGrey,
              ),
              child: Text(
                date != null ? DateFormat('dd-MMM-yyyy').format(date) : AppLocalizations.of(context)!.orderDate,
                style: date != null ? AppTextStyle.bodyText : AppTextStyle.hintText,
              ),
            ),
          );
        });
    // Text(
    //   _orderDateNotifier.value != null
    //       ? "${AppLocalizations.of(context)!.validUntil}: ${DateFormat('dd-MMM-yyyy').format(_orderDateNotifier.value!)}"
    //       : AppLocalizations.of(context)!.noExpirationDate,
    //   style: AppTextStyle.hintText,
    // ),
  }

  Widget _buildOrderTime() {
    return ValueListenableBuilder<TimeOfDay?>(
        valueListenable: _orderTimeNotifier,
        builder: (context, time, child) {
          return InkWell(
            onTap: () {
              if (_infoAction != InfoAction.view) {
                _showOrderTimePicker(context);
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: AppColors.textInputBgGrey,
              ),
              child: Text(
                time != null ? time.format(context) : AppLocalizations.of(context)!.orderTime,
                style: time != null ? AppTextStyle.bodyText : AppTextStyle.hintText,
              ),
            ),
          );
        });
    // Text(
    //   _orderDateNotifier.value != null
    //       ? "${AppLocalizations.of(context)!.validUntil}: ${DateFormat('dd-MMM-yyyy').format(_orderDateNotifier.value!)}"
    //       : AppLocalizations.of(context)!.noExpirationDate,
    //   style: AppTextStyle.hintText,
    // ),
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool onlyDigits = false}) {
    return TextField(
      controller: controller,
      onChanged: (text) {
        _checkIfEnableButton();
      },
      keyboardType: onlyDigits ? TextInputType.number : null,
      inputFormatters: [
        if (onlyDigits) FilteringTextInputFormatter.digitsOnly,
      ],
      maxLines: 1,
      enabled: _infoAction != InfoAction.view,
      style: AppTextStyle.bodyText,
      decoration: InputDecoration(
        hintStyle: AppTextStyle.hintText,
        counterText: "",
        hintText: hint,
      ),
    );
  }

  Widget _buildDropDownSelector(String title, List<BaseEntity> items, BaseEntity? selectedItem) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: AppColors.textInputBgGrey,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          hint: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: AppTextStyle.hintText,
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<BaseEntity>(
              value: item,
              child: Text(
                item.name,
                style: AppTextStyle.hintText.copyWith(fontSize: 16),
              ),
            );
          }).toList(),
          value: selectedItem,
          onChanged: _infoAction != InfoAction.view
              ? (value) {
                  setState(() {
                    if (value is Service) {
                      _selectedService = value;
                    } else if (value is Master) {
                      _selectedMaster = value;
                    }
                  });

                  _checkIfEnableButton();
                }
              : null,
          itemHeight: 40,
          selectedItemBuilder: (context) {
            return items.map(
              (item) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    selectedItem?.name ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.bodyText.copyWith(fontSize: 14),
                    maxLines: 1,
                  ),
                );
              },
            ).toList();
          },
        ),
      ),
    );
  }

  _showOrderDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _orderDateNotifier.value ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != _orderDateNotifier.value) {
      _orderDateNotifier.value = picked;

      _checkIfEnableButton();
    }
  }

  _showOrderTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _orderTimeNotifier.value ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _orderTimeNotifier.value) {
      _orderTimeNotifier.value = picked;

      _checkIfEnableButton();
    }
  }

  void _checkIfEnableButton() {
    if (_clientNameController.text.length > 2 &&
        _priceController.text.length > 1 &&
        _selectedService != null &&
        _selectedMaster != null &&
        _orderDateNotifier.value != null &&
        _orderTimeNotifier.value != null) {
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
