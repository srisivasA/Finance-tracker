import '../repositories/user_repository.dart';

class GetProfileImage {
  final UserRepository repository;

  GetProfileImage(this.repository);

  Future<String?> call() async {
    return await repository.getProfileImagePath();
  }
}
