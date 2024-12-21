import 'package:Expanses/Auth/domain/usecases/verify_otp_usecase.dart';
import 'package:flutter/material.dart';


class OtpScreen extends StatefulWidget {
  final VerifyOtpUseCase verifyOtpUseCase;
  final String verificationId;

  const OtpScreen({
    Key? key,
    required this.verifyOtpUseCase,
    required this.verificationId,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  void _verifyOtp() async {
    final otp = _otpController.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP cannot be empty")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await widget.verifyOtpUseCase.execute(widget.verificationId, otp);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Verification Successful")),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "OTP"),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _verifyOtp,
                    child: const Text("Verify OTP"),
                  ),
          ],
        ),
      ),
    );
  }
}
