import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/interest_catalog.dart';
import '../../models/user_profile.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/user_avatar.dart';
import 'profile_header.dart';

/// Read-only profile: header, "Looking For" and interests.
class ProfileView extends StatelessWidget {
  const ProfileView({
    super.key,
    required this.profile,
    required this.displayName,
    required this.avatarLabel,
    required this.isCurrentUser,
    required this.toggle,
  });

  final UserProfile profile;
  final String displayName;
  final String avatarLabel;
  final bool isCurrentUser;
  final Widget toggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final lookingFor = profile.lookingFor
        .where((entry) => entry.text.trim().isNotEmpty)
        .toList();
    final interests = profile.selectedInterests.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            AppCard(
              padding: const EdgeInsets.all(16),
              radius: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      UserAvatar(label: avatarLabel, radius: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(profile.bio, style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ProfileSummaryChip(
                          label: isCurrentUser
                              ? l10n.profileConnections
                              : l10n.profileMutualConnections,
                          value: '3',
                          icon: Icons.people_outline,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ProfileSummaryChip(
                          label: l10n.profilePastEvents,
                          value: '2',
                          icon: Icons.event_available_outlined,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ProfileSummaryChip(
                          label: l10n.profileUpcoming,
                          value: '3',
                          icon: Icons.calendar_today_outlined,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isCurrentUser) Positioned(top: 10, right: 10, child: toggle),
          ],
        ),
        const SizedBox(height: 20),
        if (lookingFor.isNotEmpty)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(l10n.profileLookingFor),
                const SizedBox(height: 10),
                ...lookingFor.map(
                  (entry) =>
                      _LookingForRow(entry: entry, showAudience: isCurrentUser),
                ),
              ],
            ),
          ),
        if (interests.isNotEmpty) ...[
          const SizedBox(height: 20),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(l10n.profileInterests),
                const SizedBox(height: 12),
                _InterestWrap(profile: profile, interests: interests),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _LookingForRow extends StatelessWidget {
  const _LookingForRow({required this.entry, required this.showAudience});

  final LookingForEntry entry;
  final bool showAudience;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final date = entry.declaredAt;
    final audience = entry.audience;
    final audienceLabel = audience.type.needsSelection
        ? audience.summary(l10n)
        : audience.type.label(l10n);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(entry.text.trim(), style: theme.textTheme.bodyMedium),
          const SizedBox(height: 2),
          Text(
            l10n.profileDeclared(date),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          if (showAudience)
            Row(
              children: [
                Icon(
                  Icons.visibility_outlined,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    l10n.activityDetailVisibleTo(audienceLabel),
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _InterestWrap extends StatelessWidget {
  const _InterestWrap({required this.profile, required this.interests});

  final UserProfile profile;
  final List<String> interests;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String noteOf(String interest) =>
        (profile.interestNotes[interest] ?? '').trim();
    bool isShort(String note) => note.isNotEmpty && note.length <= 42;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final shortNotes = interests.where((i) => isShort(noteOf(i))).length;
        final canShareRow =
            interests.length > 1 && shortNotes >= 1 && maxWidth > 320;

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: interests.map((interest) {
            final note = noteOf(interest);
            final width = canShareRow && isShort(note)
                ? (maxWidth - 8) / 2
                : maxWidth;

            return SizedBox(
              width: width,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      interestLabel(AppLocalizations.of(context), interest),
                      style: theme.textTheme.labelLarge,
                    ),
                    if (note.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(note, style: theme.textTheme.bodySmall),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
