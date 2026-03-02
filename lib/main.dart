import 'package:blog_hub/features/auth/controller/login_provider_controller.dart';
import 'package:blog_hub/features/auth/controller/register_provider_controller.dart';
import 'package:blog_hub/features/auth/view/login_screen.dart';
import 'package:blog_hub/features/auth/view/register_screen.dart';
import 'package:blog_hub/features/dashboard/admin%20dashboard/controller/admin_dashboard_provider_controller.dart';
import 'package:blog_hub/features/dashboard/admin%20dashboard/view/admin_dashboard.dart';
import 'package:blog_hub/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterProviderController()),
        ChangeNotifierProvider(create: (_) => LoginProviderController()),
        ChangeNotifierProvider(
            create: (_) => AdminDashboardProviderController()),
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
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/admin-dashboard': (context) => const AdminDashboardScreen(),
      },
    );
  }
}
