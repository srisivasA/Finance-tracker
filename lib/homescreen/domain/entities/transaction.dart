// transaction_entity.dart
class TransactionEntity {
  final int? id;
  final String type;
  final String category;
  final double amount;
  final DateTime timestamp;

  TransactionEntity({
    this.id,
    required this.type,
    required this.category,
    required this.amount,
    required this.timestamp,
  });

  factory TransactionEntity.fromJson(Map<String, dynamic> json) {
    return TransactionEntity(
      id: json['id'],
      type: json['type'],
      category: json['category'],
      amount: json['amount'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'category': category,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
