import 'package:Expanses/core/utils/app_routes.dart';
import 'package:Expanses/core/utils/db_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Check SQLite for login state
  final dbHelper = DBHelper.instance;
  final loggedInUser = await dbHelper.getLoggedInUser();

 runApp(
    ProviderScope(
      child: MyApp(initialRoute: loggedInUser != null ? '/home' : '/'),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initialRoute,
      debugShowCheckedModeBanner: false,
      routes: appRoutes,
    );
  }
}
