import 'package:flutter/material.dart';
import 'package:journal/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesRepository {
  static const _database_nane = 'notes_database.db';
  static const _table_name = 'notes';

  static Future<Database> _database() async {
    final database = openDatabase(
      join(await getDatabasesPath(), _database_nane),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE $_table_name(id INTEGER PRIMARY KEY, title TEXT, description TEXT, created_at TEXT)');
      },
      version: 1,
    );
    return database;
  }

  static insert({required Note note}) async {
    final db = await _database();
    await db.insert(
      _table_name,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static update({required Note note}) async {
    final db = await _database();
    await db.update(
      _table_name,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  static delete({required Note note}) async {
    final db = await _database();
    await db.delete(
      _table_name,
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  static Future<List<Note>> get_notes() async {
    final db = await _database();
    final List<Map<String, dynamic>> maps = await db.query(_table_name);
    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'] as int,
        title: maps[i]['title'] as String,
        description: maps[i]['description'] as String,
        created_at: DateTime.parse(maps[i]['created_at']),
      );
    });
  }
}
