import 'package:blog_hub/%20core/utils/app_messenger.dart';
import 'package:blog_hub/%20core/utils/enums.dart';
import 'package:blog_hub/features/add%20post/service/add_edit_post_api_service.dart';
import 'package:blog_hub/features/dashboard/user%20dashboard/model/post_model.dart';
import 'package:flutter/material.dart';

class AddEditPostProviderController extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  bool isLoading = false;

  // ── true = edit mode, false = add mode ──
  bool get isEditMode => _editPost != null;
  PostModel? _editPost;
  int? get editPostId => _editPost?.id;
  // ── Populate fields when editing ──
  void loadPost(PostModel post) {
    _editPost = post;
    titleController.text = post.title;
    contentController.text = post.content;
    notifyListeners();
  }

  // ── Clear for add mode ──
  void clearForm() {
    _editPost = null;
    titleController.clear();
    contentController.clear();
    notifyListeners();
  }

  // ── Add Post ──
  Future<MessageType> addPost(BuildContext context) async {
    if (!formKey.currentState!.validate()) return MessageType.error;
    try {
      isLoading = true;
      notifyListeners();

      final (type, _) =
      await AddEditPostApiService.addEditPostApiService.addPost(
        context: context,
        body: {
          'title': titleController.text.trim(),
          'content': contentController.text.trim(),
        },
      );

      if (type == MessageType.success) {
        AppMessenger.showSnackBar(
          context,
          message: 'Post created successfully! 🎉',
          type: MessageType.success,
        );
        clearForm();
      }
      return type;
    } catch (e) {
      AppMessenger.showSnackBar(
        context,
        message: e.toString(),
        type: MessageType.error,
      );
      return MessageType.error;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── Update Post ──
  Future<MessageType> updatePost(BuildContext context) async {
    if (!formKey.currentState!.validate()) return MessageType.error;
    if (_editPost == null) return MessageType.error;
    try {
      isLoading = true;
      notifyListeners();

      final (type, _) =
      await AddEditPostApiService.addEditPostApiService.updatePost(
        context: context,
        id: _editPost!.id.toString(),
        body: {
          'title': titleController.text.trim(),
          'content': contentController.text.trim(),
        },
      );

      if (type == MessageType.success) {
        AppMessenger.showSnackBar(
          context,
          message: 'Post updated successfully! ✅',
          type: MessageType.success,
        );
      }
      return type;
    } catch (e) {
      AppMessenger.showSnackBar(
        context,
        message: e.toString(),
        type: MessageType.error,
      );
      return MessageType.error;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }
}