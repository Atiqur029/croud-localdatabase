import 'dart:io';

import 'package:croud/model/contact.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _DatabaseName = "contact.db";
  static const _DatabaseVersion = 1;

  //Singleton class
  DatabaseHelper._();
  static final DatabaseHelper instense = DatabaseHelper._();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, _DatabaseName);
    return await openDatabase(dbPath,
        version: _DatabaseVersion, onCreate: _OnCreteDb);
  }

  Future<void> _OnCreteDb(Database db, int version) async {
    await db.execute('''
   CREATE  TABLE ${Contact.tblContact} (
    ${Contact.calId} INTEGER PRIMARY KEY AUTOINCREMENT,
       ${Contact.callname} TEXT NOT NULL,
          ${Contact.callmob} TEXT NOT NULL)''');
  }

  Future<int> insert(Contact contact) async {
    Database db = await database;

    return await db.insert(Contact.tblContact, contact.toMap());
  }

  Future<int> update(Contact contact) async {
    Database db = await database;
    return await db.update(Contact.tblContact, contact.toMap(),
        where: "${Contact.calId}=?", whereArgs: [contact.id]);
  }

  Future<int> delete(int id) async {
    Database db = await database;
    return await db.delete(Contact.tblContact,
        where: "${Contact.calId}=?", whereArgs: [id]);
  }

  Future<List<Contact>> showallData() async {
    Database db = await database;

    List<Map<String, dynamic>> contacts = await db.query(Contact.tblContact);
    return contacts.isEmpty
        ? []
        : contacts.map((e) => Contact.fromMap(e)).toList();
  }
}
