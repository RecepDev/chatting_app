import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final String path = join(await getDatabasesPath(), 'my_database.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        // Create your database tables here
        db.execute('''
          CREATE TABLE your_table (
            id INTEGER PRIMARY KEY,
            name TEXT,
            // Add your columns here
          )
        ''');
      },
    );
  }

  // Define methods for CRUD operations (insert, update, delete, query).
}
