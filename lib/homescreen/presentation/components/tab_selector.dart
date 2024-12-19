import 'package:Expanses/core/colors.dart';
import 'package:flutter/material.dart';


class TabSelector extends StatelessWidget {
  final String selectedTab;
  final List<String> tabs;
  final ValueChanged<String> onTabChanged;

  const TabSelector({
    Key? key,
    required this.selectedTab,
    required this.tabs,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: tabs.map((tab) {
        final isSelected = tab == selectedTab;
        final isExpense = tab == 'Expense';
        return GestureDetector(
          onTap: () => onTabChanged(tab),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isExpense ? AppColors.expenseColor : AppColors.incomeColor)
                  : AppColors.unselectedTabColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? (isExpense ? AppColors.expenseColor : AppColors.incomeColor)
                    : AppColors.unselectedTabColor,
              ),
            ),
            child: Text(
              tab,
              style: TextStyle(
                color: isSelected
                    ? AppColors.selectedTabTextColor
                    : AppColors.unselectedTabTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
