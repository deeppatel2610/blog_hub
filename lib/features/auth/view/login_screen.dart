import 'package:blog_hub/ core/utils/app_messenger.dart';
import 'package:blog_hub/ core/utils/enums.dart';
import 'package:blog_hub/features/auth/auth_component.dart';
import 'package:blog_hub/features/auth/controller/login_provider_controller.dart';
import 'package:blog_hub/features/auth/view/register_screen.dart';
import 'package:blog_hub/features/dashboard/admin%20dashboard/view/admin_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    final controller = context.read<LoginProviderController>();
    controller.fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    controller.slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    controller.initState();
  }

  @override
  void dispose() {
    final controller = context.read<LoginProviderController>();
    controller.disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Form(
            key: context.watch<LoginProviderController>().formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──
                context.read<LoginProviderController>().animatedItem(
                      0,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF6B35), Color(0xFFFF9A6C)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.login_rounded,
                                color: Colors.white, size: 26),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Welcome\nBack',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.1,
                              letterSpacing: -1.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Sign in to continue where you left off.',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white.withOpacity(0.45),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 36),
                        ],
                      ),
                    ),

                // ── Email ──
                context.read<LoginProviderController>().animatedItem(
                      1,
                      AppTextField(
                        controller: context
                            .watch<LoginProviderController>()
                            .emailController,
                        label: 'Email address',
                        icon: Icons.alternate_email_rounded,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(v)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                    ),

                const SizedBox(height: 16),

                // ── Password ──
                context.read<LoginProviderController>().animatedItem(
                      2,
                      AppTextField(
                        controller: context
                            .watch<LoginProviderController>()
                            .passwordController,
                        label: 'Password',
                        icon: Icons.lock_outline_rounded,
                        obscureText: context
                            .watch<LoginProviderController>()
                            .obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            context
                                    .watch<LoginProviderController>()
                                    .obscurePassword
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: Colors.white38,
                            size: 20,
                          ),
                          onPressed: () {
                            context
                                .read<LoginProviderController>()
                                .obscurePasswordMethod();
                          },
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          if (v.length < 6) return 'Min 6 characters';
                          return null;
                        },
                      ),
                    ),

                const SizedBox(height: 12),

                // ── Forgot Password ──
                context.read<LoginProviderController>().animatedItem(
                      2,
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to forgot password
                          },
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: Color(0xFFFF6B35),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                const SizedBox(height: 36),

                // ── Login Button ──
                context.read<LoginProviderController>().animatedItem(
                      3,
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B35), Color(0xFFFF9A6C)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF6B35).withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: context
                                    .watch<LoginProviderController>()
                                    .isLoading
                                ? null
                                : () async {
                                    final ctrl =
                                        context.read<LoginProviderController>();

                                    final result = await ctrl.onLoginApiCalling(
                                      context: context,
                                      username:
                                          ctrl.emailController.text.trim(),
                                      password:
                                          ctrl.passwordController.text.trim(),
                                    );

                                    if (result == MessageType.success) {
                                      SharedPreferences sharedPreferences =
                                          await SharedPreferences.getInstance();
                                      bool isLoggedIn = sharedPreferences
                                              .getBool("isLoggedIn") ??
                                          false;
                                      bool isAdmin = sharedPreferences
                                              .getBool("isAdmin") ??
                                          false;
                                      Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (_, __, ___) => isLoggedIn
                                              ? isAdmin
                                                  ? const AdminDashboardScreen()
                                                  : const Scaffold(
                                                      body: Center(
                                                        child: Text(
                                                            'You are not an admin'),
                                                      ),
                                                    )
                                              : const LoginScreen(),
                                          transitionsBuilder:
                                              (_, animation, __, child) {
                                            return FadeTransition(
                                                opacity: animation,
                                                child: child);
                                          },
                                          transitionDuration:
                                              const Duration(milliseconds: 500),
                                        ),
                                      );
                                    } else {
                                      AppMessenger.showSnackBar(
                                        context,
                                        message: "Login failed",
                                        type: MessageType.error,
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: context
                                    .watch<LoginProviderController>()
                                    .isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),

                const SizedBox(height: 28),

                // ── Divider ──
                context.read<LoginProviderController>().animatedItem(
                      4,
                      Row(
                        children: [
                          Expanded(
                            child:
                                Divider(color: Colors.white.withOpacity(0.1)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'or sign in with',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                          ),
                          Expanded(
                            child:
                                Divider(color: Colors.white.withOpacity(0.1)),
                          ),
                        ],
                      ),
                    ),

                const SizedBox(height: 20),

                // ── Social Buttons ──
                context.read<LoginProviderController>().animatedItem(
                      4,
                      Row(
                        children: [
                          Expanded(
                            child: SocialButton(
                              label: 'Google',
                              icon: Icons.g_mobiledata_rounded,
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: SocialButton(
                              label: 'Apple',
                              icon: Icons.apple_rounded,
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ),

                const SizedBox(height: 36),

                // ── Register Link ──
                context.read<LoginProviderController>().animatedItem(
                      5,
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 14,
                            ),
                            children: [
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Sign up',
                                    style: TextStyle(
                                      color: Color(0xFFFF6B35),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
