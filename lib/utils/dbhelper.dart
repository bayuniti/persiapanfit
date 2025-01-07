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
        version: 2, // Ubah versi database menjadi 2
        onCreate: (db, version) {
          // Membuat tabel exercises
          db.execute('''
            CREATE TABLE exercises (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT,
              description TEXT,
              image TEXT
            )
          ''');
          // Membuat tabel new_exercises
          db.execute('''
            CREATE TABLE new_exercises (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT,
              description TEXT,
              image TEXT
            )
          ''');
        },
        onUpgrade: (db, oldVersion, newVersion) {
          if (oldVersion < 2) {
            // Membuat tabel new_exercises saat upgrade ke versi 2
            db.execute('''
              CREATE TABLE new_exercises (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT,
                description TEXT,
                image TEXT
              )
            ''');
          }
        },
      );
    } catch (e) {
      throw Exception("Database initialization error: $e");
    }
  }

  // Fungsi untuk menyisipkan data ke tabel exercises
  Future<int> insertExercise(Map<String, dynamic> exercise) async {
    try {
      final db = await database;
      return await db.insert('exercises', exercise);
    } catch (e) {
      throw Exception("Error inserting exercise: $e");
    }
  }

  // Fungsi untuk menyisipkan data ke tabel new_exercises
  Future<int> insertIntoNewTable(Map<String, dynamic> exercise) async {
    try {
      final db = await database;
      return await db.insert('new_exercises', exercise);
    } catch (e) {
      throw Exception("Error inserting exercise into new table: $e");
    }
  }

  // Mengambil data dari tabel exercises
  Future<List<Map<String, dynamic>>> fetchExercises() async {
    try {
      final db = await database;
      return await db.query('exercises');
    } catch (e) {
      throw Exception("Error fetching exercises: $e");
    }
  }

  
Future<List<Map<String, dynamic>>> fetchWarmupExercises() async {
  try {
    final db = await database;
    return await db.query('new_exercises'); 
  } catch (e) {
    throw Exception("Error fetching warmup exercises: $e");
  }
}

  // Fungsi untuk menyalin data dari tabel exercises ke tabel new_exercises
  Future<void> copyDataToNewTable() async {
    try {
      final db = await database;
      final data = await fetchExercises(); // Ambil data dari tabel lama
      for (var row in data) {
        await db.insert('new_exercises', row); // Masukkan ke tabel baru
      }
    } catch (e) {
      throw Exception("Error copying data to new table: $e");
    }
  }

  // Fungsi untuk mengambil semua data dari tabel exercises
  Future<List<Map<String, dynamic>>> getAllExercises() async {
    try {
      final db = await database;
      return await db.query('exercises');
    } catch (e) {
      throw Exception("Error getting all exercises: $e");
    }
  }

  // Mengambil data berdasarkan id dari tabel exercises
  Future<Map<String, dynamic>> getExerciseById(int id) async {
    final db = await database;
    var res = await db.query(
      'exercises',
      where: 'id = ?',
      whereArgs: [id],
    );
    return res.isNotEmpty ? res.first : {};
  }

  // Update data di tabel exercises berdasarkan id
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

  // Hapus data dari tabel exercises berdasarkan id
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

  // Mengambil semua data dari tabel new_exercises
Future<List<Map<String, dynamic>>> getAllNewExercises() async {
  try {
    final db = await database;
    return await db.query('new_exercises');
  } catch (e) {
    throw Exception("Error getting all new exercises: $e");
  }
}

// Mengambil data berdasarkan id dari tabel new_exercises
Future<Map<String, dynamic>> getNewExerciseById(int id) async {
  final db = await database;
  var res = await db.query(
    'new_exercises',
    where: 'id = ?',
    whereArgs: [id],
  );
  return res.isNotEmpty ? res.first : {};
}

// Menambahkan data ke tabel new_exercises
Future<int> insertNewExercise(Map<String, dynamic> exercise) async {
  try {
    final db = await database;
    return await db.insert('new_exercises', exercise);
  } catch (e) {
    throw Exception("Error inserting into new_exercises: $e");
  }
}

// Memperbarui data di tabel new_exercises berdasarkan id
Future<int> updateNewExercise(int id, Map<String, dynamic> exercise) async {
  try {
    final db = await database;
    return await db.update(
      'new_exercises',
      exercise,
      where: 'id = ?',
      whereArgs: [id],
    );
  } catch (e) {
    throw Exception("Error updating new_exercises: $e");
  }
}

// Menghapus data dari tabel new_exercises berdasarkan id
Future<int> deleteNewExercise(int id) async {
  try {
    final db = await database;
    return await db.delete(
      'new_exercises',
      where: 'id = ?',
      whereArgs: [id],
    );
  } catch (e) {
    throw Exception("Error deleting new_exercise: $e");
  }
}

 // Fungsi untuk mengambil data berdasarkan ID
  Future<List<Map<String, dynamic>>> fetchExerciseById(int id) async {
    final db = await database; // Asumsikan ini adalah akses ke database kamu
    try {
      // Query untuk mengambil data berdasarkan ID
      final result = await db.query(
        'new_exercises', // Nama tabel
        where: 'id = ?', // Kondisi WHERE
        whereArgs: [id], // ID yang dicari
      );
      return result;
    } catch (e) {
      print("Error fetching exercise by ID: $e");
      return [];
    }
  }

}
