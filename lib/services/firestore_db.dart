import 'package:cloud_firestore/cloud_firestore.dart';
import '../cloud/notes_model.dart';

class FirestoreService {
  Firestore _database = Firestore.instance;

  Future<void> saveNotes(Notes notes){
    return _database.collection('notes').document(notes.notesId).setData(notes.toMap());
  }
}
