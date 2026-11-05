import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../../widgets/section_header.dart';
import 'interest_catalog.dart';
import 'interest_note_dialog.dart';
import 'interest_picker_sheet.dart';

/// Editable interests list with notes and the add-interest picker.
class InterestsEditSection extends ConsumerWidget {
  const InterestsEditSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final notifier = ref.read(profileProvider.notifier);
    final theme = Theme.of(context);
    final selected = profile.selectedInterests.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          'Interests',
          trailing: TextButton.icon(
            onPressed: () => showInterestPicker(context),
            icon: const Icon(Icons.add),
            label: const Text('Add interest'),
          ),
        ),
        const SizedBox(height: 12),
        if (selected.isEmpty)
          Text(
            'Choose a few interests to help people discover shared strengths.',
            style: theme.textTheme.bodyMedium,
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              final shouldDoubleUp = selected.length > 1 && maxWidth > 320;

              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selected.map((interest) {
                  final note = profile.interestNotes[interest] ?? '';
                  final hasNote = note.trim().isNotEmpty;
                  final width = shouldDoubleUp && !hasNote
                      ? (maxWidth - 8) / 2
                      : null;

                  return SizedBox(
                    width: width,
                    child: InputChip(
                      label: Text(interest),
                      avatar: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: hasNote
                              ? theme.colorScheme.primaryContainer
                              : theme.colorScheme.surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          hasNote ? Icons.edit : Icons.add,
                          size: 12,
                          color: hasNote
                              ? theme.colorScheme.onPrimaryContainer
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      showCheckmark: false,
                      onPressed: () async {
                        final updated = await showDialog<String>(
                          context: context,
                          builder: (_) => InterestNoteDialog(
                            interest: interest,
                            initialNote: note,
                          ),
                        );
                        if (updated != null) {
                          notifier.setInterestNote(interest, updated);
                        }
                      },
                      onDeleted: () => notifier.toggleInterest(
                        interest,
                        isPredefined: isPredefinedInterest(interest),
                      ),
                      deleteIcon: const Icon(Icons.close, size: 14),
                      side: BorderSide(color: theme.dividerColor),
                      backgroundColor: theme.colorScheme.surface,
                      labelStyle: theme.textTheme.labelLarge,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
      ],
    );
  }
}
