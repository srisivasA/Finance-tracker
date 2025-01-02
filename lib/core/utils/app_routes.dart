import 'package:Expanses/Auth/data/datasources/firebase_auth_datasource.dart';
import 'package:Expanses/Auth/data/repositories/auth_repository_impl.dart';
import 'package:Expanses/Auth/domain/usecases/send_otp_usecase.dart';
import 'package:Expanses/Auth/domain/usecases/verify_otp_usecase.dart';
import 'package:Expanses/Auth/presentation/pages/loginscreen.dart';
import 'package:Expanses/Auth/presentation/pages/otpscreen.dart';
import 'package:Expanses/homescreen/presentation/pages/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../profileScreen/presentation/transaction_report.dart';

final firebaseAuthDataSource = FirebaseAuthDataSource();
final authRepository = AuthRepositoryImpl(firebaseAuthDataSource);

final mobileNumberProvider = StateProvider<String?>((ref) => null);



Map<String, WidgetBuilder> appRoutes = {
 
  '/': (context) => LoginScreen(
        sendOtpUseCase: SendOtpUseCase(authRepository),
      ),
      
      '/transaction-report': (context) => const TransactionReportScreen(),
 '/otp': (context) {
  final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
  final verificationId = args['verificationId']!;
  final mobileNumber = args['mobileNumber']!;

  return Consumer(
    builder: (context, ref, child) {
      return OtpScreen(
        verifyOtpUseCase: VerifyOtpUseCase(authRepository),
        verificationId: verificationId,
        mobileNumber: mobileNumber,
      );
    },
  );
},


  '/home': (context) => HomeScreen(),
};