import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
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
  bool _isLoading = true;

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
      _isLoading = false;
    });
  }

  Future<bool> _checkStoragePermission() async {
  if (Platform.isAndroid) {
    try {
      final deviceInfoPlugin = DeviceInfoPlugin();
      final androidInfo = await deviceInfoPlugin.androidInfo;
      if ((androidInfo.version.sdkInt) >= 33) {
        return true;
      }
    } catch (e) {
      debugPrint('Error fetching device info: $e');
      return false;
    }
  }

  final status = await Permission.storage.request();
  return status.isGranted;
}


 Future<void> _generatePDF() async {
  if (!await _checkStoragePermission()) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Permission denied. Unable to save PDF.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

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

  // Save the file to the Downloads directory
  final directory = Directory('/storage/emulated/0/Download');
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }

  final path = '${directory.path}/TransactionReport.pdf';
  final file = File(path);

  await file.writeAsBytes(await pdf.save());

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('PDF saved in Downloads: $path'),
      backgroundColor: Colors.green,
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Report'),
      ),
      body: _isLoading
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
                        subtitle: Text('Amount: ₹${tx['amount']}'),
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