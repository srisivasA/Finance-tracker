
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/Transactionlist.dart';
import '../components/filter.dart';
import '../provider/finance_tracker_provider.dart';



class TransactionsTab extends ConsumerStatefulWidget {
  @override
  _TransactionsTabState createState() => _TransactionsTabState();
}

class _TransactionsTabState extends ConsumerState<TransactionsTab> {
  String _filterType = 'All'; // Default filter type
  String? _selectedSubcategory;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(financeTrackerProvider);

    // Filter transactions based on type and subcategory
    final filteredTransactions = _filterType == 'All'
        ? viewModel.transactions
        : viewModel.transactions.where((transaction) {
            final isTypeMatch = transaction.type == _filterType;
            final isSubcategoryMatch = _selectedSubcategory == null ||
                transaction.category == _selectedSubcategory;
            return isTypeMatch && isSubcategoryMatch;
          }).toList();

    return Column(
      children: [
        FilterComponent(
          filterType: _filterType,
          selectedSubcategory: _selectedSubcategory,
          onFilterTypeChanged: (type) {
            setState(() {
              _filterType = type;
              _selectedSubcategory = null;
            });
          },
          onSubcategoryChanged: (subcategory) {
            setState(() {
              _selectedSubcategory = subcategory;
            });
          },
        ),
        Expanded(
          child: TransactionList(transactions: filteredTransactions),
        ),
      ],
    );
  }
}
