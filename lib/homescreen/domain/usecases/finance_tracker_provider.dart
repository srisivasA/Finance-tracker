import 'package:Expanses/core/utils/db_helper.dart';
import 'package:Expanses/homescreen/data/repositories/transaction_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';


final financeTrackerProvider = ChangeNotifierProvider((ref) {
  final repository = TransactionRepositoryImpl(DBHelper.instance);
  return FinanceTrackerViewModel(repository);
});

class FinanceTrackerViewModel extends ChangeNotifier {
  final TransactionRepository repository;

  double _totalIncome = 0.0;
  double _totalExpenses = 0.0;
  List<TransactionEntity> _transactions = [];

  FinanceTrackerViewModel(this.repository) {
    loadTransactions();
  }

  double get totalBalance => _totalIncome - _totalExpenses;
  double get totalIncome => _totalIncome;
  double get totalExpenses => _totalExpenses;
  List<TransactionEntity> get transactions => _transactions;

  Future<void> addTransaction(TransactionEntity transaction) async {
    await repository.addTransaction(transaction);
    await loadTransactions();
  }

  Future<void> loadTransactions() async {
    _transactions = await repository.fetchTransactions();

    _totalIncome = _transactions
        .where((t) => t.type == 'Income')
        .fold(0.0, (sum, t) => sum + t.amount);

    _totalExpenses = _transactions
        .where((t) => t.type == 'Expense')
        .fold(0.0, (sum, t) => sum + t.amount);

    notifyListeners();
  }
}