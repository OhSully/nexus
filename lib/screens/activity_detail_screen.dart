import 'package:flutter/material.dart';

import '../models/activity_item.dart';
import '../theme/app_theme.dart';
import '../utils/activity_format.dart';

class ActivityDetailScreen extends StatefulWidget {
  const ActivityDetailScreen({
    super.key,
    required this.item,
    required this.onRSVP,
    this.events = const [],
    this.onEnrollLinkedEvent,
    this.onChangeLinkedEvent,
  });

  final ActivityItem item;
  final ValueChanged<ActivityItem> onRSVP;
  final List<ActivityItem> events;
  final ActivityItem Function(ActivityItem activity)? onEnrollLinkedEvent;
  final ActivityItem Function(ActivityItem activity, String? eventId)?
  onChangeLinkedEvent;

  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  late ActivityItem _item;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
  }

  void _toggleRSVP() {
    final nextGoing = !_item.isGoing;
    final nextCount =
        (nextGoing ? _item.attendeeCount + 1 : _item.attendeeCount - 1).clamp(
          0,
          1 << 30,
        );
    final updated = _item.copyWith(
      attendeeCount: nextCount,
      guests: guestsLabel(
        nextCount,
        going: nextGoing,
        capacity: _item.capacity,
      ),
      isGoing: nextGoing,
    );

    setState(() {
      _item = updated;
    });

    widget.onRSVP(updated);
  }

  void _enrollLinkedEvent() {
    final updated = widget.onEnrollLinkedEvent!(_item);
    setState(() => _item = updated);
  }

  ActivityItem? get _linkedEvent {
    final id = _item.linkedEventId;
    for (final event in widget.events) {
      if (event.id == id) {
        return event;
      }
    }
    return null;
  }

  bool get _canManageLink =>
      !_item.isEvent &&
      _item.hosts.contains('You') &&
      widget.onChangeLinkedEvent != null;

  Future<String?> _pickEvent() {
    final choices = widget.events
        .where((event) => event.id != _item.linkedEventId)
        .toList();

    return showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Choose an event'),
        children: [
          for (final event in choices)
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop(event.id),
              child: Text(event.title),
            ),
        ],
      ),
    );
  }

  Future<bool> _confirmCancelRsvps() async {
    if (!_item.linkedEventEnrolled) {
      return true;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel linked RSVPs?'),
        content: Text(
          'The ${_item.linkedEnrolledCount} RSVPs made for '
          '${_linkedEvent?.title ?? 'the linked event'} will be cancelled.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep link'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cancel RSVPs'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  Future<void> _changeLink({required bool unlink}) async {
    final String? target;
    if (unlink) {
      target = null;
      if (!await _confirmCancelRsvps()) {
        return;
      }
    } else {
      target = await _pickEvent();
      if (target == null || !mounted || !await _confirmCancelRsvps()) {
        return;
      }
    }
    if (!mounted) {
      return;
    }
    final updated = widget.onChangeLinkedEvent!(_item, target);
    setState(() => _item = updated);
  }

  Widget _buildRsvpButton() {
    if (!_item.rsvpEnabled) {
      return const Text('No RSVP needed. Just show up.');
    }
    final blocked = !_item.isGoing && _item.isFull;

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: blocked ? null : _toggleRSVP,
        child: Text(
          blocked ? 'Event full' : (_item.isGoing ? 'You are going' : 'Going'),
        ),
      ),
    );
  }

  Widget _buildLinkedEvent(BuildContext context) {
    final event = _linkedEvent;
    if (event == null) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.link, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Linked event: ${event.title}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              _item.linkedEventEnrolled
                  ? 'Everyone interested has been enrolled in this event.'
                  : 'Once you are sure, enroll everyone interested in the event.',
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(
                spacing: 8,
                children: [
                  if (!_item.linkedEventEnrolled &&
                      widget.onEnrollLinkedEvent != null)
                    OutlinedButton(
                      onPressed: _enrollLinkedEvent,
                      child: const Text('Enroll everyone in event'),
                    ),
                  if (_canManageLink) ...[
                    TextButton(
                      onPressed: () => _changeLink(unlink: false),
                      child: const Text('Change event'),
                    ),
                    TextButton(
                      onPressed: () => _changeLink(unlink: true),
                      child: const Text('Unlink'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_item.isEvent ? 'Event details' : 'Activity details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            _item.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(_item.subtitle),
          if (_item.description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(_item.description),
          ],
          if (_item.hosts.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text('Hosted by ${_item.hosts.join(', ')}'),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.visibility_outlined, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Visible to: ${_item.effectiveAudience.summary}',
                  key: const Key('detail-audience'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.brand.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(_item.guests),
              ),
              if (_item.happensRegardless)
                const Chip(
                  avatar: Icon(Icons.check_circle_outline, size: 18),
                  label: Text('Happening regardless'),
                ),
            ],
          ),
          if (_linkedEvent != null)
            _buildLinkedEvent(context)
          else if (_canManageLink && widget.events.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => _changeLink(unlink: false),
                icon: const Icon(Icons.link),
                label: const Text('Link to an event'),
              ),
            ),
          const SizedBox(height: 24),
          _buildRsvpButton(),
        ],
      ),
    );
  }
}
