import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus/main.dart';
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

  test('en and fr ARB files define identical keys', () {
    final en = _keys('lib/l10n/app_en.arb');
    final fr = _keys('lib/l10n/app_fr.arb');
    expect(en.difference(fr), isEmpty, reason: 'missing in fr');
    expect(fr.difference(en), isEmpty, reason: 'missing in en');
  });
}
