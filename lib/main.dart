import 'package:flutter/material.dart';
import 'package:smart_menu_app/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Menu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFEE4F62)),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const LoginScreen(),
      },
    );
  }
}
