import 'package:bf_network_module/bf_network_module.dart';
import 'package:bf_web_admin/prezentation/widgets/info_container.dart';
import 'package:bf_web_admin/prezentation/widgets/rounded_button.dart';
import 'package:bf_web_admin/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum MasterStatus { active, onHoliday, isIll }

class MasterInfoView extends StatefulWidget {
  final String salonId;
  final Master? master;
  final InfoAction infoAction;

  // final List<Service> services;
  final Function(Master master, InfoAction action) onClickAction;

  const MasterInfoView({
    Key? key,
    this.master,
    required this.infoAction,
    // required this.services,
    required this.salonId,
    required this.onClickAction,
  }) : super(key: key);

  @override
  State<MasterInfoView> createState() => _MasterInfoViewState();
}

class _MasterInfoViewState extends State<MasterInfoView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final ValueNotifier<bool> _enableButtonNotifier = ValueNotifier<bool>(false);

  late InfoAction _infoAction;
  late Master? _masterForUpdate;

  List<Service> _selectedServices = [];
  Service? _selectedService;

  //todo add logic for master status
  MasterStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();

    _infoAction = widget.infoAction;
    _masterForUpdate = widget.master;

    if (_masterForUpdate != null) {
      _selectedServices = _masterForUpdate!.services ?? [];
      // _selectedService = _selectedServices.isNotEmpty
      //     ? widget.services.isNotEmpty
      //         ? widget.services.first
      //         : null
      //     : null;
      _nameController.text = _masterForUpdate!.name;
      _phoneController.text = _masterForUpdate!.phoneNumber ?? "";

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
                    : AppLocalizations.of(context)!.addMaster,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 35),
        _buildTextField(_nameController, AppLocalizations.of(context)!.masterName),
        const SizedBox(height: 15),
        _buildTextField(_phoneController, AppLocalizations.of(context)!.phoneNumber),
        const SizedBox(height: 15),
        _buildServicesSelector(),
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
                  widget.onClickAction(_masterForUpdate!, InfoAction.delete);
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
                    //TODO add logic for create and update master
                    // Master masterToUpdate;
                    // if (_infoAction == InfoAction.add) {
                    //   masterToUpdate = Master(
                    //     firstname: _nameController.text,
                    //     lastname: _nameController.text,
                    //     locale: "UA",
                    //     gender: "male",
                    //     startWorkTime: startWorkTime,
                    //     endWorkTime: endWorkTime,
                    //     phoneNumber: phoneNumber,
                    //
                    //   );
                    //
                    //   widget.onClickAction(masterToUpdate, _infoAction);
                    // } else {
                    //   if (_masterForUpdate != null) {
                    //     masterToUpdate = _masterForUpdate!.copy(
                    //       name: _nameController.text,
                    //       phoneNumber: _phoneController.text,
                    //       providedServices: _selectedServices,
                    //     );
                    //
                    //     widget.onClickAction(masterToUpdate, _infoAction);
                    //   }
                    // }
                  },
                ),
              );
            },
          ),
      ],
    );
  }

  //TODO add ability to select services
  Widget _buildServicesSelector() {
    return SizedBox.shrink();

    //   Container(
    //   width: double.infinity,
    //   padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(25),
    //     color: AppColors.textInputBgGrey,
    //   ),
    //   child: DropdownButtonHideUnderline(
    //     child: DropdownButton2(
    //       isExpanded: true,
    //       hint: Align(
    //         alignment: Alignment.centerLeft,
    //         child: Text(
    //           AppLocalizations.of(context)!.service,
    //           style: Theme.of(context).textTheme.displaySmall,
    //         ),
    //       ),
    //       items: widget.services.map((service) {
    //         return DropdownMenuItem<Service>(
    //           value: service,
    //           //disable default onTap to avoid closing menu when selecting an item
    //           enabled: false,
    //           child: StatefulBuilder(
    //             builder: (context, menuSetState) {
    //               final isSelected = _selectedServices.contains(service);
    //               return InkWell(
    //                 onTap: () {
    //                   isSelected ? _selectedServices.remove(service) : _selectedServices.add(service);
    //
    //                   _selectedService = service;
    //                   //This rebuilds the StatefulWidget to update the button's text
    //                   setState(() {});
    //                   //This rebuilds the dropdownMenu Widget to update the check mark
    //                   menuSetState(() {});
    //
    //                   _checkIfEnableButton();
    //                 },
    //                 child: Row(
    //                   children: [
    //                     isSelected ? const Icon(Icons.check_box_outlined) : const Icon(Icons.check_box_outline_blank),
    //                     const SizedBox(width: 16),
    //                     Text(
    //                       service.name,
    //                       style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 16),
    //                     ),
    //                   ],
    //                 ),
    //               );
    //             },
    //           ),
    //         );
    //       }).toList(),
    //       //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
    //       value: _selectedServices.isEmpty ? null : _selectedService,
    //       onChanged: (value) {},
    //       itemHeight: 40,
    //       selectedItemBuilder: (context) {
    //         return widget.services.map(
    //           (item) {
    //             return Align(
    //               alignment: Alignment.centerLeft,
    //               child: Text(
    //                 _selectedServices.map((e) => e.name).toList().join(", "),
    //                 overflow: TextOverflow.ellipsis,
    //                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
    //                 maxLines: 1,
    //               ),
    //             );
    //           },
    //         ).toList();
    //       },
    //     ),
    //   ),
    // );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      onChanged: (text) {
        _checkIfEnableButton();
      },
      maxLines: 1,
      enabled: _infoAction != InfoAction.view,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        counterText: "",
        hintText: hint,
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  void _checkIfEnableButton() {
    if (_nameController.text.length > 2 && _selectedService != null && _phoneController.text.isNotEmpty) {
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
