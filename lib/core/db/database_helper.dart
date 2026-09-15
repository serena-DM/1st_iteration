// Fichier: lib/core/db/database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "EtoankoPay.db";
  static const _databaseVersion = 1;

  static const tableUsers = 'users';
  static const tableTransactions = 'transactions';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableUsers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            phone TEXT NOT NULL UNIQUE,
            password_hash TEXT NOT NULL,
            pin_hash TEXT NOT NULL,
            balance REAL DEFAULT 0.0,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableTransactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            type TEXT NOT NULL,
            amount REAL NOT NULL,
            recipient_phone TEXT,
            description TEXT,
            status TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users (id)
          )
          ''');
  }

  // --- MÉTHODES UTILISATEURS ---

  Future<int> insertUser(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableUsers, row);
  }

  Future<Map<String, dynamic>?> getUserByPhone(String phone) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      tableUsers,
      where: 'phone = ?',
      whereArgs: [phone],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      tableUsers,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<int> updateUserBalance(int userId, double amount) async {
    Database db = await instance.database;
    final user = await getUserById(userId);
    if (user != null) {
      final currentBalance = (user['balance'] as num).toDouble();
      final newBalance = currentBalance + amount;
      return await db.update(
        tableUsers,
        {'balance': newBalance},
        where: 'id = ?',
        whereArgs: [userId],
      );
    }
    return 0;
  }

  // --- MÉTHODES TRANSACTIONS ---

  Future<int> insertTransaction(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableTransactions, row);
  }

  Future<List<Map<String, dynamic>>> getTransactionsByUserId(int userId) async {
    Database db = await instance.database;
    return await db.query(
      tableTransactions,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
      limit: 10,
    );
  }
}
