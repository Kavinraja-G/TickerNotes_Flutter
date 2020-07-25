import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:tickernotes/cloud/notes_model.dart';
import 'package:tickernotes/pages/createnotes.dart';
import 'package:tickernotes/provider/notes_provider.dart';
import 'package:tickernotes/services/auth.dart';

class HomePage extends StatefulWidget {
  final User currentUser;
  HomePage([this.currentUser]);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _LogOut(BuildContext context) async {
    try {
      final auth = Provider.of<BaseAuthentication>(context, listen: false);
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

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notesDatabase = Provider.of<List<Notes>>(context);
    final notesProvider = Provider.of<NotesProvider>(context);
    final auth = Provider.of<BaseAuthentication>(context);
    return Scaffold(
      //Appbar Top
      appBar: AppBar(
        title: Text('Ticker'),
        backgroundColor: Colors.blue[900],
      ),

      drawer: StreamBuilder<FirebaseUser>(
          stream: auth.currentFirebaseUser,
          builder: (context, snapshot) {
            final firebaseUser = snapshot.data;
            String providerUser;
            String providerMail;
            print(firebaseUser);
            for (UserInfo profile in firebaseUser.providerData) {
              providerUser = profile.providerId;
              providerMail = profile.email;
            }
            final displayName = (providerUser != 'google.com')
                ? 'Anonymous'
                : firebaseUser.displayName;

            return Drawer(
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Colors.blue[900], Colors.blue[100]],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      currentAccountPicture: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blue[100],
                        backgroundImage: (providerUser != 'google.com')
                            ? AssetImage('images/icons8-fraud-96.png')
                            : NetworkImage(firebaseUser.photoUrl),
                      ),
                      accountName: Text(
                        '$displayName',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        maxLines: 2,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
                      accountEmail: (providerUser != 'google.com')
                          ? null
                          : Text('$providerMail'),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue[900], Colors.blue[100]],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                      indent: 10,
                      endIndent: 10,
                    ),
                    ListTile(
                      onTap: () => _showMyDialog(context),
                      leading: Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Icon(
                        Icons.exit_to_app,
                        color: Colors.red,
                      ),
                    ),
                    ListTile(
                      leading:
                          Text('Help', style: TextStyle(color: Colors.white)),
                      trailing: Icon(
                        Icons.help_outline,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

      body: ((notesDatabase != null)
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[100], Colors.blue[900]],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(5),
                child: StaggeredGridView.countBuilder(
                          staggeredTileBuilder: (int index) {
                            return StaggeredTile.fit(2);
                          },
                          crossAxisCount: 4,
                          itemCount: notesDatabase.length,
                          itemBuilder: (context, index) {
                            return Card(
                                color: Colors.white70,
                                elevation: 15,
                                child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      notesDatabase[index].title,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      notesDatabase[index].content,
                                      style: TextStyle(fontSize: 14,color: Colors.black),
                                      textAlign: TextAlign.left,
                                    ),
                                    onLongPress: () {
                                        Scaffold.of(context).showSnackBar(SnackBar(
                                            content: Text(
                                              'Are you sure want to Delete?',
                                            ),
                                            duration: Duration(seconds: 2),
                                            action: SnackBarAction(
                                                label: 'Yes',
                                                onPressed: () {
                                                  notesProvider.deleteNotes(
                                                      notesDatabase[index].notesId,
                                                      widget.currentUser);
                                                } 
                                              )
                                            )
                                          );
                                    },
                                    //To Edit current note
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => CreateNotes(
                                                notes: notesDatabase[index],
                                                user: widget.currentUser))),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[100], Colors.blue[900]],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            )),

      //Add notes button
      floatingActionButton: FloatingActionButton(
        elevation: 20,
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CreateNotes(user: widget.currentUser),
        )),
        backgroundColor: Colors.blue[100],
        child: Icon(
          Icons.add,
          color: Colors.blue[900],
        ),
      ),
    );
  }
}
