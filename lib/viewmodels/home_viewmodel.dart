import 'package:flutter/material.dart';

import 'package:PlanIt/locator.dart';
import 'package:PlanIt/models/task.dart';
import 'package:PlanIt/ui/utils/date.dart';
import 'package:PlanIt/services/database_service.dart';
import 'package:PlanIt/viewmodels/base_viewmodel.dart';
import 'package:PlanIt/managers/notification_handler.dart';
import 'package:PlanIt/services/local_storage_service.dart';
import 'package:PlanIt/services/firebase_authentication_service.dart';

class HomeViewModel extends BaseViewModel {
  final _databaseService = locator<DatabaseService>();
  final _localStorageService = locator<LocalStorageService>();
  final _notificationHandler = locator<NotificationHandler>();
  final _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  int selectedDate = dateTimeToEpoch(DateTime.now());
  var pendingTasks = <Task>[];
  var completedTasks = <Task>[];

  Future<void> onModelReady() async {
    pendingTasks = await _databaseService
        .queryPendingTask(getSelectedDate().millisecondsSinceEpoch);
    completedTasks = await _databaseService
        .queryCompletedTask(getSelectedDate().millisecondsSinceEpoch);

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
      helpText: 'Jump to a particular date',
    );
    return pickedDate;
  }

  Future logout() async {
    await _firebaseAuthenticationService.signOut();
  }

  Future showNotification() async {
    await _notificationHandler.showBigTextNotification(
      id: 1,
      title: 'Hello',
      body:
          'Welcome to PlanIt! The application will help you to organise your task efficiently. Have a good day!',
      payload: '{}',
    );
  }

  void setSelectedDate(DateTime date) {
    var epochTime = dateTimeToEpoch(date);
    selectedDate = epochTime;
    notifyListeners();
  }

  DateTime getSelectedDate() {
    return epochToDateTime(selectedDate);
  }

  void onModelDestroy() {}
}
