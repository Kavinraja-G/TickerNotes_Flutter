import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tickernotes/pages/basepage.dart';
import 'package:tickernotes/provider/notes_provider.dart';
import 'package:tickernotes/services/auth.dart';
import 'package:tickernotes/services/firestore_db.dart';

void main() {
  // //Lock Portrait use case
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    final auth = Auth();
    return Provider<BaseAuthentication>(
          create: (context) => auth,
          child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => NotesProvider()),
          ],
          child: MaterialApp(
            title: 'TickerNotes',
            home: BasePage(),
          ),
      ),
    );
  }
}
