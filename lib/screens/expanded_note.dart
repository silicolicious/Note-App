import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/screens/add_note.dart';

class ExpandedNote extends StatelessWidget {
  const ExpandedNote({Key? key, required this.currentNote}) : super(key: key);
  final Note currentNote;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AddNote(
                email: FirebaseAuth.instance.currentUser?.email ?? "",
                isUpdate: true,
                note: currentNote,
              ),
            ),
          );
        },
        child: const Icon(CupertinoIcons.pencil),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 0,
                ),
                child: Center(
                  child: Text(
                    currentNote.title,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              Text(
                currentNote.keywordOrQuestion ?? "",
                style: TextStyle(fontSize: 20),
                maxLines: 3,
              ),
              const Divider(
                color: Colors.black,
              ),
              Text(
                currentNote.body ?? "",
                style: TextStyle(fontSize: 20),
                maxLines: null,
              ),
              const Divider(
                color: Colors.black,
              ),
              Text(
                currentNote.summary ?? "",
                style: TextStyle(fontSize: 20),
                maxLines: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
