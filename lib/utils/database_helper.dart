import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_notebook_sqllite/model/Note.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; //Singleton DatabaseHelper
  static Database _database; //Singleton Database

  String noteTable = 'note_table';
  String cId = 'id';
  String cTitle = 'title';
  String cDescri = "descri";
  String cPrioroty = 'priority';
  String cDate = 'date';

  DatabaseHelper._createInstenace(); //Name Constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstenace(); // This is executed only once, Singleton Object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await intilizationDatabase();
    }

    return _database;
  }

  Future<Database> intilizationDatabase() async {
    // Get Directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    //Open/Create database on given path.
    var noteDatabase =
        await openDatabase(path, version: 1, onCreate: _createDB);
    return noteDatabase;
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($cId INTEGER PRIMARY KEY AUTOINCREMENT, $cTitle TEXT, $cDescri TEXT, $cPrioroty INTEGER, $cDate TEXT)');
  }

  //Fetch Operation
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    //var result=await db.rawQuery('SELECT * $noteTable order by $cPrioroty ASC'); // Both Same
    var result = await db.query(noteTable, orderBy: '$cPrioroty ASC');

    return result;
  }

  // Insert records
  Future<int> insertNotes(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  // Update records
  Future<int> updateNotes(Note note) async {
    Database db = await this.database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$cId = ?', whereArgs: [note.id]);
    return result;
  }

  // Update records
  Future<int> deleteNotes(int id) async {
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $noteTable WHERE $cId = $id');
    return result;
  }

  // Update records
  Future<int> count() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //Convert MAP list in Note List
  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;
    List<Note> noteList = List<Note>();
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
}
