import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../widgets/app_card.dart';
import '../../widgets/audience_picker.dart';
import '../../widgets/section_header.dart';

/// Editable "Looking For" card for the current user.
class LookingForEditSection extends ConsumerStatefulWidget {
  const LookingForEditSection({super.key});

  @override
  ConsumerState<LookingForEditSection> createState() =>
      _LookingForEditSectionState();
}

class _LookingForEditSectionState extends ConsumerState<LookingForEditSection> {
  // Text fields need controllers; everything else is read from the provider.
  final List<TextEditingController> _controllers = [];

  ProfileNotifier get _notifier => ref.read(profileProvider.notifier);

  /// Keeps one text controller per entry as entries come and go.
  void _syncControllers(int count, List<String> texts) {
    while (_controllers.length < count) {
      _controllers.add(TextEditingController(text: texts[_controllers.length]));
    }
    while (_controllers.length > count) {
      _controllers.removeLast().dispose();
    }
  }

  void _remove(int index) {
    final wasLast = ref.read(profileProvider).lookingFor.length == 1;
    _notifier.removeLookingFor(index);
    if (wasLast) {
      _controllers[index].clear();
    } else {
      _controllers.removeAt(index).dispose();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final directory = ref.watch(audienceDirectoryProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final hints = [
      l10n.lookingForHint1,
      l10n.lookingForHint2,
      l10n.lookingForHint3,
    ];
    _syncControllers(
      profile.lookingFor.length,
      profile.lookingFor.map((e) => e.text).toList(),
    );

    final dates = profile.lookingFor.map((entry) => entry.declaredAt);
    final lastDeclared = dates.isEmpty
        ? DateTime.now()
        : dates.reduce((a, b) => a.isAfter(b) ? a : b);

    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            l10n.profileLookingFor,
            trailing: _controllers.length < maxLookingForEntries
                ? TextButton(
                    onPressed: _notifier.addLookingFor,
                    child: Text(l10n.lookingForAddMore),
                  )
                : null,
          ),
          const SizedBox(height: 6),
          ...List.generate(_controllers.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controllers[index],
                          maxLength: 80,
                          maxLines: 1,
                          minLines: 1,
                          decoration: InputDecoration(
                            hintText: hints[index.clamp(0, hints.length - 1)],
                            filled: true,
                            fillColor: theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.35),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          onChanged: (text) =>
                              _notifier.setLookingForText(index, text),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _remove(index),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 8),
                    child: AudiencePicker(
                      audience: profile.lookingFor[index].audience,
                      directory: directory,
                      onChanged: (value) =>
                          _notifier.setLookingForAudience(index, value),
                    ),
                  ),
                ],
              ),
            );
          }),
          Row(
            children: [
              Icon(Icons.sync, size: 14, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.lookingForLastDeclared(lastDeclared),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              TextButton(
                onPressed: _notifier.redeclareAll,
                child: Text(l10n.lookingForRedeclare),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
