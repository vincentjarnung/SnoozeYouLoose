import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:snooze_you_loose/main.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationServices {
  void scheduleAlarm(int id, String alarmSound, DateTime time) async {
    tz.initializeTimeZones();
    print(id);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'alarm_notif', 'alarm_notif', 'Channel for Alarm notification',
        playSound: true,
        sound: RawResourceAndroidNotificationSound(alarmSound),
        icon: 'codex_logo',
        largeIcon: DrawableResourceAndroidBitmap('codex_logo'),
        fullScreenIntent: true,
        importance: Importance.high,
        priority: Priority.high);

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: alarmSound,
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
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
