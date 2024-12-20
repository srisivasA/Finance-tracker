import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class FetchTransactions {
  final TransactionRepository repository;

  FetchTransactions(this.repository);

  Future<List<TransactionEntity>> call() async {
    return await repository.fetchTransactions();
  }
}