

import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasource/transaction_local_data_source.dart';


class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl(this.localDataSource);

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
    await localDataSource.insertTransaction(transaction);
  }

  @override
  Future<List<TransactionEntity>> fetchTransactions() async {
    return await localDataSource.fetchTransactions();
  }

  @override
  Future<void> clearTransactions() async {
    await localDataSource.clearTransactions();
  }
}