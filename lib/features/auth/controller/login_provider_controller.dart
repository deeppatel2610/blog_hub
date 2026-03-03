import 'package:blog_hub/ core/utils/app_messenger.dart';
import 'package:blog_hub/ core/utils/enums.dart';
import 'package:blog_hub/features/auth/service/auth_api_service.dart';
import 'package:flutter/material.dart';

class LoginProviderController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  late AnimationController fadeController;
  late AnimationController slideController;
  late List<Animation<Offset>> slideAnimations;
  late List<Animation<double>> fadeAnimations;

  void initState() {
    slideAnimations = List.generate(6, (i) {
      final start = i * 0.12;
      final end = (start + 0.5).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0, 0.35),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: slideController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });

    fadeAnimations = List.generate(6, (i) {
      final start = i * 0.12;
      final end = (start + 0.45).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: fadeController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    fadeController.forward();
    slideController.forward();
  }

  Widget animatedItem(int index, Widget child) {
    return SlideTransition(
      position: slideAnimations[index],
      child: FadeTransition(
        opacity: fadeAnimations[index],
        child: child,
      ),
    );
  }

  void obscurePasswordMethod() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  Future<MessageType> onLoginApiCalling({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    if (!formKey.currentState!.validate()) return MessageType.error;
    try {
      isLoading = true;
      notifyListeners();

      MessageType messageType =
      await AuthApiService.authApiService.loginApiCalling(
        username: username,
        password: password,
        context: context,
      );
      return messageType;
    } catch (e) {
      AppMessenger.showSnackBar(
        context,
        message: "Email or password is incorrect!",
        type: MessageType.error,
      );
      return MessageType.error;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void disposeControllers() {
    fadeController.dispose();
    slideController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}