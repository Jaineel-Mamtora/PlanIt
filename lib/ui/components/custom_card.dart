import 'package:PlanIt/locator.dart';
import 'package:PlanIt/managers/notification_handler.dart';
import 'package:PlanIt/services/database_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:PlanIt/colors.dart';
import 'package:PlanIt/models/task.dart';

class CustomCard extends StatelessWidget {
  final _databaseService = locator<DatabaseService>();
  final Task taskEntity;
  final GlobalKey<RefreshIndicatorState> refreshKey;

  CustomCard({
    Key key,
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
          'Achievement!',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        content: Text(
          'Do you want to mark this task as completed?',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('NO'),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
          FlatButton(
            child: Text('YES'),
            onPressed: () async {
              await _databaseService.update({
                id: taskEntity.id,
                title: taskEntity.title,
                fromTime: taskEntity.fromTime,
                date: taskEntity.date,
                toTime: taskEntity.toTime,
                reminder: taskEntity.reminder,
                priority: taskEntity.priority,
                status: 1,
              });
              Fluttertoast.showToast(
                msg: 'Task mark as done successfully!',
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
              'Are you sure?',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            content: Text(
              'Do you want to remove pending Task?',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              FlatButton(
                child: Text('YES'),
                onPressed: () {
                  Fluttertoast.showToast(
                    msg: 'Task deleted successfully!',
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
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          margin: const EdgeInsets.all(0),
          elevation: 2,
          child: ListTile(
            leading: GestureDetector(
              onTap: () => markAsCompleteComfirmationDialog(context: context),
              child: SvgPicture.asset(
                'assets/icons/check_circle.svg',
                height: 45,
                width: 45,
              ),
            ),
            title: Text(
              taskEntity.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            subtitle: Row(
              children: <Widget>[
                Text(
                  "${DateFormat("hh:mm a").format(DateTime.fromMillisecondsSinceEpoch(taskEntity.fromTime))}",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                taskEntity.toTime != null && taskEntity.toTime != 0
                    ? Text(
                        " - ${DateFormat("hh:mm a").format(DateTime.fromMillisecondsSinceEpoch(taskEntity.toTime))}",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      )
                    : Container(width: 0, height: 0),
              ],
            ),
            trailing: taskEntity.priority != 0 && taskEntity.reminder == -1
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
        ),
      ),
    );
  }
}
