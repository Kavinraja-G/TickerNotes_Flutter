import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickernotes/provider/notes_provider.dart';

class CreateNotes extends StatelessWidget {
  @override
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
            colors: [Colors.white, Colors.blue[900]],
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
                decoration: InputDecoration(
                  hintText: 'Title',
                ),
                onChanged: (value) => providerForNotes.changeTitle(value),
              ),

//Content INput Field

              Container(
                child: TextField(
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: 'Content',
                  ),
                  onChanged: (value) => providerForNotes.changeContent(value),
                ),
              ),

//Spacing

              SizedBox(
                height: 10,
              ),

//Icons for Add and cancel

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.cancel),
                    iconSize: 30,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  IconButton(
                      icon: Icon(Icons.check_circle_outline),
                      iconSize: 30,
                      onPressed: () 
                      {
                        providerForNotes.saveNotes();
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
