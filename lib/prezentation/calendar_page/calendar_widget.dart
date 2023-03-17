import 'package:bf_web_admin/utils/app_colors.dart';
import 'package:bf_web_admin/utils/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CustomCalendar extends StatefulWidget {
  final List<AppointmentEntity> appointments;
  final Function(AppointmentEntity) onClickAppointment;
  final Function(String appointmentId, int startTime)? onChangeAppointmentStartTime;
  final CalendarView calendarView;
  final bool isEnabled;

  const CustomCalendar({
    Key? key,
    required this.onClickAppointment,
    this.onChangeAppointmentStartTime,
    required this.appointments,
    this.calendarView = CalendarView.week,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: widget.calendarView,
      firstDayOfWeek: 1,
      initialDisplayDate: DateTime.now().subtract(const Duration(minutes: 10)),
      appointmentBuilder: (context, details) {
        return _buildOrderSection(details);
      },
      cellEndPadding: 0,
      allowDragAndDrop: widget.isEnabled,
      // onAppointmentResizeEnd: (appointmentResizeEndDetails) {
      //   debugPrint("onAppointmentResizeEnd: ${appointmentResizeEndDetails.startTime}");
      //
      //   if (appointmentResizeEndDetails.startTime != null &&
      //       appointmentResizeEndDetails.endTime != null &&
      //       appointmentResizeEndDetails.appointment is OrderEntity) {
      //     var orderToUpdate = appointmentResizeEndDetails.appointment as OrderEntity;
      //
      //     var newDuration =
      //         appointmentResizeEndDetails.endTime!.difference(appointmentResizeEndDetails.startTime!).inMinutes;
      //
      //     print("newDuration: $newDuration");
      //     // orderToUpdate.durationInMin = newDuration;
      //     // widget.onUpdateOrder(orderToUpdate);
      //   }
      // },
      onDragEnd: (appointmentDragEndDetails) {
        debugPrint("appointmentDragEndDetails: ${appointmentDragEndDetails.droppingTime}");

        if (appointmentDragEndDetails.droppingTime != null &&
            appointmentDragEndDetails.appointment is AppointmentEntity) {
          widget.onChangeAppointmentStartTime?.call(
            (appointmentDragEndDetails.appointment as AppointmentEntity).id,
            appointmentDragEndDetails.droppingTime!.millisecondsSinceEpoch,
          );
        }
      },
      allowAppointmentResize: false,
      showNavigationArrow: true,
      timeSlotViewSettings: const TimeSlotViewSettings(
          timeInterval: Duration(minutes: 30), timeIntervalHeight: 92, timeFormat: 'HH:mm', timeRulerSize: 70),
      cellBorderColor: AppColors.disabledColor.withOpacity(AppTheme.isDark ? 0.1 : 0.3),
      onTap: (calendarTapDetails) {
        debugPrint("on tap ${calendarTapDetails.appointments?.first}");
      },
      todayHighlightColor: Theme.of(context).colorScheme.primary,
      allowedViews: const <CalendarView>[
        CalendarView.day,
        CalendarView.week,
        // CalendarView.month,
      ],
      dataSource: AppointmentsDataSource(widget.appointments),
      monthViewSettings: const MonthViewSettings(appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
    );
  }

  Widget _buildOrderSection(CalendarAppointmentDetails details) {
    var appointments = details.appointments.toList();
    List<Widget> orderItems = [];

    for (int i = 0; i < appointments.length; i++) {
      if (appointments[i] is AppointmentEntity) {
        orderItems.add(
          Positioned(
            left: i * 10,
            right: 0,
            top: 0,
            bottom: 0,
            child: _buildAppointmentItem(appointments[i]),
          ),
        );
      }
    }

    return Stack(
      children: orderItems,
    );
  }

  Widget _buildAppointmentItem(AppointmentEntity appointment) {
    return InkWell(
      onTap: () async {
        // print("onCLick index: $index");
        if (widget.isEnabled) {
          widget.onClickAppointment(appointment);
        }
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppTheme.isDark
              ? AppColors.textInputBgDarkGrey
              : appointment.serviceColor != null
                  ? Color(appointment.serviceColor!).withOpacity(0.1)
                  : Theme.of(context).colorScheme.primary.withOpacity(0.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Container(
                width: 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: appointment.serviceColor != null
                      ? Color(appointment.serviceColor!)
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                imageUrl: appointment.masterPhoto ?? "",
                imageBuilder: (context, imageProvider) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 6),
                    child: Image(
                      image: imageProvider,
                      width: 30,
                      height: 30,
                    ),
                  );
                },
                fit: BoxFit.scaleDown,
                errorWidget: (context, obj, stackTrace) {
                  return const SizedBox.shrink();
                },
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.serviceName,
                      style: TextStyle(
                          color: appointment.serviceColor != null
                              ? Color(appointment.serviceColor!)
                              : Theme.of(context).colorScheme.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      appointment.clientName ?? AppLocalizations.of(context)!.client,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${AppLocalizations.of(context)!.master}: ${appointment.masterName}",
                      maxLines: 3,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      DateFormat('HH:mm').format(appointment.date),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.hintColor),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

// List<OrderEntity> _getDataSource() {
//   final List<OrderEntity> orders = <OrderEntity>[];
//   final DateTime today = DateTime.now();
//   final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
//   //final DateTime endTime = startTime.add(const Duration(hours: 1));
//   orders.add(OrderEntity(
//       "id1",
//       "clientId",
//       "Liza dsvdsv sfvdfv",
//       "salonId",
//       "salonName",
//       "masterId",
//       "Master name fdvdfv dfvdv",
//       "masterAvatar",
//       "serviceId",
//       "Manikur1 dfvfdvfd dsvfdv",
//       startTime,
//       30,
//       0xffBA83FF,
//       300));
//   orders.add(OrderEntity("id2", "clientId", "Liza", "salonId", "salonName", "masterId", "Master name", "masterAvatar",
//       "serviceId", "Manikur2", DateTime(today.year, today.month, today.day, 10), 30, 0xffBA83FF, 300));
//   orders.add(OrderEntity("id3", "clientId", "Liza", "salonId", "salonName", "masterId", "Master name", "masterAvatar",
//       "serviceId", "Manikur3", DateTime(today.year, today.month, today.day, 11), 60, 0xffBA83FF, 300));
//   return orders;
// }
}

class AppointmentsDataSource extends CalendarDataSource {
  AppointmentsDataSource(List<AppointmentEntity> source) {
    appointments = source;
  }

  @override
  Object? convertAppointmentToObject(Object? customData, Appointment appointment) {
    if (customData is AppointmentEntity) {
      return customData.copy(
        startTime: appointment.startTime.millisecondsSinceEpoch,
        serviceDuration: appointment.endTime.difference(appointment.startTime).inMinutes,
        // ..durationInMin = appointment.endTime.difference(appointment.startTime).inMinutes;
      );
    } else {
      return null;
    }
  }

  @override
  DateTime getStartTime(int index) {
    return _getAppointmentData(index).date;
  }

  @override
  DateTime getEndTime(int index) {
    AppointmentEntity appointment = _getAppointmentData(index);
    return appointment.date.add(
      Duration(minutes: appointment.serviceDuration),
    );
  }

  @override
  String getSubject(int index) {
    return _getAppointmentData(index).serviceName;
  }

  @override
  Color getColor(int index) {
    return _getAppointmentData(index).serviceColor != null
        ? Color(_getAppointmentData(index).serviceColor!)
        : Colors.black45;
  }

  @override
  bool isAllDay(int index) {
    return _getAppointmentData(index).serviceDuration > (60 * 24);
  }

  AppointmentEntity _getAppointmentData(int index) {
    final dynamic appointment = appointments![index];
    late final AppointmentEntity appointmentData;
    if (appointment is AppointmentEntity) {
      appointmentData = appointment;
    }

    return appointmentData;
  }
}
