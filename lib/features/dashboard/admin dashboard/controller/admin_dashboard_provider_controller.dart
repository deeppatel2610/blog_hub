import 'package:blog_hub/ core/utils/app_messenger.dart';
import 'package:blog_hub/ core/utils/enums.dart';
import 'package:blog_hub/features/dashboard/admin%20dashboard/model/user_model.dart';
import 'package:blog_hub/features/dashboard/admin%20dashboard/service/admin_dashboard_api_service.dart';

import 'package:flutter/material.dart';

class AdminDashboardProviderController extends ChangeNotifier {
  List<UserModel> _users = [];
  List<UserModel> get users => _users;

  UserModel? selectedUser;

  bool isLoading = false;
  bool isActionLoading = false;
  String? errorMessage;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  final searchController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final roleController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // ── Filtered users ──
  List<UserModel> get filteredUsers {
    if (_searchQuery.isEmpty) return _users;
    final q = _searchQuery.toLowerCase();
    return _users
        .where((u) =>
    u.fullName.toLowerCase().contains(q) ||
        u.email.toLowerCase().contains(q) ||
        u.id.toString().contains(q))
        .toList();
  }

  int get totalUsers => _users.length;
  int get activeUsers => _users.where((u) => u.isActive).length;
  int get inactiveUsers => _users.where((u) => !u.isActive).length;

  void onSearchChanged(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // ── Fetch All Users ──
  Future<void> fetchAllUsers(BuildContext context) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final (type, response) = await AdminDashboardApiService
          .adminDashboardApiService
          .getAllUsers(context: context);
      if (type == MessageType.success && response != null) {
        final List data = response.data;
        _users = data.map((e) => UserModel.fromJson(e)).toList();
      } else {
        errorMessage = 'Failed to load users';
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── Get User By ID ──
  Future<void> fetchUserById(
      {required BuildContext context, required String id}) async {
    isActionLoading = true;
    notifyListeners();
    try {
      final (type, response) = await AdminDashboardApiService
          .adminDashboardApiService
          .getUserById(context: context, id: id);
      if (type == MessageType.success && response != null) {
        selectedUser = UserModel.fromJson(response.data);
      }
    } catch (e) {
      AppMessenger.showSnackBar(
        context,
        message: e.toString(),
        type: MessageType.error,
      );
    } finally {
      isActionLoading = false;
      notifyListeners();
    }
  }

  // ── Update User ──
  Future<MessageType> updateUser({
    required BuildContext context,
    required int id,
  }) async {
    if (!formKey.currentState!.validate()) return MessageType.error;
    isActionLoading = true;
    notifyListeners();
    try {
      final body = {
        'firstname': firstNameController.text.trim(),
        'lastname': lastNameController.text.trim(),
        'email': emailController.text.trim(),
        'role': roleController.text.trim(),
      };
      final (type, _) = await AdminDashboardApiService
          .adminDashboardApiService
          .updateUser(context: context, id: id.toString(), body: body);
      if (type == MessageType.success) {
        final index = _users.indexWhere((u) => u.id == id);
        if (index != -1) {
          _users[index] = _users[index].copyWith(
            firstname: firstNameController.text.trim(),
            lastname: lastNameController.text.trim(),
            email: emailController.text.trim(),
            role: roleController.text.trim(),
            updatedAt: DateTime.now(),
          );
          notifyListeners();
        }
      }
      return type;
    } catch (e) {
      return MessageType.error;
    } finally {
      isActionLoading = false;
      notifyListeners();
    }
  }

  // ── Deactivate User ──
  Future<MessageType> deactivateUser({
    required BuildContext context,
    required int id,
  }) async {
    isActionLoading = true;
    notifyListeners();
    try {
      final (type, _) = await AdminDashboardApiService
          .adminDashboardApiService
          .deactivateUser(context: context, id: id.toString());
      if (type == MessageType.success) {
        final index = _users.indexWhere((u) => u.id == id);
        if (index != -1) {
          _users[index] = _users[index].copyWith(isActive: false);
          notifyListeners();
        }
      }
      return type;
    } catch (e) {
      return MessageType.error;
    } finally {
      isActionLoading = false;
      notifyListeners();
    }
  }

  // ── Hard Delete User ──
  Future<MessageType> hardDeleteUser({
    required BuildContext context,
    required int id,
  }) async {
    isActionLoading = true;
    notifyListeners();
    try {
      final (type, _) = await AdminDashboardApiService
          .adminDashboardApiService
          .hardDeleteUser(context: context, id: id.toString());
      if (type == MessageType.success) {
        _users.removeWhere((u) => u.id == id);
        notifyListeners();
      }
      return type;
    } catch (e) {
      return MessageType.error;
    } finally {
      isActionLoading = false;
      notifyListeners();
    }
  }

  void populateEditForm(UserModel user) {
    firstNameController.text = user.firstname;
    lastNameController.text = user.lastname;
    emailController.text = user.email;
    roleController.text = user.role;
  }

  void clearEditForm() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    roleController.clear();
  }

  @override
  void dispose() {
    searchController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    roleController.dispose();
    super.dispose();
  }
}