import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:plan_it/colors.dart';
import 'package:plan_it/constants.dart';
import 'package:plan_it/ui/utils/size_config.dart';
import 'package:plan_it/viewmodels/home_viewmodel.dart';

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
        leftChevronVisible: false,
        rightChevronVisible: false,
        headerPadding: const EdgeInsets.only(bottom: 10),
        centerHeaderTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: FONT_NAME,
          color: Colors.black,
          fontSize: 3 * SizeConfig.heightMultiplier,
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
          fontSize: 4.5 * SizeConfig.widthMultiplier,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
        weekendStyle: TextStyle(
          fontSize: 4.5 * SizeConfig.widthMultiplier,
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
            padding: EdgeInsets.symmetric(
                horizontal: 1.25 * SizeConfig.widthMultiplier),
            child: Material(
              elevation: 0.75 * SizeConfig.widthMultiplier,
              borderRadius:
                  BorderRadius.circular(1.25 * SizeConfig.widthMultiplier),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: LIGHT_GREY,
                  borderRadius:
                      BorderRadius.circular(1.25 * SizeConfig.widthMultiplier),
                ),
                child: Text(
                  date.day.toString(),
                  style: TextStyle(
                    fontSize: 6 * SizeConfig.widthMultiplier,
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
                fontSize: 4.5 * SizeConfig.widthMultiplier,
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
                fontSize: 4.5 * SizeConfig.widthMultiplier,
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
