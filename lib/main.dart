import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_mail/firebase_options.dart';
import 'package:work_mail/pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:work_mail/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => AuthService(),
    child: const MyApp(),
  ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
