import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickernotes/pages/basepage.dart';
import 'package:tickernotes/provider/notes_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotesProvider(),
      child: MaterialApp(
        title: 'TickerNotes',
        home: BasePage(),
      ),
    );
  }
}
