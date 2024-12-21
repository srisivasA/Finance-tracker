abstract class AuthRepository {
  Future<String> sendOtp(String phoneNumber);
  Future<void> verifyOtp(String verificationId, String otp);
}
