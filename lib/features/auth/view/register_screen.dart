import 'dart:developer';

import 'package:blog_hub/%20core/utils/app_messenger.dart';
import 'package:blog_hub/%20core/utils/enums.dart';
import 'package:blog_hub/features/auth/controller/register_provider_controller.dart';
import 'package:blog_hub/features/components/auth_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    final controller = context.read<RegisterProviderController>();
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
    final controller = context.read<RegisterProviderController>();
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
            key: context.watch<RegisterProviderController>().formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──
                context.read<RegisterProviderController>().animatedItem(
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
                            child: const Icon(Icons.person_add_rounded,
                                color: Colors.white, size: 26),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Create\nAccount',
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
                            'Join us — it only takes a minute.',
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

                // ── First & Last Name Row ──
                context.read<RegisterProviderController>().animatedItem(
                      1,
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: context
                                  .watch<RegisterProviderController>()
                                  .firstNameController,
                              label: 'First name',
                              icon: Icons.badge_outlined,
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? 'Required'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: AppTextField(
                              controller: context
                                  .watch<RegisterProviderController>()
                                  .lastNameController,
                              label: 'Last name',
                              icon: Icons.badge_outlined,
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? 'Required'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),

                const SizedBox(height: 16),

                // ── Email ──
                context.read<RegisterProviderController>().animatedItem(
                      2,
                      AppTextField(
                        controller: context
                            .watch<RegisterProviderController>()
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
                context.read<RegisterProviderController>().animatedItem(
                      3,
                      AppTextField(
                        controller: context
                            .watch<RegisterProviderController>()
                            .passwordController,
                        label: 'Password',
                        icon: Icons.lock_outline_rounded,
                        obscureText: context
                            .watch<RegisterProviderController>()
                            .obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            context
                                    .watch<RegisterProviderController>()
                                    .obscurePassword
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: Colors.white38,
                            size: 20,
                          ),
                          onPressed: () {
                            context
                                .read<RegisterProviderController>()
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

                // ── Password hint ──
                context.read<RegisterProviderController>().animatedItem(
                      3,
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          'Use 6+ characters with letters and numbers.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),

                const SizedBox(height: 36),

                // ── Register Button ──
                context.read<RegisterProviderController>().animatedItem(
                      4,
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
                                    .watch<RegisterProviderController>()
                                    .isLoading
                                ? null
                                : () async {
                                    final ctrl = context
                                        .read<RegisterProviderController>();

                                    final result =
                                        await ctrl.onRegisterApiCalling(
                                      context: context,
                                      firstname:
                                          ctrl.firstNameController.text.trim(),
                                      lastname:
                                          ctrl.lastNameController.text.trim(),
                                      email: ctrl.emailController.text.trim(),
                                      password:
                                          ctrl.passwordController.text.trim(),
                                    );

                                    if (result == MessageType.success) {
                                      AppMessenger.showSnackBar(
                                        context,
                                        message: "Registration successful",
                                        type: MessageType.success,
                                      );
                                    } else {
                                      AppMessenger.showSnackBar(
                                        context,
                                        message: "Registration failed",
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
                                    .watch<RegisterProviderController>()
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
                                    'Create Account',
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
                context.read<RegisterProviderController>().animatedItem(
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
                              'or sign up with',
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
                context.read<RegisterProviderController>().animatedItem(
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

                // ── Login Link ──
                context.read<RegisterProviderController>().animatedItem(
                      5,
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 14,
                            ),
                            children: [
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigate to login
                                  },
                                  child: const Text(
                                    'Sign in',
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
