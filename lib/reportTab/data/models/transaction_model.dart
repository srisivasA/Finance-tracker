class TransactionModel {
  final String type;
  final String category;
  final double amount;

  TransactionModel({
    required this.type,
    required this.category,
    required this.amount,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      type: json['type'],
      category: json['category'] ?? 'Other',
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'category': category,
      'amount': amount,
    };
  }
}
