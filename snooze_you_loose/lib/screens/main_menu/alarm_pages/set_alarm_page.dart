import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snooze_you_loose/models/alarm_model.dart';
import 'package:snooze_you_loose/screens/main_menu/bottom_nav_bar.dart';
import 'package:snooze_you_loose/services/alarm_services.dart';
import 'package:snooze_you_loose/services/notification_services.dart';
import 'package:snooze_you_loose/shared/day_button.dart';
import 'package:snooze_you_loose/shared/shared_colors.dart';

class SetAlarmOverlay extends StatefulWidget {
  final int id;
  final String time;
  final List<bool> weekDays;
  final bool exists;

  SetAlarmOverlay({this.id, this.weekDays, this.time, @required this.exists});
  @override
  _SetAlarmOverlayState createState() => _SetAlarmOverlayState();
}

class _SetAlarmOverlayState extends State<SetAlarmOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _scaleAnimation;

  AlarmServices _alarmServices = AlarmServices();
  final String _today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  NotificationServices _ns = NotificationServices();

  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache _audioCache;
  List<Map<String, String>> _sounds = [
    {"path": 'singing_birds', "name": 'Singing Birds'},
    {"path": 'ocean_waves', "name": 'Ocean Waves'}
  ];

  String _time;
  List<bool> _days;
  TimeOfDay _startTime;
  double _sliderVal = 0.5;
  int _soundVal = 0;
  Icon _playPause = Icon(
    Icons.play_arrow,
    size: 40,
    color: SharedColors.kPrimaryColor,
  );
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioCache = AudioCache(fixedPlayer: audioPlayer);

    if (widget.exists) {
      _time = widget.time;
      _days = widget.weekDays;
    } else {
      _time = '08:00';
      _days = [true, true, true, true, true, false, false];
    }

    _startTime = TimeOfDay.fromDateTime(DateTime.parse(_today + ' ' + _time));

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.elasticInOut);

    _controller.addListener(() {
      setState(() {});
    });
    _controller.forward();
  }

  String _boolsToInt(List<bool> listBools) {
    String days = '';
    for (bool i in listBools) {
      if (i)
        days += '1';
      else
        days += '0';
    }
    return days;
  }

  @override
  void dispose() {
    _controller.dispose();
    audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_boolsToInt(_days));
    double maxWidth = MediaQuery.of(context).size.width;
    TextStyle header = TextStyle(
        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]);
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_time,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 150,
                      width: maxWidth * 0.6,
                      child: CupertinoDatePicker(
                        use24hFormat: true,
                        mode: CupertinoDatePickerMode.time,
                        initialDateTime: new DateTime(
                            2021, 5, 27, _startTime.hour, _startTime.minute),
                        onDateTimeChanged: (DateTime newDateTime) {
                          setState(() =>
                              _time = DateFormat('hh:mm').format(newDateTime));
                        },
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Repeat: ', style: header),
                        Row(
                          children: [
                            DayButton(
                                isEnabled: _days[0],
                                day: 'M',
                                onClick: () {
                                  setState(() {
                                    if (_days[0])
                                      _days[0] = false;
                                    else
                                      _days[0] = true;
                                  });
                                }),
                            DayButton(
                                isEnabled: _days[1],
                                day: 'T',
                                onClick: () {
                                  setState(() {
                                    if (_days[1])
                                      _days[1] = false;
                                    else
                                      _days[1] = true;
                                  });
                                }),
                            DayButton(
                                isEnabled: _days[2],
                                day: 'W',
                                onClick: () {
                                  setState(() {
                                    if (_days[2])
                                      _days[2] = false;
                                    else
                                      _days[2] = true;
                                  });
                                }),
                            DayButton(
                                isEnabled: _days[3],
                                day: 'T',
                                onClick: () {
                                  setState(() {
                                    if (_days[3])
                                      _days[3] = false;
                                    else
                                      _days[3] = true;
                                  });
                                }),
                            DayButton(
                                isEnabled: _days[4],
                                day: 'F',
                                onClick: () {
                                  setState(() {
                                    if (_days[4])
                                      _days[4] = false;
                                    else
                                      _days[4] = true;
                                  });
                                }),
                            DayButton(
                                isEnabled: _days[5],
                                day: 'S',
                                onClick: () {
                                  setState(() {
                                    if (_days[5])
                                      _days[5] = false;
                                    else
                                      _days[5] = true;
                                  });
                                }),
                            DayButton(
                                isEnabled: _days[6],
                                day: 'S',
                                onClick: () {
                                  setState(() {
                                    if (_days[6])
                                      _days[6] = false;
                                    else
                                      _days[6] = true;
                                  });
                                }),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Volume: ', style: header),
                        Slider(
                            value: _sliderVal,
                            onChanged: (newVal) {
                              setState(() {
                                _sliderVal = newVal;
                                audioPlayer.setVolume(_sliderVal);
                              });
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Choice sound: ',
                          style: header,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2,
                                    color: SharedColors.kPrimaryColor),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: DropdownButton(
                                  underline: Container(),
                                  isExpanded: false,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: SharedColors.kPrimaryColor,
                                  ),
                                  style: TextStyle(
                                      color: SharedColors.kPrimaryColor,
                                      fontSize: 20),
                                  value: _soundVal,
                                  items: [
                                    DropdownMenuItem(
                                        value: 0,
                                        child: Text(
                                            _sounds[0].values.elementAt(1))),
                                    DropdownMenuItem(
                                        value: 1,
                                        child: Text(
                                            _sounds[1].values.elementAt(1)))
                                  ],
                                  onChanged: (val) {
                                    setState(() {
                                      _playPause = Icon(
                                        Icons.play_arrow,
                                        size: 40,
                                        color: SharedColors.kPrimaryColor,
                                      );
                                      _isPlaying = false;
                                      _soundVal = val;
                                      audioPlayer.stop();
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  print(_isPlaying);
                                  if (_isPlaying) {
                                    _isPlaying = false;
                                    _playPause = Icon(
                                      Icons.play_arrow,
                                      size: 40,
                                      color: SharedColors.kPrimaryColor,
                                    );
                                    audioPlayer.stop();
                                  } else {
                                    _isPlaying = true;
                                    _playPause = Icon(
                                      Icons.pause,
                                      size: 40,
                                      color: SharedColors.kPrimaryColor,
                                    );
                                    _audioCache.loop('sounds/' +
                                        _sounds[_soundVal].values.elementAt(0) +
                                        '.wav');
                                    audioPlayer.setVolume(_sliderVal);
                                  }
                                });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2,
                                      color: SharedColors.kPrimaryColor,
                                    ),
                                  ),
                                  child: _playPause),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel')),
                        TextButton(
                            onPressed: () {
                              if (widget.exists) {
                                var alarmModel = AlarmModel(
                                    id: widget.id,
                                    time: _time,
                                    repeat: _boolsToInt(_days),
                                    isEnabled: 1,
                                    alarmSound:
                                        _sounds[_soundVal].values.elementAt(0),
                                    volume: _sliderVal);
                                _alarmServices.update(alarmModel);
                                _ns.scheduleAlarm(
                                    widget.id, DateTime.parse(_time));
                              } else {
                                var alarmModel = AlarmModel(
                                    time: _time,
                                    repeat: _boolsToInt(_days),
                                    isEnabled: 1,
                                    alarmSound:
                                        _sounds[_soundVal].values.elementAt(0),
                                    volume: _sliderVal);
                                _alarmServices.insertAlarm(alarmModel);
                                _ns.scheduleAlarm(
                                    widget.id, DateTime.parse(_time));
                              }

                              Navigator.pop(context);
                            },
                            child: Text('OK'))
                      ],
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
