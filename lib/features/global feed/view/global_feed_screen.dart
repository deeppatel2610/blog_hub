
import 'package:blog_hub/features/dashboard/user%20dashboard/model/post_model.dart';
import 'package:blog_hub/features/dashboard/user%20dashboard/view/post_read_screen.dart';
import 'package:blog_hub/features/global%20feed/controller/global_feed_provider_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GlobalFeedScreen extends StatefulWidget {
  const GlobalFeedScreen({super.key});

  @override
  State<GlobalFeedScreen> createState() => _GlobalFeedScreenState();
}

class _GlobalFeedScreenState extends State<GlobalFeedScreen>
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
      context.read<GlobalFeedProviderController>().fetchPosts(context);
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
          child: Consumer<GlobalFeedProviderController>(
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
                  onRetry: () => ctrl.fetchPosts(context),
                );
              }
              return _FeedBody();
            },
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────
// FEED BODY
// ────────────────────────────────────────────

class _FeedBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _buildHeader(context)),
        SliverToBoxAdapter(child: _buildStatsRow()),
        SliverToBoxAdapter(child: _buildSearchBar()),
        SliverToBoxAdapter(child: _buildPostsLabel()),
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
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 42,
              height: 42,
              margin: const EdgeInsets.only(right: 14, top: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Icon(Icons.arrow_back_rounded,
                  color: Colors.white.withOpacity(0.6), size: 19),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Explore 🌍',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 13,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 4),
              const Text(
                'Global Feed',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
          const Spacer(),
          Consumer<GlobalFeedProviderController>(
            builder: (context, ctrl, _) => GestureDetector(
              onTap: () => ctrl.fetchPosts(context),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Icon(Icons.refresh_rounded,
                    color: Colors.white.withOpacity(0.55), size: 20),
              ),
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
      child: Consumer<GlobalFeedProviderController>(
        builder: (_, ctrl, __) => Row(
          children: [
            _StatCard(
              label: 'Total Posts',
              value: '${ctrl.totalPosts}',
              icon: Icons.article_rounded,
              color: const Color(0xFFFF6B35),
            ),
            const SizedBox(width: 12),
            _StatCard(
              label: 'Authors',
              value: '${ctrl.totalAuthors}',
              icon: Icons.people_rounded,
              color: const Color(0xFF42A5F5),
            ),
            const SizedBox(width: 12),
            _StatCard(
              label: 'Latest',
              value: ctrl.latestPostDate,
              icon: Icons.new_releases_rounded,
              color: const Color(0xFF4CAF50),
              smallValue: true,
            ),
          ],
        ),
      ),
    );
  }

  // ── Search ──
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Consumer<GlobalFeedProviderController>(
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
              hintText: 'Search all posts...',
              hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.3), fontSize: 13),
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
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ),
    );
  }

  // ── Section label ──
  Widget _buildPostsLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 14),
      child: Consumer<GlobalFeedProviderController>(
        builder: (_, ctrl, __) => Row(
          children: [
            const Text(
              'All Posts',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 8),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: const Color(0xFFFF6B35).withOpacity(0.3)),
              ),
              child: Text(
                '${ctrl.filteredPosts.length}',
                style: const TextStyle(
                    color: Color(0xFFFF6B35),
                    fontSize: 10,
                    fontWeight: FontWeight.w800),
              ),
            ),
            const Spacer(),
            if (ctrl.searchQuery.isNotEmpty)
              Text(
                '${ctrl.filteredPosts.length} result${ctrl.filteredPosts.length != 1 ? 's' : ''}',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.35), fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }

  // ── Post List ──
  Widget _buildPostList(BuildContext context) {
    return Consumer<GlobalFeedProviderController>(
      builder: (_, ctrl, __) {
        final posts = ctrl.filteredPosts;
        if (posts.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Column(
                children: [
                  Icon(Icons.public_off_rounded,
                      color: Colors.white.withOpacity(0.1), size: 60),
                  const SizedBox(height: 14),
                  Text(
                    ctrl.searchQuery.isNotEmpty
                        ? 'No posts match your search'
                        : 'No posts available',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.3), fontSize: 14),
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
                child: _GlobalPostCard(
                  post: posts[index],
                  onTap: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          PostReadScreen(post: posts[index]),
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
                ),
              ),
              childCount: posts.length,
            ),
          ),
        );
      },
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
  final bool smallValue;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.smallValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
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
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: smallValue ? 13 : 22,
                fontWeight: FontWeight.w800,
                height: smallValue ? 1.4 : 1,
              ),
            ),
            const SizedBox(height: 2),
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
// GLOBAL POST CARD
// ────────────────────────────────────────────

class _GlobalPostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback onTap;

  const _GlobalPostCard({required this.post, required this.onTap});

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
            // ── Top row ──
            Row(
              children: [
                // Author avatar
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: const Color(0xFFFF6B35).withOpacity(0.3),
                        width: 1.5),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      post.authorAvatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF1A1A1A),
                        child: const Icon(Icons.person_rounded,
                            color: Color(0xFFFF6B35), size: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User ${post.userId}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      post.formattedDate,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 10),
                    ),
                  ],
                ),
                const Spacer(),
                // Post ID badge
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(6),
                    border:
                    Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Text('#${post.id}',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.35),
                          fontSize: 10,
                          fontWeight: FontWeight.w700)),
                ),
                if (post.isUpdated) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF42A5F5).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: const Color(0xFF42A5F5).withOpacity(0.25)),
                    ),
                    child: const Text('Updated',
                        style: TextStyle(
                            color: Color(0xFF42A5F5),
                            fontSize: 10,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 14),

            // ── Title ──
            Text(
              post.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.35),
            ),
            const SizedBox(height: 8),

            // ── Content preview ──
            Text(
              post.shortContent,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.38),
                  fontSize: 12,
                  height: 1.6),
            ),
            const SizedBox(height: 14),

            Divider(color: Colors.white.withOpacity(0.05), height: 1),
            const SizedBox(height: 12),

            // ── Footer ──
            Row(
              children: [
                const Icon(Icons.timer_outlined,
                    color: Color(0xFFFF6B35), size: 13),
                const SizedBox(width: 5),
                Text(post.readTime,
                    style: const TextStyle(
                        color: Color(0xFFFF6B35),
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: const Color(0xFFFF6B35).withOpacity(0.2)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.menu_book_rounded,
                          color: Color(0xFFFF6B35), size: 12),
                      SizedBox(width: 5),
                      Text('Read Post',
                          style: TextStyle(
                              color: Color(0xFFFF6B35),
                              fontSize: 11,
                              fontWeight: FontWeight.w700)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded,
                          color: Color(0xFFFF6B35), size: 11),
                    ],
                  ),
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