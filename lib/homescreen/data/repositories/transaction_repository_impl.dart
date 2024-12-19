import '../../../core/utils/db_helper.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final DBHelper dbHelper;

  TransactionRepositoryImpl(this.dbHelper);

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
    // Insert transaction into the database
    await dbHelper.insertTransaction({
      'type': transaction.type,
      'category': transaction.category,
      'amount': transaction.amount,
      'timestamp': transaction.timestamp.toIso8601String(), // Save as ISO 8601 string
    });
  }

  @override
  Future<List<TransactionEntity>> fetchTransactions() async {
    final data = await dbHelper.fetchTransactions();
    return data.map((e) {
      return TransactionEntity(
        type: e['type'],
        category: e['category'],
        amount: e['amount'],
        timestamp: DateTime.parse(e['timestamp']), // Parse ISO 8601 timestamp
      );
    }).toList();
  }

  @override
  Future<void> clearTransactions() async {
    await dbHelper.clearTransactions();
  }
}
