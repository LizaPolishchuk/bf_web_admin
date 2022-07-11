import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salons_adminka/injection_container_web.dart';
import 'package:salons_adminka/prezentation/clients_page/client_details_page.dart';
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
  final ValueNotifier<Widget?> _showInfoNotifier = ValueNotifier<Widget?>(null);

  bool _isVisibleDetails = true;

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
      child: Stack(
        children: [
          if (!_isVisibleDetails)
            Column(
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
          if (_isVisibleDetails)
            ClientDetailsPage(
              client: Client(
                  "",
                  "Anna",
                  "",
                  "https://t4.ftcdn.net/jpg/02/43/87/41/360_F_243874126_YLSIGaDgoNzS91Xdbg1IVpiwXeeZSXdr.jpg",
                  "Kyiv",
                  "vip",
                  "+380679162622",
                  null),
              infoAction: InfoAction.view,
              clientsBloc: _clientsBloc,
            ),
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
              _showInfoView(InfoAction.view, item, index);
            },
            onClickEdit: (item, index) {
              _showInfoView(InfoAction.edit, item, index);
            },
            onClickDelete: (item, index) {
              AlertBuilder().showAlertForDelete(context, "клиента", item.name, () {
                // _clientsBloc.removeService(item.id, index);
                Get.back();
              });
            },
          );
        });
  }

  void _showInfoView(InfoAction infoAction, BaseEntity? item, int? index) {
    // _showInfoNotifier.value = ServiceInfoView(
    //   salonId: _currentSalonId,
    //   infoAction: infoAction,
    //   service: item as Service?,
    //   categories: _clientsList,
    //   onClickAction: (service, action) {
    //     if (action == InfoAction.add) {
    //       _servicesBloc.addService(service);
    //     } else if (action == InfoAction.edit) {
    //       _servicesBloc.updateService(service, index!);
    //     } else if (action == InfoAction.delete) {
    //       AlertBuilder().showAlertForDelete(context, "сервис", service.name, () {
    //         _servicesBloc.removeService(service.id, index!);
    //         _showInfoNotifier.value = null;
    //         Get.back();
    //       });
    //     }
    //   },
    // );
  }

  @override
  void dispose() {
    _showInfoNotifier.dispose();
    // _searchTimer?.cancel();

    super.dispose();
  }
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
