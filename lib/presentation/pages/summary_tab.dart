import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../components/summary_card.dart';
import '../components/summary_grid.dart';


class SummaryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          
          SizedBox(height: 16),
          SummaryGrid(
            cards: [
              SummaryCard(
                title: "Total Balance",
                amount: "₹${'0'}",
                icon: Icons.account_balance_wallet,
                color: AppColors.balanceColor.shade700,
              ),
              SummaryCard(
                title: "Total Income",
                amount: "₹${'0'}",
                icon: Icons.arrow_drop_up_sharp,
                color: AppColors.incomeColor.shade700,
              ),
              SummaryCard(
                title: "Total Expenses",
                amount: "₹${('0')}",
                icon: Icons.arrow_drop_down_sharp,
                color: AppColors.expenseColor.shade700,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
