import 'package:Expanses/transactiontab/presentation/provider/use_case_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/clear_transaction.dart';
import '../../domain/usecases/fetch_transaction.dart';

final financeTrackerProvider = ChangeNotifierProvider((ref) {
  final addTransaction = ref.watch(addTransactionProvider);
  final fetchTransactions = ref.watch(fetchTransactionsProvider);
  final clearTransactions = ref.watch(clearTransactionsProvider);
  return FinanceTrackerViewModel(addTransaction, fetchTransactions, clearTransactions);
});

class FinanceTrackerViewModel extends ChangeNotifier {
  final AddTransaction addTransactionUseCase;
  final FetchTransactions fetchTransactionsUseCase;
  final ClearTransactions clearTransactionsUseCase;

  double _totalIncome = 0.0;
  double _totalExpenses = 0.0;
  List<TransactionEntity> _transactions = [];

  FinanceTrackerViewModel(this.addTransactionUseCase, this.fetchTransactionsUseCase, this.clearTransactionsUseCase) {
    _fetchTransactions();
  }

  double get totalBalance => _totalIncome - _totalExpenses;
  double get totalIncome => _totalIncome;
  double get totalExpenses => _totalExpenses;
  List<TransactionEntity> get transactions => _transactions;

  Future<void> addTransaction(TransactionEntity transaction) async {
    await addTransactionUseCase(transaction);
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    _transactions = await fetchTransactionsUseCase();
    _calculateTotals();
    notifyListeners();
  }

  void _calculateTotals() {
    _totalIncome = _transactions
        .where((transaction) => transaction.type == 'Income')
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
    _totalExpenses = _transactions
        .where((transaction) => transaction.type == 'Expense')
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  Future<void> clearTransactions() async {
    await clearTransactionsUseCase();
    _fetchTransactions();
  }
}