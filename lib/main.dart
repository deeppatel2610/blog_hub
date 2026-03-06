import 'package:blog_hub/features/add%20post/controller/add_edit_post_provider_controller.dart';
import 'package:blog_hub/features/add%20post/view/add_edit_post_screen.dart';
import 'package:blog_hub/features/auth/controller/login_provider_controller.dart';
import 'package:blog_hub/features/auth/controller/register_provider_controller.dart';
import 'package:blog_hub/features/auth/view/login_screen.dart';
import 'package:blog_hub/features/auth/view/register_screen.dart';
import 'package:blog_hub/features/dashboard/admin%20dashboard/controller/admin_dashboard_provider_controller.dart';
import 'package:blog_hub/features/dashboard/admin%20dashboard/view/admin_dashboard.dart';
import 'package:blog_hub/features/dashboard/user%20dashboard/controller/user_dashboard_provider_controller.dart';
import 'package:blog_hub/features/dashboard/user%20dashboard/view/user_dashboard_screen.dart';
import 'package:blog_hub/features/global%20feed/controller/global_feed_provider_controller.dart';
import 'package:blog_hub/features/global%20feed/view/global_feed_screen.dart';
import 'package:blog_hub/features/profile/controller/profile_provider_controller.dart';
import 'package:blog_hub/features/profile/view/profile_screen.dart';
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
        ChangeNotifierProvider(
            create: (_) => UserDashboardProviderController()),
        ChangeNotifierProvider(create: (_) => GlobalFeedProviderController()),
        ChangeNotifierProvider(create: (_) => ProfileProviderController()),
        ChangeNotifierProvider(create: (_) => AddEditPostProviderController()),
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
        '/user-dashboard': (context) => const UserDashboardScreen(),
        '/global-feed': (context) => const GlobalFeedScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/add-edit-post': (context) => const AddEditPostScreen(),
      },
    );
  }
}
