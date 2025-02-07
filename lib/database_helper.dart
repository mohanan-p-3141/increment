import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_increment.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        value INTEGER
      )
    ''');
  }

  Future<void> insertUser(String username, int value) async {
    final db = await database;
    await db.insert(
      'users',
      {'username': username, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUser(String username) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> updateUserValue(String username, int value) async {
    final db = await database;
    await db.update(
      'users',
      {'value': value},
      where: 'username = ?',
      whereArgs: [username],
    );
  }
}

class UserNotifier extends StateNotifier<int> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final String username;

  UserNotifier(this.username) : super(0) {
    _loadValue();
  }

  Future<void> _loadValue() async {
    final user = await _dbHelper.getUser(username);
    state = user?['value'] ?? 0;
  }

  Future<void> increment() async {
    state++;
    await _dbHelper.updateUserValue(username, state);
  }
}

final userProvider = StateNotifierProvider.family<UserNotifier, int, String>((ref, username) {
  return UserNotifier(username);
});