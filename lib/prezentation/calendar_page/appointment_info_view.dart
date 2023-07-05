import 'package:bf_network_module/bf_network_module.dart';
import 'package:bf_web_admin/prezentation/widgets/info_container.dart';
import 'package:bf_web_admin/prezentation/widgets/rounded_button.dart';
import 'package:bf_web_admin/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

enum AppointmentStatus { active, reserved, cancelled }

class AppointmentInfoView extends StatefulWidget {
  final AppointmentEntity? appointment;
  final InfoAction infoAction;
  final Function(CreateAppointmentRequest? appointmentRequest, InfoAction action) onClickAction;

  const AppointmentInfoView({
    Key? key,
    this.appointment,
    required this.infoAction,
    required this.onClickAction,
  }) : super(key: key);

  @override
  State<AppointmentInfoView> createState() => _AppointmentInfoViewState();
}

class _AppointmentInfoViewState extends State<AppointmentInfoView> {
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _clientPhoneController = TextEditingController();
  final ValueNotifier<DateTime?> _orderDateNotifier = ValueNotifier<DateTime?>(null);
  final ValueNotifier<TimeOfDay?> _orderTimeNotifier = ValueNotifier<TimeOfDay?>(null);

  final ValueNotifier<bool> _enableButtonNotifier = ValueNotifier<bool>(false);

  late InfoAction _infoAction;
  late AppointmentEntity? _appointmentForUpdate;

  Service? _selectedService;
  Master? _selectedMaster;

  late String _currentUserId;

  @override
  void initState() {
    super.initState();

    _infoAction = widget.infoAction;
    _appointmentForUpdate = widget.appointment;

    _currentUserId = getIt<LocalStorage>().getUserId();

    if (_appointmentForUpdate != null) {
      // _selectedService = widget.services.isNotEmpty && _appointmentForUpdate!.serviceId.isNotEmpty
      //     ? widget.services.firstWhere((element) => element.id == _appointmentForUpdate!.serviceId)
      //     : null;
      // _selectedMaster = widget.services.isNotEmpty && _appointmentForUpdate!.masterId.isNotEmpty
      //     ? widget.masters.firstWhere((element) => element.id == _appointmentForUpdate!.masterId)
      //     : null;

      _orderDateNotifier.value = _appointmentForUpdate!.date;
      _orderTimeNotifier.value = TimeOfDay.fromDateTime(_orderDateNotifier.value!);

      _clientNameController.text = _appointmentForUpdate!.clientName;
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
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 35),
        _buildTextField(_clientNameController, AppLocalizations.of(context)!.clientName),
        const SizedBox(height: 15),
        _buildTextField(_clientPhoneController, AppLocalizations.of(context)!.phoneNumber),
        const SizedBox(height: 15),
        //todo set up database for get services and masters list
        // _buildDropDownSelector(AppLocalizations.of(context)!.service, widget.services, _selectedService),
        // const SizedBox(height: 15),
        // _buildDropDownSelector(AppLocalizations.of(context)!.master, widget.masters, _selectedMaster),
        // const SizedBox(height: 15),
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.hintColor,
                        decoration: TextDecoration.underline,
                      ),
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.onClickAction(null, InfoAction.delete);
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
                  onPressed: () {
                    var selectedDate = _orderDateNotifier.value!;
                    var selectedTime = _orderTimeNotifier.value!;
                    print("selectedDate: $selectedDate");

                    var newDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour,
                        selectedTime.minute);

                    print("newDate: $newDate");

                    CreateAppointmentRequest appointmentRequest = CreateAppointmentRequest(
                      _selectedMaster!.id,
                      _selectedService!.id,
                      _currentUserId,
                      newDate.toUtc().millisecondsSinceEpoch,
                    );

                    widget.onClickAction(appointmentRequest, _infoAction);
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
                style: date != null ? Theme.of(context).textTheme.bodyMedium : Theme.of(context).textTheme.displaySmall,
              ),
            ),
          );
        });
    // Text(
    //   _orderDateNotifier.value != null
    //       ? "${AppLocalizations.of(context)!.validUntil}: ${DateFormat('dd-MMM-yyyy').format(_orderDateNotifier.value!)}"
    //       : AppLocalizations.of(context)!.noExpirationDate,
    //   style: Theme.of(context).textTheme.displaySmall,
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
                style: time != null ? Theme.of(context).textTheme.bodyMedium : Theme.of(context).textTheme.displaySmall,
              ),
            ),
          );
        });
    // Text(
    //   _orderDateNotifier.value != null
    //       ? "${AppLocalizations.of(context)!.validUntil}: ${DateFormat('dd-MMM-yyyy').format(_orderDateNotifier.value!)}"
    //       : AppLocalizations.of(context)!.noExpirationDate,
    //   style: Theme.of(context).textTheme.displaySmall,
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
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          counterText: "",
          hintText: hint,
        ).applyDefaults(Theme.of(context).inputDecorationTheme));
  }

  // Widget _buildDropDownSelector(String title, List<BaseEntity> items, BaseEntity? selectedItem) {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(25),
  //       color: AppColors.textInputBgGrey,
  //     ),
  //     child: DropdownButtonHideUnderline(
  //       child: DropdownButton2(
  //         hint: Align(
  //           alignment: Alignment.centerLeft,
  //           child: Text(
  //             title,
  //             style: Theme.of(context).textTheme.displaySmall,
  //           ),
  //         ),
  //         items: items.map((item) {
  //           return DropdownMenuItem<BaseEntity>(
  //             value: item,
  //             child: Text(
  //               item.name,
  //               style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 16),
  //             ),
  //           );
  //         }).toList(),
  //         value: selectedItem,
  //         onChanged: _infoAction != InfoAction.view
  //             ? (value) {
  //                 setState(() {
  //                   if (value is Service) {
  //                     _selectedService = value;
  //                   } else if (value is Master) {
  //                     _selectedMaster = value;
  //                   }
  //                 });
  //
  //                 _checkIfEnableButton();
  //               }
  //             : null,
  //         itemHeight: 40,
  //         selectedItemBuilder: (context) {
  //           return items.map(
  //             (item) {
  //               return Align(
  //                 alignment: Alignment.centerLeft,
  //                 child: Text(
  //                   selectedItem?.name ?? "",
  //                   overflow: TextOverflow.ellipsis,
  //                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
  //                   maxLines: 1,
  //                 ),
  //               );
  //             },
  //           ).toList();
  //         },
  //       ),
  //     ),
  //   );
  // }

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
        _clientPhoneController.text.length > 1 &&
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
