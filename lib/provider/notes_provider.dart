import 'package:flutter/material.dart';
import 'package:tickernotes/cloud/notes_model.dart';
import 'package:tickernotes/services/auth.dart';
import 'package:tickernotes/services/firestore_db.dart';
import 'package:uuid/uuid.dart';

class NotesProvider with ChangeNotifier {
  User user;
  final firestoreService = FirestoreService();
  String _notesId;
  String _title;
  String _content;
  var uuID = Uuid();
  NotesProvider([this.user]);

  //Implementing Getters and Setters
  String get title {
    return this._title;
  }

  String get content {
    return this._content;
  }

  String get noteId {
    return this._notesId;
  }

  changeTitle(String val) {
    this._title = val;
    notifyListeners();
  }

  changeContent(String val) {
    this._content = val;
    notifyListeners();
  }

  changeNoteId(String val) {
    this._notesId = val;
    notifyListeners();
  }

  updateNotes(Notes notes) {
    this._title = notes.title;
    this._content = notes.content;
    this._notesId = notes.notesId;
  }

  saveNotes(User user) {
    if(_notesId == null)
    {
      var notes = Notes(notesId: uuID.v4(), title: title, content: content);
      firestoreService.saveNotes(notes, user);
    }
    else  //This will replace the data when we edit
    {
      var notes = Notes(notesId: noteId, title: title, content: content);
      firestoreService.saveNotes(notes, user);
    }
  }


  deleteNotes(String noteID, User user) {
    firestoreService.deleteNotes(noteID, user);
  }
}
