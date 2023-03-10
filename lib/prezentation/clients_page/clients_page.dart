// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'package:salons_adminka/injection_container_web.dart';
// import 'package:salons_adminka/prezentation/clients_page/client_details_page.dart';
// import 'package:salons_adminka/prezentation/clients_page/clients_bloc.dart';
// import 'package:salons_adminka/prezentation/widgets/base_items_selector.dart';
// import 'package:salons_adminka/prezentation/widgets/custom_app_bar.dart';
// import 'package:salons_adminka/prezentation/widgets/flex_list_widget.dart';
// import 'package:salons_adminka/prezentation/widgets/info_container.dart';
// import 'package:salons_adminka/prezentation/widgets/search_pannel.dart';
// import 'package:salons_adminka/prezentation/widgets/table_widget.dart';
// import 'package:salons_adminka/utils/alert_builder.dart';
// import 'package:salons_adminka/utils/app_colors.dart';
// import 'package:salons_adminka/utils/app_images.dart';
// import 'package:salons_adminka/utils/app_theme.dart';
// import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
//
// class ClientsPage extends StatefulWidget {
//   final Salon? salon;
//
//   const ClientsPage({Key? key, this.salon}) : super(key: key);
//
//   @override
//   State<ClientsPage> createState() => _ClientsPageState();
// }
//
// class _ClientsPageState extends State<ClientsPage> {
//   late String _currentSalonId;
//
//   late ClientsBloc _clientsBloc;
//
//   // Timer? _searchTimer;
//
//   final ValueNotifier<ClientDetailsData?> _showInfoNotifier = ValueNotifier<ClientDetailsData?>(null);
//
//   @override
//   void initState() {
//     super.initState();
//
//     _currentSalonId = getItWeb<LocalStorage>().getSalonId();
//
//     _clientsBloc = getItWeb<ClientsBloc>();
//     _clientsBloc.getClients(_currentSalonId, null);
//
//     // _servicesBloc.errorMessage.listen((error) {
//     //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//     //     backgroundColor: Colors.red,
//     //     content: Text(error),
//     //   ));
//     // });
//     //
//     // _servicesBloc.serviceAdded.listen((isSuccess) {
//     //   _showInfoNotifier.value = null;
//     // });
//     // _servicesBloc.serviceUpdated.listen((isSuccess) {
//     //   _showInfoNotifier.value = null;
//     // });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ResponsiveBuilder(builder: (context, SizingInformation size) {
//       return Scaffold(
//         floatingActionButton: ValueListenableBuilder<ClientDetailsData?>(
//           valueListenable: _showInfoNotifier,
//           builder: (context, clientData, child) {
//             return FloatingActionButton(
//               backgroundColor: clientData == null || AppTheme.isDark
//                   ? Theme.of(context).colorScheme.primary
//                   : AppColors.darkTurquoise,
//               child: Icon(clientData == null ? Icons.add : Icons.close, color: Colors.white),
//               onPressed: () {
//                 if (clientData == null) {
//                   _showInfoNotifier.value = ClientDetailsData(InfoAction.add, null, null);
//                 } else {
//                   _showInfoNotifier.value = null;
//
//                   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//                     _clientsBloc.refreshActualData();
//                   });
//                 }
//               },
//             );
//           },
//         ),
//         body: ValueListenableBuilder<ClientDetailsData?>(
//           valueListenable: _showInfoNotifier,
//           builder: (context, clientData, child) {
//             return clientData != null
//                 ? ClientDetailsPage(
//                     clientsBloc: _clientsBloc,
//                     clientDetailsData: clientData,
//                     onClickBack: () {
//                       _showInfoNotifier.value = null;
//                       WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//                         _clientsBloc.refreshActualData();
//                       });
//                     })
//                 : Padding(
//                     padding: EdgeInsets.only(left: size.isMobile ? 10 : 42, right: size.isMobile ? 10 : 38),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         CustomAppBar(title: AppLocalizations.of(context)!.clients),
//                         FlexListWidget(
//                           children: [
//                             Flexible(
//                                 child: BaseItemsSelector(
//                               items: ClientStatus.values
//                                   .map((status) =>
//                                       BaseEntity(status.index.toString(), status.localizedName(context), ""))
//                                   .toList(),
//                               onSelectedItem: (item) {
//                                 // _mastersBloc.getMasters(_currentSalonId, item?.id);
//                               },
//                             )),
//                             SearchPanel(
//                               hintText: AppLocalizations.of(context)!.searchClient,
//                               onSearch: (text) {
//                                 // _searchTimer = Timer(const Duration(milliseconds: 600), () {
//                                 //   _servicesBloc.searchServices(text);
//                                 // });
//                               },
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//                         Flexible(
//                           fit: FlexFit.tight,
//                           child: _buildClientsTable(),
//                         ),
//                         const SizedBox(height: 20),
//                         // PaginationCounter(),
//                       ],
//                     ),
//                   );
//           },
//         ),
//       );
//     });
//   }
//
//   Widget _buildClientsTable() {
//     return StreamBuilder<List<Client>>(
//         stream: _clientsBloc.clientsLoaded,
//         builder: (context, snapshot) {
//           debugPrint("clientsLoaded : ${snapshot.connectionState}");
//
//           return TableWidget(
//             columnTitles: [
//               AppLocalizations.of(context)!.name,
//               AppLocalizations.of(context)!.city,
//               AppLocalizations.of(context)!.status,
//               AppLocalizations.of(context)!.services,
//               AppLocalizations.of(context)!.actions
//             ],
//             items: snapshot.data ?? [],
//             onClickLook: (item, index) {
//               _showInfoNotifier.value = ClientDetailsData(InfoAction.view, item as Client, index);
//             },
//             onClickEdit: (item, index) {
//               _showInfoNotifier.value = ClientDetailsData(InfoAction.edit, item as Client, index);
//             },
//             onClickDelete: (item, index) {
//               AlertBuilder().showAlertForDelete(context, "клиента", item.name, () {
//                 _clientsBloc.removeClient(item.id, index);
//               });
//             },
//           );
//         });
//   }
//
//   @override
//   void dispose() {
//     // _searchTimer?.cancel();
//
//     super.dispose();
//   }
// }
//
// class ClientDetailsData {
//   final Client? client;
//   final InfoAction infoAction;
//   final int? index;
//
//   ClientDetailsData(this.infoAction, this.client, this.index);
// }
//
// enum ClientStatus { newOne, vip }
//
// extension ClientStatusExtension on ClientStatus {
//   String localizedName(BuildContext context) {
//     switch (this) {
//       case ClientStatus.newOne:
//         return AppLocalizations.of(context)!.newTxt;
//       case ClientStatus.vip:
//         return "VIP";
//       default:
//         return "";
//     }
//   }
//
//   String iconPath() {
//     switch (this) {
//       case ClientStatus.newOne:
//         return AppIcons.icNewClient;
//       case ClientStatus.vip:
//         return AppIcons.icVipDiamond;
//       default:
//         return "";
//     }
//   }
// }
