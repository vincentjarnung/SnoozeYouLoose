import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:rxdart/subjects.dart';
import 'package:snooze_you_loose/main.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationServices {
  void scheduleAlarm(int id, DateTime time) async {
    tz.initializeTimeZones();
    print(id);

    const int insistentFlag = 4;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'alarm_notif', 'alarm_notif', 'Channel for Alarm notification',
        icon: 'codex_logo',
        largeIcon: DrawableResourceAndroidBitmap('codex_logo'),
        fullScreenIntent: true,
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
        additionalFlags: Int32List.fromList(<int>[insistentFlag]),
        autoCancel: false);

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        presentAlert: true, presentBadge: true, presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(id, 'Office', 'Title',
        tz.TZDateTime.from(time, tz.local), platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void snoozeAlarm(int id) async {
    tz.initializeTimeZones();
    print(id);

    DateTime time = DateTime.now().add(Duration(seconds: 5));

    const int insistentFlag = 4;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'alarm_notif', 'alarm_notif', 'Channel for Alarm notification',
        icon: 'codex_logo',
        largeIcon: DrawableResourceAndroidBitmap('codex_logo'),
        fullScreenIntent: true,
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
        additionalFlags: Int32List.fromList(<int>[insistentFlag]),
        autoCancel: false);

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        presentAlert: true, presentBadge: true, presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(id, 'Office', 'Title',
        tz.TZDateTime.from(time, tz.local), platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void showFullScreenNot() async {
    tz.initializeTimeZones();
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails('full screen channel id',
                'full screen channel name', 'full screen channel description',
                priority: Priority.high,
                importance: Importance.high,
                fullScreenIntent: true)),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void cancelAlarm() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }
}
