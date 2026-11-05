import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

enum CreateChoice { chat, activity, event }

/// Bottom sheet offering the things a user can create from the home shell.
Future<CreateChoice?> showCreateMenu(BuildContext context) {
  return showModalBottomSheet<CreateChoice>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline),
              title: Text(l10n.createMenuNewMessage),
              subtitle: Text(l10n.createMenuNewMessageSubtitle),
              onTap: () => Navigator.of(context).pop(CreateChoice.chat),
            ),
            ListTile(
              leading: const Icon(Icons.directions_walk),
              title: Text(l10n.createMenuNewActivity),
              subtitle: Text(l10n.createMenuNewActivitySubtitle),
              onTap: () => Navigator.of(context).pop(CreateChoice.activity),
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: Text(l10n.createMenuNewEvent),
              subtitle: Text(l10n.createMenuNewEventSubtitle),
              onTap: () => Navigator.of(context).pop(CreateChoice.event),
            ),
          ],
        ),
      );
    },
  );
}
