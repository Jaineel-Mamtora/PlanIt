import 'package:PlanIt/constants.dart';
import 'package:PlanIt/locator.dart';
import 'package:PlanIt/managers/notification_handler.dart';
import 'package:PlanIt/models/task.dart';
import 'package:PlanIt/services/database_service.dart';
import 'package:PlanIt/services/local_storage_service.dart';
import 'package:PlanIt/ui/utils/date.dart';
import 'package:PlanIt/viewmodels/base_viewmodel.dart';
import 'package:PlanIt/viewmodels/home_viewmodel.dart';
import 'package:flutter/material.dart';

class CreateTaskViewModel extends BaseViewModel {
  final _homeViewModel = locator<HomeViewModel>();
  final _databaseService = locator<DatabaseService>();
  final _localStorageService = locator<LocalStorageService>();
  final _notificationHandler = locator<NotificationHandler>();
  int selectedDate = dateTimeToEpoch(DateTime.now());
  var pendingTasks = <Task>[];
  var completedTasks = <Task>[];

  Future<void> onModelReady() async {
    pendingTasks = await _databaseService
        .queryPendingTask(getSelectedDate().millisecondsSinceEpoch);
    completedTasks = await _databaseService
        .queryCompletedTask(getSelectedDate().millisecondsSinceEpoch);
    pendingTasks.sort((a, b) => a.fromTime.compareTo(b.fromTime));
    completedTasks.sort((a, b) => a.fromTime.compareTo(b.fromTime));
    notifyListeners();
    if (_localStorageService.isNotificationClicked == true) {
      await _notificationHandler.initLocalNotification();
      _localStorageService.isNotificationClicked = false;
    }
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
    return _homeViewModel.getSelectedDate();
  }

  void setSelectedDate(DateTime date) {
    _homeViewModel.setSelectedDate(date);
  }

  void onModelDestroy() {}
}
