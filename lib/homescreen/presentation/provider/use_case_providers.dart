import 'package:Expanses/core/utils/db_helper.dart';
import 'package:Expanses/homescreen/data/datasources/transaction_local_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/clear_transaction.dart';
import '../../domain/usecases/fetch_transaction.dart';


final transactionLocalDataSourceProvider = Provider((ref) {
  return TransactionLocalDataSource(DBHelper.instance);
});

final transactionRepositoryProvider = Provider((ref) {
  final localDataSource = ref.watch(transactionLocalDataSourceProvider);
  return TransactionRepositoryImpl(localDataSource);
});

final addTransactionProvider = Provider((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return AddTransaction(repository);
});

final fetchTransactionsProvider = Provider((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return FetchTransactions(repository);
});

final clearTransactionsProvider = Provider((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return ClearTransactions(repository);
});