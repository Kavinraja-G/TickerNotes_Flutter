import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickernotes/cloud/notes_model.dart';
import 'package:tickernotes/provider/notes_provider.dart';
import 'package:tickernotes/services/auth.dart';

class CreateNotes extends StatefulWidget {
  final Notes notes;
  final User user;
  CreateNotes({this.notes, this.user});

  @override
  _CreateNotesState createState() => _CreateNotesState();
}

class _CreateNotesState extends State<CreateNotes> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.notes != null) {
      titleController.text = widget.notes.title;
      contentController.text = widget.notes.content;
      new Future.delayed(Duration.zero, () {
        //Init state only called when there is an object is inserted
        //to prevent the always listening mode of provider with the
        //controllers we need to add (listen : false)
        final providerForNotes = Provider.of<NotesProvider>(context, listen: false);
        providerForNotes.updateNotes(widget.notes);
      });
    } else {
      titleController.text = "";
      contentController.text = "";
      new Future.delayed(Duration.zero, () {
        final providerForNotes = Provider.of<NotesProvider>(context, listen: false);
        providerForNotes.updateNotes(Notes());
      });
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    final providerForNotes = Provider.of<NotesProvider>(context);
    return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.blue[900],
      title: Text('Notes'),
    ),
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[900], Colors.blue[100]],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
//Title Input Field

            TextField(
              controller: titleController,
              textAlign: TextAlign.justify,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: 'Title',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)
                ),
                hintStyle: TextStyle(color: Colors.white),
              ),
              onChanged: (value) => providerForNotes.changeTitle(value),
            ),

//Content INput Field

            TextField(
              cursorColor: Colors.white,
              textAlign: TextAlign.justify,
              controller: contentController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: 'Content',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)
                ),
                hintStyle: TextStyle(color: Colors.white),
              ),
              onChanged: (value) => providerForNotes.changeContent(value),
            ),

//Spacing

            SizedBox(
              height: 10,
            ),

//Icons for Add and cancel

            ButtonBar(
              children: <Widget>[
                RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.blue[900],
                  label: Text('Cancel'),
                  icon: Icon(Icons.cancel),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.blue[100],
                  label: Text('Add'),
                  icon: Icon(Icons.check_circle_outline),
                  onPressed: () {
                    providerForNotes.saveNotes(widget.user);
                    Navigator.of(context).pop();
                  }
                ),
              ],
            ),
          ],
        ),
      ),
    ),
      );
  }
}
