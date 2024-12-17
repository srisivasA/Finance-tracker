class TransactionEntity {
  final String type; // 'Income' or 'Expense'
  final String category;
  final double amount;

  TransactionEntity({
    required this.type,
    required this.category,
    required this.amount,
  });
}
