

import 'package:Expanses/Auth/data/datasources/firebase_auth_datasource.dart';
import 'package:Expanses/Auth/data/repositories/auth_repository_impl.dart';
import 'package:Expanses/Auth/domain/usecases/send_otp_usecase.dart';
import 'package:Expanses/Auth/domain/usecases/verify_otp_usecase.dart';
import 'package:Expanses/Auth/presentation/pages/loginscreen.dart';
import 'package:Expanses/Auth/presentation/pages/otpscreen.dart';
import 'package:flutter/material.dart';


void main() {
  final firebaseAuthDataSource = FirebaseAuthDataSource();
  final authRepository = AuthRepositoryImpl(firebaseAuthDataSource);

  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;

  const MyApp({Key? key, required this.authRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(
              sendOtpUseCase: SendOtpUseCase(authRepository),
            ),
        '/otp': (context) {
          final verificationId = ModalRoute.of(context)?.settings.arguments as String;
          return OtpScreen(
            verifyOtpUseCase: VerifyOtpUseCase(authRepository),
            verificationId: verificationId,
          );
        },
      },
    );
  }
}
