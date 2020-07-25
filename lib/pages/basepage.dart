import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickernotes/cloud/notes_model.dart';
import 'package:tickernotes/pages/homepage.dart';
import 'package:tickernotes/pages/sign_in_page.dart';
import 'package:tickernotes/services/auth.dart';
import 'package:tickernotes/services/firestore_db.dart';

class BasePage extends StatefulWidget {
  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<BaseAuthentication>(context);
    final firestoreDatabase = FirestoreService();
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null)
            return SignInPage(user);
          else
            return StreamProvider<List<Notes>>(
              create:(context) => firestoreDatabase.getNotes(user),
              builder: (context, snapshot) => HomePage(user),
              );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
