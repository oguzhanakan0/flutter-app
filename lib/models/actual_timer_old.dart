import 'dart:async';
import 'package:flutter/material.dart';

class ActualTimer extends StatefulWidget {
  @override
  _ActualTimerState createState() => new _ActualTimerState();
}

class _ActualTimerState extends State<ActualTimer> {
  @override
  initState() {
    super.initState();
    new Timer(const Duration(seconds: 3), onClose);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 0.0);
  }

  void onClose() {
    Navigator.of(context).pushReplacementNamed('/signup_verifyphone');
  }
}