import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:plan_it/ui/utils/size_config.dart';
import 'package:sprintf/sprintf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:plan_it/colors.dart';
import 'package:plan_it/locator.dart';
import 'package:plan_it/constants.dart';
import 'package:plan_it/models/task.dart';
import 'package:plan_it/enums/status.dart';
import 'package:plan_it/enums/reminder.dart';
import 'package:plan_it/enums/priority.dart';
import 'package:plan_it/ui/views/base_view.dart';
import 'package:plan_it/viewmodels/task_viewmodel.dart';
import 'package:plan_it/services/database_service.dart';
import 'package:plan_it/managers/notification_handler.dart';
import 'package:plan_it/ui/components/custom_text_field.dart';

class TaskView extends StatefulWidget {
  static const routeName = '/task';
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  final bool isEditing;
  final Task task;
  final DateTime dateSelected;

  const TaskView({
    this.refreshIndicatorKey,
    this.isEditing,
    this.task,
    this.dateSelected,
  });

  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  final _databaseService = locator<DatabaseService>();
  final _notificationHandler = locator<NotificationHandler>();
  int _defaultReminderChoiceIndex;
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

  Future markAsCompleteComfirmationDialog({
    BuildContext context,
    Task taskEntity,
  }) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          TaskConstants.ACHIEVEMENT,
          style: TextStyle(
            fontSize: 2.5 * SizeConfig.heightMultiplier,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        content: Text(
          TaskConstants.DO_YOU_WANT_TO_MARK_THIS_TASK_AS_COMPLETED,
          style: TextStyle(
            fontSize: 2.3 * SizeConfig.heightMultiplier,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(GeneralConstants.NO),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
          TextButton(
            child: Text(GeneralConstants.YES),
            onPressed: () async {
              await _databaseService.update({
                DatabaseConstants.ID: taskEntity.id,
                DatabaseConstants.TITLE: taskEntity.title,
                DatabaseConstants.FROM_TIME: taskEntity.fromTime,
                DatabaseConstants.DATE: taskEntity.date,
                DatabaseConstants.TO_TIME: taskEntity.toTime,
                DatabaseConstants.REMINDER: taskEntity.reminder,
                DatabaseConstants.PRIORITY: taskEntity.priority,
                DatabaseConstants.STATUS: 1,
              });
              Fluttertoast.showToast(
                msg: TaskConstants.TASK_MARKED_AS_DONE_SUCCESSFULLY,
                backgroundColor: Colors.green,
                textColor: Colors.white,
              );
              await NotificationHandler.flutterLocalNotificationsPlugin
                  .cancel(taskEntity.id);
              Navigator.of(ctx).pop(true);
              Navigator.of(context).pop(true);
              await widget.refreshIndicatorKey.currentState.show();
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEditing == true) {
      _controller = TextEditingController(text: widget.task.title);
      _isFromTimeSelected = true;
      _selectedFromTime =
          DateTime.fromMillisecondsSinceEpoch(widget.task.fromTime);
      if (widget.task.toTime != 0) {
        _isToTimeSelected = true;
        _selectedToTime =
            DateTime.fromMillisecondsSinceEpoch(widget.task.toTime);
      }
      print(getPriorityAssetString(widget.task.priority));
      selectedRadioButton = getPriorityAssetString(widget.task.priority);
      _defaultReminderChoiceIndex = widget.task.reminder;
    } else {
      _controller = TextEditingController();
      _defaultReminderChoiceIndex = -1;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _showFromTimePicker({
    BuildContext ctx,
    TaskViewModel model,
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
    TaskViewModel model,
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
    return BaseView<TaskViewModel>(
      onModelReady: (model) {},
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            elevation: 2,
            title: Text(
              widget.isEditing == false ? 'Create Task' : 'Edit Task',
              style: TextStyle(
                fontSize: 3 * SizeConfig.textMultiplier,
                color: Colors.black,
              ),
            ),
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
          ),
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowGlow();
              return false;
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      left: 5 * SizeConfig.widthMultiplier,
                      right: 5 * SizeConfig.widthMultiplier,
                      top: 3 * SizeConfig.heightMultiplier,
                    ),
                    child: CustomTextField(
                      labelText: TaskConstants.TITLE,
                      controller: _controller,
                      customTextCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5 * SizeConfig.widthMultiplier,
                      vertical: 1.48 * SizeConfig.heightMultiplier,
                    ),
                    child: SwitchListTile(
                      dense: true,
                      value: _isFromTimeSelected,
                      contentPadding: const EdgeInsets.all(0),
                      activeColor: Theme.of(context).primaryColor,
                      secondary: SvgPicture.asset(
                        'assets/icons/alarm.svg',
                        color: GREY,
                        height: 4.4 * SizeConfig.heightMultiplier,
                      ),
                      title: Text(
                        _selectedFromTime == null
                            ? sprintf(TaskConstants.MODAL_SHEET_FROM_TIME,
                                [DateFormat('hh:mm a').format(DateTime.now())])
                            : sprintf(TaskConstants.MODAL_SHEET_FROM_TIME, [
                                DateFormat('hh:mm a').format(_selectedFromTime)
                              ]),
                        style: TextStyle(
                          fontSize: 2.7 * SizeConfig.heightMultiplier,
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
                              model: model,
                            );
                          }
                        });
                      },
                    ),
                  ),
                  _isFromTimeSelected == true
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5 * SizeConfig.widthMultiplier,
                            vertical: 1.48 * SizeConfig.heightMultiplier,
                          ),
                          child: SwitchListTile(
                            dense: true,
                            value: _isToTimeSelected,
                            contentPadding: const EdgeInsets.all(0),
                            activeColor: Theme.of(context).primaryColor,
                            secondary: SvgPicture.asset(
                              'assets/icons/alarm.svg',
                              color: GREY,
                              height: 4.4 * SizeConfig.heightMultiplier,
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
                                fontSize: 2.7 * SizeConfig.heightMultiplier,
                                color: Colors.black,
                              ),
                            ),
                            onChanged: (_) {
                              setState(() {
                                _isToTimeSelected = !_isToTimeSelected;
                                if (_isToTimeSelected == true) {
                                  _showToTimePicker(
                                    ctx: context,
                                    model: model,
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 5 * SizeConfig.widthMultiplier,
                    ),
                    child: Divider(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5 * SizeConfig.widthMultiplier,
                      vertical: 1.49 * SizeConfig.heightMultiplier,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      dense: true,
                      leading: SvgPicture.asset(
                        'assets/icons/bell_notification.svg',
                        height: 4.4 * SizeConfig.heightMultiplier,
                      ),
                      title: Text(
                        TaskConstants.REMIND_ME,
                        style: TextStyle(
                          fontSize: 2.9 * SizeConfig.heightMultiplier,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 45,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child:
                          NotificationListener<OverscrollIndicatorNotification>(
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
                              padding: EdgeInsets.only(
                                right: 1.25 * SizeConfig.widthMultiplier,
                                left: 1.25 * SizeConfig.widthMultiplier,
                              ),
                              child: ChoiceChip(
                                pressElevation: 4,
                                label: Text(reminders[index]),
                                selected: _defaultReminderChoiceIndex == index,
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
                                    _defaultReminderChoiceIndex =
                                        selected ? index : -1;
                                  });
                                },
                                backgroundColor: LIGHT_GREY,
                                labelStyle: TextStyle(
                                  color: _defaultReminderChoiceIndex == index
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 2.3 * SizeConfig.heightMultiplier,
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
                    padding: EdgeInsets.only(
                      left: 5 * SizeConfig.widthMultiplier,
                      right: 5 * SizeConfig.widthMultiplier,
                      top: 1.76 * SizeConfig.heightMultiplier,
                    ),
                    child: Divider(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5 * SizeConfig.widthMultiplier,
                      vertical: 1.49 * SizeConfig.heightMultiplier,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      dense: true,
                      leading: SvgPicture.asset(
                        'assets/icons/exclamation_circle.svg',
                        height: 4.4 * SizeConfig.heightMultiplier,
                      ),
                      title: Text(
                        TaskConstants.PRIORITY,
                        style: TextStyle(
                          fontSize: 2.9 * SizeConfig.heightMultiplier,
                        ),
                      ),
                      trailing: Container(
                        width: 30.7 * SizeConfig.widthMultiplier,
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
                                        height:
                                            3.5 * SizeConfig.heightMultiplier,
                                      )
                                    : SvgPicture.asset(
                                        radioButtonsDisabled[index],
                                        height:
                                            3.5 * SizeConfig.heightMultiplier,
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  widget.isEditing
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5 * SizeConfig.widthMultiplier,
                            vertical: 0.75 * SizeConfig.heightMultiplier,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(8),
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                onPressed: () async {
                                  var task = Task(
                                    date: widget.dateSelected
                                            .millisecondsSinceEpoch ??
                                        DateTime.now().millisecondsSinceEpoch,
                                    fromTime: _selectedFromTime
                                        .millisecondsSinceEpoch,
                                    toTime: _selectedToTime != null
                                        ? _selectedToTime.millisecondsSinceEpoch
                                        : 0,
                                    reminder: _defaultReminderChoiceIndex,
                                    priority: selectedRadioButton != null
                                        ? getPriorityIndex(selectedRadioButton)
                                        : Priority.None.index,
                                    status: Status.Pending.index,
                                    title: _controller.text.trim(),
                                  );
                                  task.id = widget.task.id;
                                  await _databaseService.update(task.toJson());
                                  markAsCompleteComfirmationDialog(
                                    context: context,
                                    taskEntity: task,
                                  );

                                  widget.refreshIndicatorKey.currentState
                                      .show();
                                },
                                // color: Theme.of(context).primaryColor,
                                child: Text(
                                  'MARK AS DONE',
                                  style: TextStyle(
                                    letterSpacing: 1.5,
                                    color: Colors.white,
                                    fontSize: 2.5 * SizeConfig.textMultiplier,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5 * SizeConfig.widthMultiplier,
                      vertical: 0.75 * SizeConfig.heightMultiplier,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(8),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          // padding: const EdgeInsets.all(8),

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
                            if (model.isTaskTimeSlotOverlapping(
                                fromTime: _selectedFromTime,
                                toTime: _selectedToTime)) {
                              Fluttertoast.showToast(
                                msg: TaskConstants.TIME_SLOT_ALREADY_ADDED,
                              );
                              return;
                            } else {
                              var task = Task(
                                date: widget
                                        .dateSelected.millisecondsSinceEpoch ??
                                    DateTime.now().millisecondsSinceEpoch,
                                fromTime:
                                    _selectedFromTime.millisecondsSinceEpoch,
                                toTime: _selectedToTime != null
                                    ? _selectedToTime.millisecondsSinceEpoch
                                    : 0,
                                reminder: _defaultReminderChoiceIndex,
                                priority: selectedRadioButton != null
                                    ? getPriorityIndex(selectedRadioButton)
                                    : Priority.None.index,
                                status: Status.Pending.index,
                                title: _controller.text.trim(),
                              );
                              int id;
                              if (widget.isEditing == true) {
                                task.id = widget.task.id;
                                id = await _databaseService
                                    .update(task.toJson());
                              } else {
                                id = await _databaseService
                                    .insert(task.toJson());
                              }
                              if (_defaultReminderChoiceIndex >= 0) {
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
                                          _defaultReminderChoiceIndex,
                                        ),
                                  }),
                                );
                              }
                              Navigator.of(context).pop(true);
                              widget.refreshIndicatorKey.currentState.show();
                            }
                          },
                          child: Text(
                            GeneralConstants.SAVE,
                            style: TextStyle(
                              letterSpacing: 1.5,
                              color: Colors.white,
                              fontSize: 2.5 * SizeConfig.textMultiplier,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
