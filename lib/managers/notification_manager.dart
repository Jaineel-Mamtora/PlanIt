import 'package:fluttertoast/fluttertoast.dart';

import 'package:PlanIt/locator.dart';
import 'package:PlanIt/ui/views/home_view.dart';
import 'package:PlanIt/enums/notification_type.dart';
import 'package:PlanIt/services/navigation_service.dart';

class NotificationManager {
  final Map<String, dynamic> message;
  final _navigationService = locator<NavigationService>();
  // final _localStorageService = locator<LocalStorageService>();

  NotificationManager({this.message});

  Future onNotificationClick() async {
    // if (_localStorageService.isLoggedIn) {
    int id = message['id'];
    int fromTime = message['fromTime'];
    NotificationType type = notificationTypes.map[message['type'].toString()];
    switch (type) {
      case NotificationType.REMINDER:
        await navigateTaskDetails(id, fromTime);
        break;
      default:
        Fluttertoast.showToast(msg: 'Notification Click Error');
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
