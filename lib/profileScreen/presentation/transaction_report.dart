import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../../core/utils/db_helper.dart';



class TransactionReportScreen extends StatefulWidget {
  const TransactionReportScreen({Key? key}) : super(key: key);

  @override
  _TransactionReportScreenState createState() =>
      _TransactionReportScreenState();
}

class _TransactionReportScreenState extends State<TransactionReportScreen> {
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    final dbHelper = DBHelper.instance;
    final data = await dbHelper.fetchTransactions();
    setState(() {
      transactions = data;
    });
  }

  Future<void> _generatePDF() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Transaction Report', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Type', 'Category', 'Amount', 'Timestamp'],
                data: transactions.map((tx) {
                  return [
                    tx['type'],
                    tx['category'],
                    tx['amount'].toString(),
                    tx['timestamp']
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final directory = await getExternalStorageDirectory();
      final file = File('${directory!.path}/TransactionReport.pdf');
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF saved at: ${file.path}'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permission denied. Unable to save PDF.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Report'),
      ),
      body: transactions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final tx = transactions[index];
                      return ListTile(
                        title: Text('${tx['type']} - ${tx['category']}'),
                        subtitle: Text('Amount: ${tx['amount']}'),
                        trailing: Text(tx['timestamp']),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: _generatePDF,
                    icon: const Icon(Icons.download),
                    label: const Text('Download as PDF'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
