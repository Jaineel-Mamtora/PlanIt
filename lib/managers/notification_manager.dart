import 'package:fluttertoast/fluttertoast.dart';

import 'package:PlanIt/locator.dart';
import 'package:PlanIt/constants.dart';
import 'package:PlanIt/ui/views/home_view.dart';
import 'package:PlanIt/enums/notification_type.dart';
import 'package:PlanIt/services/navigation_service.dart';
import 'package:PlanIt/services/local_storage_service.dart';

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
