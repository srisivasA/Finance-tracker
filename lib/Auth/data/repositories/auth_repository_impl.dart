

import 'package:Expanses/Auth/data/datasources/firebase_auth_datasource.dart';
import 'package:Expanses/Auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource firebaseAuthDataSource;

  AuthRepositoryImpl(this.firebaseAuthDataSource);

  @override
  Future<String> sendOtp(String phoneNumber) {
    return firebaseAuthDataSource.sendOtp(phoneNumber);
  }

  @override
  Future<void> verifyOtp(String verificationId, String otp) {
    return firebaseAuthDataSource.verifyOtp(verificationId, otp);
  }
}
