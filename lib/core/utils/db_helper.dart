import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._privateConstructor();
  static Database? _database;

  DBHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    final path = join(await getDatabasesPath(), 'finance_tracker.db');
    _database = await openDatabase(
      path,
      version: 2, 
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return _database!;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        category TEXT,
        amount REAL,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mobileNumber TEXT NOT NULL,
        isLoggedIn INTEGER NOT NULL DEFAULT 0,
        profileImagePath TEXT
      )
    ''');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      
      final tableInfo = await db.rawQuery('PRAGMA table_info(user)');
      final columnExists = tableInfo.any((column) => column['name'] == 'profileImagePath');

      if (!columnExists) {
       
        await db.execute('''
          ALTER TABLE user ADD COLUMN profileImagePath TEXT
        ''');
      }
    }
  }


  Future<int> insertTransaction(Map<String, dynamic> transaction) async {
    final db = await database;
    return await db.insert('transactions', {
      'type': transaction['type'],
      'category': transaction['category'],
      'amount': transaction['amount'],
      'timestamp': transaction['timestamp'],
    });
  }

  Future<List<Map<String, dynamic>>> fetchTransactions() async {
    final db = await database;
    return await db.query(
      'transactions',
      orderBy: 'timestamp DESC',
    );
  }

  Future<void> clearTransactions() async {
    final db = await database;
    await db.delete('transactions');
  }

  // Login State Methods
  Future<void> setLoginState(String mobileNumber, bool isLoggedIn) async {
    final db = await database;
    await db.delete('user');
    await db.insert(
      'user',
      {
        'mobileNumber': mobileNumber,
        'isLoggedIn': isLoggedIn ? 1 : 0,
        'profileImagePath': null, 
      },
    );
  }

  Future<String?> getLoggedInUser() async {
    final db = await database;
    final result = await db.query(
      'user',
      where: 'isLoggedIn = ?',
      whereArgs: [1],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return result.first['mobileNumber'] as String?;
    }
    return null;
  }

  Future<void> logout() async {
    final db = await database;
    await db.delete('user');
  }


  Future<void> saveProfileImagePath(String imagePath) async {
    final db = await database;
    await db.update(
      'user',
      {'profileImagePath': imagePath},
      where: 'isLoggedIn = ?',
      whereArgs: [1],
    );
  }

  Future<String?> fetchProfileImagePath() async {
    final db = await database;
    final result = await db.query(
      'user',
      where: 'isLoggedIn = ?',
      whereArgs: [1],
    );
    if (result.isNotEmpty) {
      return result.first['profileImagePath'] as String?;
    }
    return null;
  }
}
