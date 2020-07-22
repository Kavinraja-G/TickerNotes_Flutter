import 'package:flutter/material.dart';
import 'package:tickernotes/pages/basepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TickerNotes',
        home : BasePage(),
    );
  }
}
