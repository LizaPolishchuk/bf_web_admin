import 'package:flutter/material.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({Key? key}) : super(key: key);

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.week,
      firstDayOfWeek: 1,
      appointmentBuilder: (context, details) {
        return _buildOrderItem(details);
      },
      cellEndPadding: 0,
      allowDragAndDrop: true,
      allowAppointmentResize: true,

      // dragAndDropSettings: DragAndDropSettings(
      //
      // ),
      showNavigationArrow: true,
      timeSlotViewSettings: const TimeSlotViewSettings(
          timeInterval: Duration(minutes: 30), timeIntervalHeight: 92, timeFormat: 'HH:mm', timeRulerSize: 70),
      cellBorderColor: AppColors.disabledColor.withOpacity(0.3),
      onTap: (calendarTapDetails) {
        print("on tap ${calendarTapDetails.date}");
      },
      todayHighlightColor: AppColors.darkRose,
      allowedViews: const <CalendarView>[
        CalendarView.day,
        CalendarView.week,
        // CalendarView.month,
      ],
      // monthCellBuilder: (context, details) {
      //   return Container(
      //     decoration: BoxDecoration(
      //       color: Colors.white,
      //       border: Border.all(color: Color(0xffEEF0F0), width: 0.5),
      //     ),
      //   );
      // },
      // scheduleViewMonthHeaderBuilder: (context, details) {
      //   return _buildOrderItem();
      // },
      // resourceViewHeaderBuilder: (context, details) {
      //   return _buildOrderItem();
      // },
      dataSource: MeetingDataSource(_getDataSource()),
      monthViewSettings: const MonthViewSettings(appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
    );
  }

  Widget _buildOrderItem(CalendarAppointmentDetails details) {
    print("details: ${details.appointments}");
    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: Color(0xffBA83FF), width: 2)),
        color: Color(0xffF3EBFD),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.yellow,
            radius: 18,
          )
        ],
      ),
    );
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    final DateTime endTime = startTime.add(const Duration(hours: 1));
    meetings.add(Meeting('Conference', startTime, endTime, const Color(0xFF0F8644), false));
    // meetings.add(Meeting('Conference3', startTime, endTime, const Color(0xFF0F8644), false));
    // meetings.add(Meeting('Conference4', startTime, endTime, const Color(0xFF0F8644), false));
    return meetings;
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  Object? convertAppointmentToObject(Object? customData, Appointment appointment) {
    return Meeting('Conference', appointment.startTime, appointment.endTime, const Color(0xFF0F8644), false);
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
