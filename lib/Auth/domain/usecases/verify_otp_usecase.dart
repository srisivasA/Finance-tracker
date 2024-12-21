import 'package:Expanses/Auth/domain/repositories/auth_repository.dart';


class VerifyOtpUseCase {
  final AuthRepository authRepository;

  VerifyOtpUseCase(this.authRepository);

  Future<void> execute(String verificationId, String otp) {
    return authRepository.verifyOtp(verificationId, otp);
  }
}
