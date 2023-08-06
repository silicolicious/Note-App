import 'package:flutter/material.dart';
import 'package:note_app/providers/notes_provider.dart';
import 'package:note_app/providers/themes_provider.dart';
import 'package:note_app/providers/view_provider.dart';
import 'package:note_app/screens/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var themeMode = prefs.getString('theme') ?? 'ThemeMode.light';
  var viewMode = prefs.getString('view') ?? 'list';
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<NotesProvider>(
            create: (context) => NotesProvider()),
        ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider(
                mode: themeMode == 'ThemeMode.light'
                    ? ThemeMode.light
                    : ThemeMode.dark)),
        ChangeNotifierProvider<ViewProvider>(
            create: (context) => ViewProvider(
                mode: viewMode == 'list'
                    ? ViewMode.listView
                    : ViewMode.gridView)),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget with ChangeNotifier {
  MyApp({super.key});

  initState() {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFE6D1F2),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: Provider.of<ThemeProvider>(context).mode,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
