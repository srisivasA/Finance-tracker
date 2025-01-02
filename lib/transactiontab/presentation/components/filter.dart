import 'package:Expanses/core/utils/colors.dart';
import 'package:flutter/material.dart';

class FilterComponent extends StatelessWidget {
  final String filterType;
  final String? selectedSubcategory;
  final Function(String) onFilterTypeChanged;
  final Function(String?) onSubcategoryChanged;

  final Map<String, List<String>> subcategories = {
    'All': [],
    'Income': ['Salary', 'Bonus', 'Investment'],
    'Expense': ['Rent', 'Groceries', 'Utilities', 'Food'],
  };

  FilterComponent({
    required this.filterType,
    required this.selectedSubcategory,
    required this.onFilterTypeChanged,
    required this.onSubcategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        children: [
          // Main Filter Dropdown (Income/Expense)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              DropdownButton<String>(
                value: filterType,
                dropdownColor: AppColors.cardBackground,
                underline: SizedBox(),
                icon: const Icon(Icons.arrow_drop_down, color: AppColors.textColor),
                borderRadius: BorderRadius.circular(10),
                onChanged: (String? newValue) {
                  onFilterTypeChanged(newValue!);
                },
                items: ['All', 'Income', 'Expense']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          // Subcategory Dropdown
          if (filterType != 'All')
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subcategory:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
                DropdownButton<String>(
                  value: selectedSubcategory,
                  dropdownColor: AppColors.cardBackground,
                  underline: SizedBox(),
                  hint: const Text(
                    'Select Subcategory',
                    style: TextStyle(color: AppColors.textColor),
                  ),
                  icon: const Icon(Icons.arrow_drop_down, color: AppColors.textColor),
                  borderRadius: BorderRadius.circular(10),
                  onChanged: (String? newValue) {
                    onSubcategoryChanged(newValue);
                  },
                  items: subcategories[filterType]!
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: AppColors.textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
