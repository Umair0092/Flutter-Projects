import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/CreateNote.dart';
import 'package:untitled/models/reportModel.dart';
import 'package:untitled/services/db.dart';
import 'package:untitled/services/login_info.dart';


class Firedb{
  FirebaseAuth auth=FirebaseAuth.instance;


  createNewNote(Note note) async{
    LocalDataSaver.getSyncData().then((onValue)async{
      if(onValue??true){
        final User? currentUser=auth.currentUser;
        await FirebaseFirestore.instance.collection("notes").doc(currentUser!.email).collection("usernotes").doc(note.uniqueID.toString()).set({
          "title":note.title,
          "uniqueID":note.uniqueID,
          "content":note.content,
          "date":note.createdTime,
        }).then((onValue){
          print("Data Successfull");
        });
        }
    });

  }
  Future<List<Note>> getAllNotes() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      print("No user logged in");
      return []; // Return empty list if no user is logged in
    }

    try {
      // Fetch notes from Firestore
      final querySnapshot = await FirebaseFirestore.instance
          .collection("notes")
          .doc(currentUser.email)
          .collection("usernotes")
          .orderBy("date")
          .get();

      // Map Firestore documents to a list of Note objects
      final List<Note> notes = [];
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        print("Fetched note: $data"); // Debug print
        print("Title: ${data['title']}"); // Debug print

        // Create a Note object
        final note = Note(
          title: data['title'].toString(),
          uniqueID: data['uniqueID'].toString(),
          content: data['content'].toString(),
          pin: false,
          createdTime: (data['date'] as Timestamp).toDate(),
          isArchived: false,
        );

        // Check if the note already exists in the local database by uniqueID
        final existingNote = await NotesDB.instance.getNoteByUniqueID(note.uniqueID);
        print(existingNote);
        if (existingNote == null) {
          // If the note doesn't exist, insert it into the local database
          await NotesDB.instance.create(note);
          print("Inserted note with uniqueID: ${note.uniqueID}");
        } else {
          print("Skipped note with uniqueID: ${note.uniqueID} (already exists)");
        }

        // Add to the list to return, regardless of whether it was inserted
        notes.add(note);
      }

      return notes; // Return the list of notes
    } catch (e) {
      print("Error fetching notes: $e");
      return []; // Return empty list on error
    }
  }
    updateNotes(Note note) async{
      LocalDataSaver.getSyncData().then((onValue)async{
        if(onValue??true){
          final User? currentUser=auth.currentUser;
          await FirebaseFirestore.instance.collection("notes").doc(currentUser!.email).collection("usernotes").doc(note.uniqueID.toString()).update({"title":note.title.toString(),"content":note.content.toString()}).then((value){
            print("Data Entered Successfully");
          });
        }
      });

    }
    deleteNotes(Note note) async{
      LocalDataSaver.getSyncData().then((onValue)async{
        if(onValue??true){
          final User? currentUser=auth.currentUser;
          await FirebaseFirestore.instance.collection("notes").doc(currentUser!.email).collection("usernotes").doc(note.uniqueID.toString()).delete().then((_){
            print("successfully deleted");
          });
        }
      });


    }
}