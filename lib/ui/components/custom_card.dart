import 'package:plan_it/ui/utils/size_config.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:plan_it/colors.dart';
import 'package:plan_it/locator.dart';
import 'package:plan_it/constants.dart';
import 'package:plan_it/models/task.dart';
import 'package:plan_it/ui/views/task_view.dart';
import 'package:plan_it/services/database_service.dart';
import 'package:plan_it/services/navigation_service.dart';
import 'package:plan_it/managers/notification_handler.dart';

class CustomCard extends StatelessWidget {
  final _databaseService = locator<DatabaseService>();
  final _navigationService = locator<NavigationService>();
  final Task taskEntity;
  final GlobalKey<RefreshIndicatorState> refreshKey;
  final DateTime dateSelected;

  CustomCard({
    Key key,
    this.taskEntity,
    this.refreshKey,
    this.dateSelected,
  }) : super(key: key);

  final Map<int, String> priorities = {
    0: 'None',
    1: 'assets/icons/green_dot.svg',
    2: 'assets/icons/yellow_dot.svg',
    3: 'assets/icons/red_dot.svg',
  };

  final Map<int, Color> borderColor = {
    0: LIGHT_GREY,
    1: GREEN,
    2: YELLOW,
    3: RED,
  };

  String getReminderSVG(int index) {
    return priorities[index];
  }

  Future markAsCompleteComfirmationDialog({BuildContext context}) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          TaskConstants.ACHIEVEMENT,
          style: TextStyle(
            fontSize: 5 * SizeConfig.widthMultiplier,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        content: Text(
          TaskConstants.DO_YOU_WANT_TO_MARK_THIS_TASK_AS_COMPLETED,
          style: Theme.of(context).textTheme.bodyText2,
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
              await refreshKey.currentState.show();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String fromTime = DateFormat('hh:mm a')
        .format(DateTime.fromMillisecondsSinceEpoch(taskEntity.fromTime));
    String toTime = sprintf(
      TaskConstants.CUSTOM_CARD_TO_TIME,
      [
        DateFormat('hh:mm a').format(
          DateTime.fromMillisecondsSinceEpoch(
            taskEntity.toTime,
          ),
        ),
      ],
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3 * SizeConfig.widthMultiplier),
      child: Dismissible(
        key: ValueKey(taskEntity.id),
        background: Container(
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 10 * SizeConfig.widthMultiplier,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(
            right: 2.5 * SizeConfig.widthMultiplier,
          ),
          decoration: BoxDecoration(
            color: RED,
            borderRadius: BorderRadius.circular(
              1.25 * SizeConfig.widthMultiplier,
            ),
          ),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
            barrierDismissible: false,
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(
                TaskConstants.ARE_YOU_SURE,
                style: TextStyle(
                  fontSize: 5 * SizeConfig.widthMultiplier,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
              content: Text(
                TaskConstants.DO_YOU_WANT_TO_REMOVE_PENDING_TASK,
                style: Theme.of(context).textTheme.bodyText2,
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
                  onPressed: () {
                    Fluttertoast.showToast(
                      msg: TaskConstants.TASK_DELETED_SUCESSFULLY,
                      backgroundColor: GREEN,
                      textColor: Colors.white,
                    );
                    Navigator.of(ctx).pop(true);
                  },
                ),
              ],
            ),
          );
        },
        onDismissed: (direction) async {
          await _databaseService.delete(taskEntity.id);
          await NotificationHandler.flutterLocalNotificationsPlugin
              .cancel(taskEntity.id);
          await refreshKey.currentState.show();
        },
        child: Container(
          height: 10.93 * SizeConfig.heightMultiplier,
          child: Card(
            semanticContainer: false,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: LIGHT_GREY,
              ),
              borderRadius: BorderRadius.circular(
                1.25 * SizeConfig.widthMultiplier,
              ),
            ),
            margin: const EdgeInsets.all(0),
            child: Center(
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    1.25 * SizeConfig.widthMultiplier,
                  ),
                ),
                onTap: () => _navigationService
                    .pushNamed(TaskView.routeName, arguments: {
                  'refreshKey': refreshKey,
                  'isEditing': true,
                  'task': taskEntity,
                  'dateSelected': dateSelected,
                }),
                leading: GestureDetector(
                  onTap: () =>
                      markAsCompleteComfirmationDialog(context: context),
                  child: SvgPicture.asset(
                    'assets/icons/check_circle.svg',
                    height: 7.71 * SizeConfig.heightMultiplier,
                    width: 15 * SizeConfig.widthMultiplier,
                  ),
                ),
                title: Text(
                  taskEntity.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 3.08 * SizeConfig.heightMultiplier,
                  ),
                ),
                subtitle: Row(
                  children: <Widget>[
                    Text(
                      fromTime,
                      style: TextStyle(
                        fontSize: 2.06 * SizeConfig.heightMultiplier,
                      ),
                    ),
                    taskEntity.toTime != null && taskEntity.toTime != 0
                        ? Text(
                            toTime,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          )
                        : Container(width: 0, height: 0),
                  ],
                ),
                trailing: taskEntity.priority == 0 && taskEntity.reminder == -1
                    ? Container(width: 0)
                    : taskEntity.priority != 0 && taskEntity.reminder == -1
                        ? Padding(
                            padding: EdgeInsets.only(
                              right: 3 * SizeConfig.widthMultiplier,
                            ),
                            child: SvgPicture.asset(
                              getReminderSVG(taskEntity.priority),
                              height: 2.06 * SizeConfig.heightMultiplier,
                            ),
                          )
                        : taskEntity.priority == 0 && taskEntity.reminder != -1
                            ? SvgPicture.asset(
                                'assets/icons/bell_notification.svg',
                                width: 7.5 * SizeConfig.widthMultiplier,
                              )
                            : Padding(
                                padding: EdgeInsets.only(
                                  right: 1.25 * SizeConfig.widthMultiplier,
                                ),
                                child: Container(
                                  width: 15 * SizeConfig.widthMultiplier,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      SvgPicture.asset(
                                        getReminderSVG(taskEntity.priority),
                                        height:
                                            2.06 * SizeConfig.heightMultiplier,
                                      ),
                                      SvgPicture.asset(
                                        'assets/icons/bell_notification.svg',
                                        width: 7.5 * SizeConfig.widthMultiplier,
                                      )
                                    ],
                                  ),
                                ),
                              ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
