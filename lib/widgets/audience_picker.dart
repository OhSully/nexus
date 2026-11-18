import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/audience.dart';
import '../models/interest_catalog.dart';
import '../models/sample_contacts.dart';
import '../providers/providers.dart';
import 'user_avatar.dart';

enum _FilterSection { groups, events, interests }

class AudiencePicker extends StatelessWidget {
  const AudiencePicker({
    super.key,
    required this.audience,
    required this.directory,
    required this.onChanged,
    this.compact = false,
  });

  final Audience audience;
  final AudienceDirectory directory;
  final ValueChanged<Audience> onChanged;
  final bool compact;

  Future<void> _select(BuildContext context) async {
    final initial = Audience(
      AudienceType.connections,
      people: audience.type.needsSelection
          ? audience.people
          : (audience.resolve(directory) ?? <String>{})
                .where((person) => person != currentUserName)
                .toList(),
    );
    final picked = await showAudienceSheet(
      context,
      directory: directory,
      initial: initial,
      wasPublic: audience.type == AudienceType.public,
    );
    if (picked != null && context.mounted) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reach = audience.resolve(directory)?.length;
    final summary = reach == null
        ? audience.summary(l10n)
        : l10n.audienceSummaryWithReach(audience.summary(l10n), reach);
    if (compact) {
      return IconButton(
        key: const Key('open-audience-picker'),
        onPressed: () => _select(context),
        icon: const Icon(Icons.people_outline),
        tooltip: '${l10n.audiencePickerTitle}: $summary',
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.audiencePickerTitle,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          key: const Key('open-audience-picker'),
          onPressed: () => _select(context),
          icon: const Icon(Icons.people_outline),
          label: Text(l10n.audienceChoosePeople),
        ),
        const SizedBox(height: 8),
        Text(
          summary,
          key: const Key('audience-summary'),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

Future<Audience?> showAudienceSheet(
  BuildContext context, {
  required AudienceDirectory directory,
  required Audience initial,
  bool wasPublic = false,
}) {
  return showModalBottomSheet<Audience>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _AudienceSheet(
      directory: directory,
      initial: initial,
      wasPublic: wasPublic,
    ),
  );
}

class _AudienceSheet extends ConsumerStatefulWidget {
  const _AudienceSheet({
    required this.directory,
    required this.initial,
    required this.wasPublic,
  });

  final AudienceDirectory directory;
  final Audience initial;
  final bool wasPublic;

  @override
  ConsumerState<_AudienceSheet> createState() => _AudienceSheetState();
}

class _AudienceSheetState extends ConsumerState<_AudienceSheet> {
  final ScrollController _scrollController = ScrollController();
  late final Set<String> _people = {...widget.initial.people};
  final Set<String> _groups = {};
  final Set<String> _events = {};
  final Set<String> _interests = {};
  final Set<String> _usedGroups = {};
  bool _showAllGroups = false;
  bool _showAllEvents = false;
  bool _showAllInterests = false;
  bool _connectionsOnly = true;
  _FilterSection _filterSection = _FilterSection.groups;
  String _groupQuery = '';
  String _eventQuery = '';
  String _interestQuery = '';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<String> get _groupNames {
    final usage = ref.watch(audienceGroupUsageProvider);
    return widget.directory.groups.keys.toList()..sort((a, b) {
      final count = (usage[b] ?? 0).compareTo(usage[a] ?? 0);
      return count == 0 ? a.compareTo(b) : count;
    });
  }

  List<String> get _candidates {
    final directory = widget.directory;
    final people = <String>{
      ...directory.friends,
      ...directory.groups.values.expand((members) => members),
      ...directory.pastEventAttendees.values.expand((members) => members),
      ..._people,
    }..remove(currentUserName);
    if (_connectionsOnly) {
      people.retainAll(directory.friends);
    }
    for (final group in _groups) {
      people.retainAll(directory.groups[group] ?? const []);
    }
    for (final event in _events) {
      people.retainAll(directory.pastEventAttendees[event] ?? const []);
    }
    for (final interest in _interests) {
      people.removeWhere(
        (person) =>
            !(directory.friendInterests[person]?.contains(interest) ?? false),
      );
    }
    return people.toList()..sort();
  }

  Widget _sourceFilters({
    required List<String> sources,
    required Set<String> selected,
    required bool showAll,
    required String query,
    required ValueChanged<bool> onShowAll,
    required ValueChanged<String> onQuery,
    required ValueChanged<String> onToggle,
    required String searchKey,
    String Function(String)? label,
  }) {
    final visible = showAll
        ? sources.where(
            (s) => (label?.call(s) ?? s).toLowerCase().contains(
              query.toLowerCase(),
            ),
          )
        : sources.where(
            (s) => selected.contains(s) || sources.take(3).contains(s),
          );
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sources.length > 3)
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: () => onShowAll(!showAll),
              child: Text(
                showAll ? l10n.audienceShowLess : l10n.audienceShowAllSources,
              ),
            ),
          ),
        if (showAll)
          TextField(
            key: ValueKey(searchKey),
            decoration: InputDecoration(
              labelText: l10n.audienceSearchSources,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              isDense: true,
            ),
            onChanged: onQuery,
          ),
        if (sources.isEmpty) Text(l10n.audienceNothingToChoose),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final source in visible)
              FilterChip(
                label: Text(label?.call(source) ?? source),
                selected: selected.contains(source),
                onSelected: (_) => onToggle(source),
                shape: const StadiumBorder(),
              ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  void _toggle(Set<String> filters, String value) {
    setState(() {
      if (!filters.remove(value)) filters.add(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final candidates = _candidates;
    final allSelected =
        candidates.isNotEmpty && candidates.every(_people.contains);
    final filterCount = _groups.length + _events.length + _interests.length;
    final hiddenSelections = _people.difference(candidates.toSet()).length;
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.8,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.audiencePickerTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (widget.wasPublic) Text(l10n.audienceReplacePublic),
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  children: [
                    Card(
                      elevation: 0,
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: ExpansionTile(
                        key: const Key('audience-filters'),
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        leading: Tooltip(
                          message: l10n.audienceFiltersHint,
                          child: const Icon(Icons.tune, size: 20),
                        ),
                        shape: const Border(),
                        collapsedShape: const Border(),
                        onExpansionChanged: (expanded) {
                          if (!expanded) {
                            _scrollController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                            );
                          }
                        },
                        title: Text(
                          '${l10n.audienceFilters} · '
                          '${_connectionsOnly ? l10n.audienceConnectionsOnly : l10n.audienceAllPeople}'
                          '${filterCount == 0 ? '' : ' · $filterCount'}',
                          semanticsLabel:
                              '${l10n.audienceFilters}, '
                              '${_connectionsOnly ? l10n.audienceConnectionsOnly : l10n.audienceAllPeople}, '
                              '${l10n.audienceActiveFilters(filterCount)}',
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 8,
                                  children: [
                                    FilterChip(
                                      key: const Key(
                                        'audience-connections-only',
                                      ),
                                      label: Text(l10n.audienceConnectionsOnly),
                                      selected: _connectionsOnly,
                                      onSelected: (value) => setState(
                                        () => _connectionsOnly = value,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed:
                                          _groups.isEmpty &&
                                              _events.isEmpty &&
                                              _interests.isEmpty &&
                                              _connectionsOnly
                                          ? null
                                          : () => setState(() {
                                              _groups.clear();
                                              _events.clear();
                                              _interests.clear();
                                              _connectionsOnly = true;
                                            }),
                                      child: Text(l10n.audienceClearFilters),
                                    ),
                                  ],
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      for (final (section, label) in [
                                        (
                                          _FilterSection.groups,
                                          l10n.audienceGroupsTitle,
                                        ),
                                        (
                                          _FilterSection.events,
                                          l10n.audiencePastEventsTitle,
                                        ),
                                        (
                                          _FilterSection.interests,
                                          l10n.audienceFilterInterests,
                                        ),
                                      ])
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                end: 8,
                                              ),
                                          child: ChoiceChip(
                                            key: ValueKey(
                                              'audience-filter-section-${section.name}',
                                            ),
                                            label: Text(label),
                                            selected: _filterSection == section,
                                            onSelected: (_) => setState(
                                              () => _filterSection = section,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                if (_filterSection == _FilterSection.groups)
                                  _sourceFilters(
                                    sources: _groupNames,
                                    selected: _groups,
                                    showAll: _showAllGroups,
                                    query: _groupQuery,
                                    searchKey: 'audience-group-search',
                                    onShowAll: (value) => setState(() {
                                      _showAllGroups = value;
                                      _groupQuery = '';
                                    }),
                                    onQuery: (value) =>
                                        setState(() => _groupQuery = value),
                                    onToggle: (value) {
                                      _toggle(_groups, value);
                                      if (_groups.contains(value)) {
                                        _usedGroups.add(value);
                                      }
                                    },
                                  ),
                                if (_filterSection == _FilterSection.events)
                                  _sourceFilters(
                                    sources: widget
                                        .directory
                                        .pastEventAttendees
                                        .keys
                                        .toList(),
                                    selected: _events,
                                    showAll: _showAllEvents,
                                    query: _eventQuery,
                                    searchKey: 'audience-event-search',
                                    onShowAll: (value) => setState(() {
                                      _showAllEvents = value;
                                      _eventQuery = '';
                                    }),
                                    onQuery: (value) =>
                                        setState(() => _eventQuery = value),
                                    onToggle: (value) =>
                                        _toggle(_events, value),
                                  ),
                                if (_filterSection == _FilterSection.interests)
                                  _sourceFilters(
                                    sources: widget.directory.interests,
                                    selected: _interests,
                                    showAll: _showAllInterests,
                                    query: _interestQuery,
                                    searchKey: 'audience-interest-search',
                                    onShowAll: (value) => setState(() {
                                      _showAllInterests = value;
                                      _interestQuery = '';
                                    }),
                                    onQuery: (value) =>
                                        setState(() => _interestQuery = value),
                                    onToggle: (value) =>
                                        _toggle(_interests, value),
                                    label: (value) =>
                                        interestLabel(l10n, value),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Material(
                      key: const Key('audience-bulk-container'),
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(16),
                      clipBehavior: Clip.antiAlias,
                      child: CheckboxListTile(
                        key: const Key('audience-select-all'),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        secondary: Icon(
                          Icons.select_all,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondaryContainer,
                        ),
                        title: Text(
                          allSelected
                              ? l10n.audienceDeselectAll
                              : l10n.audienceSelectAll,
                        ),
                        value: allSelected,
                        onChanged: candidates.isEmpty
                            ? null
                            : (_) => setState(() {
                                if (allSelected) {
                                  _people.removeAll(candidates);
                                } else {
                                  _people.addAll(candidates);
                                }
                              }),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.audiencePeopleTitle,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    const Divider(),
                    if (candidates.isEmpty) Text(l10n.audiencePeopleNone),
                    for (final person in candidates)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Material(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(14),
                          clipBehavior: Clip.antiAlias,
                          child: CheckboxListTile(
                            key: ValueKey('audience-person-$person'),
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            secondary:
                                widget
                                        .directory
                                        .personDetails[person]
                                        ?.hasAccount ==
                                    false
                                ? CircleAvatar(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHighest,
                                    child: const Icon(Icons.person_outline),
                                  )
                                : UserAvatar.tonal(
                                    context,
                                    label: person.isEmpty
                                        ? '?'
                                        : person.characters.first.toUpperCase(),
                                    radius: 20,
                                    image:
                                        widget
                                                .directory
                                                .personDetails[person]
                                                ?.avatarUrl ==
                                            null
                                        ? null
                                        : NetworkImage(
                                            widget
                                                .directory
                                                .personDetails[person]!
                                                .avatarUrl!,
                                          ),
                                  ),
                            title: Text(person),
                            subtitle:
                                widget
                                        .directory
                                        .personDetails[person]
                                        ?.hasAccount ==
                                    false
                                ? Text(l10n.audienceNoAccount)
                                : null,
                            value: _people.contains(person),
                            onChanged: (value) => setState(() {
                              if (value == true) {
                                _people.add(person);
                              } else {
                                _people.remove(person);
                              }
                            }),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                l10n.audienceReaches(_people.length),
                key: const Key('audience-reach'),
              ),
              if (hiddenSelections > 0)
                Text(
                  l10n.audienceHiddenSelections(hiddenSelections),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    ref
                        .read(audienceGroupUsageProvider.notifier)
                        .record(_usedGroups);
                    Navigator.of(context).pop(
                      Audience(
                        AudienceType.connections,
                        people: _people.toList()..sort(),
                      ),
                    );
                  },
                  child: Text(l10n.commonDone),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
