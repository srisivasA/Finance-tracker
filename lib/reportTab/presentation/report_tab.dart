import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/db_helper.dart';
import '../domain/repositories/report_repository_impl.dart';
import '../domain/usecases/get_report_data.dart';

class ReportTab extends StatefulWidget {
  @override
  _ReportTabState createState() => _ReportTabState();
}

class _ReportTabState extends State<ReportTab> {
  Map<String, Map<String, double>> _data = {};
  String? _selectedCategory;
  int? _touchedIndex; // Track the touched section index
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
      if (_data.isNotEmpty) {
        _selectedCategory = _data.keys.first;
      }
      _isLoading = false;
    });
  }

  Widget _buildCategoryPieChart() {
  final dataEntries = _data.entries.toList(); // Convert to a list
  return PieChart(
    PieChartData(
      sectionsSpace: 2,
      centerSpaceRadius: 40,
      sections: dataEntries.asMap().entries.map((entry) {
        final index = entry.key;
        final category = entry.value.key;
        final total = entry.value.value.values.fold(0.0, (sum, amount) => sum + amount);

        final isTouched = _touchedIndex == index; // Check if this section is touched
        final radius = isTouched ? 100.0 : 80.0; // Increase radius for touched section

        return PieChartSectionData(
          value: total,
          color: Colors.primaries[index % Colors.primaries.length],
          radius: radius,
          title: '${category}\n₹${total.toStringAsFixed(2)}',
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        );
      }).toList(),
      pieTouchData: PieTouchData(
        touchCallback: (event, touchResponse) {
          final touchedSection = touchResponse?.touchedSection;
          if (touchedSection != null && touchedSection.touchedSectionIndex != null) {
            final index = touchedSection.touchedSectionIndex;
            setState(() {
              _touchedIndex = index;
              _selectedCategory = _data.keys.toList()[index];
            });
          } else {
            setState(() {
              _touchedIndex = null;
            });
          }
        },
      ),
    ),
  );
}


  Widget _buildSubcategoryPieChart() {
    if (_selectedCategory == null) {
      return const Center(child: Text('Select a category to view details.'));
    }

    final subcategories = _data[_selectedCategory!]!;
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: subcategories.entries.map((entry) {
          return PieChartSectionData(
            value: entry.value,
            color: Colors.primaries[subcategories.keys.toList().indexOf(entry.key) % Colors.primaries.length],
            radius: 80,
            title: '${entry.key}\n₹${entry.value.toStringAsFixed(2)}',
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          );
        }).toList(),
      ),
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
            'Income vs Expense Categories',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(child: _buildCategoryPieChart()),
          const SizedBox(height: 20),
          Text(
            _selectedCategory != null
                ? 'Subcategories for $_selectedCategory'
                : 'Select a category to view details.',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(child: _buildSubcategoryPieChart()),
        ],
      ),
    );
  }
}
