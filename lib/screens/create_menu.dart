import 'package:flutter/material.dart';

enum CreateChoice { chat, activity, event }

/// Bottom sheet offering the things a user can create from the home shell.
Future<CreateChoice?> showCreateMenu(BuildContext context) {
  return showModalBottomSheet<CreateChoice>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.chat_bubble_outline),
            title: const Text('New message'),
            subtitle: const Text('Open or start a chat'),
            onTap: () => Navigator.of(context).pop(CreateChoice.chat),
          ),
          ListTile(
            leading: const Icon(Icons.directions_walk),
            title: const Text('New activity'),
            subtitle: const Text('A casual plan, with or without company'),
            onTap: () => Navigator.of(context).pop(CreateChoice.activity),
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('New event'),
            subtitle: const Text('RSVPs, limits, hosts and details'),
            onTap: () => Navigator.of(context).pop(CreateChoice.event),
          ),
        ],
      ),
    ),
  );
}
