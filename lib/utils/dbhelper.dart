import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'exercise_database.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          return db.execute('''
            CREATE TABLE exercises (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT,
              description TEXT,
              image TEXT
            )
          ''');
        },
      );
    } catch (e) {
      throw Exception("Database initialization error: $e");
    }
  }

  // Insert new exercise into the database
  Future<int> insertExercise(Map<String, dynamic> exercise) async {
    try {
      final db = await database;
      return await db.insert('exercises', exercise);
    } catch (e) {
      throw Exception("Error inserting exercise: $e");
    }
  }

  // Fetch all exercises from the database
  Future<List<Map<String, dynamic>>> fetchExercises() async {
    try {
      final db = await database;
      return await db.query('exercises');
    } catch (e) {
      throw Exception("Error fetching exercises: $e");
    }
  }

  // Update exercise data by id
  Future<int> updateExercise(int id, Map<String, dynamic> exercise) async {
    try {
      final db = await database;
      return await db.update(
        'exercises',
        exercise,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception("Error updating exercise: $e");
    }
  }

  // Delete exercise by id
  Future<int> deleteExercise(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'exercises',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception("Error deleting exercise: $e");
    }
  }

  // Get all exercises
  Future<List<Map<String, dynamic>>> getAllExercises() async {
    try {
      final db = await database;
      return await db.query('exercises');
    } catch (e) {
      throw Exception("Error getting all exercises: $e");
    }
  }

   Future<Map<String, dynamic>> getExerciseById(int id) async {
    final db = await database;
    var res = await db.query(
      'exercises',
      where: 'id = ?',
      whereArgs: [id],
    );
    return res.isNotEmpty ? res.first : {};
  }
}
