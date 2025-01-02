import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/db_helper.dart';
import '../data/datasources/user_local_data_source.dart';
import '../data/repositories/user_repository_impl.dart';
import '../domain/usecases/get_profile_image.dart';
import '../domain/usecases/save_profile_image.dart';

// Dependency Providers
final dbHelperProvider = Provider((ref) => DBHelper.instance);
final userLocalDataSourceProvider = Provider((ref) => UserLocalDataSource(ref.watch(dbHelperProvider)));
final userRepositoryProvider = Provider((ref) => UserRepositoryImpl(ref.watch(userLocalDataSourceProvider)));

// Use Cases
final getProfileImageProvider = Provider((ref) => GetProfileImage(ref.watch(userRepositoryProvider)));
final saveProfileImageProvider = Provider((ref) => SaveProfileImage(ref.watch(userRepositoryProvider)));

// State Notifier for Profile Image
class ProfileImageNotifier extends StateNotifier<String?> {
  final GetProfileImage getProfileImage;
  final SaveProfileImage saveProfileImage;

  ProfileImageNotifier({
    required this.getProfileImage,
    required this.saveProfileImage,
  }) : super(null) {
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final imagePath = await getProfileImage();
    state = imagePath;
  }

  Future<void> pickImage(String imagePath) async {
    await saveProfileImage(imagePath);
    state = imagePath;
  }
}

final profileImageProvider = StateNotifierProvider<ProfileImageNotifier, String?>((ref) {
  return ProfileImageNotifier(
    getProfileImage: ref.watch(getProfileImageProvider),
    saveProfileImage: ref.watch(saveProfileImageProvider),
  );
});
