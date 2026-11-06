import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../models/interest_catalog.dart';
import '../../providers/providers.dart';
import '../../widgets/section_header.dart';

Future<void> showInterestPicker(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const InterestPickerSheet(),
  );
}

class InterestPickerSheet extends ConsumerStatefulWidget {
  const InterestPickerSheet({super.key});

  @override
  ConsumerState<InterestPickerSheet> createState() =>
      _InterestPickerSheetState();
}

class _InterestPickerSheetState extends ConsumerState<InterestPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggle(String interest) {
    final normalized = interest.trim();
    if (normalized.isEmpty) {
      return;
    }
    ref
        .read(profileProvider.notifier)
        .toggleInterest(
          normalized,
          isPredefined: isPredefinedInterest(normalized),
        );
  }

  List<String> _visibleInterests(Set<String> custom, AppLocalizations l10n) {
    final query = _searchController.text.trim().toLowerCase();
    final inCategory = switch (_selectedCategory) {
      'All' => {...interestGroups.values.expand((g) => g), ...custom}.toList(),
      'Custom' => custom.toList(),
      final name => interestGroups[name] ?? const <String>[],
    };
    if (query.isEmpty) {
      return inCategory;
    }
    return inCategory
        .where(
          (i) =>
              i.toLowerCase().contains(query) ||
              interestLabel(l10n, i).toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(profileProvider);
    final interests = _visibleInterests(profile.customInterests, l10n);
    final query = _searchController.text.trim();
    final hasManualInterest =
        query.isNotEmpty &&
        !interests.any(
          (i) =>
              i.toLowerCase() == query.toLowerCase() ||
              interestLabel(l10n, i).toLowerCase() == query.toLowerCase(),
        );
    final categories = ['All', ...interestGroups.keys, 'Custom'];

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SectionHeader(l10n.interestsAdd),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: l10n.interestsSearchHint,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(switch (category) {
                      'All' => l10n.commonAll,
                      'Custom' => l10n.interestsCategoryCustom,
                      _ => interestCategoryLabel(l10n, category),
                    }),
                    selected: category == _selectedCategory,
                    onSelected: (_) =>
                        setState(() => _selectedCategory = category),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 320),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (hasManualInterest)
                      FilterChip(
                        label: Text(l10n.interestsAddQuery(query)),
                        selected: false,
                        onSelected: (_) {
                          _toggle(query);
                          _searchController.clear();
                          setState(() => _selectedCategory = 'All');
                        },
                      ),
                    ...interests.take(16).map((interest) {
                      return FilterChip(
                        label: Text(interestLabel(l10n, interest)),
                        selected: profile.selectedInterests.contains(interest),
                        onSelected: (_) => _toggle(interest),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
