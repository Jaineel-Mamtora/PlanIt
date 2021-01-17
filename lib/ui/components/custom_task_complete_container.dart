import 'package:PlanIt/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:PlanIt/colors.dart';
import 'package:PlanIt/locator.dart';
import 'package:PlanIt/services/database_service.dart';

class CustomTaskCompleteContainer extends StatelessWidget {
  final _databaseService = locator<DatabaseService>();
  final int id;
  final String title;
  final int index;
  final GlobalKey<RefreshIndicatorState> refreshKey;

  CustomTaskCompleteContainer({
    this.id,
    this.index,
    this.title,
    this.refreshKey,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: RED,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
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
              TaskConstants.DO_YOU_WANT_TO_REMOVE_COMPLETED_TASK,
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
        await _databaseService.delete(id);
        await refreshKey.currentState.show();
      },
      child: ListTile(
        leading: SvgPicture.asset(
          'assets/icons/checkmark.svg',
          width: 20,
          height: 18,
        ),
        tileColor: (index % 2 == 0) ? LIGHT_BLUE : Colors.white,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
