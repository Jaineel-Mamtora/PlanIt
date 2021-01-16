import 'dart:convert';

import 'package:PlanIt/constants.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:PlanIt/colors.dart';
import 'package:PlanIt/locator.dart';
import 'package:PlanIt/models/task.dart';
import 'package:PlanIt/enums/status.dart';
import 'package:PlanIt/enums/reminder.dart';
import 'package:PlanIt/enums/priority.dart';
import 'package:PlanIt/viewmodels/home_viewmodel.dart';
import 'package:PlanIt/services/database_service.dart';
import 'package:PlanIt/managers/notification_handler.dart';
import 'package:PlanIt/ui/components/custom_text_field.dart';
import 'package:sprintf/sprintf.dart';

class CustomModalBottomSheet extends StatefulWidget {
  final DateTime date;
  final HomeViewModel model;
  final GlobalKey<RefreshIndicatorState> refreshKey;

  CustomModalBottomSheet({
    this.date,
    this.model,
    this.refreshKey,
  });

  @override
  _CustomModalBottomSheetState createState() => _CustomModalBottomSheetState();
}

class _CustomModalBottomSheetState extends State<CustomModalBottomSheet> {
  final _databaseService = locator<DatabaseService>();
  final _notificationHandler = locator<NotificationHandler>();
  int _defaultChoiceIndex;
  TextEditingController _controller;
  DateTime _time = DateTime.now();
  bool _isFromTimeSelected = false;
  bool _isToTimeSelected = false;
  DateTime _selectedFromTime;
  DateTime _selectedToTime;
  String selectedRadioButton;

  List<String> radioButtonsDisabled = [
    'assets/icons/radio_green_disable.svg',
    'assets/icons/radio_yellow_disable.svg',
    'assets/icons/radio_red_disable.svg',
  ];

  List<String> radioButtonsEnabled = [
    'assets/icons/radio_green_enable.svg',
    'assets/icons/radio_yellow_enable.svg',
    'assets/icons/radio_red_enable.svg',
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _defaultChoiceIndex = -1;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _showFromTimePicker({
    BuildContext ctx,
    HomeViewModel model,
  }) async {
    await showTimePicker(
      context: ctx,
      initialTime: TimeOfDay.now(),
    ).then((TimeOfDay pickedFromTime) {
      if (pickedFromTime == null) {
        setState(() {
          _isFromTimeSelected = false;
        });
        return;
      }
      setState(() {
        _time = DateTime(
          model.getSelectedDate().year,
          model.getSelectedDate().month,
          model.getSelectedDate().day,
          pickedFromTime.hour,
          pickedFromTime.minute,
        );
        setState(() {
          _selectedFromTime = _time;
        });
      });
    });
  }

  Future<void> _showToTimePicker({
    BuildContext ctx,
    HomeViewModel model,
  }) async {
    await showTimePicker(
      context: ctx,
      initialTime: TimeOfDay.now(),
    ).then((pickedToTime) {
      if (_selectedFromTime == null && _selectedToTime != null) {
        Fluttertoast.showToast(
          msg: TaskConstants.PLEASE_SELECT_START_TIME,
        );
        setState(() {
          _isToTimeSelected = false;
        });
        return;
      }
      if (pickedToTime == null) {
        setState(() {
          _isToTimeSelected = false;
        });
        return;
      }
      if (pickedToTime.hour < _selectedFromTime.hour ||
          (pickedToTime.hour <= _selectedFromTime.hour &&
              pickedToTime.minute <= _selectedFromTime.minute)) {
        Fluttertoast.showToast(
          msg: TaskConstants.PLEASE_SELECT_VALID_END_TIME,
        );
        setState(() {
          _isToTimeSelected = false;
        });
        return;
      }
      setState(() {
        _time = DateTime(
          model.getSelectedDate().year,
          model.getSelectedDate().month,
          model.getSelectedDate().day,
          pickedToTime.hour,
          pickedToTime.minute,
        );
        setState(() {
          _selectedToTime = _time;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final Size deviceSize = mediaQuery.size;
    return Container(
      height: deviceSize.height * 0.75 + mediaQuery.viewInsets.bottom,
      padding: EdgeInsets.only(
        bottom: mediaQuery.viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(20.0),
          topRight: const Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 10,
            ),
            width: 50,
            child: Divider(
              thickness: 3,
              color: GREY,
            ),
          ),
          Expanded(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowGlow();
                return false;
              },
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: CustomTextField(
                        labelText: TaskConstants.TITLE,
                        controller: _controller,
                        customTextCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: SwitchListTile(
                        dense: true,
                        value: _isFromTimeSelected,
                        contentPadding: const EdgeInsets.all(0),
                        activeColor: Theme.of(context).primaryColor,
                        secondary: SvgPicture.asset(
                          'assets/icons/alarm.svg',
                          color: GREY,
                        ),
                        title: Text(
                          _selectedFromTime == null
                              ? sprintf(TaskConstants.MODAL_SHEET_FROM_TIME, [
                                  DateFormat('hh:mm a').format(DateTime.now())
                                ])
                              : sprintf(TaskConstants.MODAL_SHEET_FROM_TIME, [
                                  DateFormat('hh:mm a')
                                      .format(_selectedFromTime)
                                ]),
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        onChanged: (_) {
                          setState(() {
                            _isFromTimeSelected = !_isFromTimeSelected;
                            if (_isFromTimeSelected == false) {
                              setState(() {
                                _isToTimeSelected = false;
                              });
                            }
                            if (_isFromTimeSelected == true) {
                              _showFromTimePicker(
                                ctx: context,
                                model: widget.model,
                              );
                            }
                          });
                        },
                      ),
                    ),
                    _isFromTimeSelected == true
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: SwitchListTile(
                              dense: true,
                              value: _isToTimeSelected,
                              contentPadding: const EdgeInsets.all(0),
                              activeColor: Theme.of(context).primaryColor,
                              secondary: SvgPicture.asset(
                                'assets/icons/alarm.svg',
                                color: GREY,
                              ),
                              title: Text(
                                _selectedToTime == null
                                    ? sprintf(
                                        TaskConstants.MODAL_SHEET_TO_TIME,
                                        [
                                          DateFormat('hh:mm a')
                                              .format(DateTime.now())
                                        ],
                                      )
                                    : sprintf(
                                        TaskConstants.MODAL_SHEET_TO_TIME,
                                        [
                                          DateFormat('hh:mm a')
                                              .format(_selectedToTime)
                                        ],
                                      ),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              onChanged: (_) {
                                setState(() {
                                  _isToTimeSelected = !_isToTimeSelected;
                                  if (_isToTimeSelected == true) {
                                    _showToTimePicker(
                                      ctx: context,
                                      model: widget.model,
                                    );
                                  }
                                });
                              },
                            ),
                          )
                        : Container(
                            width: 0,
                            height: 0,
                          ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        dense: true,
                        leading: SvgPicture.asset(
                          'assets/icons/bell_notification.svg',
                          height: 30,
                        ),
                        title: Text(
                          TaskConstants.REMIND_ME,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 45,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: NotificationListener<
                            OverscrollIndicatorNotification>(
                          onNotification:
                              (OverscrollIndicatorNotification overscroll) {
                            overscroll.disallowGlow();
                            return false;
                          },
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: reminders.length,
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  right: 5,
                                  left: 5,
                                ),
                                child: ChoiceChip(
                                  pressElevation: 4,
                                  label: Text(reminders[index]),
                                  selected: _defaultChoiceIndex == index,
                                  selectedColor: BLUE,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      if (_selectedFromTime == null) {
                                        Fluttertoast.showToast(
                                          msg: TaskConstants
                                              .PLEASE_SELECT_START_TIME_FIRST,
                                        );
                                        return;
                                      }
                                      if ((index == 0 &&
                                              _selectedFromTime
                                                          .millisecondsSinceEpoch -
                                                      DateTime.now()
                                                          .millisecondsSinceEpoch <=
                                                  300000) ||
                                          (index == 1 &&
                                              _selectedFromTime
                                                          .millisecondsSinceEpoch -
                                                      DateTime.now()
                                                          .millisecondsSinceEpoch <=
                                                  1800000) ||
                                          (index == 2 &&
                                              _selectedFromTime
                                                          .millisecondsSinceEpoch -
                                                      DateTime.now()
                                                          .millisecondsSinceEpoch <=
                                                  3600000)) {
                                        Fluttertoast.showToast(
                                          msg: TaskConstants
                                              .PLEASE_SELECT_VALID_START_TIME,
                                        );
                                        return;
                                      }
                                      _defaultChoiceIndex =
                                          selected ? index : -1;
                                    });
                                  },
                                  backgroundColor: LIGHT_GREY,
                                  labelStyle: TextStyle(
                                    color: _defaultChoiceIndex == index
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              );
                              // return InkWell(
                              //   onTap: () {
                              //     setState(() {
                              //       selectedReminder = reminders[index];
                              //     });
                              //   },
                              //   child: Container(
                              //     alignment: Alignment.center,
                              //     padding: const EdgeInsets.symmetric(
                              //       horizontal: 10,
                              //     ),
                              //     margin: EdgeInsets.only(
                              //       right: 10,
                              //     ),
                              //     decoration: BoxDecoration(
                              //       color: (selectedReminder != null &&
                              //               selectedReminder == reminders[index])
                              //           ? BLUE
                              //           : LIGHT_GREY,
                              //       borderRadius: BorderRadius.circular(20.0),
                              //     ),
                              //     child: Text(
                              //       reminders[index],
                              //       style: TextStyle(
                              //         color: (selectedReminder != null &&
                              //                 selectedReminder == reminders[index])
                              //             ? Colors.white
                              //             : Colors.black,
                              //       ),
                              //     ),
                              //   ),
                              // );
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 12,
                      ),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        dense: true,
                        leading: SvgPicture.asset(
                          'assets/icons/exclamation_circle.svg',
                          height: 30,
                        ),
                        title: Text(
                          TaskConstants.PRIORITY,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        trailing: Container(
                          width: 110,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(0),
                            scrollDirection: Axis.horizontal,
                            itemCount: radioButtonsDisabled.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedRadioButton =
                                        radioButtonsEnabled[index];
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: (selectedRadioButton != null &&
                                          selectedRadioButton ==
                                              radioButtonsEnabled[index])
                                      ? SvgPicture.asset(
                                          radioButtonsEnabled[index],
                                          height: 28,
                                        )
                                      : SvgPicture.asset(
                                          radioButtonsDisabled[index],
                                          height: 28,
                                        ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: ButtonTheme(
                        minWidth: double.infinity,
                        child: RaisedButton(
                          padding: const EdgeInsets.all(8),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          onPressed: () async {
                            if (_controller.text.trim().isEmpty ||
                                _selectedFromTime == null) {
                              Fluttertoast.showToast(
                                msg: TaskConstants
                                    .PLEASE_ENTER_TITLE_AND_START_TIME,
                              );
                              return;
                            }
                            // add logic of Time-Slot already added. Currently not working
                            // also check for test case where only title is added and nothing else
                            if (widget.model.isTaskTimeSlotOverlapping(
                                fromTime: _selectedFromTime,
                                toTime: _selectedToTime)) {
                              Fluttertoast.showToast(
                                msg: TaskConstants.TIME_SLOT_ALREADY_ADDED,
                              );
                              return;
                            } else {
                              var task = Task(
                                date: widget.model
                                        .getSelectedDate()
                                        .millisecondsSinceEpoch ??
                                    DateTime.now().millisecondsSinceEpoch,
                                fromTime:
                                    _selectedFromTime.millisecondsSinceEpoch,
                                toTime: _selectedToTime != null
                                    ? _selectedToTime.millisecondsSinceEpoch
                                    : 0,
                                reminder: _defaultChoiceIndex,
                                priority: selectedRadioButton != null
                                    ? getPriorityIndex(selectedRadioButton) + 1
                                    : Priority.None.index,
                                status: Status.Pending.index,
                                title: _controller.text.trim(),
                              );
                              int id =
                                  await _databaseService.insert(task.toJson());
                              if (_defaultChoiceIndex >= 0) {
                                await _notificationHandler
                                    .showBigTextNotification(
                                  id: id,
                                  title: task.priority != null &&
                                          task.priority != 0
                                      ? sprintf(
                                          NotificationConstants
                                              .PUSH_NOTIFICATION_TITLE,
                                          [getPriorityString(task.priority)])
                                      : TaskConstants.REMINDER,
                                  body: task.toTime == null || task.toTime == 0
                                      ? sprintf(
                                          NotificationConstants
                                              .PUSH_NOTIFICATION_BODY_WITH_ONLY_FROM_TIME,
                                          [
                                            task.title,
                                            DateFormat('hh:mm a').format(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      task.fromTime),
                                            )
                                          ],
                                        )
                                      : sprintf(
                                          NotificationConstants
                                              .PUSH_NOTIFICATION_BODY_WITH_BOTH_FROM_TIME_AND_TO_TIME,
                                          [
                                            task.title,
                                            DateFormat('hh:mm a').format(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      task.fromTime),
                                            ),
                                            DateFormat('hh:mm a').format(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      task.toTime),
                                            ),
                                          ],
                                        ),
                                  payload: jsonEncode({
                                    DatabaseConstants.ID: task.id,
                                    NotificationConstants.NOTIFICATION_TYPE:
                                        DatabaseConstants.REMINDER,
                                    DatabaseConstants.FROM_TIME: task.fromTime -
                                        getReminderMilliseconds(
                                          _defaultChoiceIndex,
                                        ),
                                  }),
                                );
                              }
                              // removed purposefully
                              // widget.model.onModelReady();
                              Navigator.of(context).pop(true);
                            }
                          },
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            GeneralConstants.SAVE,
                            style: TextStyle(
                              letterSpacing: 1.5,
                              color: Colors.white,
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
