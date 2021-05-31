import 'package:flutter/material.dart';
import 'package:snooze_you_loose/shared/shared_colors.dart';

class DayButton extends StatelessWidget {
  final bool isEnabled;
  final String day;
  final Function onClick;
  DayButton(
      {@required this.isEnabled, @required this.day, @required this.onClick});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 35,
        decoration: BoxDecoration(
            color: !isEnabled ? Colors.white : SharedColors.kPrimaryColor,
            shape: BoxShape.circle,
            border: Border.all(color: SharedColors.kPrimaryColor, width: 1)),
        child: TextButton(
          style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith(
                  (states) => Colors.transparent)),
          onPressed: onClick,
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                color: isEnabled ? Colors.white : SharedColors.kPrimaryColor),
          ),
        ),
      ),
    );
  }
}
