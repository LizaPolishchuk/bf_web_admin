import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:salons_adminka/injection_container_web.dart';
import 'package:salons_adminka/prezentation/clients_page/additional_client_details_widget.dart';
import 'package:salons_adminka/prezentation/clients_page/clients_bloc.dart';
import 'package:salons_adminka/prezentation/clients_page/clients_page.dart';
import 'package:salons_adminka/prezentation/widgets/custom_app_bar.dart';
import 'package:salons_adminka/prezentation/widgets/info_container.dart';
import 'package:salons_adminka/prezentation/widgets/rounded_button.dart';
import 'package:salons_adminka/utils/alert_builder.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:salons_adminka/utils/app_images.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class ClientDetailsPage extends StatefulWidget {
  final ClientsBloc clientsBloc;
  final ClientDetailsData clientDetailsData;
  final VoidCallback onClickBack;

  const ClientDetailsPage(
      {Key? key, required this.clientsBloc, required this.clientDetailsData, required this.onClickBack})
      : super(key: key);

  @override
  State<ClientDetailsPage> createState() => _ClientDetailsPageState();
}

class _ClientDetailsPageState extends State<ClientDetailsPage> {
  late Client? _client;
  late InfoAction _infoAction;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  late ValueNotifier<bool> _isEditModeNotifier;
  final ValueNotifier<bool> _enableButtonNotifier = ValueNotifier<bool>(false);

  ClientStatus? _selectedStatus;
  final ImagePickerPlugin _picker = ImagePickerPlugin();
  final ValueNotifier<PickedFile?> _pickedPhotoNotifier = ValueNotifier<PickedFile?>(null);

  late String _currentSalonId;

  @override
  void initState() {
    super.initState();

    _currentSalonId = getItWeb<LocalStorage>().getSalonId();

    _client = widget.clientDetailsData.client;
    _infoAction = widget.clientDetailsData.infoAction;

    if (_infoAction == InfoAction.edit || _infoAction == InfoAction.add) {
      _isEditModeNotifier = ValueNotifier<bool>(true);
    } else {
      _isEditModeNotifier = ValueNotifier<bool>(false);
    }

    if (_client != null) {
      _nameController.text = _client!.name;
      _phoneController.text = _client!.phone ?? "";
      if (_client!.photoUrl?.isNotEmpty == true) {
        _pickedPhotoNotifier.value = PickedFile(_client!.photoUrl!);
      }
      if (_client!.name.isNotEmpty) {
        _enableButtonNotifier.value = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 42, right: 38, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomAppBar(title: AppLocalizations.of(context)!.clients),
          InkWell(
            onTap: () {
              widget.onClickBack();
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
          const SizedBox(height: 10),
          Flexible(
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: _buildCard(
                    child: _buildMainInfoContainer(),
                  ),
                ),
                const SizedBox(width: 67),
                Flexible(
                  flex: 2,
                  child: _buildCard(
                    child: AdditionalClientDetails(client: _client),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC4C4C4).withOpacity(0.25),
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildMainInfoContainer() {
    return ValueListenableBuilder<bool>(
        valueListenable: _isEditModeNotifier,
        builder: (context, isEditMode, child) {
          return Column(
            children: [
              Opacity(
                opacity: _infoAction == InfoAction.add ? 0 : 1,
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    splashRadius: 5,
                    icon: Icon(
                      isEditMode ? Icons.close : Icons.edit,
                      size: 16,
                    ),
                    color: Colors.black,
                    onPressed: () {
                      _isEditModeNotifier.value = !isEditMode;
                    },
                  ),
                ),
              ),
              InkWell(
                onTap: isEditMode ? () {} : null,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ValueListenableBuilder<PickedFile?>(
                      valueListenable: _pickedPhotoNotifier,
                      builder: (context, pickedPhoto, child) {
                        return CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(pickedPhoto?.path ?? ""),
                          backgroundColor: AppColors.rose,
                        );
                      },
                    ),
                    if (isEditMode)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: InkWell(
                          onTap: () async {
                            // if (pickedPhoto == null) {
                            var photo = await _picker.pickImage(source: ImageSource.gallery);
                            _pickedPhotoNotifier.value = photo;
                            // }
                            // else {
                            //   _pickedPhotoNotifier.value = null;
                            // }
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            color: _client?.photoUrl?.isNotEmpty == true
                                ? Colors.black.withOpacity(0.5)
                                : AppColors.textInputBgGrey,
                            child: Center(
                              child: SvgPicture.asset(
                                AppIcons.icGallery,
                                color: _client?.photoUrl?.isNotEmpty == true ? Colors.white : AppColors.hintColor,
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: isEditMode || _client == null ? _buildMainDetailsInEditMode() : _buildMainDetails(),
              ),
            ],
          );
        });
  }

  Widget _buildMainDetails() {
    assert(_client != null);

    ClientStatus? clientStatus = _client!.status?.isNotEmpty == true
        ? ClientStatus.values.firstWhereOrNull((e) => e.name == _client!.status)
        : null;

    return Column(
      children: [
        Text(
          _client!.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        if (clientStatus != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(clientStatus.iconPath()),
              const SizedBox(width: 6),
              Text(
                clientStatus.localizedName(context),
                style: Theme.of(context).textTheme.bodyMedium,
              )
            ],
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Container(
            width: double.infinity,
            height: 0.5,
            color: AppColors.hintColor,
          ),
        ),
        _buildMainContactInfo(),
        const Spacer(),
        TextButton(
          onPressed: () {
            AlertBuilder().showAlertForDelete(context, AppLocalizations.of(context)!.client1, _client!.name, () {
              widget.clientsBloc.removeClient(_client!.id, widget.clientDetailsData.index!);
              widget.onClickBack();
            });
          },
          child: Row(
            children: [
              const Icon(
                Icons.delete_outline,
                color: AppColors.hintColor,
              ),
              const SizedBox(width: 4),
              Text(
                AppLocalizations.of(context)!.deleteProfile,
                style: Theme.of(context).textTheme.displaySmall,
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildMainDetailsInEditMode() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          _buildTextField(_nameController, AppLocalizations.of(context)!.name),
          const SizedBox(height: 15),
          _buildTextField(_phoneController, AppLocalizations.of(context)!.mobilePhone, isPhone: true),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: AppColors.textInputBgGrey,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                hint: Text(
                  AppLocalizations.of(context)!.status,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                items: ClientStatus.values
                    .map(
                      (status) => DropdownMenuItem<ClientStatus>(
                        value: status,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(status.iconPath()),
                            const SizedBox(width: 6),
                            Text(
                              status.localizedName(context),
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          ],
                        ),
                      ),
                    )
                    .toList()
                  ..insert(
                    0,
                    DropdownMenuItem<ClientStatus>(
                      value: null,
                      child: Text(
                        AppLocalizations.of(context)!.withoutStatus,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.hintColor),
                      ),
                    ),
                  ),
                value: _selectedStatus,
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value as ClientStatus?;
                    // _checkIfEnableButton();
                  });
                },
                itemHeight: 40,
              ),
            ),
          ),
          const Spacer(),
          ValueListenableBuilder<bool>(
            valueListenable: _enableButtonNotifier,
            builder: (context, value, child) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: RoundedButton(
                  text: AppLocalizations.of(context)!.save,
                  buttonColor: value ? AppColors.darkRose : AppColors.disabledColor,
                  onPressed: () {
                    _infoAction = InfoAction.view;
                    _isEditModeNotifier.value = false;

                    if (widget.clientDetailsData.infoAction == InfoAction.add) {
                      _client = Client("", _nameController.text, "", "", "", _selectedStatus?.name,
                          _phoneController.text, {}, _currentSalonId);

                      widget.clientsBloc.addClient(_client!, _pickedPhotoNotifier.value);
                    } else {
                      if (_client != null) {
                        _client = _client!.copy(
                          name: _nameController.text,
                          phone: _phoneController.text,
                          status: _selectedStatus?.name,
                        );

                        widget.clientsBloc
                            .updateClient(_client!, widget.clientDetailsData.index!, _pickedPhotoNotifier.value);
                      }
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isPhone = false}) {
    return TextField(
      controller: controller,
      onChanged: (text) {
        if (text.isNotEmpty && _enableButtonNotifier.value != true) {
          _enableButtonNotifier.value = true;
        } else if (text.isEmpty && _enableButtonNotifier.value != false) {
          _enableButtonNotifier.value = false;
        }
      },
      maxLines: 1,
      style: Theme.of(context).textTheme.bodyMedium,
      inputFormatters: [
        if (isPhone) FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        counterText: "",
        hintText: hint,
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _buildMainContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_client!.phone?.isNotEmpty == true) _buildContactInfoItem(Icons.phone, "Телефон", _client!.phone!),
      ],
    );
  }

  Widget _buildContactInfoItem(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.lightTurquoise,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.textColor),
            ),
          ],
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();

    _enableButtonNotifier.dispose();
    _isEditModeNotifier.dispose();
  }
}
