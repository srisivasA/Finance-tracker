import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl(this.localDataSource);

  @override
  Future<String?> getProfileImagePath() async {
    return await localDataSource.fetchProfileImagePath();
  }

  @override
  Future<void> saveProfileImagePath(String imagePath) async {
    await localDataSource.saveProfileImagePath(imagePath);
  }
}
