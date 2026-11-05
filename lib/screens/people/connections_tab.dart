import 'package:flutter/material.dart';

import '../../models/people.dart';

class ConnectionsTab extends StatelessWidget {
  const ConnectionsTab({
    super.key,
    required this.connections,
    required this.groups,
    required this.selectedGroup,
    required this.onSelectGroup,
    required this.onManageGroups,
    required this.onInviteGroup,
    required this.onOpenProfile,
    required this.onMessage,
  });

  final List<Connection> connections;
  final Map<String, List<String>> groups;
  final String? selectedGroup;
  final ValueChanged<String?> onSelectGroup;
  final VoidCallback onManageGroups;
  final ValueChanged<String> onInviteGroup;
  final ValueChanged<String> onOpenProfile;
  final ValueChanged<String> onMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visible = selectedGroup == null
        ? connections
        : connections
              .where(
                (connection) =>
                    groups[selectedGroup]?.contains(connection.name) ?? false,
              )
              .toList();

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: selectedGroup == null,
                onSelected: (_) => onSelectGroup(null),
              ),
              const SizedBox(width: 8),
              ...groups.keys.map(
                (group) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(group),
                    selected: selectedGroup == group,
                    onSelected: (_) => onSelectGroup(group),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            TextButton.icon(
              onPressed: onManageGroups,
              icon: const Icon(Icons.group_add_outlined),
              label: const Text('Manage groups'),
            ),
            const Spacer(),
            if (selectedGroup != null)
              FilledButton.tonal(
                onPressed: visible.isEmpty
                    ? null
                    : () => onInviteGroup(selectedGroup!),
                child: const Text('Invite group'),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Expanded(
          child: visible.isEmpty
              ? const Center(child: Text('No connections in this group yet.'))
              : ListView.separated(
                  padding: const EdgeInsets.only(top: 4),
                  itemCount: visible.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final connection = visible[index];
                    return Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => onOpenProfile(connection.name),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor:
                                    theme.colorScheme.primaryContainer,
                                child: Text(
                                  connection.initials,
                                  style: TextStyle(
                                    color: theme.colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      connection.name,
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      connection.latestUpdate,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      connection.updateTime,
                                      style: theme.textTheme.labelSmall,
                                    ),
                                  ],
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () => onMessage(connection.name),
                                icon: const Icon(Icons.chat_bubble_outline),
                                label: const Text('Message'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
