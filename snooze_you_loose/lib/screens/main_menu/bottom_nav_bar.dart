import 'package:flutter/material.dart';
import 'package:snooze_you_loose/screens/main_menu/alarm_pages/alarm_home_page.dart';
import 'package:snooze_you_loose/shared/shared_colors.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
