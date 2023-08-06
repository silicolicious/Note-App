import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/screens/all_notes.dart';
import 'package:note_app/screens/settings_page.dart';
import 'package:note_app/widgets/exception_alert.dart';
import 'package:provider/provider.dart';

import '../providers/notes_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String username;
  late String password;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      // backgroundColor: Colors.lightBlueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FractionallySizedBox(
              widthFactor: 0.8,
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  hintText: 'Enter Username',
                ),
                onChanged: (value) {
                  username = value;
                },
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter Password',
                ),
                onChanged: (value) {
                  password = value;
                },
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              child: Text("Login"),
              onPressed: () async {
                try {
                  final user = await _auth.signInWithEmailAndPassword(
                    email: username,
                    password: password,
                  );
                  // Navigator.pop(context);
                  Provider.of<NotesProvider>(context, listen: false)
                      .refreshNotes();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteHome(),
                    ),
                  );
                } catch (e) {
                  showAlertDialog(context, e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
