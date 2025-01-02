// // import 'package:fl_chart/fl_chart.dart';
// // import 'package:flutter/material.dart';

// // import '../../../core/utils/db_helper.dart';

// // class ReportTab extends StatefulWidget {
// //   @override
// //   _ReportTabState createState() => _ReportTabState();
// // }

// // class _ReportTabState extends State<ReportTab> {
// //   Map<String, double> _data = {};
// //   bool _isLoading = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchData();
// //   }

// //   Future<void> _fetchData() async {
// //     final dbHelper = DBHelper.instance;
// //     final transactions = await dbHelper.fetchTransactions();
// //     print('transactions: $transactions');

// //     double totalIncome = 0.0;
// //     double totalExpense = 0.0;

// //     for (var transaction in transactions) {
// //       final type = transaction['type'].toString().toLowerCase(); // Normalize case
// //       if (type == 'income') {
// //         totalIncome += transaction['amount'] as double;
// //       } else if (type == 'expense') {
// //         totalExpense += transaction['amount'] as double;
// //       }
// //     }

// //     setState(() {
// //       _data = {'Income': totalIncome, 'Expense': totalExpense};
// //       _isLoading = false;
// //     });
// //   }

// //   void _showInvestmentDetails(String title, double amount) {
// //     showDialog(
// //       context: context,
// //       builder: (context) {
// //         return AlertDialog(
// //           title: Text('$title Details'),
// //           content: Text('Amount: ₹${amount.toStringAsFixed(2)}'),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.of(context).pop(),
// //               child: const Text('Close'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     if (_isLoading) {
// //       return const Center(child: CircularProgressIndicator());
// //     }

// //     if (_data.isEmpty) {
// //       return const Center(
// //         child: Text(
// //           'No data available.',
// //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //         ),
// //       );
// //     }

// //     return Padding(
// //       padding: const EdgeInsets.all(16.0),
// //       child: Column(
// //         children: [
// //           const Text(
// //             'Income vs Expense',
// //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// //           ),
// //           const SizedBox(height: 20),
// //           Expanded(
// //             child: PieChart(
// //               PieChartData(
// //                 sectionsSpace: 2,
// //                 centerSpaceRadius: 40,
// //                 sections: _data.entries.map((entry) {
// //                   final isIncome = entry.key.toLowerCase() == 'income';
// //                   return PieChartSectionData(
// //                     value: entry.value,
// //                     color: isIncome ? Colors.green : Colors.red,
// //                     radius: 80,
// //                     titleStyle: const TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                     showTitle: false,
// //                   );
// //                 }).toList(),
// // pieTouchData: PieTouchData(
// //   touchCallback: (FlTouchEvent event, PieTouchResponse? touchResponse) {
// //     if (touchResponse != null && touchResponse.touchedSection != null) {
// //       final touchedSection = touchResponse.touchedSection!;
// //       final entry = _data.entries.toList()[touchedSection.touchedSectionIndex];
// //       _showInvestmentDetails(entry.key, entry.value);
// //     }
// //   },
// // ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }


// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// import '../../../core/utils/db_helper.dart';

// class ReportTab extends StatefulWidget {
//   @override
//   _ReportTabState createState() => _ReportTabState();
// }

// class _ReportTabState extends State<ReportTab> {
//   Map<String, Map<String, double>> _data = {};
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }

//   Future<void> _fetchData() async {
//     final dbHelper = DBHelper.instance;
//     final transactions = await dbHelper.fetchTransactions();
//     print('transactions: $transactions');

//     final incomeData = <String, double>{};
//     final expenseData = <String, double>{};

//     for (var transaction in transactions) {
//       final type = transaction['type'].toString().toLowerCase(); // Normalize case
//       final category = transaction['category'] ?? 'Other';
//       final amount = transaction['amount'] as double;

//       if (type == 'income') {
//         incomeData[category] = (incomeData[category] ?? 0.0) + amount;
//       } else if (type == 'expense') {
//         expenseData[category] = (expenseData[category] ?? 0.0) + amount;
//       }
//     }

//     setState(() {
//       _data = {'Income': incomeData, 'Expense': expenseData};
//       _isLoading = false;
//     });
//   }

//   void _showCategoryDetails(String type, Map<String, double> categoryData) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('$type Details'),
//           content: SizedBox(
//             width: double.maxFinite,
//             child: ListView(
//               children: categoryData.entries.map((entry) {
//                 return ListTile(
//                   title: Text(entry.key),
//                   trailing: Text('₹${entry.value.toStringAsFixed(2)}'),
//                 );
//               }).toList(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (_data.isEmpty) {
//       return const Center(
//         child: Text(
//           'No data available.',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//       );
//     }

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           const Text(
//             'Income vs Expense',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: PieChart(
//               PieChartData(
//                 sectionsSpace: 2,
//                 centerSpaceRadius: 40,
//                 sections: _data.entries.map((entry) {
//                   final isIncome = entry.key.toLowerCase() == 'income';
//                   final total = entry.value.values.fold(0.0, (sum, amount) => sum + amount);
//                   return PieChartSectionData(
//                     value: total,
//                     color: isIncome ? Colors.green : Colors.red,
//                     radius: 80,
//                     title: '${entry.key}\n₹${total.toStringAsFixed(2)}',
//                     titleStyle: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   );
//                 }).toList(),
//                 pieTouchData: PieTouchData(
//                 touchCallback: (FlTouchEvent event, PieTouchResponse? touchResponse) {
//                   if (touchResponse != null && touchResponse.touchedSection != null) {
//                     final touchedSection = touchResponse.touchedSection!;
//                     final entry = _data.entries.toList()[touchedSection.touchedSectionIndex];
//                     _showCategoryDetails(entry.key, entry.value);
//                   }
//                 },
//                 )
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }