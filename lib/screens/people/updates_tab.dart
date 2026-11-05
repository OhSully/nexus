import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/people.dart';

class UpdatesTab extends StatelessWidget {
  const UpdatesTab({
    super.key,
    required this.updates,
    required this.responses,
    required this.onRespond,
    required this.onOpenProfile,
  });

  final List<PeopleUpdate> updates;
  final Map<String, String> responses;
  final void Function(String person, String response) onRespond;
  final ValueChanged<String> onOpenProfile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.separated(
      padding: const EdgeInsets.only(top: 4),
      itemCount: updates.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final update = updates[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    update.icon,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => onOpenProfile(update.person),
                        child: Text(
                          update.person,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(update.description),
                      const SizedBox(height: 6),
                      Text(update.time, style: theme.textTheme.labelSmall),
                      if (update.action != null) ...[
                        const SizedBox(height: 6),
                        _buildAction(context, update),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAction(BuildContext context, PeopleUpdate update) {
    final l10n = AppLocalizations.of(context);
    if (update.action != 'Respond') {
      return TextButton(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.updatesSampleNotice)));
        },
        child: Text(
          update.action == 'View event'
              ? l10n.updatesViewEvent
              : update.action!,
        ),
      );
    }

    final response = responses[update.person];
    if (response != null) {
      return Text(
        switch (response) {
          'Accepted' => l10n.updatesAccepted,
          'Declined' => l10n.updatesDeclined,
          _ => response,
        },
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }
    return Wrap(
      spacing: 8,
      children: [
        FilledButton.tonal(
          onPressed: () => onRespond(update.person, 'Accepted'),
          child: Text(l10n.updatesAccept),
        ),
        TextButton(
          onPressed: () => onRespond(update.person, 'Declined'),
          child: Text(l10n.updatesDecline),
        ),
      ],
    );
  }
}
