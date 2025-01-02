import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../transactiontab/presentation/provider/filter_provider.dart';
import '../components/Transactionlist.dart';
import '../components/filter.dart';
import '../provider/finance_tracker_provider.dart';


class TransactionsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(financeTrackerProvider);
    final filterState = ref.watch(filterStateProvider);

    // Filtering logic
    final filteredTransactions = viewModel.transactions.where((transaction) {
      // Show all transactions if "All" is selected
      if (filterState.filterType == 'All') return true;

      // Filter by type (Income/Expense)
      final isTypeMatch = transaction.type == filterState.filterType;

      // Filter by subcategory if one is selected
      final isSubcategoryMatch = filterState.selectedSubcategory == null ||
          transaction.category == filterState.selectedSubcategory;

      // Return true only if both conditions match
      return isTypeMatch && isSubcategoryMatch;
    }).toList();

    return Column(
      children: [
        FilterComponent(
          filterType: filterState.filterType,
          selectedSubcategory: filterState.selectedSubcategory,
          onFilterTypeChanged: (type) {
            ref.read(filterStateProvider.notifier).setFilterType(type);
          },
          onSubcategoryChanged: (subcategory) {
            ref.read(filterStateProvider.notifier).setSubcategory(subcategory);
          },
        ),
        Expanded(
          child: TransactionList(transactions: filteredTransactions),
        ),
      ],
    );
  }
}
