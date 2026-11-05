import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/sample_contacts.dart';
import '../theme/app_theme.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key, required this.chats, required this.onOpenChat});

  final List<ChatSummary> chats;
  final ValueChanged<ChatSummary> onOpenChat;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.chatsTitle,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.chatsSubtitle,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: chats.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  final name = chat.name;
                  final message = chat.lastMessage;
                  final time = chat.time == chatTimeNow
                      ? l10n.chatsTimeNow
                      : chat.time;
                  final unread = chat.unread;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.brand.withValues(alpha: 0.12),
                      child: Text(
                        name[0],
                        style: const TextStyle(
                          color: AppColors.brand,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          time,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(message),
                    ),
                    trailing: unread
                        ? Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: AppColors.brand,
                              shape: BoxShape.circle,
                            ),
                          )
                        : null,
                    onTap: () => onOpenChat(chat),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
