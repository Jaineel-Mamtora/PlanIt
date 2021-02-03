import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:PlanIt/colors.dart';
import 'package:PlanIt/constants.dart';
import 'package:PlanIt/viewmodels/home_viewmodel.dart';

class CustomTableCalendar extends StatefulWidget {
  final HomeViewModel model;
  final GlobalKey<RefreshIndicatorState> refreshKey;
  final CalendarController controller;

  const CustomTableCalendar({
    Key key,
    this.model,
    this.refreshKey,
    this.controller,
  }) : super(key: key);

  @override
  _CustomTableCalendarState createState() => _CustomTableCalendarState();
}

class _CustomTableCalendarState extends State<CustomTableCalendar> {
  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      initialSelectedDay: widget.model.getSelectedDate(),
      initialCalendarFormat: CalendarFormat.week,
      availableCalendarFormats: {
        CalendarFormat.week: CalendarConstants.WEEK,
      },
      calendarController: widget.controller,
      headerVisible: true,
      headerStyle: HeaderStyle(
        headerPadding: const EdgeInsets.all(0),
        centerHeaderTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: FONT_NAME,
          color: Colors.black,
          fontSize: 18,
        ),
      ),
      calendarStyle: CalendarStyle(
        selectedColor: Theme.of(context).primaryColor,
        todayColor: Theme.of(context).accentColor,
      ),
      startingDayOfWeek: StartingDayOfWeek.monday,
      daysOfWeekStyle: DaysOfWeekStyle(
        dowTextBuilder: (date, locale) => DateFormat.E(locale).format(date)[0],
        weekdayStyle: TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
        weekendStyle: TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
      onDaySelected: (day, events, holidays) {
        setState(() {
          widget.model.setSelectedDate(day);
        });
        widget.refreshKey.currentState.show();
      },
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, events) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: LIGHT_GREY,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  date.day.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          );
        },
        dayBuilder: (context, date, events) {
          return Container(
            alignment: Alignment.center,
            child: Text(
              date.day.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, events) {
          return Container(
            alignment: Alignment.center,
            child: Text(
              date.day.toString(),
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
