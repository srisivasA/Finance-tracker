import 'package:Expanses/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For formatting date and time

import '../../domain/usecases/finance_tracker_provider.dart';

class TransactionsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(financeTrackerProvider);

    return viewModel.transactions.isEmpty
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
            itemCount: viewModel.transactions.length,
            itemBuilder: (context, index) {
              final transaction = viewModel.transactions[index];

              // Format the date and time in local (IST) time zone
              final formattedDate = DateFormat('dd MMM yyyy, hh:mm a')
                  .format(transaction.timestamp.toLocal());

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: AppColors.cardBackground,
                elevation: 2,
                child: ListTile(
                  leading: Icon(
                    transaction.type == 'Income'
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: transaction.type == 'Income'
                        ? AppColors.incomeColor
                        : AppColors.expenseColor,
                  ),
                  title: Text(
                    transaction.category,
                    style: const TextStyle(
                      color: AppColors.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.type,
                        style: const TextStyle(
                          color: AppColors.textColor,
                        ),
                      ),
                      Text(
                        formattedDate, // Display the date and time in local time zone
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  trailing: Text(
                    "₹${transaction.amount}",
                    style: TextStyle(
                      color: transaction.type == 'Income'
                          ? AppColors.incomeColor
                          : AppColors.expenseColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
  }
}
