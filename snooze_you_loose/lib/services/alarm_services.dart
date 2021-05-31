import 'package:snooze_you_loose/models/alarm_model.dart';
import 'package:sqflite/sqflite.dart';

final String tableAlarm = 'alarm';
final String colID = 'id';
final String colTime = 'time';
final String colEnabled = 'isEnabled';
final String colSound = 'alarmSound';
final String colVolume = 'alarmVolume';
final String colRepeat = 'alarmRepeat';

class AlarmServices {
  static Database _db;
  static AlarmServices _alarmServices;

  Future<Database> get database async {
    if (_db == null) _db = await initializeDatabase();
    return _db;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + 'alarm.db';

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(''' 
        CREATE TABLE IF NOT EXISTS $tableAlarm (
          $colID INTEGER PRIMARY KEY AUTOINCREMENT,
          $colTime TEXT NOT NULL,
          $colSound TEXT NOT NULL,
          $colRepeat TEXT NOT NULL,
          $colEnabled INTEGER,
          $colVolume REAL NOT NULL)
        ''').then((value) => print('tableCreated'));
      },
    );
    return database;
  }

  void insertAlarm(AlarmModel alarmModel) async {
    var db = await this.database;
    var result = await db.insert(tableAlarm, alarmModel.toMap());
    print(result);
  }

  Future<List<AlarmModel>> getAlarms() async {
    List<AlarmModel> _alarms = [];

    var db = await this.database;
    var result = await db.query(tableAlarm);
    result.forEach((element) {
      var alarmModel = AlarmModel.fromMap(element);
      _alarms.add(alarmModel);
    });
    return _alarms;
  }

  Future<int> delete(int id) async {
    var db = await this.database;
    var result =
        await db.delete(tableAlarm, where: '$colID = ?', whereArgs: [id]);
    print(result);
    return result;
  }

  Future<int> update(AlarmModel alarmModel) async {
    var db = await this.database;
    print(alarmModel.id);
    print(alarmModel.time);
    print(alarmModel.alarmSound);
    print(alarmModel.repeat);
    print(alarmModel.isEnabled);
    print(alarmModel.volume);

    var result = await db.update(tableAlarm, alarmModel.toMap(),
        where: '$colID = ?', whereArgs: [alarmModel.id]);

    print(result);
    return result;
  }
}
