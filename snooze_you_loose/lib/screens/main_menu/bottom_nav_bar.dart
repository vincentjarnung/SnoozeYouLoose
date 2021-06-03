import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:snooze_you_loose/main.dart';
import 'package:snooze_you_loose/screens/main_menu/alarm_pages/alarm_home_page.dart';
import 'package:snooze_you_loose/shared/shared_colors.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar(
    this.notificationAppLaunchDetails, {
    Key key,
  }) : super(key: key);

  static const String routeName = '/';

  final NotificationAppLaunchDetails notificationAppLaunchDetails;

  bool get didNotificationLaunchApp =>
      notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selIndex = 0;

  void initState() {
    super.initState();
    print('HEEEEYOOOOOO OVER HERER!!!!');
    print(widget.didNotificationLaunchApp);
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  void onItemTapped(int index) {
    setState(() {
      selIndex = index;
    });
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        WakeUp(receivedNotification.payload),
                  ),
                );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await Navigator.pushNamed(context, '/wakeUp');
    });
  }

  @override
  Widget build(BuildContext context) {
    print('HEEEEYOOOOOO OVER HERER!!!!');
    print(widget.didNotificationLaunchApp);
    final widgetOptions = [
      AlarmHomePage(),
      AlarmHomePage(),
    ];
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(selIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: SharedColors.kSecoundaryColor,
        backgroundColor: Color(0xFFE4FFFA),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Alarm'),
          BottomNavigationBarItem(
              icon: Icon(Icons.house), label: 'Organisations'),
        ],
        currentIndex: selIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
