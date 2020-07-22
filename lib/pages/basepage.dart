import 'package:flutter/material.dart';
import 'package:tickernotes/pages/homepage.dart';
import 'package:tickernotes/pages/sign_in_page.dart';
import 'package:tickernotes/services/auth.dart';

class BasePage extends StatelessWidget {
  @override
  final auth = Auth();
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: auth.onChangedAuthstate,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null)
            return SignInPage();
          else
            return HomePage();
        } 
        else {
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
