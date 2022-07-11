import 'package:flutter/material.dart';
import 'package:salons_adminka/injection_container_web.dart';
import 'package:salons_adminka/prezentation/clients_page/clients_bloc.dart';
import 'package:salons_adminka/prezentation/widgets/base_items_selector.dart';
import 'package:salons_adminka/prezentation/widgets/custom_app_bar.dart';
import 'package:salons_adminka/prezentation/widgets/info_container.dart';
import 'package:salons_adminka/prezentation/widgets/search_pannel.dart';
import 'package:salons_adminka/prezentation/widgets/table_widget.dart';
import 'package:salons_adminka/utils/alert_builder.dart';
import 'package:salons_adminka/utils/app_images.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class ClientsPage extends StatefulWidget {
  final Salon? salon;

  const ClientsPage({Key? key, this.salon}) : super(key: key);

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  late String _currentSalonId;

  late ClientsBloc _clientsBloc;

  // Timer? _searchTimer;

  @override
  void initState() {
    super.initState();

    _currentSalonId = getItWeb<LocalStorage>().getSalonId();

    _clientsBloc = getItWeb<ClientsBloc>();
    _clientsBloc.getClients(_currentSalonId, null);

    // _servicesBloc.errorMessage.listen((error) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     backgroundColor: Colors.red,
    //     content: Text(error),
    //   ));
    // });
    //
    // _servicesBloc.serviceAdded.listen((isSuccess) {
    //   _showInfoNotifier.value = null;
    // });
    // _servicesBloc.serviceUpdated.listen((isSuccess) {
    //   _showInfoNotifier.value = null;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 42, right: 38),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomAppBar(title: "Клиенты"),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                  child: BaseItemsSelector(
                items: ClientStatus.values
                    .map((status) => BaseEntity(status.index.toString(), status.localizedName(), ""))
                    .toList(),
                onSelectedItem: (item) {
                  // _mastersBloc.getMasters(_currentSalonId, item?.id);
                },
              )),
              const SizedBox(width: 60),
              SearchPanel(
                hintText: "Поиск клиента",
                onSearch: (text) {
                  // _searchTimer = Timer(const Duration(milliseconds: 600), () {
                  //   _servicesBloc.searchServices(text);
                  // });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Flexible(
            fit: FlexFit.tight,
            child: _buildClientsTable(),
          ),
          const SizedBox(height: 20),
          // PaginationCounter(),
        ],
      ),
    );
  }

  Widget _buildClientsTable() {
    return StreamBuilder<List<Client>>(
        stream: _clientsBloc.clientsLoaded,
        builder: (context, snapshot) {
          return TableWidget(
            columnTitles: const ["Имя", "Город", "Статус", "Услуги", "Действия"],
            items: snapshot.data ?? [],
            onClickLook: (item, index) {
              // Routes.clientEdit,
              // arguments: [ClientDetailsData(item as Client, InfoAction.view, index), _clientsBloc]);
            },
            onClickEdit: (item, index) {
              // Get.rootDelegate.toNamed(Routes.clientEdit,
              //     arguments: [ClientDetailsData(item as Client, InfoAction.edit, index), _clientsBloc]);
            },
            onClickDelete: (item, index) {
              AlertBuilder().showAlertForDelete(context, "клиента", item.name, () {
                // _clientsBloc.removeService(item.id, index);
              });
            },
          );
        });
  }

  @override
  void dispose() {
    // _searchTimer?.cancel();

    super.dispose();
  }
}

class ClientDetailsData {
  final Client client;
  final InfoAction infoAction;
  final int index;

  ClientDetailsData(this.client, this.infoAction, this.index);
}

enum ClientStatus { newOne, vip }

extension ClientStatusExtension on ClientStatus {
  String localizedName() {
    switch (this) {
      case ClientStatus.newOne:
        return "Новый";
      case ClientStatus.vip:
        return "VIP";
      default:
        return "";
    }
  }

  String iconPath() {
    switch (this) {
      case ClientStatus.newOne:
        return AppIcons.icNewClient;
      case ClientStatus.vip:
        return AppIcons.icVipDiamond;
      default:
        return "";
    }
  }
}
