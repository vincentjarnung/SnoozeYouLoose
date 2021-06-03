import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:snooze_you_loose/screens/main_menu/bottom_nav_bar.dart';
import 'package:snooze_you_loose/services/notification_services.dart';
import 'package:snooze_you_loose/shared/shared_colors.dart';
import 'package:rxdart/subjects.dart';

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

String initialRoute = '/';
String selectedNotificationPayload;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationServices().init();
  final NotificationAppLaunchDetails notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails.payload;
    initialRoute = SecondPage.routeName;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snooze You Loose',
      theme: ThemeData(
        primarySwatch: SharedColors.kPrimaryColor,
        primaryColor: SharedColors.kPrimaryColor,
      ),
      initialRoute: initalRoute,
      home: BottomNavBar(),
    );
  }
}

class WakeUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
    );
  }
}
