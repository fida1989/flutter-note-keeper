import 'package:flutter/material.dart';
import 'screens/note_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note Keeper',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.deepPurple,
      ),
      home: NoteList(),
    );
  }
}


