import 'package:blog_hub/%20core/storage/preference_keys.dart';
import 'package:blog_hub/features/auth/view/login_screen.dart';
import 'package:blog_hub/features/dashboard/admin%20dashboard/view/admin_dashboard.dart';
import 'package:blog_hub/features/global%20feed/view/global_feed_screen.dart';
import 'package:blog_hub/features/profile/view/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer>
    with SingleTickerProviderStateMixin {
  int _userId = 0;
  String _role = '';
  bool _isLoading = true;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(-0.08, 0),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt(PreferenceKeys.userId) ?? 0;
      _role = prefs.getString(PreferenceKeys.role) ?? 'user';
      _isLoading = false;
    });
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // ── Navigate helper ──
  void _navigate(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  // ── Logout ──
  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF111111),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF5350).withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: const Color(0xFFEF5350).withOpacity(0.3)),
                ),
                child: const Icon(Icons.logout_rounded,
                    color: Color(0xFFEF5350), size: 28),
              ),
              const SizedBox(height: 16),
              const Text(
                'Logout',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Text(
                'Are you sure you want to\nlogout from BlogHub?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.45),
                    fontSize: 13,
                    height: 1.6),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  // Cancel
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context, false),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: const Center(
                          child: Text('Cancel',
                              style: TextStyle(
                                  color: Colors.white60,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Logout
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context, true),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF5350).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color(0xFFEF5350).withOpacity(0.3)),
                        ),
                        child: const Center(
                          child: Text('Logout',
                              style: TextStyle(
                                  color: Color(0xFFEF5350),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const LoginScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 400),
          ),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0D0D0D),
      width: MediaQuery.of(context).size.width * 0.82,
      child: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                    color: Color(0xFFFF6B35), strokeWidth: 2))
            : FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Column(
                    children: [
                      // ── Profile Header ──
                      _buildProfileHeader(),

                      Divider(
                        color: Colors.white.withOpacity(0.07),
                        height: 1,
                        indent: 24,
                        endIndent: 24,
                      ),

                      const SizedBox(height: 12),

                      // ── Menu Items ──
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            _buildSectionLabel('MENU'),
                            const SizedBox(height: 8),

                            // Profile
                            _DrawerMenuItem(
                              icon: Icons.person_rounded,
                              label: 'My Profile',
                              subtitle: 'View your info',
                              color: const Color(0xFFFF6B35),
                              onTap: () =>
                                  _navigate(context, const ProfileScreen()),
                            ),
                            const SizedBox(height: 8),

                            // My Dashboard
                            if (_role == 'user') ...[
                              _DrawerMenuItem(
                                icon: Icons.dashboard_rounded,
                                label: 'My Dashboard',
                                subtitle: 'Your posts',
                                color: const Color(0xFF4CAF50),
                                onTap: () => Navigator.pop(context),
                              ),
                              const SizedBox(height: 8),
                            ],
                            // Global Feed
                            _DrawerMenuItem(
                              icon: Icons.public_rounded,
                              label: 'Global Feed',
                              subtitle: 'All posts',
                              color: const Color(0xFF42A5F5),
                              onTap: () =>
                                  _navigate(context, const GlobalFeedScreen()),
                            ),

                            // ── Admin only ──
                            if (_role == 'admin') ...[
                              const SizedBox(height: 20),
                              _buildSectionLabel('ADMIN'),
                              const SizedBox(height: 8),
                              _DrawerMenuItem(
                                icon: Icons.admin_panel_settings_rounded,
                                label: 'Admin Dashboard',
                                subtitle: 'Manage all users',
                                color: const Color(0xFFFFB300),
                                badge: 'ADMIN',
                                onTap: () => _navigate(
                                    context, const AdminDashboardScreen()),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // ── App version ──
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF6B35),
                                    Color(0xFFFF9A6C)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.article_rounded,
                                  color: Colors.white, size: 14),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'BlogHub  v1.0.0',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.25),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),

                      Divider(
                        color: Colors.white.withOpacity(0.07),
                        height: 1,
                        indent: 24,
                        endIndent: 24,
                      ),

                      // ── Logout Button ──
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: GestureDetector(
                          onTap: () => _logout(context),
                          child: Container(
                            width: double.infinity,
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF5350).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: const Color(0xFFEF5350)
                                      .withOpacity(0.25)),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.logout_rounded,
                                    color: Color(0xFFEF5350), size: 18),
                                SizedBox(width: 10),
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: Color(0xFFEF5350),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
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

  // ── Profile Header ──
  Widget _buildProfileHeader() {
    final isAdmin = _role == 'admin';
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Row(
        children: [
          // Avatar
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: const Color(0xFFFF6B35).withOpacity(0.4), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B35).withOpacity(0.2),
                  blurRadius: 16,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                'https://ui-avatars.com/api/?name=User+$_userId&background=FF6B35&color=fff&bold=true&size=80&rounded=true',
                width: 54,
                height: 54,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 54,
                  height: 54,
                  color: const Color(0xFF1A1A1A),
                  child: const Icon(Icons.person_rounded,
                      color: Color(0xFFFF6B35), size: 26),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User $_userId',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                // Role badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isAdmin
                        ? const Color(0xFFFFB300).withOpacity(0.12)
                        : const Color(0xFFFF6B35).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isAdmin
                          ? const Color(0xFFFFB300).withOpacity(0.3)
                          : const Color(0xFFFF6B35).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isAdmin
                            ? Icons.admin_panel_settings_rounded
                            : Icons.person_rounded,
                        color: isAdmin
                            ? const Color(0xFFFFB300)
                            : const Color(0xFFFF6B35),
                        size: 10,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _role.toUpperCase(),
                        style: TextStyle(
                          color: isAdmin
                              ? const Color(0xFFFFB300)
                              : const Color(0xFFFF6B35),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Close
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Icon(Icons.close_rounded,
                  color: Colors.white.withOpacity(0.4), size: 16),
            ),
          ),
        ],
      ),
    );
  }

  // ── Section Label ──
  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withOpacity(0.25),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────
// DRAWER MENU ITEM
// ────────────────────────────────────────────

class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final String? badge;
  final VoidCallback onTap;

  const _DrawerMenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            // Icon box
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: color, size: 19),
            ),
            const SizedBox(width: 14),
            // Label + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.35),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            // Badge or arrow
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Text(
                  badge!,
                  style: TextStyle(
                      color: color,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5),
                ),
              )
            else
              Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.2), size: 14),
          ],
        ),
      ),
    );
  }
}
