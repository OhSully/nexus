import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/interest_catalog.dart';
import '../../models/audience.dart';
import '../../models/user_profile.dart';
import '../../widgets/app_card.dart';
import '../../widgets/audience_picker.dart';
import '../../widgets/section_header.dart';
import '../../widgets/user_avatar.dart';
import 'profile_header.dart';
import 'beacon_refresh_control.dart';

/// Read-only profile: header, beacons and interests.
class ProfileView extends StatelessWidget {
  const ProfileView({
    super.key,
    required this.profile,
    required this.displayName,
    required this.avatarLabel,
    required this.isCurrentUser,
    required this.directory,
    required this.onAudienceChanged,
    required this.onBeaconRefresh,
    required this.onAddBeacon,
    required this.toggle,
  });

  final UserProfile profile;
  final String displayName;
  final String avatarLabel;
  final bool isCurrentUser;
  final AudienceDirectory directory;
  final void Function(LookingForEntry, Audience)? onAudienceChanged;
  final void Function(LookingForEntry, BeaconDuration?)? onBeaconRefresh;
  final VoidCallback? onAddBeacon;
  final Widget toggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final lookingFor = profile.lookingFor.indexed.where(
      (item) => item.$2.text.trim().isNotEmpty,
    );
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
        if (isCurrentUser || lookingFor.isNotEmpty)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(l10n.profileLookingFor),
                const SizedBox(height: 10),
                if (lookingFor.isEmpty && onAddBeacon != null)
                  OutlinedButton.icon(
                    key: const Key('add-first-beacon'),
                    onPressed: onAddBeacon,
                    icon: const Icon(Icons.add),
                    label: Text(l10n.profileAddBeacon),
                  ),
                for (final (_, entry) in lookingFor)
                  _LookingForRow(
                    entry: entry,
                    directory: directory,
                    onAudienceChanged: onAudienceChanged == null
                        ? null
                        : (audience) => onAudienceChanged!(entry, audience),
                    onRefresh: onBeaconRefresh == null
                        ? null
                        : (duration) => onBeaconRefresh!(entry, duration),
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
  const _LookingForRow({
    required this.entry,
    required this.directory,
    required this.onAudienceChanged,
    required this.onRefresh,
  });

  final LookingForEntry entry;
  final AudienceDirectory directory;
  final ValueChanged<Audience>? onAudienceChanged;
  final ValueChanged<BeaconDuration?>? onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  entry.text.trim(),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              if (onAudienceChanged != null)
                AudiencePicker(
                  compact: true,
                  audience: entry.audience,
                  directory: directory,
                  onChanged: onAudienceChanged!,
                ),
              BeaconRefreshControl(entry: entry, onRefresh: onRefresh),
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
