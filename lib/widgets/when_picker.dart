import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../providers/providers.dart';

class WhenPicker extends ConsumerWidget {
  const WhenPicker({
    super.key,
    required this.date,
    required this.start,
    required this.end,
    required this.onDateChanged,
    required this.onStartChanged,
    required this.onEndChanged,
    this.errorText,
  });

  final DateTime date;
  final TimeOfDay start;
  final TimeOfDay end;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TimeOfDay> onStartChanged;
  final ValueChanged<TimeOfDay> onEndChanged;
  final String? errorText;

  static DateTime combine(DateTime date, TimeOfDay time) =>
      DateTime(date.year, date.month, date.day, time.hour, time.minute);

  Future<void> _pickDate(BuildContext context, DateTime today) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(today.year, today.month, today.day),
      lastDate: today.add(const Duration(days: 365)),
    );
    if (picked != null) {
      onDateChanged(picked);
    }
  }

  Future<void> _pickTime(
    BuildContext context,
    TimeOfDay initial,
    ValueChanged<TimeOfDay> onChanged,
  ) async {
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = MaterialLocalizations.of(context);
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionChip(
              avatar: const Icon(Icons.calendar_today_outlined, size: 18),
              label: Text(localizations.formatMediumDate(date)),
              onPressed: () => _pickDate(context, ref.read(clockProvider)()),
            ),
            ActionChip(
              avatar: const Icon(Icons.schedule, size: 18),
              label: Text(
                l10n.whenPickerStarts(localizations.formatTimeOfDay(start)),
              ),
              onPressed: () => _pickTime(context, start, onStartChanged),
            ),
            ActionChip(
              avatar: const Icon(Icons.schedule, size: 18),
              label: Text(
                l10n.whenPickerEnds(localizations.formatTimeOfDay(end)),
              ),
              onPressed: () => _pickTime(context, end, onEndChanged),
            ),
          ],
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              errorText!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
