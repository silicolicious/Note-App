import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/providers/notes_provider.dart';
import 'package:note_app/providers/themes_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/view_provider.dart';
import 'home_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    ThemeProvider theme = Provider.of<ThemeProvider>(context, listen: false);
    ViewProvider view = Provider.of<ViewProvider>(context, listen: false);
    List<bool> selectedViewButton =
        view.mode == ViewMode.listView ? [true, false] : [false, true];
    List<bool> selectedThemeButton =
        theme.mode == ThemeMode.light ? [true, false] : [false, true];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'View Mode: ',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                ToggleButtons(
                  direction: Axis.horizontal,
                  onPressed: (int index) async {
                    setState(() {
                      if (index == 0) {
                        selectedViewButton = [true, false];
                        if (view.mode == ViewMode.gridView) view.toggleMode();
                      } else {
                        selectedViewButton = [false, true];
                        if (view.mode == ViewMode.listView) view.toggleMode();
                      }
                    });
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('view',
                        view.mode == ViewMode.listView ? "list" : "grid");
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: Colors.black12,
                  selectedColor: Colors.black,
                  fillColor: Colors.white,
                  color: Colors.white,
                  constraints: const BoxConstraints(
                    minHeight: 40.0,
                    minWidth: 40.0,
                  ),
                  isSelected: selectedViewButton,
                  children: const [Icon(Icons.list), Icon(Icons.grid_view)],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Theme: ',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                ToggleButtons(
                  direction: Axis.horizontal,
                  onPressed: (int index) async {
                    setState(() {
                      if (index == 0) {
                        selectedThemeButton = [true, false];
                        if (theme.mode == ThemeMode.dark) theme.toggleMode();
                      } else {
                        selectedThemeButton = [false, true];
                        if (theme.mode == ThemeMode.light) theme.toggleMode();
                      }
                    });
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('theme', theme.mode.toString());
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: Colors.black12,
                  selectedColor: Colors.black,
                  fillColor: Colors.white,
                  color: Colors.white,
                  constraints: const BoxConstraints(
                    minHeight: 40.0,
                    minWidth: 40.0,
                  ),
                  isSelected: selectedThemeButton,
                  children: const [Icon(Icons.sunny), Icon(Icons.mode_night)],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Logout: ",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.logout,
                ),
                onPressed: () {
                  Provider.of<NotesProvider>(context, listen: false)
                      .notes
                      .clear();
                  Provider.of<NotesProvider>(context, listen: false)
                      .isDataFetched = false;
                  Provider.of<NotesProvider>(context, listen: false).i = 0;
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
