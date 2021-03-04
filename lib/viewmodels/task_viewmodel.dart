import 'package:flutter/material.dart';

import 'package:plan_it/locator.dart';
import 'package:plan_it/constants.dart';
import 'package:plan_it/ui/utils/date.dart';
import 'package:plan_it/viewmodels/base_viewmodel.dart';
import 'package:plan_it/viewmodels/home_viewmodel.dart';

class TaskViewModel extends BaseViewModel {
  final _homeViewModel = locator<HomeViewModel>();
  int selectedDate = dateTimeToEpoch(DateTime.now());

  Future<void> onModelReady() async {}

  Future<DateTime> selectDate(
    BuildContext ctx,
  ) async {
    final pickedDate = await showDatePicker(
      context: ctx,
      initialDate: getSelectedDate(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      helpText: CalendarConstants.JUMP_TO_A_PARTICULAR_DATE,
    );
    return pickedDate;
  }

  void setSelectedDate(DateTime date) {
    var epochTime = dateTimeToEpoch(date);
    selectedDate = epochTime;
    notifyListeners();
  }

  bool isTaskTimeSlotOverlapping({DateTime fromTime, DateTime toTime}) {
    int flag = 0;
    int fromTimeEpoch = fromTime.millisecondsSinceEpoch;
    int toTimeEpoch;
    if (toTime != null) {
      toTimeEpoch = toTime.millisecondsSinceEpoch;
    }
    _homeViewModel.pendingTasks.forEach((pendingTask) {
      if (fromTimeEpoch >= pendingTask.fromTime &&
          fromTimeEpoch < pendingTask.toTime) {
        flag = 1;
      } else if (toTimeEpoch != null &&
          fromTimeEpoch >= pendingTask.fromTime &&
          toTimeEpoch < pendingTask.toTime) {
        flag = 1;
      } else if (pendingTask.fromTime == fromTimeEpoch) {
        flag = 1;
      }
    });
    if (flag == 1) {
      return true;
    } else {
      return false;
    }
  }

  DateTime getSelectedDate() {
    return epochToDateTime(selectedDate);
  }

  void onModelDestroy() {}
}
