import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:snooze_you_loose/models/alarm_model.dart';
import 'package:snooze_you_loose/screens/main_menu/alarm_pages/set_alarm_page.dart';
import 'package:snooze_you_loose/services/alarm_services.dart';
import 'package:timezone/browser.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class AlarmHomePage extends StatefulWidget {
  @override
  AlarmHomePageState createState() => AlarmHomePageState();
}

class AlarmHomePageState extends State<AlarmHomePage> {
  Future<List<AlarmModel>> _alarms;
  AlarmServices _alarmServices = AlarmServices();
  String path = 'sounds/singingBirds.mp3';

  @override
  void initState() {
    super.initState();

    print('state');
    _alarmServices.initializeDatabase().then((value) {
      _loadAlarms();
    });
  }

  List<bool> _getBools(String days) {
    List<bool> weekDays = [];

    for (int i = 1; i < days.length + 1; i++) {
      if (days.substring(i - 1, i) == '1')
        weekDays.add(true);
      else
        weekDays.add(false);
    }

    return weekDays;
  }

  String _getDays(List<bool> boolDays) {
    String days = '';

    if (boolDays[0]) days += 'Mon ';
    if (boolDays[1]) days += 'Tue ';
    if (boolDays[2]) days += 'Wed ';
    if (boolDays[3]) days += 'Thu ';
    if (boolDays[4]) days += 'Fri ';
    if (boolDays[5]) days += 'Sat ';
    if (boolDays[6]) days += 'Sun ';

    return days;
  }

  void _loadAlarms() {
    _alarms = _alarmServices.getAlarms().whenComplete(() => setState(() {}));
  }

  Future _deleteData(int id) async {
    await _alarmServices.delete(id);
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Color(0xFFD3E7F8),
            Color(0xFFD3E7F8),
            Color(0xFFDEF6FA),
            Color(0xFFE4FFFA)
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 50,
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Alarms',
                  style: TextStyle(fontSize: 20),
                ),
              )),
              FutureBuilder(
                  future: _alarms,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    return ListView(
                      shrinkWrap: true,
                      children: snapshot.data.map<Widget>((alarm) {
                        return Center(
                            child: GestureDetector(
                          onLongPress: () {
                            _deleteData(alarm.id)
                                .whenComplete(() => _loadAlarms());
                          },
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) => SetAlarmOverlay(
                                    id: alarm.id,
                                    exists: true,
                                    time: alarm.time,
                                    weekDays: _getBools(alarm.repeat)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                            child: Container(
                              height: 70,
                              decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          alarm.time,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(_getDays(_getBools(alarm.repeat)))
                                      ],
                                    ),
                                    Switch(
                                        value: alarm.isEnabled == 1,
                                        onChanged: (newVal) {
                                          setState(() {
                                            if (newVal) {
                                              _scheduleAlarm();
                                              alarm.isEnabled = 1;
                                            } else {
                                              alarm.isEnabled = 0;
                                            }
                                          });
                                        })
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ));
                      }).toList(),
                    );
                  }),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) => SetAlarmOverlay(
                      exists: false,
                    )).whenComplete(() => _loadAlarms());
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void _scheduleAlarm() async {
    print('ggggo');

    DateTime scheduledNotificationDayTime =
        DateTime.now().add(Duration(seconds: 10));

    tz.TZDateTime time = tz.TZDateTime.from(
        scheduledNotificationDayTime, tz.getLocation('Stockholm/Sweden'));

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      icon: 'codex_logo',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('codex_logo'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        0, 'Office', 'Title', time, platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
