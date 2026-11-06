import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus/main.dart';
import 'package:nexus/models/audience.dart';
import 'package:nexus/providers/providers.dart';

Set<String> _keys(String path) {
  final json = jsonDecode(File(path).readAsStringSync()) as Map;
  return json.keys.cast<String>().where((k) => !k.startsWith('@')).toSet();
}

class _FrenchLocale extends LocaleNotifier {
  @override
  Locale? build() => const Locale('fr');
}

void main() {
  testWidgets('French locale shows French navigation labels', (tester) async {
    await tester.pumpWidget(
      NexusApp(overrides: [localeProvider.overrideWith(_FrenchLocale.new)]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Accueil'), findsOneWidget);
    expect(find.text('Discussions'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
    expect(find.text('Home'), findsNothing);
    expect(find.text('Chats'), findsNothing);
    expect(find.text('Profile'), findsNothing);
  });

  testWidgets('Settings language choice switches the app language', (
    tester,
  ) async {
    await tester.pumpWidget(const NexusApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('open-settings')));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('language-fr')));
    await tester.pumpAndSettle();
    expect(find.text('Paramètres'), findsOneWidget);
    expect(find.text('Langue'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('language-en')));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Profile'), findsWidgets);
  });

  testWidgets('Settings theme, notifications and default audience apply', (
    tester,
  ) async {
    await tester.pumpWidget(const NexusApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('open-settings')));
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(Scaffold).first),
    );

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(container.read(themeModeProvider), ThemeMode.dark);
    expect(
      Theme.of(tester.element(find.byType(Scaffold).first)).brightness,
      Brightness.dark,
    );

    final messages = find.byKey(const ValueKey('notif-messages'));
    await tester.ensureVisible(messages);
    await tester.tap(messages);
    await tester.pumpAndSettle();
    expect(
      container.read(notificationPrefsProvider),
      isNot(contains(NotificationKind.messages)),
    );

    final publicOption = find.descendant(
      of: find.byKey(const ValueKey('default-audience')),
      matching: find.text('Public'),
    );
    await tester.ensureVisible(publicOption);
    await tester.tap(publicOption);
    await tester.pumpAndSettle();
    expect(container.read(defaultAudienceProvider), Audience.public);

    final exportData = find.byKey(const ValueKey('export-data'));
    await tester.ensureVisible(exportData);
    await tester.tap(exportData);
    await tester.pump();
    expect(find.textContaining('Not available yet'), findsOneWidget);
  });

  test('en and fr ARB files define identical keys', () {
    final en = _keys('lib/l10n/app_en.arb');
    final fr = _keys('lib/l10n/app_fr.arb');
    expect(en.difference(fr), isEmpty, reason: 'missing in fr');
    expect(fr.difference(en), isEmpty, reason: 'missing in en');
  });
}
