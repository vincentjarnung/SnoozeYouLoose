import 'package:flutter/material.dart';

class AlarmModel {
  final int id;
  final String time;
  String repeat;
  int isEnabled;
  double volume;
  String alarmSound;

  AlarmModel(
      {this.id,
      @required this.time,
      @required this.repeat,
      @required this.isEnabled,
      this.volume,
      this.alarmSound});

  factory AlarmModel.fromMap(Map<String, dynamic> json) => AlarmModel(
      id: json["id"],
      time: json["time"],
      alarmSound: json['alarmSound'],
      repeat: (json["alarmRepeat"]),
      isEnabled: json["isEnabled"],
      volume: json["alarmVolume"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "time": time,
        "alarmSound": alarmSound,
        "alarmRepeat": repeat,
        "isEnabled": isEnabled,
        "alarmVolume": volume,
      };
}
