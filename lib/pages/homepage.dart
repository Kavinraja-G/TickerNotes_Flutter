import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tickernotes/services/auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//Signout from Auth User in firebase
  Future<void> _LogOut(BuildContext context) async {
    try {
      final auth = Auth();
      await auth.signOut();
    } catch (error) {
      print(error.toString());
    }
  }

//Alert to confirm signout
  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text('Logout User'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure want to Logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop();
                _LogOut(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//Appbar Top
      appBar: AppBar(
        title: Text('Ticker'),
        backgroundColor: Colors.blue[900],
        actions: <Widget>[
          IconButton(
            onPressed: () => _showMyDialog(context),
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[900],Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),



//Add notes button 
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue[900],
        child: Icon(Icons.add),
      ),
    );
  }
}
