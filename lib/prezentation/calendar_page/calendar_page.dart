import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:salons_adminka/injection_container_web.dart';
import 'package:salons_adminka/prezentation/calendar_page/appointment_info_view.dart';
import 'package:salons_adminka/prezentation/calendar_page/appointments_bloc.dart';
import 'package:salons_adminka/prezentation/calendar_page/calendar_widget.dart';
import 'package:salons_adminka/prezentation/widgets/info_container.dart';
import 'package:salons_adminka/utils/alert_builder.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:salons_adminka/utils/app_theme.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class CalendarPage extends StatefulWidget {
  final Salon? salon;

  const CalendarPage({Key? key, this.salon}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late String _currentSalonId;
  late AppointmentsBloc _ordersBloc;

  final ValueNotifier<Widget?> _showInfoNotifier = ValueNotifier<Widget?>(null);

  @override
  void initState() {
    super.initState();

    LocalStorage localStorage = getItWeb<LocalStorage>();
    _currentSalonId = localStorage.getSalonId() as String;

    _ordersBloc = getIt<AppointmentsBloc>();
    _ordersBloc.getAppointments(_currentSalonId, AppointmentsType.salon);

    _ordersBloc.errorMessage.listen((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(error),
      ));
    });

    _ordersBloc.appointmentAdded.listen((isSuccess) {
      _showInfoNotifier.value = null;
    });
    _ordersBloc.appointmentUpdated.listen((isSuccess) {
      _showInfoNotifier.value = null;
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
                // CustomAppBar(title: _currentSalon?.name ?? ""),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.isDark ? AppColors.darkBlue : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: StreamBuilder<List<AppointmentEntity>>(
                        stream: _ordersBloc.appointmentsLoaded,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          var orders = snapshot.data ?? [];
                          print("orders: $orders");

                          return CustomCalendar(
                            appointments: orders,
                            onChangeAppointmentStartTime: (appointmentId, startTime) {
                              _ordersBloc.changeAppointmentStartTime(appointmentId, startTime);
                            },
                            onClickAppointment: (order) {
                              _showInfoView(InfoAction.view, order, null);
                            },
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showInfoView(InfoAction infoAction, AppointmentEntity? item, int? index) {
    // LocalStorage _localStorage = getItWeb<LocalStorage>();
    // List<Service>? servicesList = List<Service>.from(_localStorage.getServicesList() as List<dynamic>);
    // List<Master>? mastersList = List<Master>.from(_localStorage.getMastersList() as List<dynamic>);

    _showInfoNotifier.value = AppointmentInfoView(
      infoAction: infoAction,
      appointment: item,
      // masters: mastersList,
      // services: servicesList,
      onClickAction: (request, action) {
        if (action == InfoAction.add) {
          _ordersBloc.addAppointment(request!);
        } else if (action == InfoAction.edit) {
          _ordersBloc.updateAppointment(item!.id, request!);
        } else if (action == InfoAction.delete) {
          AlertBuilder().showAlertForDelete(
              context,
              AppLocalizations.of(context)!.order1,
              DateFormat('dd-MMM-yyyy').format(item!.date), () {
            _ordersBloc.removeAppointment(item.id);
            _showInfoNotifier.value = null;
          });
        }
      },
    );
  }
}
