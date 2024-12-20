import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class AddTransaction {
  final TransactionRepository repository;

  AddTransaction(this.repository);

  Future<void> call(TransactionEntity transaction) async {
    await repository.addTransaction(transaction);
  }
}