import 'package:blog_hub/features/dashboard/admin%20dashboard/admin_dashboard_componenr.dart';
import 'package:blog_hub/features/dashboard/admin%20dashboard/controller/admin_dashboard_provider_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminDashboardProviderController>().fetchAllUsers(context);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildStatsRow(),
              _buildSearchBar(),
              const SizedBox(height: 4),
              Expanded(child: _buildUserList()),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ──
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFFF9A6C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B35).withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.admin_panel_settings_rounded,
                color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Admin Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Manage all users',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.4), fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          // ── Refresh ──
          GestureDetector(
            onTap: () => context
                .read<AdminDashboardProviderController>()
                .fetchAllUsers(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Icon(Icons.refresh_rounded,
                  color: Colors.white.withOpacity(0.6), size: 20),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats Row ──
  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Consumer<AdminDashboardProviderController>(
        builder: (_, ctrl, __) => Row(
          children: [
            StatCard(
                label: 'Total',
                value: ctrl.totalUsers,
                color: const Color(0xFFFF6B35),
                icon: Icons.people_rounded),
            const SizedBox(width: 12),
            StatCard(
                label: 'Active',
                value: ctrl.activeUsers,
                color: const Color(0xFF4CAF50),
                icon: Icons.check_circle_rounded),
            const SizedBox(width: 12),
            StatCard(
                label: 'Inactive',
                value: ctrl.inactiveUsers,
                color: const Color(0xFF9E9E9E),
                icon: Icons.block_rounded),
          ],
        ),
      ),
    );
  }

  // ── Search Bar ──
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Consumer<AdminDashboardProviderController>(
        builder: (_, ctrl, __) => Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: TextField(
            controller: ctrl.searchController,
            onChanged: ctrl.onSearchChanged,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search by name, email or ID...',
              hintStyle:
                  TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13),
              prefixIcon: Icon(Icons.search_rounded,
                  color: Colors.white.withOpacity(0.3), size: 20),
              suffixIcon: ctrl.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear_rounded,
                          color: Colors.white.withOpacity(0.3), size: 18),
                      onPressed: () {
                        ctrl.searchController.clear();
                        ctrl.onSearchChanged('');
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ),
    );
  }

  // ── User List ──
  Widget _buildUserList() {
    return Consumer<AdminDashboardProviderController>(
      builder: (context, ctrl, _) {
        if (ctrl.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
                color: Color(0xFFFF6B35), strokeWidth: 2.5),
          );
        }
        if (ctrl.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline_rounded,
                    color: Colors.white.withOpacity(0.25), size: 52),
                const SizedBox(height: 12),
                Text(ctrl.errorMessage!,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.4), fontSize: 13)),
                const SizedBox(height: 16),
                GradientButton(
                  label: 'Retry',
                  onTap: () => ctrl.fetchAllUsers(context),
                ),
              ],
            ),
          );
        }
        if (ctrl.filteredUsers.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person_search_rounded,
                    color: Colors.white.withOpacity(0.12), size: 60),
                const SizedBox(height: 12),
                Text('No users found',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.3), fontSize: 14)),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          itemCount: ctrl.filteredUsers.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final user = ctrl.filteredUsers[index];
            return UserCard(user: user);
          },
        );
      },
    );
  }
}
