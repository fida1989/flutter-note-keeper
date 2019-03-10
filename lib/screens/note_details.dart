import 'package:flutter/material.dart';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/utils/database_helper.dart';
import 'package:intl/intl.dart';

class NoteDetails extends StatefulWidget {
  final String title;
  final Note note;

  NoteDetails(this.note, this.title);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteDetailsState(this.note, this.title);
  }
}

class NoteDetailsState extends State<NoteDetails> {
  static var _priorities = ['High', 'Low'];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String title;
  Note note;

  DatabaseHelper helper = DatabaseHelper();

  NoteDetailsState(this.note, this.title);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.subhead;

    titleController.text = note.title;
    descriptionController.text = note.description;
    // TODO: implement build
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              //Navigator.pop(context);
              moveToLastScreen();
            },
          ),
        ),
        body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: DropdownButton(
                    items: _priorities.map((String dropDownString) {
                      return DropdownMenuItem<String>(
                          child: Text(dropDownString), value: dropDownString);
                    }).toList(),
                    style: textStyle,
                    value: getPriorityAsString(note.priority),
                    onChanged: (value) {
                      setState(() {
                        updatePriorityAsInt(value);
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text('Save', textScaleFactor: 1.5),
                          onPressed: () {
                            setState(() {
                             _save();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text('Delete', textScaleFactor: 1.5),
                          onPressed: () {
                            setState(() {
                              _delete();
                            });
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
      onWillPop: () {
        moveToLastScreen();
      },
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context,true);
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

  void _save() async {
    moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());

    int result;
    if (note.id != null) {
      result = await helper.updateNote(note);
    } else {
      result = await helper.insertNote(note);
    }
    if (result != 0) {
      _showDialog('Status', 'Note Saved Successfully');
    } else {
      _showDialog('Status', 'Error Saving Note');
    }
  }

  void _delete() async{
    moveToLastScreen();
    if(note.id==null){
      _showDialog("Status", 'No Note Was Deleted.');
      return;
    }
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showDialog('Status', 'Note Deleted Successfully');
    } else {
      _showDialog('Status', 'Error Deleting Note');
    }
  }

  void _showDialog(String s, String t) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(s),
      content: Text(t),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
