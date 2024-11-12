import 'package:journal/models/todo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TodosRepository {
  static const _database_nane = 'todos_database.db';
  static const _table_name = 'todos';

  static Future<Database> _database() async {
    final database = openDatabase(
      join(await getDatabasesPath(), _database_nane),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE $_table_name(id INTEGER PRIMARY KEY, title TEXT, description TEXT, deadline TEXT, isFinished INTEGER)');
      },
      version: 1,
    );
    return database;
  }

  static insert({required Todo todo}) async {
    final db = await _database();
    await db.insert(
      _table_name,
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static update({required Todo todo}) async {
    final db = await _database();
    await db.update(
      _table_name,
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  static delete({required Todo todo}) async {
    final db = await _database();
    await db.delete(
      _table_name,
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  static checkmark({required Todo todo}) async {
    todo.isFinished = todo.isFinished==0 ? 1  : 0;
    final db = await _database();
    await db.update(
      _table_name,
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  static Future<List<Todo>> get_todos() async {
    final db = await _database();
    final List<Map<String, dynamic>> maps = await db.query(_table_name);
    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'] as int,
        title: maps[i]['title'] as String,
        description: maps[i]['description'] as String,
        deadline: DateTime.parse(maps[i]['deadline']),
        isFinished: maps[i]['isFinished'] as int,
      );
    });
  }
}
