import 'package:Expanses/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/usecases/finance_tracker_provider.dart';
import '../components/dropdown_field.dart';
import '../components/tab_selector.dart';
import '../components/text_field.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  String _transactionType = 'Income';
  String _selectedCategory = 'Salary';

  final List<String> _incomeCategories = ['Salary', 'Bonus', 'Investment'];
  final List<String> _expenseCategories = [
    'Rent',
    'Groceries',
    'Utilities',
    'Food'
  ];

  bool _isButtonDisabled = false;
  bool isDebouncing = false; 

  @override
  void dispose() {
    _amountController.dispose(); 
    isDebouncing = false; 
    super.dispose();
  }

  void _handleButtonPress(Function action) {
    if (_isButtonDisabled) return;

    setState(() {
      _isButtonDisabled = true;
    });

    action();

    
    isDebouncing = true; 
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        
        setState(() {
          _isButtonDisabled = false;
        });
      }
      isDebouncing = false; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final viewModel = ref.watch(financeTrackerProvider);
        final viewModelNotifier = ref.watch(financeTrackerProvider.notifier);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Add Transaction'),
            backgroundColor: AppColors.incomeColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TabSelector(
                    selectedTab: _transactionType,
                    onTabChanged: (type) {
                      setState(() {
                        _transactionType = type;
                        _selectedCategory = (_transactionType == 'Income'
                                ? _incomeCategories
                                : _expenseCategories)
                            .first;
                      });
                    },
                    tabs: const ['Income', 'Expense'],
                  ),
                  const SizedBox(height: 16),
                  DropdownField(
                    value: _selectedCategory,
                    label: 'Category',
                    items: (_transactionType == 'Income'
                        ? _incomeCategories
                        : _expenseCategories),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _amountController,
                    label: 'Amount',
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*')), // Allow numbers and a single decimal point
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      if (double.tryParse(value) == null ||
                          double.parse(value) <= 0) {
                        return 'Enter a valid positive number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.incomeColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _isButtonDisabled
                        ? null
                        : () => _handleButtonPress(() {
                              if (_formKey.currentState!.validate()) {
                                final amount =
                                    double.parse(_amountController.text);

                                if (_transactionType == 'Expense' &&
                                    viewModel.totalBalance < amount) {
                                  // Show error if expense exceeds total balance
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Insufficient balance to add this expense.',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                final newTransaction = TransactionEntity(
                                  type: _transactionType,
                                  category: _selectedCategory,
                                  amount: amount,
                                  timestamp: DateTime.now(),
                                );

                                viewModelNotifier.addTransaction(newTransaction);
                                Navigator.of(context).pop();
                              }
                            }),
                    child: const Text(
                      'Add Transaction',
                      style: TextStyle(
                          fontSize: 18, color: AppColors.selectedTabTextColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

