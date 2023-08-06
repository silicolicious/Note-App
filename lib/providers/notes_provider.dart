import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

final _firestore = FirebaseFirestore.instance;

class NotesProvider with ChangeNotifier {
  List<Note> notes = [];
  bool isLoading = false;
  bool isDataFetched = false;
  int i = 0;

  NotesProvider() {
    refreshNotes();
  }

  void addNote(Note newNote) {
    notes.add(newNote);
    _firestore.collection('notes').doc(newNote.id).set(newNote.toMap());
    notifyListeners();
  }

  void updateNote(Note currentNote) {
    int noteIndex = notes.indexOf(
      notes.firstWhere((element) => element.id == currentNote.id),
    );
    notes[noteIndex] = currentNote;
    _firestore
        .collection('notes')
        .doc(currentNote.id)
        .update(currentNote.toMap());
    notifyListeners();
  }

  void deleteNote(Note currentNote) {
    int noteIndex = notes.indexOf(
      notes.firstWhere((element) => element.id == currentNote.id),
    );
    notes.removeAt(noteIndex);
    _firestore.collection('notes').doc(currentNote.id).delete();
    notifyListeners();
  }

  Future<void> refreshNotes() async {
    i++;
    print("$i ");
    if (i > 5) return;
    print("passed\n\n\n");
    notes.clear();
    isLoading = true;
    if (isDataFetched) return;
    String currentUser = FirebaseAuth.instance.currentUser?.email ?? "";
    QuerySnapshot<Map<String, dynamic>> allDocs = await _firestore
        .collection('notes')
        .where("Sender", isEqualTo: currentUser)
        .get();
    for (int i = 0; i < allDocs.docs.length; i++) {
      QueryDocumentSnapshot<Map<String, dynamic>> curDoc = allDocs.docs[i];
      notes.add(
        Note(
          title: curDoc['Title'],
          keywordOrQuestion: curDoc['KeywordsOrQuestions'],
          body: curDoc['Body'],
          summary: curDoc['Summary'],
          userEmail: curDoc['Sender'],
          id: curDoc.id,
        ),
      );
    }
    isLoading = false;
    isDataFetched = true;
    notifyListeners();
  }

  List<Note> getSearchNotes(String search) {
    return notes
        .where((element) =>
            element.title.toLowerCase().contains(
                  search.toLowerCase(),
                ) ||
            element.keywordOrQuestion!.toLowerCase().contains(
                  search.toLowerCase(),
                ) ||
            element.body!.toLowerCase().contains(
                  search.toLowerCase(),
                ) ||
            element.summary!.toLowerCase().contains(
                  search.toLowerCase(),
                ))
        .toList();
  }
}
