import 'package:Expanses/reportTab/domain/usecases/get_report_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/db_helper.dart';
import '../domain/repositories/report_repository_impl.dart';

class ReportTab extends StatefulWidget {
  @override
  _ReportTabState createState() => _ReportTabState();
}

class _ReportTabState extends State<ReportTab> {
  Map<String, Map<String, double>> _data = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final useCase = GetReportData(ReportRepositoryImpl(DBHelper.instance));
    final result = await useCase();
    setState(() {
      _data = result;
      _isLoading = false;
    });
  }

  void _showCategoryDetails(String type, Map<String, double> categoryData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$type Details'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              children: categoryData.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  trailing: Text('₹${entry.value.toStringAsFixed(2)}'),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_data.isEmpty) {
      return const Center(
        child: Text(
          'No data available.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Income vs Expense',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: _data.entries.map((entry) {
                  final isIncome = entry.key.toLowerCase() == 'income';
                  final total = entry.value.values.fold(0.0, (sum, amount) => sum + amount);
                  return PieChartSectionData(
                    value: total,
                    color: isIncome ? Colors.green : Colors.red,
                    radius: 80,
                    title: '${entry.key}\n₹${total.toStringAsFixed(2)}',
                    titleStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
                pieTouchData: PieTouchData(
                  touchCallback: (event, touchResponse) {
                    if (touchResponse?.touchedSection != null) {
                      final index = touchResponse!.touchedSection!.touchedSectionIndex;
                      final entry = _data.entries.toList()[index];
                      _showCategoryDetails(entry.key, entry.value);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
