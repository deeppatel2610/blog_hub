import 'package:blog_hub/features/auth/controller/login_provider_controller.dart';
import 'package:blog_hub/features/auth/controller/register_provider_controller.dart';
import 'package:blog_hub/features/auth/view/login_screen.dart';
import 'package:blog_hub/features/auth/view/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterProviderController()),
        ChangeNotifierProvider(create: (_) => LoginProviderController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const LoginScreen(),
      },
    );
  }
}
