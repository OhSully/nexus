import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/user_avatar.dart';

class ProfileModeToggle extends StatelessWidget {
  const ProfileModeToggle({
    super.key,
    required this.isViewing,
    required this.onPressed,
  });

  final bool isViewing;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.primaryContainer,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            isViewing ? Icons.edit_outlined : Icons.check,
            size: 18,
            color: scheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}

/// Header card in edit mode: avatar, name, bio field and background toggle.
class ProfileEditHeader extends StatelessWidget {
  const ProfileEditHeader({
    super.key,
    required this.displayName,
    required this.avatarLabel,
    required this.bioController,
    required this.onBioChanged,
    required this.hasBackgroundImage,
    required this.onToggleAvatar,
    required this.onToggleBackground,
    required this.toggle,
  });

  final String displayName;
  final String avatarLabel;
  final TextEditingController bioController;
  final ValueChanged<String> onBioChanged;
  final bool hasBackgroundImage;
  final VoidCallback onToggleAvatar;
  final VoidCallback onToggleBackground;
  final Widget toggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onImage = hasBackgroundImage;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor),
            image: hasBackgroundImage
                ? const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=800&q=80',
                    ),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: onToggleAvatar,
                      child: UserAvatar(label: avatarLabel, radius: 30),
                    ),
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: GestureDetector(
                        onTap: onToggleAvatar,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: AppColors.brand,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.surface,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: onImage
                          ? Colors.black.withValues(alpha: 0.18)
                          : theme.colorScheme.surface.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: onImage
                            ? Colors.white.withValues(alpha: 0.24)
                            : theme.dividerColor,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: onImage ? Colors.white : null,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: bioController,
                          onChanged: onBioChanged,
                          minLines: 1,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Add a short bio',
                          ),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: onImage
                                ? Colors.white.withValues(alpha: 0.95)
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -8,
          left: -8,
          child: GestureDetector(
            onTap: onToggleBackground,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: theme.dividerColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                hasBackgroundImage
                    ? Icons.close
                    : Icons.add_photo_alternate_outlined,
                size: 16,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
        Positioned(top: 10, right: 10, child: toggle),
      ],
    );
  }
}

/// Small stat tile shown in the view-mode header.
class ProfileSummaryChip extends StatelessWidget {
  const ProfileSummaryChip({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall,
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
