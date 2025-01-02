import '../repositories/user_repository.dart';

class SaveProfileImage {
  final UserRepository repository;

  SaveProfileImage(this.repository);

  Future<void> call(String imagePath) async {
    await repository.saveProfileImagePath(imagePath);
  }
}
