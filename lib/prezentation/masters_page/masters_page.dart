import 'dart:async';

import 'package:bf_network_module/bf_network_module.dart';
import 'package:bf_web_admin/injection_container_web.dart';
import 'package:bf_web_admin/prezentation/masters_page/master_info_view.dart';
import 'package:bf_web_admin/prezentation/masters_page/masters_bloc.dart';
import 'package:bf_web_admin/prezentation/widgets/base_items_selector.dart';
import 'package:bf_web_admin/prezentation/widgets/custom_app_bar.dart';
import 'package:bf_web_admin/prezentation/widgets/flex_list_widget.dart';
import 'package:bf_web_admin/prezentation/widgets/info_container.dart';
import 'package:bf_web_admin/prezentation/widgets/search_pannel.dart';
import 'package:bf_web_admin/prezentation/widgets/table_widget.dart';
import 'package:bf_web_admin/utils/alert_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MastersPage extends StatefulWidget {
  final Salon? salon;

  const MastersPage({Key? key, this.salon}) : super(key: key);

  @override
  State<MastersPage> createState() => _MastersPageState();
}

class _MastersPageState extends State<MastersPage> {
  late String _currentSalonId;

  List<Service> _servicesList = [];

  late MastersBloc _mastersBloc;

  Timer? _searchTimer;
  final ValueNotifier<Widget?> _showInfoNotifier = ValueNotifier<Widget?>(null);

  @override
  void initState() {
    super.initState();

    LocalStorage localStorage = getItWeb<LocalStorage>();
    _currentSalonId = localStorage.getSalonId();
    // _servicesList = List<Service>.from(localStorage.getServicesList() as List<dynamic>);

    _mastersBloc = getItWeb<MastersBloc>();
    _mastersBloc.getMasters(_currentSalonId, null);

    _mastersBloc.errorMessage.listen((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(error),
      ));
    });

    _mastersBloc.masterAdded.listen((isSuccess) {
      _showInfoNotifier.value = null;
    });
    _mastersBloc.masterUpdated.listen((isSuccess) {
      _showInfoNotifier.value = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InfoContainer(
      onPressedAddButton: () {
        _showInfoView(InfoAction.add, null, null);
      },
      showInfoNotifier: _showInfoNotifier,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomAppBar(title: AppLocalizations.of(context)!.masters),
          FlexListWidget(children: [
            Flexible(
                child: BaseItemsSelector(
              items: _servicesList,
              onSelectedItem: (item) {
                _mastersBloc.getMasters(_currentSalonId, item?.id);
              },
            )),
            SearchPanel(
              hintText: AppLocalizations.of(context)!.searchMaster,
              onSearch: (text) {
                _searchTimer = Timer(const Duration(milliseconds: 600), () {
                  _mastersBloc.searchMasters(text);
                });
              },
            ),
          ]),
          const SizedBox(height: 20),
          Flexible(
            fit: FlexFit.tight,
            child: _buildMastersTable(),
          ),
          const SizedBox(height: 20),
          // PaginationCounter(),
        ],
      ),
    );
  }

  Widget _buildMastersTable() {
    return StreamBuilder<List<Master>>(
        stream: _mastersBloc.mastersLoaded,
        builder: (context, snapshot) {
          return TableWidget(
            columnTitles: [
              AppLocalizations.of(context)!.masterName,
              AppLocalizations.of(context)!.phoneNumber,
              AppLocalizations.of(context)!.services,
              AppLocalizations.of(context)!.status,
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
              AlertBuilder().showAlertForDelete(context, AppLocalizations.of(context)!.master1, (item as Master).name,
                  () {
                _mastersBloc.removeMaster(item.id, index);
              });
            },
          );
        });
  }

  void _showInfoView(InfoAction infoAction, BaseEntity? item, int? index) {
    // List<Service>? servicesList = List<Service>.from(getItWeb<LocalStorage>().getServicesList() as List<dynamic>);

    _showInfoNotifier.value = MasterInfoView(
      salonId: _currentSalonId,
      infoAction: infoAction,
      master: item as Master,
      // services: servicesList,
      onClickAction: (master, action) {
        if (action == InfoAction.add) {
          _mastersBloc.addMaster(master);
        } else if (action == InfoAction.edit) {
          _mastersBloc.updateMaster(master, index!);
        } else if (action == InfoAction.delete) {
          AlertBuilder().showAlertForDelete(context, AppLocalizations.of(context)!.master1, master.name, () {
            _mastersBloc.removeMaster(master.id, index!);
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
