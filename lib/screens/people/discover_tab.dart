import 'package:flutter/material.dart';

import '../../models/people.dart';

class DiscoverTab extends StatelessWidget {
  const DiscoverTab({
    super.key,
    required this.people,
    required this.filterIndex,
    required this.onFilterChanged,
    required this.connectionRequests,
    required this.sentInvites,
    required this.onConnect,
    required this.onInvite,
  });

  final List<DiscoverPerson> people;
  final int filterIndex;
  final ValueChanged<int> onFilterChanged;
  final Set<String> connectionRequests;
  final Set<String> sentInvites;
  final ValueChanged<String> onConnect;
  final ValueChanged<String> onInvite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = discoverFilters[filterIndex];
    final visible = filterIndex == 0
        ? people
        : people
              .where((person) => person.matchCategories.contains(category))
              .toList();

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(discoverFilters.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(discoverFilters[index]),
                  selected: filterIndex == index,
                  onSelected: (_) => onFilterChanged(index),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 4),
            itemCount: visible.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final person = visible[index];
              final requested = connectionRequests.contains(person.name);
              final invited = sentInvites.contains(person.name);
              return Card(
                margin: const EdgeInsets.only(bottom: 2),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 9,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 19,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(person.name[0]),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              person.name,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Wrap(
                              spacing: 5,
                              runSpacing: 4,
                              children: person.tags
                                  .map((tag) => _TagChip(tag: tag))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: requested || invited
                            ? null
                            : () => person.isInvite
                                  ? onInvite(person.name)
                                  : onConnect(person.name),
                        child: Text(
                          person.isInvite
                              ? invited
                                    ? 'Invite sent'
                                    : 'Invite to app'
                              : requested
                              ? 'Requested'
                              : 'Connect',
                        ),
                      ),
                    ],
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

class _TagChip extends StatelessWidget {
  const _TagChip({required this.tag});

  final DiscoveryTag tag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tag.meaning,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.55,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              tag.icon,
              size: 13,
              color: theme.colorScheme.onSurfaceVariant,
              semanticLabel: tag.meaning,
            ),
            const SizedBox(width: 4),
            Text(tag.label, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}
