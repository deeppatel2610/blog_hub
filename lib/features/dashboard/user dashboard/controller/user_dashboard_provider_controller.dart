import 'package:blog_hub/ core/utils/enums.dart';
import 'package:blog_hub/%20core/storage/preference_keys.dart';
import 'package:blog_hub/features/dashboard/user%20dashboard/model/post_model.dart';
import 'package:blog_hub/features/dashboard/user%20dashboard/service/user_dashboard_api_service.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDashboardProviderController extends ChangeNotifier {
  List<PostModel> _allPosts = [];
  List<PostModel> _myPosts = [];
  List<PostModel> get myPosts => _myPosts;

  int _currentUserId = 0;
  int get currentUserId => _currentUserId;

  bool isLoading = false;
  String? errorMessage;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  final searchController = TextEditingController();

  List<PostModel> get filteredMyPosts {
    if (_searchQuery.isEmpty) return _myPosts;
    final q = _searchQuery.toLowerCase();
    return _myPosts
        .where((p) =>
    p.title.toLowerCase().contains(q) ||
        p.content.toLowerCase().contains(q))
        .toList();
  }

  int get myPostCount => _myPosts.length;
  int get myUpdatedCount => _myPosts.where((p) => p.isUpdated).length;
  int get myThisMonthCount {
    final now = DateTime.now();
    return _myPosts
        .where((p) =>
    p.createdAt.month == now.month && p.createdAt.year == now.year)
        .length;
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // ── Read userId from SharedPreferences ──
  Future<void> _loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserId = prefs.getInt(PreferenceKeys.userId) ?? 0;
  }

  // ── Fetch & filter ──
  Future<void> fetchAllPosts(BuildContext context) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      // Load userId first
      await _loadCurrentUserId();

      final (type, response) = await UserDashboardApiService
          .userDashboardApiService
          .getAllPosts(context: context);

      if (type == MessageType.success && response != null) {
        final List data =
        response.data is List ? response.data : response.data['posts'] ?? [];
        _allPosts = data.map((e) => PostModel.fromJson(e)).toList();

        // ── Filter only logged-in user's posts ──
        _myPosts = _allPosts
            .where((p) => p.userId == _currentUserId)
            .toList();

        // Sort newest first
        _myPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
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