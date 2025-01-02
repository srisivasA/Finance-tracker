import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/Transactionlist.dart';
import '../components/filter.dart';
import '../provider/filter_provider.dart';
import '../provider/finance_tracker_provider.dart';


class TransactionsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(financeTrackerProvider);
    final filterState = ref.watch(filterStateProvider);

    final filteredTransactions = viewModel.transactions.where((transaction) {
      final isTypeMatch = filterState.filterType == 'All' ||
          transaction.type == filterState.filterType;
      final isSubcategoryMatch = filterState.selectedSubcategory == null ||
          transaction.category == filterState.selectedSubcategory;

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
