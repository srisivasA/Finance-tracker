import '../../../core/utils/db_helper.dart';
import '../../data/models/transaction_model.dart';


class ReportRepositoryImpl {
  final DBHelper dbHelper;

  ReportRepositoryImpl(this.dbHelper);

  Future<List<TransactionModel>> fetchTransactions() async {
    final rawData = await dbHelper.fetchTransactions();
    return rawData.map((tx) => TransactionModel.fromJson(tx)).toList();
  }
}
