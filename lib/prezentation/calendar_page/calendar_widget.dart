import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:salons_adminka/utils/app_text_style.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CustomCalendar extends StatefulWidget {
  final List<OrderEntity> orders;
  final Function(OrderEntity) onClickOrder;
  final Function(OrderEntity) onUpdateOrder;
  final CalendarView calendarView;
  final bool isEnabled;

  const CustomCalendar({
    Key? key,
    required this.onClickOrder,
    required this.onUpdateOrder,
    required this.orders,
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

        if (appointmentDragEndDetails.droppingTime != null && appointmentDragEndDetails.appointment is OrderEntity) {
          var orderToUpdate = appointmentDragEndDetails.appointment as OrderEntity;
          orderToUpdate.date = appointmentDragEndDetails.droppingTime!;
          widget.onUpdateOrder(orderToUpdate);
        }
      },
      allowAppointmentResize: false,
      showNavigationArrow: true,
      timeSlotViewSettings: const TimeSlotViewSettings(
          timeInterval: Duration(minutes: 30), timeIntervalHeight: 92, timeFormat: 'HH:mm', timeRulerSize: 70),
      cellBorderColor: AppColors.disabledColor.withOpacity(0.3),
      todayHighlightColor: AppColors.darkRose,
      allowedViews: const <CalendarView>[
        CalendarView.day,
        CalendarView.week,
        // CalendarView.month,
      ],
      dataSource: OrdersDataSource(widget.orders),
      monthViewSettings: const MonthViewSettings(appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
    );
  }

  Widget _buildOrderSection(CalendarAppointmentDetails details) {
    var appointments = details.appointments.toList();
    List<Widget> orderItems = [];

    for (int i = 0; i < appointments.length; i++) {
      if (appointments[i] is OrderEntity) {
        orderItems.add(
          Positioned(
            left: i * 10,
            right: 0,
            top: 0,
            bottom: 0,
            child: _buildOrderItem(appointments[i]),
          ),
        );
      }
    }

    return Stack(
      children: orderItems,
    );
  }

  Widget _buildOrderItem(OrderEntity order) {
    return InkWell(
      onTap: () async {
        // print("onCLick index: $index");
        if (widget.isEnabled) {
          widget.onClickOrder(order);
        }
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: order.categoryColor != null
              ? Color(order.categoryColor!).withOpacity(0.1)
              : AppColors.darkRose.withOpacity(0.5),
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
                  color: order.categoryColor != null ? Color(order.categoryColor!) : AppColors.darkRose,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                imageUrl: order.masterAvatar ?? "",
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
                      order.serviceName,
                      style: TextStyle(
                          color: order.categoryColor != null ? Color(order.categoryColor!) : AppColors.darkRose,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      order.clientName ?? AppLocalizations.of(context)!.client,
                      style: AppTextStyle.bodyText1,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "${AppLocalizations.of(context)!.master}: ${order.masterName}",
                      maxLines: 3,
                      style: AppTextStyle.bodyText1,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      DateFormat('HH:mm').format(order.date),
                      style: AppTextStyle.bodyText1.copyWith(color: AppColors.hintColor),
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

class OrdersDataSource extends CalendarDataSource {
  OrdersDataSource(List<OrderEntity> source) {
    appointments = source;
  }

  @override
  Object? convertAppointmentToObject(Object? customData, Appointment appointment) {
    if (customData is OrderEntity) {
      return customData
        ..date = appointment.startTime
        ..durationInMin = appointment.endTime.difference(appointment.startTime).inMinutes;
    } else {
      return null;
    }
  }

  @override
  DateTime getStartTime(int index) {
    return _getOrderData(index).date;
  }

  @override
  DateTime getEndTime(int index) {
    OrderEntity order = _getOrderData(index);
    return order.date.add(Duration(minutes: order.durationInMin));
  }

  @override
  String getSubject(int index) {
    return _getOrderData(index).serviceName;
  }

  @override
  Color getColor(int index) {
    return _getOrderData(index).categoryColor != null ? Color(_getOrderData(index).categoryColor!) : Colors.black45;
  }

  @override
  bool isAllDay(int index) {
    return _getOrderData(index).durationInMin > (60 * 24);
  }

  OrderEntity _getOrderData(int index) {
    final dynamic order = appointments![index];
    late final OrderEntity orderData;
    if (order is OrderEntity) {
      orderData = order;
    }

    return orderData;
  }
}
