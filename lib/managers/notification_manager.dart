import 'package:fluttertoast/fluttertoast.dart';

import 'package:plan_it/locator.dart';
import 'package:plan_it/constants.dart';
import 'package:plan_it/ui/views/home_view.dart';
import 'package:plan_it/enums/notification_type.dart';
import 'package:plan_it/services/navigation_service.dart';
import 'package:plan_it/services/local_storage_service.dart';

class NotificationManager {
  final Map<String, dynamic> message;
  final _navigationService = locator<NavigationService>();
  final _localStorageService = locator<LocalStorageService>();

  NotificationManager({this.message});

  Future onNotificationClick() async {
    _localStorageService.isNotificationClicked = true;
    // if (_localStorageService.isLoggedIn) {
    int id = message[DatabaseConstants.ID];
    int fromTime = message[DatabaseConstants.FROM_TIME];
    NotificationType type = notificationTypes
        .map[message[NotificationConstants.NOTIFICATION_TYPE].toString()];
    switch (type) {
      case NotificationType.REMINDER:
        await navigateTaskDetails(id, fromTime);
        break;
      default:
        Fluttertoast.showToast(
          msg: NotificationConstants.NOTIFICATION_CLICK_ERROR,
        );
        break;
    }
    // } else {
    //   Fluttertoast.showToast(msg: 'Please Login First');
    // }
  }

  Future<void> navigateTaskDetails(int taskId, int fromTime) async {
    await _navigationService.pushReplacementNamed(
      HomeView.routeName,
      arguments: {
        'taskId': taskId,
        'fromTime': fromTime,
      },
    );
  }
}
