import 'package:flutter/material.dart';

import '../models/sample_contacts.dart';

Future<List<String>?> showContactPicker(
  BuildContext context, {
  required String title,
  required String confirmLabel,
  List<String> initial = const [],
  bool allowEmpty = false,
}) {
  return showModalBottomSheet<List<String>>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _ContactPickerSheet(
      title: title,
      confirmLabel: confirmLabel,
      initial: initial,
      allowEmpty: allowEmpty,
    ),
  );
}

class _ContactPickerSheet extends StatefulWidget {
  const _ContactPickerSheet({
    required this.title,
    required this.confirmLabel,
    required this.initial,
    required this.allowEmpty,
  });

  final String title;
  final String confirmLabel;
  final List<String> initial;
  final bool allowEmpty;

  @override
  State<_ContactPickerSheet> createState() => _ContactPickerSheetState();
}

class _ContactPickerSheetState extends State<_ContactPickerSheet> {
  late final Set<String> _selected = {...widget.initial};

  @override
  Widget build(BuildContext context) {
    final canConfirm = widget.allowEmpty || _selected.isNotEmpty;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            for (final name in sampleContacts)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _selected.contains(name),
                title: Text(name),
                secondary: CircleAvatar(child: Text(name[0])),
                onChanged: (checked) => setState(() {
                  if (checked ?? false) {
                    _selected.add(name);
                  } else {
                    _selected.remove(name);
                  }
                }),
              ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: canConfirm
                    ? () => Navigator.of(
                        context,
                      ).pop(sampleContacts.where(_selected.contains).toList())
                    : null,
                child: Text(widget.confirmLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
