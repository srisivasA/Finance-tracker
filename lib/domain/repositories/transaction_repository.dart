import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(TransactionEntity transaction);
  Future<List<TransactionEntity>> fetchTransactions();
  Future<void> clearTransactions();
}
