import 'package:flutter/material.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/providers/notes_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddNote extends StatefulWidget {
  const AddNote(
      {Key? key, required this.email, required this.isUpdate, this.note})
      : super(key: key);
  final String email;
  final bool isUpdate;
  final Note? note;
  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  FocusNode keyFocus = FocusNode();
  TextEditingController titleController = TextEditingController(),
      keywordQuestionController = TextEditingController(),
      bodyController = TextEditingController(),
      summaryController = TextEditingController();

  void addNewNote() {
    Note newNote = Note(
      id: const Uuid().v1(),
      title: titleController.text,
      keywordOrQuestion: keywordQuestionController.text,
      body: bodyController.text,
      summary: summaryController.text,
      userEmail: widget.email,
    );
    Provider.of<NotesProvider>(context, listen: false).addNote(newNote);
    Navigator.pop(context);
  }

  void updateCurrentNote() {
    widget.note!.title = titleController.text;
    widget.note!.keywordOrQuestion = keywordQuestionController.text;
    widget.note!.body = bodyController.text;
    widget.note!.summary = summaryController.text;
    widget.note!.userEmail = widget.email;
    Provider.of<NotesProvider>(context, listen: false).updateNote(widget.note!);
    Navigator.pop(context);
  }

  @override
  void initState() {
    if (widget.isUpdate) {
      titleController.text = widget.note!.title;
      keywordQuestionController.text = widget.note!.keywordOrQuestion!;
      bodyController.text = widget.note!.body!;
      summaryController.text = widget.note!.summary!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              if (widget.isUpdate) {
                updateCurrentNote();
              } else {
                addNewNote();
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          child: ListView(
            children: [
              TextField(
                controller: titleController,
                onSubmitted: (val) {
                  if (val != "") {
                    keyFocus.requestFocus();
                  }
                },
                decoration: const InputDecoration(hintText: "Title"),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                autofocus: !widget.isUpdate,
              ),
              TextField(
                controller: keywordQuestionController,
                focusNode: keyFocus,
                decoration: InputDecoration(hintText: "Keywords/Questions"),
                style: TextStyle(fontSize: 20),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 3,
              ),
              TextField(
                controller: bodyController,
                onSubmitted: (val) {},
                decoration: InputDecoration(hintText: "Body"),
                style: TextStyle(fontSize: 20),
                maxLines: null,
              ),
              TextField(
                controller: summaryController,
                onSubmitted: (val) {},
                decoration: InputDecoration(
                  hintText: "Summary",
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 20),
                keyboardType: TextInputType.multiline,
                maxLines: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
