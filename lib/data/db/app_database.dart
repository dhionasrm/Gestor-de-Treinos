import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_dhionas.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE workout_sessions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            workout_letter TEXT NOT NULL,
            goal_mode TEXT NOT NULL,
            completed_at TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE session_exercises(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            session_id INTEGER NOT NULL,
            slot_id TEXT NOT NULL,
            exercise_id TEXT NOT NULL,
            order_index INTEGER NOT NULL,
            FOREIGN KEY(session_id) REFERENCES workout_sessions(id) ON DELETE CASCADE
          )
        ''');
        await db.execute('''
          CREATE TABLE set_logs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            session_exercise_id INTEGER NOT NULL,
            set_number INTEGER NOT NULL,
            weight_kg REAL,
            reps INTEGER,
            FOREIGN KEY(session_exercise_id) REFERENCES session_exercises(id) ON DELETE CASCADE
          )
        ''');
      },
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }
}
