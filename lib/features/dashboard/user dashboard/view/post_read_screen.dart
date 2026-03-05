import 'package:blog_hub/features/dashboard/user%20dashboard/model/post_model.dart';
import 'package:flutter/material.dart';

class PostReadScreen extends StatefulWidget {
  final PostModel post;
  const PostReadScreen({super.key, required this.post});

  @override
  State<PostReadScreen> createState() => _PostReadScreenState();
}

class _PostReadScreenState extends State<PostReadScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  final ScrollController _scrollController = ScrollController();
  double _readProgress = 0;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();

    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        final max = _scrollController.position.maxScrollExtent;
        final current = _scrollController.offset;
        setState(() {
          _readProgress = max > 0 ? (current / max).clamp(0.0, 1.0) : 0;
        });
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── App Bar ──
                SliverAppBar(
                  backgroundColor: const Color(0xFF0D0D0D),
                  pinned: true,
                  elevation: 0,
                  leading: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.08)),
                      ),
                      child: Icon(Icons.arrow_back_rounded,
                          color: Colors.white.withOpacity(0.7), size: 18),
                    ),
                  ),
                  actions: [
                    // Read time chip
                    Container(
                      margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xFFFF6B35).withOpacity(0.25)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.timer_outlined,
                              color: Color(0xFFFF6B35), size: 13),
                          const SizedBox(width: 5),
                          Text(post.readTime,
                              style: const TextStyle(
                                  color: Color(0xFFFF6B35),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Post Meta ──
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color:
                                Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.1)),
                              ),
                              child: Text('POST #${post.id}',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5)),
                            ),
                            const SizedBox(width: 8),
                            if (post.isUpdated)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF42A5F5)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: const Color(0xFF42A5F5)
                                          .withOpacity(0.25)),
                                ),
                                child: const Text('Updated',
                                    style: TextStyle(
                                        color: Color(0xFF42A5F5),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700)),
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // ── Title ──
                        Text(
                          post.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ── Author & Date Row ──
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF141414),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.06)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: const Color(0xFFFF6B35)
                                          .withOpacity(0.3),
                                      width: 1.5),
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    post.authorAvatarUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: const Color(0xFF1A1A1A),
                                      child: const Center(
                                        child: Icon(Icons.person_rounded,
                                            color: Color(0xFFFF6B35),
                                            size: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('User ${post.userId}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Published ${post.formattedDate}',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.4),
                                          fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                              if (post.isUpdated)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('Updated',
                                        style: TextStyle(
                                            color:
                                            Colors.white.withOpacity(0.3),
                                            fontSize: 10)),
                                    Text(
                                      post.updatedAt != null
                                          ? _formatDate(post.updatedAt!)
                                          : '',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.45),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ── Divider with label ──
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 20,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF6B35),
                                    Color(0xFFFF9A6C)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Article',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // ── Content ──
                        Text(
                          post.content,
                          style: const TextStyle(
                            color: Color(0xFFD4D4D4),
                            fontSize: 15,
                            height: 1.85,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.1,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // ── End of article ──
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF6B35),
                                      Color(0xFFFF9A6C)
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF6B35)
                                          .withOpacity(0.3),
                                      blurRadius: 16,
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.check_rounded,
                                    color: Colors.white, size: 24),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'End of Article',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.35),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Text(
                                  '← Back to My Posts',
                                  style:  TextStyle(
                                      color: Color(0xFFFF6B35),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ── Read Progress Bar (top) ──
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                height: 3,
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: _readProgress,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xFFFF6B35), Color(0xFFFF9A6C)]),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}