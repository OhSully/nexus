import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus/data/repositories.dart';
import 'package:nexus/l10n/app_localizations.dart';
import 'package:nexus/models/audience.dart';
import 'package:nexus/models/user_profile.dart';
import 'package:nexus/providers/providers.dart';
import 'package:nexus/screens/profile/beacon_refresh_control.dart';
import 'package:nexus/screens/profile_screen.dart';

UserProfile profileWith(List<LookingForEntry> entries) => UserProfile(
  bio: '',
  lookingFor: entries,
  selectedInterests: const {},
  customInterests: const {},
  interestNotes: const {},
);

void main() {
  Future<TestGesture> holdRefresh(WidgetTester tester, Finder refresh) async {
    final gesture = await tester.startGesture(tester.getCenter(refresh));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump();
    return gesture;
  }

  Future<void> dragToDuration(
    WidgetTester tester,
    TestGesture gesture,
    BeaconDuration duration,
  ) async {
    final option = find.byKey(ValueKey('beacon-duration-${duration.name}'));
    await gesture.moveTo(tester.getCenter(option));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
  }

  test('duration expiry uses local midnight and exact elapsed days', () {
    final now = DateTime(2026, 11, 17, 15, 30);
    expect(BeaconDuration.today.expiryFrom(now), DateTime(2026, 11, 18));
    expect(
      BeaconDuration.oneDay.expiryFrom(now),
      now.add(const Duration(days: 1)),
    );
    expect(
      BeaconDuration.sevenDays.expiryFrom(now),
      now.add(const Duration(days: 7)),
    );
    expect(
      BeaconDuration.thirtyDays.expiryFrom(now),
      now.add(const Duration(days: 30)),
    );
    final entry = LookingForEntry(text: 'Hike', declaredAt: now);
    expect(entry.isExpired(entry.expiresAt), isTrue);
    expect(
      entry.isExpired(
        entry.expiresAt.subtract(const Duration(microseconds: 1)),
      ),
      isFalse,
    );
  });

  test('expired entries are removed on load and saved to the repository', () {
    final now = DateTime(2026, 11, 17);
    final repository = InMemoryProfileRepository(
      seed: profileWith([
        LookingForEntry(
          text: 'Expired',
          declaredAt: now.subtract(const Duration(days: 7)),
        ),
        LookingForEntry(text: 'Active', declaredAt: now),
      ]),
    );
    final container = ProviderContainer(
      overrides: [
        clockProvider.overrideWithValue(() => now),
        profileRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    expect(container.read(profileProvider).lookingFor.single.text, 'Active');
    expect(repository.load().lookingFor.single.text, 'Active');
  });

  testWidgets('last beacon expiry leaves a way to create a beacon', (
    tester,
  ) async {
    var now = DateTime(2026, 11, 17, 12);
    final repository = InMemoryProfileRepository(
      seed: profileWith([
        LookingForEntry(
          text: 'Expiring',
          declaredAt: now
              .subtract(const Duration(days: 1))
              .add(const Duration(seconds: 1)),
          duration: BeaconDuration.oneDay,
        ),
      ]),
    );
    final container = ProviderContainer(
      overrides: [
        clockProvider.overrideWithValue(() => now),
        profileRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: ProfileScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Expiring'), findsOneWidget);
    now = now.add(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.text('Beacons'), findsOneWidget);
    final add = find.byKey(const Key('add-first-beacon'));
    expect(add, findsOneWidget);
    await tester.tap(add);
    await tester.pumpAndSettle();
    expect(container.read(profileProvider).lookingFor, hasLength(1));
    expect(find.byKey(const Key('open-audience-picker')), findsOneWidget);
    final field = find.byType(TextField).last;
    await tester.ensureVisible(field);
    await tester.enterText(field, 'A new hike');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byIcon(Icons.check));
    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();
    expect(find.text('A new hike'), findsOneWidget);
    expect(repository.load().lookingFor.single.text, 'A new hike');
    await tester.pumpWidget(const SizedBox());
    container.dispose();
  });

  testWidgets('empty state reuses a blank draft', (tester) async {
    final now = DateTime(2026, 11, 17, 12);
    final repository = InMemoryProfileRepository(
      seed: profileWith([LookingForEntry(text: ' ', declaredAt: now)]),
    );
    final container = ProviderContainer(
      overrides: [
        clockProvider.overrideWithValue(() => now),
        profileRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          locale: Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: ProfileScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Balises'), findsOneWidget);
    await tester.tap(find.text('Allumer une balise'));
    await tester.pumpAndSettle();
    expect(container.read(profileProvider).lookingFor, hasLength(1));
    expect(find.byKey(const Key('open-audience-picker')), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    container.dispose();
  });

  testWidgets('refresh retains duration and choices reset expiry per beacon', (
    tester,
  ) async {
    var now = DateTime(2026, 11, 17, 15, 30);

    final initial = now;
    final repository = InMemoryProfileRepository(
      seed: profileWith([
        LookingForEntry(
          text: 'Hike',
          declaredAt: now.subtract(const Duration(days: 1)),
          audience: const Audience(
            AudienceType.connections,
            people: ['Maya Patel'],
          ),
        ),
        LookingForEntry(text: 'Coffee', declaredAt: now),
      ]),
    );
    final container = ProviderContainer(
      overrides: [
        clockProvider.overrideWithValue(() => now),
        profileRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: ProfileScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final refresh = find.byKey(const Key('refresh-beacon')).first;
    expect(find.text('6'), findsOneWidget);
    await tester.tap(refresh);
    await tester.pumpAndSettle();
    expect(
      container.read(profileProvider).lookingFor.first.declaredAt,
      initial,
    );
    expect(find.text('7'), findsNWidgets(2));
    now = now.add(const Duration(hours: 1));
    final gesture = await holdRefresh(tester, refresh);
    expect(find.text('Duration (days)'), findsOneWidget);
    await dragToDuration(tester, gesture, BeaconDuration.today);
    expect(find.byKey(const Key('beacon-duration-popup')), findsNothing);
    var entries = container.read(profileProvider).lookingFor;
    expect(entries.first.duration, BeaconDuration.today);
    expect(entries.first.expiresAt, DateTime(2026, 11, 18));
    expect(entries.first.audience.people, ['Maya Patel']);
    expect(entries.last.declaredAt, initial);
    now = now.add(const Duration(hours: 1));
    await tester.tap(refresh);
    await tester.pumpAndSettle();
    entries = container.read(profileProvider).lookingFor;
    expect(entries.first.declaredAt, now);
    expect(entries.first.duration, BeaconDuration.today);
    expect(entries.first.expiresAt, DateTime(2026, 11, 18));
    await tester.pumpWidget(const SizedBox());
    container.dispose();
  });

  testWidgets('duration popup follows the hold and fits a small screen', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    var entry = LookingForEntry(text: 'Hike', declaredAt: DateTime.now());
    final choices = <BeaconDuration?>[];
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('fr'),
          theme: ThemeData.dark(useMaterial3: true),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.5)),
            child: child!,
          ),
          home: Scaffold(
            body: Align(
              alignment: Alignment.bottomRight,
              child: StatefulBuilder(
                builder: (context, setState) => BeaconRefreshControl(
                  entry: entry,
                  onRefresh: (duration) {
                    choices.add(duration);
                    if (duration != null) {
                      setState(
                        () => entry = entry.copyWith(duration: duration),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
    final refresh = find.byKey(const Key('refresh-beacon'));
    for (final duration in BeaconDuration.values) {
      final gesture = await holdRefresh(tester, refresh);
      final popup = find.byKey(const Key('beacon-duration-popup'));
      expect(popup, findsOneWidget);
      expect(
        tester.getBottomLeft(popup).dy,
        lessThan(tester.getTopLeft(refresh).dy),
      );
      expect(tester.getTopLeft(popup).dx, greaterThanOrEqualTo(0));
      expect(tester.getTopRight(popup).dx, lessThanOrEqualTo(320));
      await dragToDuration(tester, gesture, duration);
      expect(choices.last, duration);
      expect(popup, findsNothing);
      expect(tester.takeException(), isNull);
    }
    var gesture = await holdRefresh(tester, refresh);
    await gesture.up();
    await tester.pumpAndSettle();
    expect(choices, BeaconDuration.values);
    expect(find.byKey(const Key('beacon-duration-popup')), findsNothing);
    gesture = await holdRefresh(tester, refresh);
    await gesture.moveTo(
      tester.getCenter(find.byKey(const Key('beacon-duration-oneDay'))),
    );
    await tester.pump();
    await gesture.moveTo(tester.getCenter(refresh));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(choices, BeaconDuration.values);
    gesture = await holdRefresh(tester, refresh);
    await gesture.moveTo(
      tester.getCenter(find.byKey(const Key('beacon-duration-oneDay'))),
    );
    await tester.pump();
    await gesture.cancel();
    await tester.pumpAndSettle();
    expect(choices, BeaconDuration.values);
    expect(find.byKey(const Key('beacon-duration-popup')), findsNothing);
  });

  testWidgets('popup stays visible when the refresh icon is at the top', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: BeaconRefreshControl(
                entry: LookingForEntry(
                  text: 'Hike',
                  declaredAt: DateTime.now(),
                ),
                onRefresh: (_) {},
              ),
            ),
          ),
        ),
      ),
    );
    final refresh = find.byKey(const Key('refresh-beacon'));
    final gesture = await holdRefresh(tester, refresh);
    final popup = find.byKey(const Key('beacon-duration-popup'));
    expect(
      tester.getTopLeft(popup).dy,
      greaterThan(tester.getBottomLeft(refresh).dy),
    );
    await gesture.up();
    await tester.pumpAndSettle();
    expect(popup, findsNothing);
  });

  testWidgets('duration choices are available as screen reader actions', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    BeaconDuration? chosen;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: BeaconRefreshControl(
              entry: LookingForEntry(text: 'Hike', declaredAt: DateTime.now()),
              onRefresh: (duration) => chosen = duration,
            ),
          ),
        ),
      ),
    );
    final node = tester.getSemantics(find.byKey(const Key('refresh-beacon')));
    final action = CustomSemanticsAction.getIdentifier(
      const CustomSemanticsAction(label: '30 days'),
    );
    expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    expect(node.getSemanticsData().label, contains('Refresh beacon'));
    expect(node.getSemanticsData().customSemanticsActionIds, contains(action));
    tester
        .renderObject(find.byKey(const Key('refresh-beacon')))
        .owner!
        .semanticsOwner!
        .performAction(node.id, SemanticsAction.customAction, action);
    expect(chosen, BeaconDuration.thirtyDays);
    handle.dispose();
  });

  testWidgets('expiry timer removes only expired entries from stored profile', (
    tester,
  ) async {
    var now = DateTime(2026, 11, 17, 12);
    final repository = InMemoryProfileRepository(
      seed: profileWith([
        LookingForEntry(
          text: 'Expires soon',
          declaredAt: now
              .subtract(const Duration(days: 1))
              .add(const Duration(seconds: 1)),
          duration: BeaconDuration.oneDay,
        ),
        LookingForEntry(text: 'Still active', declaredAt: now),
      ]),
    );
    final container = ProviderContainer(
      overrides: [
        clockProvider.overrideWithValue(() => now),
        profileRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    container.read(profileProvider);
    now = now.add(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(
      container.read(profileProvider).lookingFor.single.text,
      'Still active',
    );
    expect(repository.load().lookingFor.single.text, 'Still active');
    container.dispose();
  });

  testWidgets('expiring a beacon in edit mode keeps the remaining text', (
    tester,
  ) async {
    var now = DateTime(2026, 11, 17, 12);
    final repository = InMemoryProfileRepository(
      seed: profileWith([
        LookingForEntry(
          text: 'Expiring',
          declaredAt: now
              .subtract(const Duration(days: 1))
              .add(const Duration(seconds: 2)),
          duration: BeaconDuration.oneDay,
        ),
        LookingForEntry(text: 'Keep this', declaredAt: now),
      ]),
    );
    final container = ProviderContainer(
      overrides: [
        clockProvider.overrideWithValue(() => now),
        profileRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: ProfileScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();
    now = now.add(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.widgetWithText(TextField, 'Keep this'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Expiring'), findsNothing);
    await tester.pumpWidget(const SizedBox());
    container.dispose();
  });
}
