import 'package:blog_hub/ core/utils/enums.dart';
import 'package:blog_hub/%20core/storage/preference_keys.dart';
import 'package:blog_hub/features/profile/model/profile_model.dart';
import 'package:blog_hub/features/profile/service/profile_api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProviderController extends ChangeNotifier {
  ProfileModel? _profile;
  ProfileModel? get profile => _profile;

  bool isLoading = false;
  String? errorMessage;

  int _userId = 0;
  String _role = '';
  int get userId => _userId;
  String get role => _role;

  // ── Load userId & role from SharedPreferences ──
  Future<void> _loadLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt(PreferenceKeys.userId) ?? 0;
    _role = prefs.getString(PreferenceKeys.role) ?? 'user';
  }

  // ── Fetch Profile from API ──
  Future<void> fetchProfile(BuildContext context) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _loadLocalData();

      final (type, response) = await ProfileApiService.profileApiService
          .getProfile(context: context, id: _userId.toString());

      if (type == MessageType.success && response != null) {
        _profile = ProfileModel.fromJson(response.data);
      } else {
        errorMessage = 'Failed to load profile';
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}