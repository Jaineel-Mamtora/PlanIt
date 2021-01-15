import 'dart:io';
import 'dart:convert';

import 'package:rxdart/subjects.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:PlanIt/models/recieve_notification.dart';
import 'package:PlanIt/managers/notification_manager.dart';

class NotificationHandler {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  BehaviorSubject<ReceiveNotification> get didReceiveLocalNotificationSubject =>
      BehaviorSubject<ReceiveNotification>();

  Future<void> initLocalNotification() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Detroit'));
    if (Platform.isIOS) {
      requestIOSPermission();
    }
    initializePlatform();
  }

  void requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void initializePlatform() {
    var initSettingAndroid =
        AndroidInitializationSettings('app_notification_icon');
    var initSettingIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          var notification = ReceiveNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          );
          didReceiveLocalNotificationSubject.add(notification);
        });
    var initSetting = InitializationSettings(
        android: initSettingAndroid, iOS: initSettingIOS);
    flutterLocalNotificationsPlugin.initialize(
      initSetting,
      onSelectNotification: onSelectNotification,
    );
  }

  Future onSelectNotification(String payload) async {
    Map<String, dynamic> data = jsonDecode(payload);
    var manager = NotificationManager(message: data);
    await manager.onNotificationClick();
  }

  void setOnNotificationReceive(Function onNotificationReceive) {
    didReceiveLocalNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }

  void onNotificationReceive(ReceiveNotification notification) {
    print('Notification Received: ${notification.id}');
  }

  static Future<String> _downloadAndSaveFile(
      String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final response = await http.get(url);
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future showBigPictureNotificationHiddenLargeIcon({
    @required int id,
    @required String largeIcon,
    @required String bigPicture,
    @required String title,
    @required String body,
    @required String payload,
  }) async {
    Map<String, dynamic> data = jsonDecode(payload);
    final largeIconPath = await _downloadAndSaveFile(largeIcon, 'largeIcon');
    final bigPicturePath = await _downloadAndSaveFile(bigPicture, 'bigPicture');
    final bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      hideExpandedLargeIcon: true,
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      contentTitle: title,
      htmlFormatContentTitle: true,
      summaryText: title,
      htmlFormatSummaryText: true,
    );
    var androidChannel = AndroidNotificationDetails(
      'com.trailblazing.planit',
      'PlanIt',
      'Channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigPictureStyleInformation,
    );
    var iOSChannel = IOSNotificationDetails(
      attachments: [IOSNotificationAttachment(bigPicturePath)],
    );
    var platformChannel = NotificationDetails(
      android: androidChannel,
      iOS: iOSChannel,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, data['date']),
      platformChannel,
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future showBigTextNotification({
    @required int id,
    @required String title,
    @required String body,
    @required String payload,
  }) async {
    Map<String, dynamic> data = jsonDecode(payload);
    final bigTextStyleInformation = BigTextStyleInformation(
      body,
      // htmlFormatBigText: true,
      contentTitle: title,
      // htmlFormatContentTitle: true,
      // summaryText: body,
      // htmlFormatSummaryText: true,
    );
    var androidChannel = AndroidNotificationDetails(
      'com.trailblazing.planit',
      'PlanIt',
      'Channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigTextStyleInformation,
      largeIcon:
          DrawableResourceAndroidBitmap('@mipmap/notification_large_icon'),
    );
    var iOSChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(
      android: androidChannel,
      iOS: iOSChannel,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.fromMillisecondsSinceEpoch(
        tz.local,
        data['fromTime'],
      ),
      platformChannel,
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
