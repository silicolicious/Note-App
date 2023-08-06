import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String id;
  String title;
  String? keywordOrQuestion;
  String? body;
  String? summary;
  String userEmail;

  Note(
      {required this.title,
      this.keywordOrQuestion,
      this.body,
      this.summary,
      required this.userEmail,
      required this.id});

  Map<String, dynamic> toMap() {
    return {
      'Title': title,
      'KeywordsOrQuestions': keywordOrQuestion,
      'Body': body,
      'Summary': summary,
      'Sender': userEmail
    };
  }

  factory Note.fromJson(Map<String, dynamic> json, String id) {
    return Note(
      id: id,
      title: json['Title'],
      keywordOrQuestion: json['KeywordsOrQuestions'],
      body: json['Body'],
      summary: json['Summary'],
      userEmail: json['Sender'],
    );
  }

  factory Note.fromFirestore(DocumentSnapshot doc) {
    return Note(
      id: doc.id,
      title: doc['Title'],
      keywordOrQuestion: doc['KeywordsOrQuestions'],
      body: doc['Body'],
      summary: doc['Summary'],
      userEmail: doc['Sender'],
    );
  }
}
