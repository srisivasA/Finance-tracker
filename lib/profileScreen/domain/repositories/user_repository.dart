abstract class UserRepository {
  Future<String?> getProfileImagePath();
  Future<void> saveProfileImagePath(String imagePath);
}
