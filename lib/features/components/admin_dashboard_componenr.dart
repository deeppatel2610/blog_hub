import 'package:blog_hub/%20core/utils/app_messenger.dart';
import 'package:blog_hub/%20core/utils/enums.dart';
import 'package:blog_hub/features/dashboard/admin%20dashboard/controller/admin_dashboard_provider_controller.dart';
import 'package:blog_hub/features/dashboard/admin%20dashboard/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
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
            Text('$value',
                style: TextStyle(
                    color: color, fontSize: 22, fontWeight: FontWeight.w800)),
            Text(label,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.35),
                    fontSize: 11,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final UserModel user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: user.isActive
              ? Colors.white.withOpacity(0.07)
              : Colors.red.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // ── Avatar with status dot ──
              Stack(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: const Color(0xFFFF6B35).withOpacity(0.25),
                          width: 2),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        user.avatarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFF1A1A1A),
                          child: Center(
                            child: Text(
                              user.firstname[0].toUpperCase(),
                              style: const TextStyle(
                                  color: Color(0xFFFF6B35),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: user.isActive
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFF757575),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFF141414), width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              // ── Info ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.fullName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        RoleBadge(role: user.role),
                        if (!user.isActive) ...[
                          const SizedBox(width: 6),
                          const StatusBadge(),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(user.email,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 12)),
                    const SizedBox(height: 3),
                    Text(
                      'ID: ${user.id}  •  ${_formatDate(user.createdAt)}',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.22), fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // ── Divider ──
          Divider(color: Colors.white.withOpacity(0.05), height: 1),
          const SizedBox(height: 12),
          // ── Action Buttons ──
          Row(
            children: [
              ActionButton(
                icon: Icons.edit_rounded,
                label: 'Edit',
                color: const Color(0xFFFF6B35),
                onTap: () => _showEditSheet(context, user),
              ),
              const SizedBox(width: 8),
              ActionButton(
                icon: Icons.person_search_rounded,
                label: 'View',
                color: const Color(0xFF42A5F5),
                onTap: () => _showDetailDialog(context, user),
              ),
              const SizedBox(width: 8),
              ActionButton(
                icon: Icons.block_rounded,
                label: 'Deactivate',
                color: const Color(0xFFFFB300),
                onTap: user.isActive
                    ? () => _confirmDeactivate(context, user)
                    : null,
              ),
              const SizedBox(width: 8),
              ActionButton(
                icon: Icons.delete_forever_rounded,
                label: 'Delete',
                color: const Color(0xFFEF5350),
                onTap: () => _confirmDelete(context, user),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';

  void _showEditSheet(BuildContext context, UserModel user) {
    final ctrl = context.read<AdminDashboardProviderController>();
    ctrl.populateEditForm(user);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: ctrl,
        child: EditUserSheet(user: user),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (_) => UserDetailDialog(user: user),
    );
  }

  void _confirmDeactivate(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
        icon: Icons.block_rounded,
        iconColor: const Color(0xFFFFB300),
        title: 'Deactivate User',
        message:
            'Are you sure you want to deactivate ${user.fullName}? They will lose access to the platform.',
        confirmLabel: 'Deactivate',
        confirmColor: const Color(0xFFFFB300),
        onConfirm: () async {
          Navigator.pop(context);
          final result = await context
              .read<AdminDashboardProviderController>()
              .deactivateUser(context: context, id: user.id);
          AppMessenger.showSnackBar(
            context,
            message: result == MessageType.success
                ? '${user.fullName} has been deactivated'
                : 'Deactivation failed',
            type: result,
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
        icon: Icons.delete_forever_rounded,
        iconColor: const Color(0xFFEF5350),
        title: 'Permanently Delete',
        message:
            'This will permanently delete ${user.fullName} and all their data. This action cannot be undone.',
        confirmLabel: 'Delete',
        confirmColor: const Color(0xFFEF5350),
        onConfirm: () async {
          Navigator.pop(context);
          final result = await context
              .read<AdminDashboardProviderController>()
              .hardDeleteUser(context: context, id: user.id);
          AppMessenger.showSnackBar(
            context,
            message: result == MessageType.success
                ? '${user.fullName} has been permanently deleted'
                : 'Delete failed',
            type: result,
          );
        },
      ),
    );
  }
}

class RoleBadge extends StatelessWidget {
  final String role;

  const RoleBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final isAdmin = role == 'admin';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: isAdmin
            ? const Color(0xFFFF6B35).withOpacity(0.15)
            : Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isAdmin
              ? const Color(0xFFFF6B35).withOpacity(0.35)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Text(
        role.toUpperCase(),
        style: TextStyle(
          color: isAdmin
              ? const Color(0xFFFF6B35)
              : Colors.white.withOpacity(0.45),
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.red.withOpacity(0.25)),
      ),
      child: const Text(
        'INACTIVE',
        style: TextStyle(
            color: Color(0xFFEF5350),
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedOpacity(
          opacity: isDisabled ? 0.35 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withOpacity(0.18)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 15),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                      color: color, fontSize: 9, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const GradientButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFFFF6B35), Color(0xFFFF9A6C)]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14)),
      ),
    );
  }
}

class EditUserSheet extends StatelessWidget {
  final UserModel user;

  const EditUserSheet({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: const BoxDecoration(
          color: Color(0xFF111111),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Consumer<AdminDashboardProviderController>(
          builder: (context, ctrl, _) => Form(
            key: ctrl.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Title row with avatar
                Row(
                  children: [
                    ClipOval(
                      child: Image.network(user.avatarUrl,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                                width: 40,
                                height: 40,
                                color: const Color(0xFF1A1A1A),
                                child: Center(
                                  child: Text(user.firstname[0].toUpperCase(),
                                      style: const TextStyle(
                                          color: Color(0xFFFF6B35),
                                          fontWeight: FontWeight.w800)),
                                ),
                              )),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Edit User',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800)),
                        Text('ID: ${user.id}',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.35),
                                fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // First & Last name
                Row(
                  children: [
                    Expanded(
                      child: SheetTextField(
                        controller: ctrl.firstNameController,
                        label: 'First Name',
                        icon: Icons.badge_outlined,
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SheetTextField(
                        controller: ctrl.lastNameController,
                        label: 'Last Name',
                        icon: Icons.badge_outlined,
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SheetTextField(
                  controller: ctrl.emailController,
                  label: 'Email',
                  icon: Icons.alternate_email_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(v)) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                SheetTextField(
                  controller: ctrl.roleController,
                  label: 'Role',
                  icon: Icons.shield_outlined,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 24),
                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B35), Color(0xFFFF9A6C)]),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B35).withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: ctrl.isActionLoading
                          ? null
                          : () async {
                              final result = await ctrl.updateUser(
                                  context: context, id: user.id);
                              Navigator.pop(context);
                              AppMessenger.showSnackBar(
                                context,
                                message: result == MessageType.success
                                    ? 'User updated successfully'
                                    : 'Update failed',
                                type: result,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: ctrl.isActionLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2.5, color: Colors.white))
                          : const Text('Save Changes',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SheetTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const SheetTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 13),
          prefixIcon:
              Icon(icon, color: Colors.white.withOpacity(0.3), size: 18),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          errorStyle: const TextStyle(color: Color(0xFFFF6B6B), fontSize: 11),
        ),
      ),
    );
  }
}

class UserDetailDialog extends StatelessWidget {
  final UserModel user;

  const UserDetailDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF111111),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: const Color(0xFFFF6B35).withOpacity(0.4), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B35).withOpacity(0.2),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  user.avatarUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    color: const Color(0xFF1A1A1A),
                    child: Center(
                      child: Text(user.firstname[0].toUpperCase(),
                          style: const TextStyle(
                              color: Color(0xFFFF6B35),
                              fontSize: 30,
                              fontWeight: FontWeight.w800)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(user.fullName,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            RoleBadge(role: user.role),
            const SizedBox(height: 20),
            // Details
            DetailRow(
                icon: Icons.tag_rounded, label: 'ID', value: '${user.id}'),
            DetailRow(
                icon: Icons.alternate_email_rounded,
                label: 'Email',
                value: user.email),
            DetailRow(
              icon: Icons.circle,
              label: 'Status',
              value: user.isActive ? 'Active' : 'Inactive',
              valueColor: user.isActive
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFF9E9E9E),
            ),
            DetailRow(
                icon: Icons.calendar_today_rounded,
                label: 'Joined',
                value:
                    '${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}'),
            if (user.updatedAt != null)
              DetailRow(
                  icon: Icons.update_rounded,
                  label: 'Updated',
                  value:
                      '${user.updatedAt!.day}/${user.updatedAt!.month}/${user.updatedAt!.year}'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: const Center(
                    child: Text('Close',
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const DetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFF6B35), size: 16),
          const SizedBox(width: 10),
          Text(label,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.4), fontSize: 13)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  color: valueColor ?? Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class ConfirmDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String confirmLabel;
  final Color confirmColor;
  final VoidCallback onConfirm;

  const ConfirmDialog({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.confirmColor,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF111111),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: iconColor.withOpacity(0.25)),
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(height: 16),
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: 13,
                  height: 1.5),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: const Center(
                          child: Text('Cancel',
                              style: TextStyle(
                                  color: Colors.white60,
                                  fontWeight: FontWeight.w600))),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: confirmColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: confirmColor.withOpacity(0.3)),
                      ),
                      child: Center(
                          child: Text(confirmLabel,
                              style: TextStyle(
                                  color: confirmColor,
                                  fontWeight: FontWeight.w700))),
                    ),
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
