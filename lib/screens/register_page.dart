import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/widgets/exception_alert.dart';

import 'all_notes.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late String username;
  late String password;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
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
              child: const Text("Register"),
              onPressed: () async {
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                    email: username,
                    password: password,
                  );
                  Navigator.pop(context);
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
