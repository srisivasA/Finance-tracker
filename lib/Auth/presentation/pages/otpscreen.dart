import 'package:Expanses/Auth/domain/usecases/verify_otp_usecase.dart';
import 'package:Expanses/core/utils/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mobileNumberProvider = StateProvider<String?>((ref) => null);

class OtpScreen extends ConsumerStatefulWidget {
  final VerifyOtpUseCase verifyOtpUseCase;
  final String verificationId;
  final String mobileNumber;

  const OtpScreen({
    Key? key,
    required this.verifyOtpUseCase,
    required this.verificationId,
    required this.mobileNumber,
  }) : super(key: key);

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

 void _verifyOtp() async {
  final otp = _otpController.text.trim();

  if (otp.isEmpty || otp.length != 6) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter a valid 6-digit OTP")),
    );
    return;
  }

  setState(() => _isLoading = true);

  try {
    print("Verifying OTP...");
    await widget.verifyOtpUseCase.execute(widget.verificationId, otp);
    print("OTP verified successfully!");

    // Update login state in the database
    final dbHelper = DBHelper.instance;
    await dbHelper.setLoginState(widget.mobileNumber, true);

    // Navigate to HomeScreen
    Navigator.pushReplacementNamed(context, '/home');
  } catch (e) {
    print("Error in OTP verification: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Verification failed: ${e.toString()}")),
    );
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    print('Mobile Number: ${widget.mobileNumber}');
    print('Verification ID: ${widget.verificationId}');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify OTP"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 130),
            Center(
              child: Text(
                "Verify Your Number",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                "Enter the OTP sent to your phone number",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: "OTP",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixIcon: const Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Verify OTP",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
