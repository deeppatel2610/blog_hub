import 'package:blog_hub/features/profile/controller/profile_provider_controller.dart';
import 'package:blog_hub/features/profile/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProviderController>().fetchProfile(context);
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Consumer<ProfileProviderController>(
            builder: (context, ctrl, _) {
              if (ctrl.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                      color: Color(0xFFFF6B35), strokeWidth: 2.5),
                );
              }
              if (ctrl.errorMessage != null || ctrl.profile == null) {
                return _ErrorView(
                  message: ctrl.errorMessage ?? 'Something went wrong',
                  onRetry: () => ctrl.fetchProfile(context),
                );
              }
              return _ProfileBody(profile: ctrl.profile!);
            },
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────
// PROFILE BODY
// ────────────────────────────────────────────

class _ProfileBody extends StatelessWidget {
  final ProfileModel profile;
  const _ProfileBody({required this.profile});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _buildHeader(context)),
        SliverToBoxAdapter(child: _buildAvatarSection()),
        SliverToBoxAdapter(child: _buildInfoSection()),
        SliverToBoxAdapter(child: _buildAccountSection()),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  // ── Top Header ──
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(13),
                border:
                Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Icon(Icons.arrow_back_rounded,
                  color: Colors.white.withOpacity(0.6), size: 19),
            ),
          ),
          const SizedBox(width: 14),
          const Text(
            'My Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          // Active status badge
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: profile.isActive
                  ? const Color(0xFF4CAF50).withOpacity(0.1)
                  : const Color(0xFF9E9E9E).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: profile.isActive
                    ? const Color(0xFF4CAF50).withOpacity(0.3)
                    : const Color(0xFF9E9E9E).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: profile.isActive
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFF9E9E9E),
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  profile.isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    color: profile.isActive
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFF9E9E9E),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Avatar Section ──
  Widget _buildAvatarSection() {
    final isAdmin = profile.role == 'admin';
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        children: [
          // Avatar with glow
          Center(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B35).withOpacity(0.3),
                    blurRadius: 36,
                    spreadRadius: 4,
                  ),
                ],
                border: Border.all(
                    color: const Color(0xFFFF6B35).withOpacity(0.4),
                    width: 2.5),
              ),
              child: ClipOval(
                child: Image.network(
                  profile.avatarUrl,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 110,
                    height: 110,
                    color: const Color(0xFF1A1A1A),
                    child: Center(
                      child: Text(
                        profile.initials,
                        style: const TextStyle(
                          color: Color(0xFFFF6B35),
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Full name
          Text(
            profile.fullName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),

          // Email
          Text(
            profile.email,
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),

          // Role badge
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isAdmin
                  ? const Color(0xFFFFB300).withOpacity(0.12)
                  : const Color(0xFFFF6B35).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isAdmin
                    ? const Color(0xFFFFB300).withOpacity(0.35)
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
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  profile.role.toUpperCase(),
                  style: TextStyle(
                    color: isAdmin
                        ? const Color(0xFFFFB300)
                        : const Color(0xFFFF6B35),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Personal Info ──
  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: 'Personal Info'),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.person_rounded,
                  label: 'First Name',
                  value: profile.firstname,
                  color: const Color(0xFFFF6B35),
                  showDivider: true,
                ),
                _InfoRow(
                  icon: Icons.person_outline_rounded,
                  label: 'Last Name',
                  value: profile.lastname,
                  color: const Color(0xFFFF6B35),
                  showDivider: true,
                ),
                _InfoRow(
                  icon: Icons.alternate_email_rounded,
                  label: 'Email',
                  value: profile.email,
                  color: const Color(0xFF42A5F5),
                  showDivider: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Account Info ──
  Widget _buildAccountSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: 'Account Info'),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.tag_rounded,
                  label: 'User ID',
                  value: '#${profile.id}',
                  color: const Color(0xFFFF6B35),
                  showDivider: true,
                ),
                _InfoRow(
                  icon: Icons.shield_rounded,
                  label: 'Role',
                  value: profile.role[0].toUpperCase() +
                      profile.role.substring(1),
                  color: profile.role == 'admin'
                      ? const Color(0xFFFFB300)
                      : const Color(0xFF42A5F5),
                  showDivider: true,
                ),
                _InfoRow(
                  icon: Icons.calendar_today_rounded,
                  label: 'Member Since',
                  value: profile.formattedCreatedAt,
                  color: const Color(0xFF4CAF50),
                  showDivider: true,
                ),
                _InfoRow(
                  icon: Icons.update_rounded,
                  label: 'Last Updated',
                  value: profile.formattedUpdatedAt,
                  color: const Color(0xFF9E9E9E),
                  showDivider: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────
// SECTION TITLE
// ────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B35), Color(0xFFFF9A6C)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────
// INFO ROW
// ────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool showDivider;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 17),
              ),
              const SizedBox(width: 14),
              Text(
                label,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.45), fontSize: 13),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            color: Colors.white.withOpacity(0.05),
            height: 1,
            indent: 18,
            endIndent: 18,
          ),
      ],
    );
  }
}

// ────────────────────────────────────────────
// ERROR VIEW
// ────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFEF5350).withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                    color: const Color(0xFFEF5350).withOpacity(0.25)),
              ),
              child: const Icon(Icons.wifi_off_rounded,
                  color: Color(0xFFEF5350), size: 32),
            ),
            const SizedBox(height: 16),
            const Text('Failed to load profile',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 12,
                  height: 1.5),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 13),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFFFF9A6C)]),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B35).withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Text('Try Again',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}