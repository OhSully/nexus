import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/activity_item.dart';
import '../models/audience.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../utils/activity_format.dart';
import '../widgets/contact_picker.dart';
import '../widgets/audience_picker.dart';
import '../widgets/when_picker.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key, required this.directory});

  final AudienceDirectory directory;

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _capacityController = TextEditingController();

  late DateTime _date;
  late TimeOfDay _start;
  late TimeOfDay _end;
  bool _rsvpEnabled = true;
  bool _limitAttendance = false;
  late Audience _audience;
  List<String> _coHosts = [];
  String? _titleError;
  String? _timeError;
  String? _capacityError;

  @override
  void initState() {
    super.initState();
    _audience = ref.read(defaultAudienceProvider);
    final now = DateTime.now();
    _date = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    _start = const TimeOfDay(hour: 18, minute: 0);
    _end = const TimeOfDay(hour: 20, minute: 0);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _pickHosts() async {
    final picked = await showContactPicker(
      context,
      title: AppLocalizations.of(context).createEventAddCoHosts,
      confirmLabel: AppLocalizations.of(context).commonDone,
      initial: _coHosts,
      allowEmpty: true,
    );
    if (picked != null) {
      setState(() => _coHosts = picked);
    }
  }

  void _save() {
    final l10n = AppLocalizations.of(context);
    final title = _titleController.text.trim();
    final startsAt = WhenPicker.combine(_date, _start);
    final endsAt = WhenPicker.combine(_date, _end);
    final titleError = title.isEmpty ? l10n.createEventTitleError : null;
    final timeError = endsAt.isAfter(startsAt) ? null : l10n.createEndTimeError;

    int? capacity;
    String? capacityError;
    if (_rsvpEnabled && _limitAttendance) {
      capacity = int.tryParse(_capacityController.text.trim());
      if (capacity == null || capacity < 1) {
        capacityError = l10n.createEventCapacityError;
      }
    }

    if (titleError != null || timeError != null || capacityError != null) {
      setState(() {
        _titleError = titleError;
        _timeError = timeError;
        _capacityError = capacityError;
      });
      return;
    }

    final location = _locationController.text.trim();
    Navigator.of(context).pop(
      ActivityItem(
        id: 'event-${DateTime.now().microsecondsSinceEpoch}',
        title: title,
        subtitle: activitySubtitle(
          l10n,
          startsAt,
          location.isEmpty ? l10n.commonLocationTbd : location,
        ),
        guests: guestsLabel(l10n, 1, going: true, capacity: capacity),
        attendeeCount: 1,
        icon: Icons.event,
        color: AppColors.event,
        isGoing: true,
        startsAt: startsAt,
        endsAt: endsAt,
        eventType: 'Event',
        visibility: _audience.visibilityKey,
        audience: _audience,
        kind: ActivityKind.event,
        description: _descriptionController.text.trim(),
        location: location,
        hosts: ['You', ..._coHosts],
        capacity: capacity,
        rsvpEnabled: _rsvpEnabled,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.createEventTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                if (value.trim().isNotEmpty && _titleError != null) {
                  setState(() => _titleError = null);
                }
              },
              decoration: InputDecoration(
                labelText: l10n.createEventTitleLabel,
                hintText: l10n.createEventTitleHint,
                border: const OutlineInputBorder(),
                errorText: _titleError,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.createEventDescriptionLabel,
                alignLabelWithHint: true,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: l10n.commonLocation,
                hintText: l10n.createEventLocationHint,
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
            const SizedBox(height: 16),
            Text(
              l10n.createEventHosts,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text(l10n.commonYou)),
                for (final host in _coHosts) Chip(label: Text(host)),
                ActionChip(
                  avatar: const Icon(Icons.person_add_alt, size: 18),
                  label: Text(l10n.createEventAddCoHosts),
                  onPressed: _pickHosts,
                ),
              ],
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _rsvpEnabled,
              onChanged: (value) => setState(() => _rsvpEnabled = value),
              title: Text(l10n.createEventAllowRsvps),
              subtitle: Text(
                _rsvpEnabled ? l10n.createEventRsvpOn : l10n.createEventRsvpOff,
              ),
            ),
            if (_rsvpEnabled) ...[
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _limitAttendance,
                onChanged: (value) => setState(() => _limitAttendance = value),
                title: Text(l10n.createEventLimitAttendance),
              ),
              if (_limitAttendance)
                TextField(
                  controller: _capacityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.createEventMaxAttendees,
                    border: const OutlineInputBorder(),
                    errorText: _capacityError,
                  ),
                  onChanged: (_) {
                    if (_capacityError != null) {
                      setState(() => _capacityError = null);
                    }
                  },
                ),
            ],
            const SizedBox(height: 16),
            AudiencePicker(
              audience: _audience,
              directory: widget.directory,
              onChanged: (value) => setState(() => _audience = value),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: Text(l10n.createEventButton)),
          ],
        ),
      ),
    );
  }
}
