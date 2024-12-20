import 'package:Expanses/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/transaction.dart';

class TransactionListComponent extends StatelessWidget {
  final List<TransactionEntity> transactions;

  const TransactionListComponent({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? const Center(
            child: Text(
              'No Transactions Available',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textColor,
              ),
            ),
          )
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              final formattedDate = DateFormat('dd MMM yyyy, hh:mm a')
                  .format(transaction.timestamp.toLocal());

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Card(
                  elevation: 3,
                  shadowColor: Colors.grey.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: AppColors.cardBackground,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
                    leading: CircleAvatar(
                      backgroundColor: transaction.type == 'Income'
                          ? AppColors.incomeColor.withOpacity(0.1)
                          : AppColors.expenseColor.withOpacity(0.1),
                      child: Icon(
                        transaction.type == 'Income'
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: transaction.type == 'Income'
                            ? AppColors.incomeColor
                            : AppColors.expenseColor,
                      ),
                    ),
                    title: Text(
                      transaction.category,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.type,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      "₹${transaction.amount.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: transaction.type == 'Income'
                            ? AppColors.incomeColor
                            : AppColors.expenseColor,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
