import 'package:flutter/material.dart';
import 'package:tickernotes/cloud/notes_model.dart';
import 'package:tickernotes/services/firestore_db.dart';
import 'package:uuid/uuid.dart';

class NotesProvider with ChangeNotifier {
  final firestoreService = FirestoreService();
  String _noteId;
  String _title;
  String _content;
  var uuID = Uuid();

  //Implementing Getters and Setters
  String get title {
    return this._title;
  }

  String get content {
    return this._content;
  }

  changeTitle(String val) {
    this._title = val;
    notifyListeners();
  }

  changeContent(String val) {
    this._content = val;
    notifyListeners();
  }

  saveNotes() {
    var notes = Notes(notesId: uuID.v4(), title: title, content: content);
    firestoreService.saveNotes(notes);
  }
}
