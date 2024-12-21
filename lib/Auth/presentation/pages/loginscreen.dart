import 'package:Expanses/Auth/domain/usecases/send_otp_usecase.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  final SendOtpUseCase sendOtpUseCase;

  const LoginScreen({Key? key, required this.sendOtpUseCase})
      : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  void _sendOtp() async {
    final phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Phone number cannot be empty")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final verificationId = await widget.sendOtpUseCase.execute(phoneNumber);
      Navigator.pushNamed(
        context,
        '/otp',
        arguments: verificationId,
      );
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
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "Phone Number"),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _sendOtp,
                    child: const Text("Send OTP"),
                  ),
          ],
        ),
      ),
    );
  }
}
