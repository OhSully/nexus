import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/activity_item.dart';
import '../providers/providers.dart';
import '../utils/activity_format.dart';

class ActivityCard extends ConsumerWidget {
  const ActivityCard({
    super.key,
    required this.item,
    required this.onTap,
    this.showAttendanceStatus = false,
  });

  final ActivityItem item;
  final VoidCallback onTap;
  final bool showAttendanceStatus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isAttending = showAttendanceStatus && item.isGoing;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      key: ValueKey('activity-card-${item.id}'),
      margin: const EdgeInsets.only(bottom: 16),
      color: isAttending
          ? colorScheme.primaryContainer.withValues(alpha: 0.45)
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isAttending ? colorScheme.primary : Colors.transparent,
          width: isAttending ? 2 : 0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: item.color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(itemSubtitle(l10n, item, ref.read(clockProvider)())),
                    const SizedBox(height: 12),
                    Text(
                      itemGuests(l10n, item),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              if (isAttending) ...[
                Tooltip(
                  message: l10n.activityCardAttending,
                  child: Icon(
                    Icons.check_circle,
                    color: colorScheme.primary,
                    semanticLabel: l10n.activityCardAttending,
                  ),
                ),
                const SizedBox(width: 4),
              ],
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
