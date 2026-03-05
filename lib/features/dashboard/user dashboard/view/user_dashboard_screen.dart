import 'package:blog_hub/%20core/storage/preference_keys.dart';
import 'package:blog_hub/features/components/app_drawer.dart';
import 'package:blog_hub/features/dashboard/user%20dashboard/controller/user_dashboard_provider_controller.dart';
import 'package:blog_hub/features/dashboard/user%20dashboard/model/post_model.dart';
import 'package:blog_hub/features/dashboard/user%20dashboard/view/post_read_screen.dart';
import 'package:blog_hub/features/global%20feed/view/global_feed_screen.dart';
import 'package:blog_hub/features/profile/view/profile_screen.dart';
import 'package:blog_hub/features/dashboard/admin%20dashboard/view/admin_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserDashboardProviderController>().fetchAllPosts(context);
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
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF0D0D0D),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Consumer<UserDashboardProviderController>(
            builder: (context, ctrl, _) {
              if (ctrl.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                      color: Color(0xFFFF6B35), strokeWidth: 2.5),
                );
              }
              if (ctrl.errorMessage != null) {
                return _ErrorView(
                  message: ctrl.errorMessage!,
                  onRetry: () => ctrl.fetchAllPosts(context),
                );
              }
              return _DashboardBody(scaffoldKey: _scaffoldKey);
            },
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────
// DASHBOARD BODY
// ────────────────────────────────────────────

class _DashboardBody extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const _DashboardBody({required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _buildHeader(context)),
        SliverToBoxAdapter(child: _buildStatsRow()),
        SliverToBoxAdapter(child: _buildSearchBar()),
        SliverToBoxAdapter(child: _buildRecentSection(context)),
        SliverToBoxAdapter(child: _buildAllPostsHeader()),
        _buildPostList(context),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  // ── Header ──
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hamburger ──
          GestureDetector(
            onTap: () => scaffoldKey.currentState?.openDrawer(),
            child: Container(
              width: 42,
              height: 42,
              margin: const EdgeInsets.only(right: 14, top: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(13),
                border:
                Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Icon(Icons.menu_rounded,
                  color: Colors.white.withOpacity(0.6), size: 20),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Dashboard 📝',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 13,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 4),
              const Text(
                'BlogHub',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.2,
                ),
              ),
            ],
          ),

          const Spacer(),

          // ── Refresh ──
          Consumer<UserDashboardProviderController>(
            builder: (context, ctrl, _) => GestureDetector(
              onTap: () => ctrl.fetchAllPosts(context),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(13),
                  border:
                  Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Icon(Icons.refresh_rounded,
                    color: Colors.white.withOpacity(0.55), size: 20),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // ── Global Feed ──
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const GlobalFeedScreen(),
                transitionsBuilder: (_, anim, __, child) =>
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                          parent: anim, curve: Curves.easeOutCubic)),
                      child: child,
                    ),
                transitionDuration: const Duration(milliseconds: 350),
              ),
            ),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B35), Color(0xFFFF9A6C)]),
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B35).withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.public_rounded,
                  color: Colors.white, size: 20),
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
      child: Consumer<UserDashboardProviderController>(
        builder: (_, ctrl, __) => Row(
          children: [
            _StatCard(
              label: 'My Posts',
              value: '${ctrl.myPostCount}',
              icon: Icons.article_rounded,
              color: const Color(0xFFFF6B35),
            ),
            const SizedBox(width: 12),
            _StatCard(
              label: 'Updated',
              value: '${ctrl.myUpdatedCount}',
              icon: Icons.edit_rounded,
              color: const Color(0xFF42A5F5),
            ),
            const SizedBox(width: 12),
            _StatCard(
              label: 'This Month',
              value: '${ctrl.myThisMonthCount}',
              icon: Icons.calendar_month_rounded,
              color: const Color(0xFF4CAF50),
            ),
          ],
        ),
      ),
    );
  }

  // ── Search Bar ──
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Consumer<UserDashboardProviderController>(
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
              hintText: 'Search your posts...',
              hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.3), fontSize: 13),
              prefixIcon: Icon(Icons.search_rounded,
                  color: Colors.white.withOpacity(0.3), size: 20),
              suffixIcon: ctrl.searchQuery.isNotEmpty
                  ? IconButton(
                icon: Icon(Icons.clear_rounded,
                    color: Colors.white.withOpacity(0.3),
                    size: 18),
                onPressed: () {
                  ctrl.searchController.clear();
                  ctrl.onSearchChanged('');
                },
              )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ),
    );
  }

  // ── Recent Section ──
  Widget _buildRecentSection(BuildContext context) {
    return Consumer<UserDashboardProviderController>(
      builder: (_, ctrl, __) {
        final recent = [...ctrl.myPosts]
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        if (recent.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 14),
              child: Row(
                children: [
                  const Text('Recent',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color:
                      const Color(0xFFFF6B35).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFFFF6B35)
                              .withOpacity(0.3)),
                    ),
                    child: Text('${recent.length}',
                        style: const TextStyle(
                            color: Color(0xFFFF6B35),
                            fontSize: 10,
                            fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 170,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: recent.take(6).length,
                separatorBuilder: (_, __) =>
                const SizedBox(width: 14),
                itemBuilder: (_, index) => GestureDetector(
                  onTap: () =>
                      _navigateToRead(context, recent[index]),
                  child: _RecentCard(post: recent[index]),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── All Posts Header ──
  Widget _buildAllPostsHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 14),
      child: Consumer<UserDashboardProviderController>(
        builder: (_, ctrl, __) => Row(
          children: [
            const Text('My Posts',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700)),
            const Spacer(),
            if (ctrl.searchQuery.isNotEmpty)
              Text(
                '${ctrl.filteredMyPosts.length} result${ctrl.filteredMyPosts.length != 1 ? 's' : ''}',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.35),
                    fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }

  // ── Post List ──
  Widget _buildPostList(BuildContext context) {
    return Consumer<UserDashboardProviderController>(
      builder: (_, ctrl, __) {
        final posts = ctrl.filteredMyPosts;
        if (posts.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                children: [
                  Icon(Icons.article_outlined,
                      color: Colors.white.withOpacity(0.1), size: 60),
                  const SizedBox(height: 14),
                  Text(
                    ctrl.searchQuery.isNotEmpty
                        ? 'No posts match your search'
                        : "You haven't written any posts yet",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        }
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                  (_, index) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _PostCard(
                  post: posts[index],
                  onTap: () =>
                      _navigateToRead(context, posts[index]),
                ),
              ),
              childCount: posts.length,
            ),
          ),
        );
      },
    );
  }

  void _navigateToRead(BuildContext context, PostModel post) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => PostReadScreen(post: post),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
                parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }
}

// ────────────────────────────────────────────
// STAT CARD
// ────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding:
        const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.18)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    color: color,
                    fontSize: 22,
                    fontWeight: FontWeight.w800)),
            Text(label,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.35),
                    fontSize: 10,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────
// RECENT CARD
// ────────────────────────────────────────────

class _RecentCard extends StatelessWidget {
  final PostModel post;
  const _RecentCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFFFF6B35).withOpacity(0.15)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -16,
            right: -16,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF6B35).withOpacity(0.05),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color:
                      const Color(0xFFFF6B35).withOpacity(0.25)),
                ),
                child: Text('POST #${post.id}',
                    style: const TextStyle(
                        color: Color(0xFFFF6B35),
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5)),
              ),
              const Spacer(),
              Text(post.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.3)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded,
                      color: Colors.white.withOpacity(0.3), size: 11),
                  const SizedBox(width: 5),
                  Text(post.formattedDate,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.35),
                          fontSize: 10)),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_rounded,
                      color: Color(0xFFFF6B35), size: 14),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────
// POST CARD
// ────────────────────────────────────────────

class _PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback onTap;

  const _PostCard({required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Text('#${post.id}',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 10,
                          fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 8),
                if (post.isUpdated)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color:
                      const Color(0xFF42A5F5).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: const Color(0xFF42A5F5)
                              .withOpacity(0.25)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.edit_rounded,
                            color: Color(0xFF42A5F5), size: 10),
                        SizedBox(width: 4),
                        Text('Updated',
                            style: TextStyle(
                                color: Color(0xFF42A5F5),
                                fontSize: 10,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color:
                        const Color(0xFFFF6B35).withOpacity(0.2)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.menu_book_rounded,
                          color: Color(0xFFFF6B35), size: 10),
                      SizedBox(width: 4),
                      Text('Read',
                          style: TextStyle(
                              color: Color(0xFFFF6B35),
                              fontSize: 10,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(post.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.35)),
            const SizedBox(height: 8),
            Text(post.shortContent,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.38),
                    fontSize: 12,
                    height: 1.6)),
            const SizedBox(height: 14),
            Divider(
                color: Colors.white.withOpacity(0.05), height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today_rounded,
                    color: Colors.white.withOpacity(0.3), size: 12),
                const SizedBox(width: 6),
                Text(post.formattedDate,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.35),
                        fontSize: 11)),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined,
                        color: Color(0xFFFF6B35), size: 12),
                    const SizedBox(width: 4),
                    Text(post.readTime,
                        style: const TextStyle(
                            color: Color(0xFFFF6B35),
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(width: 10),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        color: Color(0xFFFF6B35), size: 12),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
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
            const Text('Something went wrong',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 12,
                    height: 1.5)),
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