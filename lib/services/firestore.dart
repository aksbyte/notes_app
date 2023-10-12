import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreServices {
  // get collection of notes
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

// Create add new notes
  Future<void> addNote(String note) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }

// Read get notes from database
  Stream<QuerySnapshot> getNoteStream() {
    final notesStream =
        notes.orderBy('timestamp', descending: true).snapshots();
    return notesStream;
  }

// Update notes given a doc id

  Future<void> updateNote(String docID, String newNote) {
    return notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

// Delete given notes a doc id

  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
}
