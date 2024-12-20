import '../../../../core/utils/db_helper.dart';
import '../../domain/entities/transaction.dart';

class TransactionLocalDataSource {
  final DBHelper dbHelper;

  TransactionLocalDataSource(this.dbHelper);

  Future<void> insertTransaction(TransactionEntity transaction) async {
    await dbHelper.insertTransaction(transaction.toJson());
  }

  Future<List<TransactionEntity>> fetchTransactions() async {
    final data = await dbHelper.fetchTransactions();
    return data.map((e) => TransactionEntity.fromJson(e)).toList();
  }

  Future<void> clearTransactions() async {
    await dbHelper.clearTransactions();
  }
}