
import '../repositories/report_repository_impl.dart';

class GetReportData {
  final ReportRepositoryImpl repository;

  GetReportData(this.repository);

  Future<Map<String, Map<String, double>>> call() async {
    final transactions = await repository.fetchTransactions();
    final incomeData = <String, double>{};
    final expenseData = <String, double>{};

    for (var transaction in transactions) {
      final category = transaction.category;
      final amount = transaction.amount;

      if (transaction.type.toLowerCase() == 'income') {
        incomeData[category] = (incomeData[category] ?? 0.0) + amount;
      } else if (transaction.type.toLowerCase() == 'expense') {
        expenseData[category] = (expenseData[category] ?? 0.0) + amount;
      }
    }

    return {'Income': incomeData, 'Expense': expenseData};
  }
}
