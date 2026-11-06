import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/activity_item.dart';
import '../models/audience.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../utils/activity_format.dart';
import '../widgets/audience_picker.dart';
import '../widgets/when_picker.dart';

class CreateActivityScreen extends ConsumerStatefulWidget {
  const CreateActivityScreen({
    super.key,
    required this.events,
    required this.directory,
  });

  final List<ActivityItem> events;
  final AudienceDirectory directory;

  @override
  ConsumerState<CreateActivityScreen> createState() =>
      _CreateActivityScreenState();
}

class _CreateActivityScreenState extends ConsumerState<CreateActivityScreen> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  late DateTime _date;
  late TimeOfDay _start;
  late TimeOfDay _end;
  bool _happensRegardless = false;
  late Audience _audience;
  String? _linkedEventId;
  String? _titleError;
  String? _timeError;

  @override
  void initState() {
    super.initState();
    _audience = ref.read(defaultAudienceProvider);
    final now = DateTime.now();
    _date = DateTime(now.year, now.month, now.day);
    final startHour = (now.hour + 1).clamp(0, 23);
    _start = TimeOfDay(hour: startHour, minute: 0);
    _end = startHour >= 23
        ? const TimeOfDay(hour: 23, minute: 59)
        : TimeOfDay(hour: startHour + 1, minute: 0);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    final l10n = AppLocalizations.of(context);
    final title = _titleController.text.trim();
    final startsAt = WhenPicker.combine(_date, _start);
    final endsAt = WhenPicker.combine(_date, _end);
    final titleError = title.isEmpty ? l10n.createActivityTitleError : null;
    final timeError = endsAt.isAfter(startsAt) ? null : l10n.createEndTimeError;

    if (titleError != null || timeError != null) {
      setState(() {
        _titleError = titleError;
        _timeError = timeError;
      });
      return;
    }

    final location = _locationController.text.trim();
    Navigator.of(context).pop(
      ActivityItem(
        id: 'activity-${DateTime.now().microsecondsSinceEpoch}',
        title: title,
        subtitle: activitySubtitle(
          l10n,
          startsAt,
          location.isEmpty ? l10n.commonLocationTbd : location,
        ),
        guests: guestsLabel(l10n, 1, going: true),
        attendeeCount: 1,
        icon: Icons.directions_run,
        color: AppColors.friends,
        isGoing: true,
        startsAt: startsAt,
        endsAt: endsAt,
        eventType: 'Activity',
        visibility: _audience.visibilityKey,
        audience: _audience,
        kind: ActivityKind.activity,
        description: _notesController.text.trim(),
        location: location,
        hosts: const ['You'],
        happensRegardless: _happensRegardless,
        linkedEventId: _linkedEventId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.createActivityTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.createActivityIntro,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                if (value.trim().isNotEmpty && _titleError != null) {
                  setState(() => _titleError = null);
                }
              },
              decoration: InputDecoration(
                labelText: l10n.createActivityTitleLabel,
                hintText: l10n.createActivityTitleHint,
                border: const OutlineInputBorder(),
                errorText: _titleError,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: l10n.commonLocation,
                hintText: l10n.createActivityLocationHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            WhenPicker(
              date: _date,
              start: _start,
              end: _end,
              errorText: _timeError,
              onDateChanged: (value) => setState(() {
                _date = value;
                _timeError = null;
              }),
              onStartChanged: (value) => setState(() {
                _start = value;
                _timeError = null;
              }),
              onEndChanged: (value) => setState(() {
                _end = value;
                _timeError = null;
              }),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.createActivityNotesLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _happensRegardless,
              onChanged: (value) => setState(() => _happensRegardless = value),
              title: Text(l10n.activityDetailHappeningRegardless),
              subtitle: Text(
                _happensRegardless
                    ? l10n.createActivityRegardlessOn
                    : l10n.createActivityRegardlessOff,
              ),
            ),
            AudiencePicker(
              audience: _audience,
              directory: widget.directory,
              onChanged: (value) => setState(() => _audience = value),
            ),
            if (widget.events.isNotEmpty) ...[
              const SizedBox(height: 20),
              DropdownButtonFormField<String?>(
                key: const Key('linked-event-field'),
                initialValue: _linkedEventId,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: l10n.createActivityLinkLabel,
                  helperText: l10n.createActivityLinkHelper,
                  helperMaxLines: 2,
                  border: const OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text(l10n.createActivityNoLinkedEvent),
                  ),
                  for (final event in widget.events)
                    DropdownMenuItem<String?>(
                      value: event.id,
                      child: Text(event.title, overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: (value) => setState(() => _linkedEventId = value),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _save,
              child: Text(l10n.createActivityButton),
            ),
          ],
        ),
      ),
    );
  }
}
