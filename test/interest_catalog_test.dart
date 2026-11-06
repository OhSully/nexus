import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus/l10n/app_localizations.dart';
import 'package:nexus/models/interest_catalog.dart';

void main() {
  testWidgets('every predefined interest and category has a French label', (
    tester,
  ) async {
    late AppLocalizations en;
    late AppLocalizations fr;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('fr'),
        home: Builder(
          builder: (context) {
            fr = AppLocalizations.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    en = await AppLocalizations.delegate.load(const Locale('en'));

    for (final entry in interestGroups.entries) {
      expect(interestCategoryLabel(en, entry.key), entry.key);
      expect(interestCategoryLabel(fr, entry.key), isNotEmpty);
      for (final interest in entry.value) {
        // Falling through to the raw key means the switch lacks a case.
        expect(interestLabel(en, interest), interest);
        expect(interestLabel(fr, interest), isNotEmpty);
      }
    }
    expect(interestLabel(fr, 'Running'), 'Course à pied');
    expect(
      interestLabel(fr, 'Underwater basket weaving'),
      'Underwater basket weaving',
    );
  });
}
