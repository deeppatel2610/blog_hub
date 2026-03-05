import 'package:blog_hub/features/auth/view/login_screen.dart';
import 'package:blog_hub/features/dashboard/admin%20dashboard/view/admin_dashboard.dart';
import 'package:blog_hub/features/dashboard/user%20dashboard/view/user_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _pulseController;
  late AnimationController _exitController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _taglineFade;
  late Animation<double> _pulse;
  late Animation<double> _exitFade;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    // Logo animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Text animation
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    // Pulse glow on logo
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Exit fade
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeIn),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    _textController.forward();

    // Hold for a moment then navigate
    await Future.delayed(const Duration(milliseconds: 2000));
    await _exitController.forward();

    if (mounted) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      bool isLoggedIn = sharedPreferences.getBool("isLoggedIn") ?? false;
      bool isAdmin = sharedPreferences.getBool("isAdmin") ?? false;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => isLoggedIn
              ? isAdmin
                  ? const AdminDashboardScreen()
                  : const UserDashboardScreen()
              : const LoginScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _exitFade,
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0D0D),
        body: Stack(
          children: [
            // ── Background radial glow ──
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _pulse,
                builder: (context, _) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 0.85,
                        colors: [
                          const Color(0xFFFF6B35)
                              .withOpacity(0.08 * _pulse.value),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // ── Center content ──
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Logo ──
                  AnimatedBuilder(
                    animation: _pulse,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF6B35)
                                  .withOpacity(0.35 * _pulse.value),
                              blurRadius: 48 * _pulse.value,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: child,
                      );
                    },
                    child: FadeTransition(
                      opacity: _logoFade,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B35), Color(0xFFFF9A6C)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF6B35).withOpacity(0.4),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.article_rounded,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── App name ──
                  SlideTransition(
                    position: _textSlide,
                    child: FadeTransition(
                      opacity: _textFade,
                      child: const Text(
                        'BlogHub',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ── Tagline ──
                  FadeTransition(
                    opacity: _taglineFade,
                    child: Text(
                      'Stories worth reading.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.4),
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Bottom loader ──
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _taglineFade,
                child: Column(
                  children: [
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          const Color(0xFFFF6B35).withOpacity(0.7),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Loading...',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.25),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
