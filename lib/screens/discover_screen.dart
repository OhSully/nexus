import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/activity_item.dart';
import '../widgets/activity_card.dart';
import '../widgets/section_header.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({
    super.key,
    required this.items,
    required this.onOpenActivity,
  });

  final List<ActivityItem> items;
  final ValueChanged<ActivityItem> onOpenActivity;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: ScreenTitle(AppLocalizations.of(context).discoverTitle),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ActivityCard(
                  item: item,
                  onTap: () => onOpenActivity(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
