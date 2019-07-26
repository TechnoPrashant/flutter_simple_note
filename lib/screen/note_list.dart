import 'package:flutter/material.dart';
import 'package:flutter_notebook_sqllite/screen/note_details.dart';
import 'dart:async';
import 'package:flutter_notebook_sqllite/model/Note.dart';
import 'package:flutter_notebook_sqllite/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_notebook_sqllite/screen/add_note.dart';
import 'package:flutter_notebook_sqllite/utils/StringUtils.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _noteListState();
  }
}

class _noteListState extends State<NoteList> {
  int count = 0;
  DatabaseHelper _databaseHelper = new DatabaseHelper();
  List<Note> noteList;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = new List();
      updateListView();
    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(StringUtils().strMyNote),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NevigateToAddNote();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int postion) {
        return Card(
          elevation: 4.0,
          color: Colors.white,
          child: ListTile(
            leading: CircleAvatar(
              child: getIconPriority(noteList[postion].priority),
              backgroundColor: getColorPriority(noteList[postion].priority),
            ),
            title: Text(noteList[postion].title),
            subtitle: Text(noteList[postion].date),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () {
                _deleteNotes(context, noteList[postion]);
              },
            ),
            onTap: () {
              NevigateTodetails(
                  this.noteList[postion], StringUtils().strEditNote);
            },
          ),
        );
      },
    );
  }

  void NevigateTodetails(Note note, String appTitle) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetials(note, appTitle);
    }));

    if (result) {
      updateListView();
    }
  }

  void NevigateToAddNote() async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddNote();
    }));

    if (result) {
      updateListView();
    }
  }

  Color getColorPriority(int priority) {
    Color color;

    if (priority == 1) {
      color = Colors.red;
    } else {
      color = Colors.green;
    }
    return color;
  }

  Icon getIconPriority(int priority) {
    Icon icon;
    if (priority == 1) {
      icon = Icon(
        Icons.note,
        color: Colors.white,
      );
    } else {
      icon = Icon(Icons.note, color: Colors.white);
    }
    return icon;
  }

  void _deleteNotes(BuildContext context, Note note) async {
    int result = await _databaseHelper.deleteNotes(note.id);
    if (result != 0) {
      _snakbar(context, StringUtils().messageDelete);
      updateListView();
    }
  }

  void _snakbar(BuildContext context, String s) {
    final snackbar = SnackBar(content: Text(s));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void updateListView() {
    final Future<Database> dbFuture = _databaseHelper.intilizationDatabase();
    dbFuture.then((Database) {
      Future<List<Note>> noteListFuture = _databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
