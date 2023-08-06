import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/screens/all_notes.dart';
import 'package:note_app/screens/login_page.dart';
import 'package:note_app/screens/register_page.dart';

class HomePage extends StatelessWidget {
  static String id = "HomePage";
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const NoteHome();
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text("Note App"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PageButton(
                  buttonText: "Register",
                  page: RegisterPage(),
                ),
                PageButton(
                  buttonText: "Login",
                  page: LoginPage(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PageButton extends StatelessWidget {
  const PageButton({super.key, required this.page, required this.buttonText});
  final Widget page;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      },
      child: Text(buttonText),
    );
  }
}
