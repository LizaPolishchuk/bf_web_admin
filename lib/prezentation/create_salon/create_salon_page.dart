import 'dart:async';

import 'package:bf_network_module/bf_network_module.dart';
import 'package:bf_web_admin/address_search.dart';
import 'package:bf_web_admin/injection_container_web.dart';
import 'package:bf_web_admin/prezentation/create_salon/create_salon_bloc.dart';
import 'package:bf_web_admin/prezentation/profile_page/search_places/places_bloc.dart';
import 'package:bf_web_admin/prezentation/widgets/custom_app_bar.dart';
import 'package:bf_web_admin/prezentation/widgets/rounded_button.dart';
import 'package:bf_web_admin/utils/app_colors.dart';
import 'package:bf_web_admin/utils/app_images.dart';
import 'package:bf_web_admin/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CreateSalonPage extends StatefulWidget {
  const CreateSalonPage({Key? key}) : super(key: key);

  @override
  State<CreateSalonPage> createState() => _CreateSalonPageState();
}

class _CreateSalonPageState extends State<CreateSalonPage> {
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

  late CreateSalonBloc _createSalonBloc;
  late PlacesBloc _placesBloc;
  final List<StreamSubscription> _subscriptions = [];

  final ImagePickerPlugin _picker = ImagePickerPlugin();

  String? adminId;

  final ValueNotifier<PickedFile?> _pickedPhotoNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();

    LocalStorage localStorage = getIt<LocalStorage>();
    adminId = localStorage.getUserId();

    // assert(adminId != null);

    debugPrint("adminId: $adminId");

    _createSalonBloc = getItWeb<CreateSalonBloc>();

    _placesBloc = getItWeb<PlacesBloc>();

    _subscriptions.addAll([
      _createSalonBloc.salonCreated.listen((event) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Salon created success")));
      }),
      _createSalonBloc.errorMessage.listen((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(error),
        ));
      }),
      _placesBloc.placeDetailsLoaded.listen((place) {
        _addressController.text = place.name;
      }),
      _placesBloc.errorMessage.listen((error) {
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
      body: ScreenTypeLayout.builder(
        desktop: (context) => _buildDesktopContent(context),
        tablet: (context) => _buildMobileContent(context),
        mobile: (context) => _buildMobileContent(context),
      ),
    );
  }

  Widget _buildMobileContent(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(title: AppLocalizations.of(context)!.createSalon),
            SizedBox(
              width: 640,
              height: 182,
              child: _buildPhotoWidget(),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: _mobileSalonDetails(context),
              ),
            ),
            Material(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RoundedButton(
                  width: double.infinity,
                  text: AppLocalizations.of(context)!.saveChanges,
                  onPressed: _onClickSave,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _mobileSalonDetails(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _buildSettingsTitle(AppLocalizations.of(context)!.photo),
            const Spacer(),
            IconButton(
              splashRadius: 18,
              onPressed: () async {
                final PickedFile image = await _picker.pickImage(source: ImageSource.gallery);
                _pickedPhotoNotifier.value = image;
              },
              icon: SvgPicture.asset(
                AppTheme.isDark ? AppIcons.icEditCircleBlue : AppIcons.icEditCircle,
              ),
            ),
            // const SizedBox(width: 8),
            IconButton(
              splashRadius: 18,
              onPressed: () {
                setState(() {
                  if (_pickedPhotoNotifier.value != null) {
                    _pickedPhotoNotifier.value = null;
                  }
                });
              },
              icon: SvgPicture.asset(
                AppIcons.icDeleteCircle,
                color: AppTheme.isDark ? AppColors.blue : AppColors.lightRose,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSettingsRow(AppLocalizations.of(context)!.salonName, "", _nameController, _nameFormKey),
        const SizedBox(height: 15),
        _buildSettingsRow(AppLocalizations.of(context)!.description, "", _descriptionController, _descriptionFormKey,
            hint: AppLocalizations.of(context)!.shortSalonDescription),
        const SizedBox(height: 15),
        _buildSettingsRow(AppLocalizations.of(context)!.address, "", _addressController, _addressFormKey),
        const SizedBox(height: 15),
        _buildSettingsRow(AppLocalizations.of(context)!.phoneNumber, "", _phoneController, _phoneFormKey),
        // _buildSettingsRow("График работы", null, _scheduleController, _scheduleFormKey),
      ],
    );
  }

  Widget _buildDesktopContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 42, right: 50, bottom: 35),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(title: AppLocalizations.of(context)!.profileSettings),
                Expanded(
                  child: _buildSalonDetails(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSalonDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 640,
          height: 182,
          child: _buildPhotoWidget(),
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
                      _buildSettingsTitle(AppLocalizations.of(context)!.photo),
                      const Spacer(),
                      IconButton(
                        splashRadius: 18,
                        onPressed: () async {
                          final PickedFile image = await _picker.pickImage(source: ImageSource.gallery);
                          _pickedPhotoNotifier.value = image;
                        },
                        icon: SvgPicture.asset(
                          AppTheme.isDark ? AppIcons.icEditCircleBlue : AppIcons.icEditCircle,
                        ),
                      ),
                      // const SizedBox(width: 8),
                      IconButton(
                        splashRadius: 18,
                        onPressed: () {
                          setState(() {
                            if (_pickedPhotoNotifier.value != null) {
                              _pickedPhotoNotifier.value = null;
                            }
                          });
                        },
                        icon: SvgPicture.asset(
                          AppIcons.icDeleteCircle,
                          color: AppTheme.isDark ? AppColors.blue : AppColors.lightRose,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSettingsRow(AppLocalizations.of(context)!.salonName, "", _nameController, _nameFormKey),
                  const SizedBox(height: 15),
                  _buildSettingsRow(
                      AppLocalizations.of(context)!.description, "", _descriptionController, _descriptionFormKey,
                      hint: AppLocalizations.of(context)!.shortSalonDescription),
                  const SizedBox(height: 15),
                  _buildSettingsRow(AppLocalizations.of(context)!.address, "", _addressController, _addressFormKey),
                  const SizedBox(height: 15),
                  _buildSettingsRow(AppLocalizations.of(context)!.phoneNumber, "", _phoneController, _phoneFormKey),
                ],
              ),
            ),
            const SizedBox(width: 50),
            const Flexible(
              child: Padding(padding: EdgeInsets.only(top: 45), child: null
                  // _buildSettingsRow("График работы", null, _scheduleController, _scheduleFormKey),
                  ),
            ),
          ],
        ),
        const Spacer(),
        const SizedBox(height: 10),
        Center(
          child: RoundedButton(
            text: AppLocalizations.of(context)!.saveChanges,
            onPressed: _onClickSave,
          ),
        ),
      ],
    );
  }

  void _onClickSave() {
    _errorText = "";

    if (_nameFormKey.currentState?.validate() == true &&
        _descriptionFormKey.currentState?.validate() == true &&
        // _addressFormKey.currentState?.validate() == true &&
        _phoneFormKey.currentState?.validate() == true) {
      print("validated");

      Salon salon = Salon(
        id: "",
        name: _nameController.text,
        description: _descriptionController.text,
        address: "test",
        city: "Kyiv",
        country: "Ukraine",
        timezone: "ua",//DateTime.now().timeZoneName,
        phoneNumber: _phoneController.text,
      );

      _createSalonBloc.createSalon(salon, _pickedPhotoNotifier.value);
    }
  }

  Widget _buildPhotoWidget() {
    return ValueListenableBuilder<PickedFile?>(
        valueListenable: _pickedPhotoNotifier,
        builder: (context, pickedFile, child) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              pickedFile?.path ?? "",
              errorBuilder: (context, obj, stackTrace) {
                return Container(
                  color: AppTheme.isDark ? AppColors.blue : AppColors.lightRose,
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Container(
                  color: AppTheme.isDark ? AppColors.blue : AppColors.lightRose,
                );
              },
              fit: BoxFit.cover,
            ),
          );
        });
  }

  Widget _buildSettingsRow(String title, String? text, TextEditingController controller, GlobalKey<FormState> formKey,
      {String? hint}) {
    controller.text = text ?? "";

    // print("isSearchAddressField: $isSearchAddressField");

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
              style: Theme.of(context).textTheme.bodyMedium,
              // textAlignVertical: TextAlignVertical.center,
              readOnly: controller == _addressController || formKey == _scheduleFormKey,
              onTap: () async {
                if (controller == _addressController) {
                  final SuggestionPlace? clickedPlace = await showSearch<SuggestionPlace?>(
                    context: context,
                    delegate: AddressSearch(_placesBloc),
                  );

                  if (clickedPlace != null) {
                    _placesBloc.getPlaceDetails(clickedPlace.placeId);
                    // final placeDetails = await PlaceApiProvider(sessionToken).getPlaceDetailFromId(result.placeId);
                    // setState(() {
                    //   _searchPlaceController.text =
                    //       "place: ${placeDetails.lat}, ${placeDetails.lng}, ${result.description}";
                    // });
                  }
                }
              },
              validator: (text) {
                if (_errorText == null) {
                  return _errorText;
                }
                if ((text == null || text.isEmpty) && formKey != _nameFormKey && formKey != _phoneFormKey) {
                  return null;
                }
                if (text == null || text.isEmpty) {
                  return AppLocalizations.of(context)!.fieldCannotBeEmpty;
                }
                if (text.length < 3) {
                  return AppLocalizations.of(context)!.fieldMustContainMoreThanCharacters;
                }
                if (formKey == _phoneFormKey) {
                  if (!RegExp(r"^[+]?[(]?[0-9]{3}[)]?[-\s.]?[0-9]{3}[-\s.]?[0-9]{4,6}$").hasMatch(text)) {
                    return AppLocalizations.of(context)!.enterPhoneInRightForm;
                  }
                }
                if (formKey == _addressFormKey) {
                  if (!RegExp(r"(?:(?:https?|ftp)://)?[\w/\-?=%.]+\.[\w/\-?=%.]+").hasMatch(text)) {
                    return AppLocalizations.of(context)!.enterGoogleMapLink;
                  }
                }
                return null;
              },
              decoration: InputDecoration(
                counterText: "",
                hintText: hint ?? title,
                fillColor: Colors.white,
              ).applyDefaults(Theme.of(context).inputDecorationTheme),
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
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
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
