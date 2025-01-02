import 'package:Expanses/Auth/domain/usecases/send_otp_usecase.dart';
import 'package:Expanses/core/utils/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final SendOtpUseCase sendOtpUseCase;

  const LoginScreen({Key? key, required this.sendOtpUseCase}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

 void _sendOtp() async {
  final phoneNumber = _phoneController.text.trim();

  if (phoneNumber.length != 10) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter a valid 10-digit phone number")),
    );
    return;
  }

  final fullPhoneNumber = '+91$phoneNumber';

  setState(() => _isLoading = true);

  try {
    print("Sending OTP...");
    final verificationId = await widget.sendOtpUseCase.execute(fullPhoneNumber);
    print("OTP sent successfully, verificationId: $verificationId");

    // Store the phone number in SQLite
    final dbHelper = DBHelper.instance;
    await dbHelper.setLoginState(fullPhoneNumber, false); 

    // Navigate to OTP screen
    Navigator.pushReplacementNamed(
      context,
      '/otp',
      arguments: {
        'verificationId': verificationId,
        'mobileNumber': fullPhoneNumber,
      },
    );
    print("Navigation to /otp triggered");
  } catch (e) {
    print("Error in sending OTP: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to send OTP: ${e.toString()}")),
    );
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 180),
            Center(
              child: Text(
                "Welcome Back!",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 18),
            Center(
              child: Text(
                "Enter your phone number to continue",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixIcon: const Icon(Icons.phone),
                prefixText: '+91 ',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sendOtp,
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
                        "Send OTP",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                "We will send an OTP to verify your number.",
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
