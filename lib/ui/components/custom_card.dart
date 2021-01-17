import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:PlanIt/colors.dart';
import 'package:PlanIt/locator.dart';
import 'package:PlanIt/constants.dart';
import 'package:PlanIt/models/task.dart';
import 'package:PlanIt/services/database_service.dart';
import 'package:PlanIt/managers/notification_handler.dart';

class CustomCard extends StatelessWidget {
  final _databaseService = locator<DatabaseService>();
  final int index;
  final Task taskEntity;
  final GlobalKey<RefreshIndicatorState> refreshKey;

  CustomCard({
    Key key,
    this.index,
    this.taskEntity,
    this.refreshKey,
  }) : super(key: key);

  final Map<int, String> priorities = {
    0: 'None',
    1: 'assets/icons/green_dot.svg',
    2: 'assets/icons/yellow_dot.svg',
    3: 'assets/icons/red_dot.svg',
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
            fontSize: 16,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        content: Text(
          TaskConstants.DO_YOU_WANT_TO_MARK_THIS_TASK_AS_COMPLETED,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(GeneralConstants.NO),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
          FlatButton(
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
    return Dismissible(
      key: ValueKey(taskEntity.id),
      background: Container(
        color: RED,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(
          right: 10,
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
                fontSize: 16,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            content: Text(
              TaskConstants.DO_YOU_WANT_TO_REMOVE_PENDING_TASK,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(GeneralConstants.NO),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              FlatButton(
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
      child: ListTile(
        tileColor: (index % 2 == 0)
            ? Color.fromRGBO(151, 151, 151, 0.08)
            : Colors.white,
        leading: GestureDetector(
          onTap: () => markAsCompleteComfirmationDialog(context: context),
          child: SvgPicture.asset(
            'assets/icons/check_circle.svg',
            height: 40,
            width: 40,
          ),
        ),
        title: Text(
          taskEntity.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        subtitle: Row(
          children: <Widget>[
            Text(
              DateFormat('hh:mm a').format(
                  DateTime.fromMillisecondsSinceEpoch(taskEntity.fromTime)),
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            taskEntity.toTime != null && taskEntity.toTime != 0
                ? Text(
                    sprintf(
                      TaskConstants.CUSTOM_CARD_TO_TIME,
                      [
                        DateFormat('hh:mm a').format(
                          DateTime.fromMillisecondsSinceEpoch(
                            taskEntity.toTime,
                          ),
                        ),
                      ],
                    ),
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
                    padding: const EdgeInsets.only(right: 5),
                    child: SvgPicture.asset(
                      getReminderSVG(taskEntity.priority),
                      height: 12,
                    ),
                  )
                : taskEntity.priority == 0 && taskEntity.reminder != -1
                    ? SvgPicture.asset(
                        'assets/icons/bell_notification.svg',
                        width: 26,
                      )
                    : Container(
                        width: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SvgPicture.asset(
                              getReminderSVG(taskEntity.priority),
                              height: 12,
                            ),
                            SvgPicture.asset(
                              'assets/icons/bell_notification.svg',
                              width: 26,
                            )
                          ],
                        ),
                      ),
      ),
    );
  }
}
