import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:salons_adminka/injection_container_web.dart';
import 'package:salons_adminka/prezentation/services_page/service_info_view.dart';
import 'package:salons_adminka/prezentation/services_page/services_bloc.dart';
import 'package:salons_adminka/prezentation/widgets/custom_app_bar.dart';
import 'package:salons_adminka/prezentation/widgets/flex_list_widget.dart';
import 'package:salons_adminka/prezentation/widgets/info_container.dart';
import 'package:salons_adminka/prezentation/widgets/search_pannel.dart';
import 'package:salons_adminka/prezentation/widgets/table_widget.dart';
import 'package:salons_adminka/utils/alert_builder.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class ServicesPage extends StatefulWidget {
  final Salon? salon;

  const ServicesPage({Key? key, this.salon}) : super(key: key);

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  late String _currentSalonId;

  List<Category> _categoriesList = [];

  late ServicesBloc _servicesBloc;

  Timer? _searchTimer;
  final ValueNotifier<Widget?> _showInfoNotifier = ValueNotifier<Widget?>(null);

  @override
  void initState() {
    super.initState();

    _currentSalonId = getItWeb<LocalStorage>().getSalonId();

    _servicesBloc = getItWeb<ServicesBloc>();
    _servicesBloc.getServices(_currentSalonId, null);

    _servicesBloc.errorMessage.listen((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(error),
      ));
    });

    _servicesBloc.serviceAdded.listen((isSuccess) {
      _showInfoNotifier.value = null;
    });
    _servicesBloc.serviceUpdated.listen((isSuccess) {
      _showInfoNotifier.value = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("${AppLocalizations.of(context)}");
    return ResponsiveBuilder(
      builder: (BuildContext context, SizingInformation size) => InfoContainer(
        onPressedAddButton: () {
          _showInfoView(InfoAction.add, null, null);
        },
        showInfoNotifier: _showInfoNotifier,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomAppBar(title: AppLocalizations.of(context)!.services),
            FlexListWidget(children: [
              //TODO return categories
              // Flexible(
              //   child: CategoriesSelector(
              //     onSelectedCategory: (category) {
              //       _servicesBloc.getServices(_currentSalonId, category?.id);
              //     },
              //     onCategoriesLoaded: (categories) {
              //       _categoriesList = categories;
              //     },
              //   ),
              // ),
              SearchPanel(
                hintText: AppLocalizations.of(context)!.searchService,
                onSearch: (text) {
                  _searchTimer = Timer(const Duration(milliseconds: 600), () {
                    _servicesBloc.searchServices(text);
                  });
                },
              ),
            ]),
            const SizedBox(height: 20),
            Flexible(
              fit: FlexFit.tight,
              child: _buildServicesTable(size),
            ),
            const SizedBox(height: 20),
            // PaginationCounter(),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesTable(SizingInformation size) {
    return StreamBuilder<List<Service>>(
        stream: _servicesBloc.servicesLoaded,
        builder: (context, snapshot) {
          return TableWidget(
            columnTitles: [
              AppLocalizations.of(context)!.serviceName,
              "${AppLocalizations.of(context)!.price}, ${AppLocalizations.of(context)!.uah}",
              "${AppLocalizations.of(context)!.time}, ${AppLocalizations.of(context)!.min}",
              AppLocalizations.of(context)!.category,
              AppLocalizations.of(context)!.actions
            ],
            items: snapshot.data ?? [],
            onClickLook: (item, index) {
              _showInfoView(InfoAction.view, item, index);
            },
            onClickEdit: (item, index) {
              _showInfoView(InfoAction.edit, item, index);
            },
            onClickDelete: (item, index) {
              AlertBuilder().showAlertForDelete(context, AppLocalizations.of(context)!.service.toLowerCase(), (item as Service).name,
                  () {
                _servicesBloc.removeService(item.id, index);
              });
            },
          );
        });
  }

  void _showInfoView(InfoAction infoAction, BaseEntity? item, int? index) {
    _showInfoNotifier.value = ServiceInfoView(
      salonId: _currentSalonId,
      infoAction: infoAction,
      service: item as Service?,
      categories: _categoriesList,
      onClickAction: (service, action) {
        if (action == InfoAction.add) {
          _servicesBloc.addService(service);
        } else if (action == InfoAction.edit) {
          _servicesBloc.updateService(service, index!);
        } else if (action == InfoAction.delete) {
          AlertBuilder().showAlertForDelete(context, AppLocalizations.of(context)!.service.toLowerCase(), service.name,
              () {
            _servicesBloc.removeService(service.id, index!);
            _showInfoNotifier.value = null;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _showInfoNotifier.dispose();
    _searchTimer?.cancel();

    super.dispose();
  }
}
