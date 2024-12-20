
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._privateConstructor();
  static Database? _database;



  DBHelper._privateConstructor();

  // Getter to initialize or return the existing database
  Future<Database> get database async {
    if (_database != null) return _database!;
    final path = join(await getDatabasesPath(), 'finance_tracker.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT,
            category TEXT,
            amount REAL,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
          )
        ''');
      },
    );
    return _database!;
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

  // Clear all transactions from the table
  Future<void> clearTransactions() async {
    final db = await database;
    await db.delete('transactions');
  }

 

}
