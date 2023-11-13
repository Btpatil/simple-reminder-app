import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:rxdart/rxdart.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _androidInitializationSettings =
      const AndroidInitializationSettings('logo');

  static final onClickNotification = BehaviorSubject<String>();

  void initalizeNotification() async {
    InitializationSettings initializationSettings = InitializationSettings(
      android: _androidInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
      onClickNotification.add(notificationResponse.payload!);
    }
  }

  Future<List> getAllNoti() async {
    List<PendingNotificationRequest> pending =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    List ids = [];
    pending.forEach((e) {
      ids.add(e.id);
    });
    return ids;
  }

  void cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<int> clearNotification(int id) async {
    List ids = await getAllNoti();
    try {
      if (ids.contains(id)) {
        await _flutterLocalNotificationsPlugin.cancel(id);
        return 1;
      } else {
        return -1;
      }
    } catch (e) {
      return -1;
    }
    // print('line 25 $noti');
  }

  Future sendNotification(String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max, priority: Priority.high);

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails);
  }

  Future<String> scheduleNotification(int id, String title, String body,
      int hour, int minutes, int day, dynamic payload) async {
    try {
      AndroidNotificationDetails androidNotificationDetails =
          const AndroidNotificationDetails('channel Id', 'channel Name',
              importance: Importance.max, priority: Priority.high);

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
      );

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        _scheduledDaily(TimeOfDay(hour: hour, minute: minutes)),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: id.toString(),
      );
      return 'success';
    } catch (e) {
      return 'failed';
    }
  }

  tz.TZDateTime _scheduledDaily(TimeOfDay timeOfDay) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    // daily notification
    return scheduleDate.isBefore(now)
        ? scheduleDate.add(const Duration(days: 1))
        : scheduleDate;
  }

  // tz.TZDateTime _nextInstanceOfTenAM() {
  //   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  //   tz.TZDateTime scheduledDate =
  //       tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
  //   if (scheduledDate.isBefore(now)) {
  //     scheduledDate = scheduledDate.add(const Duration(days: 1));
  //   }
  //   return scheduledDate;
  // }

// schedule weekly code
  // tz.TZDateTime _scheduledWeekly(TimeOfDay timeOfDay, int day) {
  //   // final now = tz.TZDateTime.now(tz.local);
  //   tz.TZDateTime scheduleDate = _scheduledDaily(timeOfDay);
  //   List<int> days = [day];
  //   while (!days.contains(scheduleDate.weekday)) {
  //     scheduleDate = scheduleDate.add(const Duration(days: 1));
  //   }
  //   print('$scheduleDate');
  //   return scheduleDate;
  // }
}
