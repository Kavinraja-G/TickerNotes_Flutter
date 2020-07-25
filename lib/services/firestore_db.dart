import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tickernotes/services/auth.dart';
import '../cloud/notes_model.dart';

class FirestoreService {
  //FirebaseUser user;
  Firestore _db = Firestore.instance;
  Future<void> saveNotes(Notes notes, User user) {
    return _db
        .collection('notes-' + user.uid)
        .document(notes.notesId)
        .setData(notes.toMap());
  }

  Stream<List<Notes>> getNotes(User user) {
    return _db.collection('notes-' + user.uid).snapshots().map((snapshot) =>
        snapshot.documents
            .map((document) => Notes.fromFirestore(document.data))
            .toList());
  }

  Future<void> deleteNotes(String noteID, User user) {
    return _db
        .collection('notes-' + user.uid)
        .document(noteID)
        .delete();
  }
}
