import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:salons_adminka/injection_container_web.dart';
import 'package:salons_adminka/prezentation/calendar_page/calendar_widget.dart';
import 'package:salons_adminka/prezentation/calendar_page/order_info_view.dart';
import 'package:salons_adminka/prezentation/calendar_page/orders_bloc.dart';
import 'package:salons_adminka/prezentation/widgets/custom_app_bar.dart';
import 'package:salons_adminka/prezentation/widgets/info_container.dart';
import 'package:salons_adminka/utils/alert_builder.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class CalendarPage extends StatefulWidget {
  final Salon? salon;

  const CalendarPage({Key? key, this.salon}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Salon _currentSalon;
  late OrdersBloc _ordersBloc;

  final ValueNotifier<Widget?> _showInfoNotifier = ValueNotifier<Widget?>(null);

  @override
  void initState() {
    super.initState();

    LocalStorage localStorage = getItWeb<LocalStorage>();
    var salon = localStorage.getSalon() as Salon?;

    if (salon == null) {
      return;
    } else {
      _currentSalon = salon;
    }

    _ordersBloc = getIt<OrdersBloc>();
    _ordersBloc.getOrders(_currentSalon.id);

    _ordersBloc.ordersLoaded.listen((event) {
      print("ordersLoaded: ${event.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: InfoContainer(
            padding: const EdgeInsets.only(left: 16, right: 16),
            onPressedAddButton: () {
              _showInfoView(InfoAction.add, null, null);
            },
            showInfoNotifier: _showInfoNotifier,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomAppBar(title: _currentSalon?.name ?? ""),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const CustomCalendar(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showInfoView(InfoAction infoAction, BaseEntity? item, int? index) {
    LocalStorage _localStorage = getItWeb<LocalStorage>();
    List<Service>? servicesList = List<Service>.from(_localStorage.getServicesList() as List<dynamic>);
    List<Master>? mastersList = List<Master>.from(_localStorage.getMastersList() as List<dynamic>);

    _showInfoNotifier.value = OrderInfoView(
      salon: _currentSalon,
      infoAction: infoAction,
      order: item as OrderEntity?,
      masters: mastersList,
      services: servicesList,
      onClickAction: (order, action) {
        if (action == InfoAction.add) {
          _ordersBloc.addOrder(order);
        } else if (action == InfoAction.edit) {
          // _mastersBloc.updateMaster(master, index!);
        } else if (action == InfoAction.delete) {
          AlertBuilder()
              .showAlertForDelete(context, AppLocalizations.of(context)!.master1, order.date.toIso8601String(), () {
            // _mastersBloc.removeMaster(master.id, index!);
            _showInfoNotifier.value = null;
          });
        }
      },
    );
  }
}