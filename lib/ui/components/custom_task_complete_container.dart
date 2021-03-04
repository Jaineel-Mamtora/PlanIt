import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:plan_it/colors.dart';
import 'package:plan_it/locator.dart';
import 'package:plan_it/constants.dart';
import 'package:plan_it/ui/utils/size_config.dart';
import 'package:plan_it/services/database_service.dart';

class CustomTaskCompleteContainer extends StatelessWidget {
  final _databaseService = locator<DatabaseService>();
  final int id;
  final String title;
  final GlobalKey<RefreshIndicatorState> refreshKey;

  CustomTaskCompleteContainer({
    this.id,
    this.title,
    this.refreshKey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 3 * SizeConfig.widthMultiplier,
      ),
      child: Dismissible(
        key: ValueKey(id),
        background: Container(
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 7.5 * SizeConfig.widthMultiplier,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(
            right: 2.5 * SizeConfig.widthMultiplier,
          ),
          decoration: BoxDecoration(
            color: RED,
            borderRadius: BorderRadius.circular(
              4 * SizeConfig.widthMultiplier,
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
                  fontSize: 2.5 * SizeConfig.heightMultiplier,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
              content: Text(
                TaskConstants.DO_YOU_WANT_TO_REMOVE_COMPLETED_TASK,
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
        child: Card(
          margin: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              5 * SizeConfig.widthMultiplier,
            ),
          ),
          child: Container(
            height: 7.44 * SizeConfig.heightMultiplier,
            decoration: BoxDecoration(
              color: LIGHT_BLUE,
              border: Border.all(
                color: BLUE,
              ),
              borderRadius: BorderRadius.circular(
                4 * SizeConfig.widthMultiplier,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      4 * SizeConfig.widthMultiplier,
                    ),
                    color: Colors.transparent,
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: 7.5 * SizeConfig.widthMultiplier,
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/checkmark.svg',
                    width: 6.5 * SizeConfig.widthMultiplier,
                    height: 3.42 * SizeConfig.heightMultiplier,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 5.5 * SizeConfig.widthMultiplier,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
