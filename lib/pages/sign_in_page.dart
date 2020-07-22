import 'package:flutter/material.dart';
import 'package:tickernotes/services/auth.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  Future<void> _signInGoogle(BuildContext context) {
    final auth = Auth();
    auth.signInWithGoogle();
    setState(() {});
  }

  Future<void> _signInAnonymous(BuildContext context) {
    final auth = Auth();
    auth.signInAnonymously();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        title: Text('Ticker'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[800], Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
//Spacing
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
            ),

//Text SignIn
            Center(
              child: Text(
                'Sign in',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: MediaQuery.of(context).size.width * 0.1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

//Spacing
            SizedBox(
              height: 25,
            ),

//Sign in with Google
            SizedBox(
              height: 45,
              child: RaisedButton(
                onPressed: () => _signInGoogle(context),
                elevation: 15,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Image.asset(
                      'images/google-logo.png',
                    ),
                    Text('Sign with Google'),
                    Opacity(
                      opacity: 0,
                      child: Image.asset(
                        'images/google-logo.png',
                      ),
                    ),
                  ],
                ),
              ),
            ),

//Spacing
            SizedBox(
              height: 20,
            ),

//Sign in Anonymously
            SizedBox(
              height: 45,
              child: RaisedButton(
                onPressed: () => _signInAnonymous(context),
                elevation: 15,
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Image.asset(
                      'images/icons8-fraud-96.png',
                    ),
                    Text(
                      'Sign Anonymously',
                      style: TextStyle(color: Colors.white),
                    ),
                    Opacity(
                      opacity: 0,
                      child: Image.asset(
                        'images/google-logo.png',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
