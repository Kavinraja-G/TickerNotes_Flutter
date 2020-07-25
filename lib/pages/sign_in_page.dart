import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickernotes/services/auth.dart';

class SignInPage extends StatefulWidget {
  final User user;
  SignInPage([this.user]);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;
  bool animate = false;
  String logo = 'images/question.png';
  Future<void> _signInGoogle(BuildContext context) {
    try {
      setState(() {
        _isLoading = true;
      });
      final auth = Provider.of<BaseAuthentication>(context, listen: false);
      auth.signInWithGoogle();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInAnonymous(BuildContext context) {
    try {
      setState(() {
        _isLoading = true;
      });
      final auth = Provider.of<BaseAuthentication>(context, listen: false);
      auth.signInAnonymously();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        title: Text('Ticker'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[900], Colors.blue[100], Colors.blue[900]],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(20),
        child: buildWidgets(context),
      ),
    );
  }

  Widget buildWidgets(BuildContext context) {
//If the sign in is in progress
    if (_isLoading == true)
      return Center(
        child: CircularProgressIndicator(),
      );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
//Spacing
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
        ),

//Text SignIn
        GestureDetector(
          onTap: () {
            setState(() {
              animate = !animate;
              logo = (animate) ? 'images/notes.png' : 'images/question.png';
            });
          },
          child: Center(
            child: AnimatedSwitcher(
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(child: child, scale: animation);
              },
              duration: const Duration(milliseconds: 500),
              child: Container(
                key: ValueKey<String>(logo),
                child: SizedBox(
                  width: 80,
                  child: Image.asset('$logo'),
                ),
              ),
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
            onPressed: _isLoading ? null : () => _signInGoogle(context),
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
            onPressed: _isLoading ? null : () => _signInAnonymous(context),
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
    );
  }
}
