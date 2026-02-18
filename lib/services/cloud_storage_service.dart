import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/models/cloud_note.dart';

class FirebaseCloudStorage {
  // 1. Create a private constructor (so nobody else can create an instance)
  FirebaseCloudStorage._sharedInstance();
  
  // 2. The single, static instance of this class
  static final FirebaseCloudStorage _shared = FirebaseCloudStorage._sharedInstance();
  
  // 3. The factory constructor that always returns the same instance
  factory FirebaseCloudStorage() => _shared;

  // 4. The link to your "notes" collection in Firebase
  final notes = FirebaseFirestore.instance.collection('notes');





// --- CRUD Operations ---

  // CREATE: Save a new note with a title and empty text
  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    // 1. Tell Firestore to add a new document to the 'notes' collection
    final document = await notes.add({
      'owner_user_id': ownerUserId,
      'title': '', // Start with an empty title
      'text': '',  // Start with empty text
    });
    
    // 2. Fetch the document we just created to get its unique ID
    final fetchedNote = await document.get();
    
    // 3. Convert that Firebase data into our professional CloudNote model
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      title: '',
      text: '',
    );
  }




  // READ: Get all notes for a specific user as a Stream
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    return notes
        .where('owner_user_id', isEqualTo: ownerUserId) // Security: Only get YOUR notes
        .snapshots() // This makes it a "live" stream
        .map((event) => event.docs.map((doc) => CloudNote(
              documentId: doc.id,
              ownerUserId: doc.data()['owner_user_id'] as String,
              title: doc.data()['title'] as String,
              text: doc.data()['text'] as String,
            )));
  }



  // UPDATE: Change the content of an existing note
  Future<void> updateNote({
    required String documentId,
    required String title,
    required String text,
  }) async {
    try {
      // Find the specific 'file' in the 'cabinet' using its unique ID
      await notes.doc(documentId).update({
        'title': title,
        'text': text,
      });
    } catch (e) {
      throw Exception('Could not update note');
    }
  }

  // DELETE: Remove a note forever
  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw Exception('Could not delete note');
    }
  }

}