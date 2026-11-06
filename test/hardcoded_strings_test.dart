import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Fails when a user-visible string literal is hard-coded in UI code instead
/// of coming from the ARB files. Sample data and generated l10n are exempt.
void main() {
  final widgetText = RegExp(
    r'''\b(?:Text|SelectableText)\(\s*(['"])((?:(?!\1).)*[A-Za-z](?:(?!\1).)*)\1''',
  );
  final textProperty = RegExp(
    r'''\b(?:label|labelText|hintText|helperText|tooltip|title|semanticLabel|subtitle|errorText)\s*:\s*(?:const\s+Text\()?(['"])((?:(?!\1).)*[A-Za-z](?:(?!\1).)*)\1''',
  );

  // Placeholder strings that are stand-ins for backend data.
  const allowed = {'Sunrise hike', 'Sunday brunch'};

  bool isExempt(String path) {
    final p = path.replaceAll('\\', '/');
    return p.contains('lib/l10n/') ||
        p.contains('lib/data/') ||
        p.contains('/sample_');
  }

  test('UI code has no hard-coded user-visible strings', () {
    final offenders = <String>[];
    for (final file in Directory('lib').listSync(recursive: true)) {
      if (file is! File ||
          !file.path.endsWith('.dart') ||
          isExempt(file.path)) {
        continue;
      }
      final source = file.readAsStringSync();
      for (final pattern in [widgetText, textProperty]) {
        for (final match in pattern.allMatches(source)) {
          final text = match.group(2)!;
          final literal = text.replaceAll(RegExp(r'\$\{[^}]*\}|\$\w+'), '');
          if (RegExp('[A-Za-z]').hasMatch(literal) && !allowed.contains(text)) {
            offenders.add('${file.path}: "$text"');
          }
        }
      }
    }
    expect(
      offenders,
      isEmpty,
      reason:
          'Move these strings into lib/l10n/*.arb:\n${offenders.join('\n')}',
    );
  });
}
