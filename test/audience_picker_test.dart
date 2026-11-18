import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus/l10n/app_localizations.dart';
import 'package:nexus/models/audience.dart';
import 'package:nexus/widgets/audience_picker.dart';
import 'package:nexus/widgets/user_avatar.dart';

const directory = AudienceDirectory(
  groups: {
    'Alpha': ['Maya Patel', 'Jordan Lee', 'Alex Guest'],
    'Beta': ['Maya Patel', 'Sofia Nguyen'],
    'Gamma': ['Jordan Lee'],
    'Zeta': ['Sofia Nguyen'],
  },
  pastEventAttendees: {
    'Recent': ['Maya Patel', 'Sofia Nguyen', 'Alex Guest', 'Sam Visitor'],
    'Older': ['Jordan Lee'],
    'Oldest': ['Maya Patel'],
    'Archive': ['Sofia Nguyen'],
  },
  personDetails: {
    'Alex Guest': AudiencePersonDetails(hasAccount: false),
    'Sam Visitor': AudiencePersonDetails(),
  },
);

void main() {
  Future<void> pumpPicker(
    WidgetTester tester, {
    required ValueChanged<Audience> onChanged,
    Locale? locale,
    Audience initial = Audience.empty,
    Size size = const Size(800, 1400),
    double textScale = 1,
    bool dark = false,
  }) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    var audience = initial;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: locale,
          theme: dark ? ThemeData.dark(useMaterial3: true) : null,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => AudiencePicker(
                audience: audience,
                directory: directory,
                onChanged: (value) {
                  setState(() => audience = value);
                  onChanged(value);
                },
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('open-audience-picker')));
    await tester.pumpAndSettle();
  }

  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> closeFilters(WidgetTester tester) async {
    await tapVisible(
      tester,
      find.byWidgetPredicate(
        (widget) =>
            widget is Text && (widget.data?.startsWith('Filters') ?? false),
      ),
    );
  }

  Future<void> openFilters(WidgetTester tester) async {
    await closeFilters(tester);
  }

  testWidgets(
    'filters intersect without selecting; bulk changes only matches',
    (tester) async {
      Audience? saved;
      await pumpPicker(tester, onChanged: (value) => saved = value);
      expect(
        find.descendant(
          of: find.byKey(const Key('audience-bulk-container')),
          matching: find.byKey(const Key('audience-select-all')),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(const Key('audience-bulk-container')),
          matching: find.byKey(const ValueKey('audience-person-Sofia Nguyen')),
        ),
        findsNothing,
      );
      expect(find.text('Reaches 0 people'), findsOneWidget);
      await tester.tap(
        find.byKey(const ValueKey('audience-person-Sofia Nguyen')),
      );
      await tester.pumpAndSettle();
      await openFilters(tester);
      await tapVisible(tester, find.widgetWithText(FilterChip, 'Alpha'));
      await tapVisible(
        tester,
        find.byKey(const Key('audience-filter-section-events')),
      );
      await tapVisible(tester, find.widgetWithText(FilterChip, 'Recent'));
      expect(find.text('Reaches 1 person'), findsOneWidget);
      await closeFilters(tester);
      expect(find.text('Filters · Connections only · 2'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('audience-person-Jordan Lee')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey('audience-person-Maya Patel')),
        findsOneWidget,
      );
      expect(find.text('Select all'), findsOneWidget);
      await tester.tap(find.byKey(const Key('audience-select-all')));
      await tester.pumpAndSettle();
      expect(find.text('Reaches 2 people'), findsOneWidget);
      expect(find.text('Deselect all'), findsOneWidget);
      await tester.tap(find.byKey(const Key('audience-select-all')));
      await tester.pumpAndSettle();
      expect(find.text('Reaches 1 person'), findsOneWidget);
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      expect(saved!.people, ['Sofia Nguyen']);
    },
  );

  testWidgets('shared person remains selected across groups and interests', (
    tester,
  ) async {
    Audience? saved;
    await pumpPicker(tester, onChanged: (value) => saved = value);
    await openFilters(tester);
    await tapVisible(tester, find.widgetWithText(FilterChip, 'Alpha'));
    await closeFilters(tester);
    await tester.tap(find.byKey(const ValueKey('audience-person-Maya Patel')));
    await tester.pumpAndSettle();
    await openFilters(tester);
    await tapVisible(tester, find.widgetWithText(FilterChip, 'Alpha'));
    await tapVisible(tester, find.widgetWithText(FilterChip, 'Beta'));
    await tapVisible(
      tester,
      find.byKey(const Key('audience-filter-section-interests')),
    );
    await tapVisible(tester, find.text('Search all'));
    await tapVisible(tester, find.widgetWithText(FilterChip, 'Yoga'));
    await closeFilters(tester);
    expect(
      tester
          .widget<CheckboxListTile>(
            find.byKey(const ValueKey('audience-person-Maya Patel')),
          )
          .value,
      isTrue,
    );
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(saved!.people, ['Maya Patel']);
  });

  testWidgets('searches older sources and cancelling discards selections', (
    tester,
  ) async {
    Audience? saved;
    await pumpPicker(tester, onChanged: (value) => saved = value);
    await openFilters(tester);
    await tapVisible(
      tester,
      find.byKey(const Key('audience-filter-section-events')),
    );
    await tapVisible(tester, find.text('Search all'));
    await tester.enterText(
      find.byKey(const Key('audience-event-search')),
      'Archive',
    );
    await tester.pumpAndSettle();
    await tapVisible(tester, find.widgetWithText(FilterChip, 'Archive'));
    await closeFilters(tester);
    await tester.tap(find.byKey(const Key('audience-select-all')));
    await tester.pumpAndSettle();
    expect(find.text('Reaches 1 person'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(saved, isNull);
    expect(find.textContaining('0 people'), findsOneWidget);
  });

  testWidgets('connections filter hides but retains selected non-connections', (
    tester,
  ) async {
    Audience? saved;
    await pumpPicker(tester, onChanged: (value) => saved = value);
    await openFilters(tester);
    expect(
      tester
          .widget<FilterChip>(
            find.byKey(const Key('audience-connections-only')),
          )
          .selected,
      isTrue,
    );
    await tapVisible(
      tester,
      find.byKey(const Key('audience-filter-section-events')),
    );
    await tapVisible(tester, find.widgetWithText(FilterChip, 'Recent'));
    await closeFilters(tester);
    expect(find.text('Alex Guest'), findsNothing);
    expect(find.text('Sam Visitor'), findsNothing);
    await openFilters(tester);
    await tapVisible(
      tester,
      find.byKey(const Key('audience-connections-only')),
    );
    await closeFilters(tester);
    expect(find.text('Alex Guest'), findsOneWidget);
    expect(find.text('Sam Visitor'), findsOneWidget);
    expect(find.text('No account'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('audience-person-Alex Guest')),
        matching: find.byIcon(Icons.person_outline),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('audience-person-Sam Visitor')),
        matching: find.byType(UserAvatar),
      ),
      findsOneWidget,
    );
    await tapVisible(
      tester,
      find.byKey(const Key('audience-person-Alex Guest')),
    );
    await openFilters(tester);
    await tapVisible(
      tester,
      find.byKey(const Key('audience-connections-only')),
    );
    await closeFilters(tester);
    expect(find.text('1 selected person is hidden by filters'), findsOneWidget);
    await tapVisible(tester, find.byKey(const Key('audience-select-all')));
    expect(find.text('Reaches 3 people'), findsOneWidget);
    await tapVisible(tester, find.byKey(const Key('audience-select-all')));
    expect(find.text('Reaches 1 person'), findsOneWidget);
    await tapVisible(tester, find.byKey(const Key('audience-select-all')));
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(saved!.people, ['Alex Guest', 'Maya Patel', 'Sofia Nguyen']);
    await tester.tap(find.byKey(const Key('open-audience-picker')));
    await tester.pumpAndSettle();
    expect(find.text('Alex Guest'), findsNothing);
    expect(find.text('1 selected person is hidden by filters'), findsOneWidget);
    await openFilters(tester);
    await tapVisible(
      tester,
      find.byKey(const Key('audience-connections-only')),
    );
    await closeFilters(tester);
    expect(
      tester
          .widget<CheckboxListTile>(
            find.byKey(const Key('audience-person-Alex Guest')),
          )
          .value,
      isTrue,
    );
    await openFilters(tester);
    await tapVisible(tester, find.text('Reset filters'));
    expect(
      tester
          .widget<FilterChip>(
            find.byKey(const Key('audience-connections-only')),
          )
          .selected,
      isTrue,
    );
    await closeFilters(tester);
    expect(find.text('Alex Guest'), findsNothing);
    expect(find.text('1 selected person is hidden by filters'), findsOneWidget);
  });

  testWidgets('French labels and empty audience are supported', (tester) async {
    Audience? saved;
    await pumpPicker(
      tester,
      onChanged: (value) => saved = value,
      locale: const Locale('fr'),
    );
    expect(find.text('Rejoint 0 personnes'), findsOneWidget);
    expect(find.text('Tout sélectionner'), findsOneWidget);
    await tester.tap(find.text('Terminé'));
    await tester.pumpAndSettle();
    expect(saved!.people, isEmpty);
  });

  testWidgets('filters fit a narrow screen with larger French text', (
    tester,
  ) async {
    await pumpPicker(
      tester,
      onChanged: (_) {},
      locale: const Locale('fr'),
      size: const Size(320, 640),
      textScale: 1.5,
      dark: true,
    );
    await tester.tap(find.byKey(const Key('audience-filters')));
    await tester.pumpAndSettle();
    await tapVisible(tester, find.widgetWithText(FilterChip, 'Alpha'));
    expect(tester.takeException(), isNull);
  });

  testWidgets('public legacy audience warns before replacing it', (
    tester,
  ) async {
    await pumpPicker(tester, onChanged: (_) {}, initial: Audience.public);
    expect(
      find.text('Saving replaces public visibility with the selected people.'),
      findsOneWidget,
    );
  });
}
