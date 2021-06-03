import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:snooze_you_loose/screens/main_menu/bottom_nav_bar.dart';
import 'package:snooze_you_loose/services/notification_services.dart';
import 'package:rxdart/subjects.dart';
import 'package:snooze_you_loose/shared/shared_colors.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

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

String initialRoute;
String selectedNotificationPayload;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingsAndroid =
      AndroidInitializationSettings('codex_logo');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {});

  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectedNotificationPayload = payload;
    selectNotificationSubject.add(payload);
  });

  final NotificationAppLaunchDetails notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  initialRoute = BottomNavBar.routeName;

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails.payload;
    initialRoute = WakeUp.routeName;
  }

  print(initialRoute);
  runApp(
    MaterialApp(
      initialRoute: initialRoute,
      title: 'Snooze You Loose',
      theme: ThemeData(
        primarySwatch: SharedColors.kPrimaryColor,
        primaryColor: SharedColors.kPrimaryColor,
      ),
      routes: <String, WidgetBuilder>{
        BottomNavBar.routeName: (_) =>
            BottomNavBar(notificationAppLaunchDetails),
        WakeUp.routeName: (_) => WakeUp(selectedNotificationPayload)
      },
    ),
  );
}

/*class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snooze You Loose',
      theme: ThemeData(
        primarySwatch: SharedColors.kPrimaryColor,
        primaryColor: SharedColors.kPrimaryColor,
      ),
      //initialRoute: initalRoute,
      home: BottomNavBar(),
    );
  }
}*/

class WakeUp extends StatelessWidget {
  const WakeUp(
    this.payload, {
    Key key,
  }) : super(key: key);

  static const String routeName = '/wakeUp';

  final String payload;

  @override
  Widget build(BuildContext context) {
    final NotificationServices _ns = NotificationServices();
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: SharedColors.kSecoundaryColor,
          ),
          child: TextButton(
              onPressed: () {
                _ns.cancelAlarm();
                exit(0);
              },
              child: Text('Awake',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ))),
        ),
      ),
    );
  }
}
