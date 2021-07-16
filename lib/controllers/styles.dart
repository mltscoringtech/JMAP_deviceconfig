import 'package:flutter/material.dart';

final TextTheme textTheme = TextTheme(
  headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
  caption: TextStyle(fontSize: 22),
  bodyText2: TextStyle(fontSize: 22),
  bodyText1: TextStyle(fontSize: 22),
);

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    padding: EdgeInsets.all(0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ));
