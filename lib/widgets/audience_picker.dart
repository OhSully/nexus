import 'package:flutter/material.dart';

import '../models/audience.dart';

class AudiencePicker extends StatelessWidget {
  const AudiencePicker({
    super.key,
    required this.audience,
    required this.directory,
    required this.onChanged,
  });

  final Audience audience;
  final AudienceDirectory directory;
  final ValueChanged<Audience> onChanged;

  Future<void> _select(BuildContext context, AudienceType type) async {
    if (!type.needsSelection) {
      onChanged(Audience(type));
      return;
    }
    final initial = audience.type == type ? audience : Audience(type);
    final picked = await showAudienceSheet(
      context,
      directory: directory,
      initial: initial,
    );
    if (picked != null) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reach = audience.resolve(directory)?.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Who can see this', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final type in AudienceType.values)
              ChoiceChip(
                label: Text(type.label),
                selected: audience.type == type,
                onSelected: (_) => _select(context, type),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                reach == null
                    ? audience.summary
                    : '${audience.summary} · $reach ${reach == 1 ? 'friend' : 'friends'}',
                key: const Key('audience-summary'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            if (audience.type.needsSelection)
              TextButton(
                onPressed: () => _select(context, audience.type),
                child: const Text('Edit'),
              ),
          ],
        ),
      ],
    );
  }
}

Future<Audience?> showAudienceSheet(
  BuildContext context, {
  required AudienceDirectory directory,
  required Audience initial,
}) {
  return showModalBottomSheet<Audience>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) =>
        _AudienceSheet(directory: directory, initial: initial),
  );
}

class _AudienceSheet extends StatefulWidget {
  const _AudienceSheet({required this.directory, required this.initial});

  final AudienceDirectory directory;
  final Audience initial;

  @override
  State<_AudienceSheet> createState() => _AudienceSheetState();
}

class _RuleDraft {
  _RuleDraft([AudienceRule? rule])
    : groups = {...?rule?.groups},
      pastEvents = {...?rule?.pastEvents},
      interests = {...?rule?.interests},
      people = {...?rule?.people};

  final Set<String> groups;
  final Set<String> pastEvents;
  final Set<String> interests;
  final Set<String> people;

  bool get hasCriteria =>
      groups.isNotEmpty || pastEvents.isNotEmpty || interests.isNotEmpty;

  AudienceRule toRule() => AudienceRule(
    groups: groups.toList(),
    pastEvents: pastEvents.toList(),
    interests: interests.toList(),
    // Explicit people only apply to sets without criteria.
    people: hasCriteria ? const [] : people.toList(),
  );
}

class _AudienceSheetState extends State<_AudienceSheet> {
  late final List<_RuleDraft> _drafts = _initialDrafts();
  late final Set<String> _excluded = {...widget.initial.excluded};
  int _active = 0;

  AudienceType get _type => widget.initial.type;
  bool get _isCustom => _type == AudienceType.custom;
  _RuleDraft get _draft => _drafts[_active];

  List<_RuleDraft> _initialDrafts() {
    final initial = widget.initial;
    if (initial.type == AudienceType.custom) {
      return initial.rules.isEmpty
          ? [_RuleDraft()]
          : [for (final rule in initial.rules) _RuleDraft(rule)];
    }
    return [
      _RuleDraft(
        AudienceRule(
          groups: initial.groups,
          pastEvents: initial.pastEvents,
          interests: initial.interests,
        ),
      ),
    ];
  }

  Audience get _current {
    if (_isCustom) {
      return Audience(
        _type,
        rules: [for (final draft in _drafts) draft.toRule()],
        excluded: _excluded.toList(),
      );
    }
    final draft = _drafts.first;
    return Audience(
      _type,
      groups: draft.groups.toList(),
      pastEvents: draft.pastEvents.toList(),
      interests: draft.interests.toList(),
    );
  }

  Widget _setTabs() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (var i = 0; i < _drafts.length; i++)
            ChoiceChip(
              label: Text('Set ${i + 1}'),
              selected: i == _active,
              onSelected: (_) => setState(() => _active = i),
            ),
          ActionChip(
            key: const Key('add-audience-set'),
            avatar: const Icon(Icons.add, size: 16),
            label: const Text('Or another set'),
            onPressed: () => setState(() {
              _drafts.add(_RuleDraft());
              _active = _drafts.length - 1;
            }),
          ),
          if (_drafts.length > 1)
            IconButton(
              tooltip: 'Remove this set',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => setState(() {
                _drafts.removeAt(_active);
                _active = 0;
              }),
            ),
        ],
      ),
    );
  }

  Widget _peopleSection() {
    final directory = widget.directory;
    final rule = _draft.toRule();
    final filtered = rule.hasCriteria;
    final candidates = filtered
        ? (rule.matches(directory).toList()..sort())
        : directory.friends;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('People', style: Theme.of(context).textTheme.titleSmall),
          Text(
            filtered
                ? 'Everyone matching this set. Untick to exclude someone.'
                : 'Pick filters above, or add specific people here.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          if (candidates.isEmpty)
            const Text('Nobody matches these filters')
          else
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final person in candidates)
                  FilterChip(
                    label: Text(person),
                    selected: filtered
                        ? !_excluded.contains(person)
                        : _draft.people.contains(person),
                    onSelected: (value) => setState(() {
                      final target = filtered ? _excluded : _draft.people;
                      final add = filtered ? !value : value;
                      if (add) {
                        target.add(person);
                      } else {
                        target.remove(person);
                      }
                    }),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _section(
    String title,
    List<String> options,
    Set<String> selected, {
    String? emptyText,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          if (hint != null)
            Text(hint, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          if (options.isEmpty)
            Text(emptyText ?? 'Nothing to choose yet')
          else
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final option in options)
                  FilterChip(
                    label: Text(option),
                    selected: selected.contains(option),
                    onSelected: (value) => setState(() {
                      if (value) {
                        selected.add(option);
                      } else {
                        selected.remove(option);
                      }
                    }),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final directory = widget.directory;
    final current = _current;
    final reach = current.resolve(directory)?.length ?? 0;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isCustom ? 'Custom audience' : _type.label,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_isCustom) ...[
                        _setTabs(),
                        Text(
                          'People must match every filter in a set; sets are combined.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (_isCustom || _type == AudienceType.groups)
                        _section(
                          'Groups',
                          directory.groups.keys.toList(),
                          _draft.groups,
                          emptyText:
                              'No groups yet. Create one from the People tab.',
                        ),
                      if (_isCustom || _type == AudienceType.pastAttendees)
                        _section(
                          'Attendees of past events',
                          directory.pastEventAttendees.keys.toList(),
                          _draft.pastEvents,
                        ),
                      if (_isCustom || _type == AudienceType.interests)
                        _section(
                          'Friends with interests',
                          directory.interests,
                          _draft.interests,
                          hint: 'Friends who share any of these.',
                        ),
                      if (_isCustom) _peopleSection(),
                    ],
                  ),
                ),
              ),
              Text(
                'Reaches $reach ${reach == 1 ? 'friend' : 'friends'}',
                key: const Key('audience-reach'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: current.isEmpty
                      ? null
                      : () => Navigator.of(context).pop(current),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
