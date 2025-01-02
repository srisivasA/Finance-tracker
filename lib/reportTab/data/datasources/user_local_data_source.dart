import '../../../core/utils/db_helper.dart';

class UserLocalDataSource {
  final DBHelper dbHelper;

  UserLocalDataSource(this.dbHelper);

  Future<String?> fetchProfileImagePath() async {
    return await dbHelper.fetchProfileImagePath();
  }

  Future<void> saveProfileImagePath(String imagePath) async {
    await dbHelper.saveProfileImagePath(imagePath);
  }
}
