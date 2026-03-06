import 'package:blog_hub/%20core/utils/enums.dart';
import 'package:blog_hub/features/add%20post/controller/add_edit_post_provider_controller.dart';
import 'package:blog_hub/features/dashboard/user%20dashboard/model/post_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEditPostScreen extends StatefulWidget {
  final PostModel? post; // null = Add mode, non-null = Edit mode
  const AddEditPostScreen({super.key, this.post});

  @override
  State<AddEditPostScreen> createState() => _AddEditPostScreenState();
}

class _AddEditPostScreenState extends State<AddEditPostScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = context.read<AddEditPostProviderController>();
      if (widget.post != null) {
        ctrl.loadPost(widget.post!); // ── Edit mode
      } else {
        ctrl.clearForm(); // ── Add mode
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddEditPostProviderController>(
      builder: (context, ctrl, _) {
        final isEdit = ctrl.isEditMode;
        return Scaffold(
          backgroundColor: const Color(0xFF0D0D0D),
          body: FadeTransition(
            opacity: _fadeAnim,
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context, isEdit),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                      child: Form(
                        key: ctrl.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Mode indicator ──
                            _buildModeIndicator(isEdit, ctrl),
                            const SizedBox(height: 28),

                            // ── Title field ──
                            _buildSectionLabel('Post Title'),
                            const SizedBox(height: 10),
                            _buildTitleField(ctrl),
                            const SizedBox(height: 24),

                            // ── Content field ──
                            _buildSectionLabel('Content'),
                            const SizedBox(height: 10),
                            _buildContentField(ctrl),
                            const SizedBox(height: 12),

                            // ── Word count ──
                            _buildWordCount(ctrl),
                            const SizedBox(height: 32),

                            // ── Submit button ──
                            _buildSubmitButton(context, ctrl, isEdit),
                            const SizedBox(height: 12),

                            // ── Cancel button ──
                            _buildCancelButton(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Header ──
  Widget _buildHeader(BuildContext context, bool isEdit) {
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
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEdit ? 'Edit Post ✏️' : 'New Post 📝',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 2),
              Text(
                isEdit ? 'Edit Post' : 'Create Post',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Mode indicator card ──
  Widget _buildModeIndicator(
      bool isEdit, AddEditPostProviderController ctrl) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEdit
            ? const Color(0xFF42A5F5).withOpacity(0.06)
            : const Color(0xFF4CAF50).withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isEdit
              ? const Color(0xFF42A5F5).withOpacity(0.15)
              : const Color(0xFF4CAF50).withOpacity(0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isEdit
                  ? const Color(0xFF42A5F5).withOpacity(0.12)
                  : const Color(0xFF4CAF50).withOpacity(0.12),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              isEdit ? Icons.edit_rounded : Icons.add_rounded,
              color: isEdit
                  ? const Color(0xFF42A5F5)
                  : const Color(0xFF4CAF50),
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? 'Editing Post' : 'Creating New Post',
                  style: TextStyle(
                    color: isEdit
                        ? const Color(0xFF42A5F5)
                        : const Color(0xFF4CAF50),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isEdit
                      ? 'POST #${ctrl.editPostId} — changes will be saved'
                      : 'Fill in the details to publish',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.35),
                      fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Section label ──
  Widget _buildSectionLabel(String label) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B35), Color(0xFFFF9A6C)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  // ── Title field ──
  Widget _buildTitleField(AddEditPostProviderController ctrl) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: TextFormField(
        controller: ctrl.titleController,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600),
        maxLength: 150,
        validator: (v) {
          if (v == null || v.trim().isEmpty) {
            return 'Title cannot be empty';
          }
          if (v.trim().length < 3) {
            return 'Title must be at least 3 characters';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: 'Enter a catchy title...',
          hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.25), fontSize: 14),
          prefixIcon: Icon(Icons.title_rounded,
              color: Colors.white.withOpacity(0.3), size: 20),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          counterStyle: TextStyle(
              color: Colors.white.withOpacity(0.2), fontSize: 10),
          errorStyle: const TextStyle(
              color: Color(0xFFEF5350), fontSize: 11),
        ),
      ),
    );
  }

  // ── Content field ──
  Widget _buildContentField(AddEditPostProviderController ctrl) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: TextFormField(
        controller: ctrl.contentController,
        style: const TextStyle(
            color: Color(0xFFD4D4D4), fontSize: 14, height: 1.7),
        maxLines: 12,
        minLines: 8,
        validator: (v) {
          if (v == null || v.trim().isEmpty) {
            return 'Content cannot be empty';
          }
          if (v.trim().length < 10) {
            return 'Content must be at least 10 characters';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: 'Write your story here...',
          hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.2), fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          errorStyle: const TextStyle(
              color: Color(0xFFEF5350), fontSize: 11),
        ),
      ),
    );
  }

  // ── Word count ──
  Widget _buildWordCount(AddEditPostProviderController ctrl) {
    return ValueListenableBuilder(
      valueListenable: ctrl.contentController,
      builder: (_, value, __) {
        final words = value.text.trim().isEmpty
            ? 0
            : value.text.trim().split(RegExp(r'\s+')).length;
        final readTime = (words / 200).ceil();
        return Row(
          children: [
            Icon(Icons.text_fields_rounded,
                color: Colors.white.withOpacity(0.25), size: 14),
            const SizedBox(width: 6),
            Text(
              '$words word${words != 1 ? 's' : ''}',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.3), fontSize: 11),
            ),
            const SizedBox(width: 12),
            Icon(Icons.timer_outlined,
                color: Colors.white.withOpacity(0.25), size: 14),
            const SizedBox(width: 6),
            Text(
              '~$readTime min read',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.3), fontSize: 11),
            ),
          ],
        );
      },
    );
  }

  // ── Submit button ──
  Widget _buildSubmitButton(BuildContext context,
      AddEditPostProviderController ctrl, bool isEdit) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFFFF6B35), Color(0xFFFF9A6C)]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B35).withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: ctrl.isLoading
              ? null
              : () async {
            MessageType result;
            if (isEdit) {
              result = await ctrl.updatePost(context);
            } else {
              result = await ctrl.addPost(context);
            }
            if (result == MessageType.success &&
                context.mounted) {
              Navigator.pop(context, true); // true = refresh list
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
          child: ctrl.isLoading
              ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                  strokeWidth: 2.5, color: Colors.white))
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isEdit
                    ? Icons.save_rounded
                    : Icons.send_rounded,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(
                isEdit ? 'Save Changes' : 'Publish Post',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Cancel button ──
  Widget _buildCancelButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(14),
            border:
            Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: const Center(
            child: Text(
              'Cancel',
              style: TextStyle(
                  color: Colors.white60,
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}