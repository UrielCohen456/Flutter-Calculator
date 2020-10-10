import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final double fontSize;
  final Function onPressed;

  ActionButton(this.text, this.textColor, this.fontSize, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      minWidth: 70.0,
      height: 50.0,
      color: Colors.grey[300],
      highlightColor: Colors.grey[700],
    );
  }
}
