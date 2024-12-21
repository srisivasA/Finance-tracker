import 'package:Expanses/Auth/domain/repositories/auth_repository.dart';


class SendOtpUseCase {
  final AuthRepository authRepository;

  SendOtpUseCase(this.authRepository);

  Future<String> execute(String phoneNumber) {
    return authRepository.sendOtp(phoneNumber);
  }
}
