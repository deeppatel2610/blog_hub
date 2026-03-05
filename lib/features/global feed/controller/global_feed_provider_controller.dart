import 'package:blog_hub/ core/utils/enums.dart';
import 'package:blog_hub/features/dashboard/user%20dashboard/model/post_model.dart';
import 'package:blog_hub/features/global%20feed/service/global_feed_api_service.dart';

import 'package:flutter/material.dart';

class GlobalFeedProviderController extends ChangeNotifier {
  List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;

  bool isLoading = false;
  String? errorMessage;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  final searchController = TextEditingController();

  List<PostModel> get filteredPosts {
    if (_searchQuery.isEmpty) return _posts;
    final q = _searchQuery.toLowerCase();
    return _posts
        .where((p) =>
    p.title.toLowerCase().contains(q) ||
        p.content.toLowerCase().contains(q) ||
        'user ${p.userId}'.contains(q))
        .toList();
  }

  int get totalPosts => _posts.length;

  // unique authors
  int get totalAuthors =>
      _posts.map((p) => p.userId).toSet().length;

  // latest post date
  String get latestPostDate {
    if (_posts.isEmpty) return '—';
    final sorted = [..._posts]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.first.formattedDate;
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchPosts(BuildContext context) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final (type, response) = await GlobalFeedApiService
          .globalFeedApiService
          .getAllPosts(context: context);
      if (type == MessageType.success && response != null) {
        final List data =
        response.data is List ? response.data : response.data['posts'] ?? [];
        _posts = data.map((e) => PostModel.fromJson(e)).toList();
        // Sort newest first
        _posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } else {
        errorMessage = 'Failed to load posts';
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}