import 'package:flutter/material.dart';

import 'package:PlanIt/locator.dart';
import 'package:PlanIt/constants.dart';
import 'package:PlanIt/models/task.dart';
import 'package:PlanIt/ui/utils/date.dart';
import 'package:PlanIt/services/database_service.dart';
import 'package:PlanIt/viewmodels/base_viewmodel.dart';
import 'package:PlanIt/services/local_storage_service.dart';
import 'package:PlanIt/services/firebase_authentication_service.dart';

class HomeViewModel extends BaseViewModel {
  final _databaseService = locator<DatabaseService>();
  final _localStorageService = locator<LocalStorageService>();
  final _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  int selectedDate = dateTimeToEpoch(DateTime.now());
  var pendingTasks = <Task>[];
  var completedTasks = <Task>[];

  Future<void> onModelReady({int taskId, int fromTime}) async {
    if (taskId != 0 &&
        fromTime != 0 &&
        _localStorageService.isNotificationClicked == true) {
      setSelectedDate(DateTime.fromMillisecondsSinceEpoch(fromTime));
      _localStorageService.isNotificationClicked = false;
    }
    pendingTasks = await _databaseService
        .queryPendingTask(getSelectedDate().millisecondsSinceEpoch);
    completedTasks = await _databaseService
        .queryCompletedTask(getSelectedDate().millisecondsSinceEpoch);
    pendingTasks.sort((a, b) => a.fromTime.compareTo(b.fromTime));
    completedTasks.sort((a, b) => a.fromTime.compareTo(b.fromTime));
    notifyListeners();
  }

  Future<DateTime> selectDate(
    HomeViewModel model,
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

  Future logout() async {
    await _firebaseAuthenticationService.signOut();
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
    pendingTasks.forEach((pendingTask) {
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
