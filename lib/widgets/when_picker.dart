import 'package:flutter/material.dart';

class WhenPicker extends StatelessWidget {
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

  Future<void> _pickDate(BuildContext context) async {
    final today = DateTime.now();
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
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);

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
              onPressed: () => _pickDate(context),
            ),
            ActionChip(
              avatar: const Icon(Icons.schedule, size: 18),
              label: Text('Starts ${localizations.formatTimeOfDay(start)}'),
              onPressed: () => _pickTime(context, start, onStartChanged),
            ),
            ActionChip(
              avatar: const Icon(Icons.schedule, size: 18),
              label: Text('Ends ${localizations.formatTimeOfDay(end)}'),
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
