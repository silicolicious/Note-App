import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/screens/add_note.dart';
import 'package:note_app/screens/expanded_note.dart';
import 'package:note_app/screens/home_page.dart';
import 'package:note_app/screens/settings_page.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';
import '../providers/themes_Provider.dart';
import '../providers/view_provider.dart';
import '../widgets/exception_alert.dart';

enum ViewType { listView, gridView }

class NoteHome extends StatefulWidget {
  static String id = "NoteHome";
  const NoteHome({Key? key}) : super(key: key);

  @override
  State<NoteHome> createState() => _NoteHomeState();
}

class _NoteHomeState extends State<NoteHome> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  String searchText = "";

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      showAlertDialog(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Your Notes"),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.settings,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: (notesProvider.isLoading == false)
            ? SafeArea(
                child: (notesProvider.notes.isEmpty)
                    ? const Padding(
                        padding: EdgeInsets.only(top: 25.0),
                        child: Center(
                          child: Text('No notes available'),
                        ),
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 15.0,
                            ),
                            child: TextField(
                              onTap: () {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);

                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                              },
                              onChanged: (txt) {
                                setState(() {
                                  searchText = txt;
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: 'Search',
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: double.infinity,
                              child: Provider.of<ViewProvider>(context).mode ==
                                      ViewMode.listView
                                  ? ListViewNote(
                                      notesProvider: notesProvider,
                                      searchText: searchText,
                                    )
                                  : GridViewNote(
                                      notesProvider: notesProvider,
                                      searchText: searchText,
                                    ),
                            ),
                          ),
                        ],
                      ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (context) => AddNote(
                  email: loggedInUser.email ?? "",
                  isUpdate: false,
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class ListViewNote extends StatelessWidget {
  const ListViewNote({
    Key? key,
    required this.notesProvider,
    required this.searchText,
  }) : super(key: key);

  final NotesProvider notesProvider;
  final String searchText;

  @override
  Widget build(BuildContext context) {
    // ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return ListView.separated(
      shrinkWrap: true,
      itemCount: notesProvider.getSearchNotes(searchText).length,
      itemBuilder: (BuildContext context, int index) {
        Note currentNote = notesProvider.getSearchNotes(searchText)[index];
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListTile(
            title: Text(
              currentNote.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                letterSpacing: 1,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              currentNote.body!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => ExpandedNote(
                    currentNote: currentNote,
                  ),
                ),
              );
            },
            onLongPress: () {
              notesProvider.deleteNote(currentNote);
            },
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(color: Colors.black);
      },
    );
  }
}

class GridViewNote extends StatelessWidget {
  const GridViewNote({
    Key? key,
    required this.notesProvider,
    required this.searchText,
  }) : super(key: key);

  final NotesProvider notesProvider;
  final String searchText;

  @override
  Widget build(BuildContext context) {
    // ThemeProvider themeProvider =
    //     Provider.of<ThemeProvider>(context, listen: true);
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      shrinkWrap: true,
      itemCount: notesProvider.getSearchNotes(searchText).length,
      itemBuilder: (BuildContext context, int index) {
        Note currentNote = notesProvider.getSearchNotes(searchText)[index];
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: GestureDetector(
            child: Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    width: 2,
                  )),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      currentNote.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        letterSpacing: 1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    currentNote.body!,
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => ExpandedNote(
                    currentNote: currentNote,
                  ),
                ),
              );
            },
            onLongPress: () {
              notesProvider.deleteNote(currentNote);
            },
          ),
        );
      },
    );
  }
}
