import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/models/activity_item.dart';
import 'package:flutter_application_2/models/audience.dart';
import 'package:flutter_application_2/providers/providers.dart';
import 'package:flutter_application_2/screens/plans_screen.dart';
import 'package:flutter_application_2/screens/profile_screen.dart';

void main() {
  testWidgets('Nexus app shows the discover screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());

    expect(find.text('Upcoming activities'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('FAB offers message, activity and event options', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('New message'), findsOneWidget);
    expect(find.text('New activity'), findsOneWidget);
    expect(find.text('New event'), findsOneWidget);
  });

  testWidgets('User can create a new activity', (WidgetTester tester) async {
    await tester.pumpWidget(const NexusApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New activity'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Sunset run');
    await tester.enterText(find.byType(TextField).at(1), 'River Walk');
    await tester.tap(find.text('Happening regardless'));
    await tester.pumpAndSettle();
    expect(find.textContaining('whether or not anyone joins'), findsOneWidget);
    await tester.ensureVisible(find.text('Create activity'));
    await tester.tap(find.text('Create activity'));
    await tester.pumpAndSettle();

    expect(find.text('Sunset run'), findsOneWidget);
    expect(find.textContaining('River Walk'), findsOneWidget);

    await tester.tap(find.text('Sunset run'));
    await tester.pumpAndSettle();
    expect(find.text('Happening regardless'), findsOneWidget);
  });

  testWidgets('Activity title is required when creating an activity', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New activity'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Create activity'));
    await tester.tap(find.text('Create activity'));
    await tester.pumpAndSettle();

    expect(find.text('Enter an activity title'), findsOneWidget);
  });

  testWidgets('Activity linked to an event can enroll everyone', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New activity'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextField).first,
      'Who wants to see it?',
    );
    await tester.ensureVisible(find.byKey(const Key('linked-event-field')));
    await tester.tap(find.byKey(const Key('linked-event-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Movie night').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Create activity'));
    await tester.tap(find.text('Create activity'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Who wants to see it?'));
    await tester.pumpAndSettle();
    expect(find.text('Linked event: Movie night'), findsOneWidget);

    await tester.tap(find.text('Enroll everyone in event'));
    await tester.pumpAndSettle();

    expect(
      find.text('Everyone interested has been enrolled in this event.'),
      findsOneWidget,
    );
    expect(find.text('Enroll everyone in event'), findsNothing);
  });

  testWidgets('User can create an event with an attendance limit', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New event'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Create event'));
    await tester.tap(find.text('Create event'));
    await tester.pumpAndSettle();
    expect(find.text('Enter an event title'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Board game night');
    await tester.enterText(find.byType(TextField).at(2), 'My place');
    await tester.ensureVisible(find.text('Limit attendance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Limit attendance'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Create event'));
    await tester.tap(find.text('Create event'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a limit of at least 1'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Maximum attendees'),
      '6',
    );
    await tester.tap(find.text('Create event'));
    await tester.pumpAndSettle();

    expect(find.text('Board game night'), findsOneWidget);
    await tester.tap(find.text('Board game night'));
    await tester.pumpAndSettle();
    expect(find.text('1 of 6 spots taken'), findsOneWidget);
    expect(find.text('Hosted by You'), findsOneWidget);
  });

  testWidgets('New chat is only added to Chats once a message is sent', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());

    Future<void> startChatWith(List<String> names) async {
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.tap(find.text('New message'));
      await tester.pumpAndSettle();
      for (final name in names) {
        await tester.tap(find.widgetWithText(CheckboxListTile, name));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text('Start chat'));
      await tester.pumpAndSettle();
    }

    await startChatWith(['Maya Patel', 'Sofia Nguyen']);
    expect(find.text('Perfect, I’ll bring water.'), findsNothing);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chats'));
    await tester.pumpAndSettle();
    expect(find.text('Maya Patel, Sofia Nguyen'), findsNothing);

    await startChatWith(['Maya Patel', 'Sofia Nguyen']);
    await tester.enterText(find.byType(TextField), 'Brunch Sunday?');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('Maya Patel, Sofia Nguyen'), findsOneWidget);
    expect(find.text('Brunch Sunday?'), findsOneWidget);
  });

  testWidgets('Existing chat only moves to the top after a message is sent', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());
    await tester.tap(find.text('Chats'));
    await tester.pumpAndSettle();

    double top(String text) => tester.getTopLeft(find.text(text)).dy;

    await tester.tap(find.text('Maya Patel'));
    await tester.pumpAndSettle();
    expect(find.text('Perfect, I’ll bring water.'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(top("Brendan O'Sullivan"), lessThan(top('Maya Patel')));

    await tester.tap(find.text('Maya Patel'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'See you there');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(top('Maya Patel'), lessThan(top("Brendan O'Sullivan")));
    expect(find.text('See you there'), findsOneWidget);
  });

  testWidgets('Linked activity can be unlinked and RSVPs are cancelled', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const NexusApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New activity'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField).first,
      'Who wants to see it?',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('linked-event-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Movie night').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Create activity'));
    await tester.tap(find.text('Create activity'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Who wants to see it?'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enroll everyone in event'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Unlink'));
    await tester.pumpAndSettle();
    expect(find.text('Cancel linked RSVPs?'), findsOneWidget);
    await tester.tap(find.text('Cancel RSVPs'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Linked event:'), findsNothing);
    expect(find.text('Link to an event'), findsOneWidget);
    expect(find.textContaining('Cancelled 1 RSVPs'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Movie night'));
    await tester.pumpAndSettle();
    expect(find.text('8 people going'), findsOneWidget);
    expect(find.text('Going'), findsOneWidget);
  });

  testWidgets('Linked activity can be re-linked to another event', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New event'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Board game night');
    await tester.ensureVisible(find.text('Create event'));
    await tester.tap(find.text('Create event'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New activity'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Anyone keen?');
    await tester.ensureVisible(find.text('Create activity'));
    await tester.tap(find.text('Create activity'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Anyone keen?'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Link to an event'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Movie night'));
    await tester.pumpAndSettle();
    expect(find.text('Linked event: Movie night'), findsOneWidget);

    await tester.tap(find.text('Change event'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Board game night'));
    await tester.pumpAndSettle();
    expect(find.text('Linked event: Board game night'), findsOneWidget);
  });

  testWidgets('User can open an activity detail and RSVP', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());

    await tester.tap(find.text('Morning gym session'));
    await tester.pumpAndSettle();

    expect(find.text('Activity details'), findsOneWidget);
    expect(find.text('Going'), findsOneWidget);

    await tester.tap(find.text('Going'));
    await tester.pumpAndSettle();

    expect(find.text('You are going'), findsOneWidget);
  });

  testWidgets('Plans includes events the user has not RSVP\'d to', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());

    await tester.tap(find.text('Plans'));
    await tester.pumpAndSettle();

    expect(find.text('Plans'), findsNWidgets(2));
    expect(find.text('Your upcoming plans'), findsNothing);
    expect(
      find.text('No ongoing or upcoming plans for this day.'),
      findsNothing,
    );
  });

  testWidgets('Plans distinguishes RSVP events from other events', (
    WidgetTester tester,
  ) async {
    final now = DateTime.now();
    final plans = [
      ActivityItem(
        id: 'booked',
        title: 'Booked run',
        subtitle: 'Today · 2:00 PM · Park',
        guests: '3 people going',
        attendeeCount: 3,
        icon: Icons.directions_run,
        color: Colors.blue,
        isGoing: true,
        startsAt: now.add(const Duration(minutes: 30)),
      ),
      ActivityItem(
        id: 'available',
        title: 'Open coffee meetup',
        subtitle: 'Today · 3:00 PM · Cafe',
        guests: '2 people interested',
        attendeeCount: 2,
        icon: Icons.coffee,
        color: Colors.brown,
        isGoing: false,
        startsAt: now.add(const Duration(minutes: 60)),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlansScreen(plans: plans, onOpenActivity: (_) {}),
        ),
      ),
    );

    expect(find.text('Booked run'), findsOneWidget);
    expect(find.text('Open coffee meetup'), findsOneWidget);
    final bookedCard = tester.widget<Card>(
      find.byKey(const ValueKey('activity-card-booked')),
    );
    final openCard = tester.widget<Card>(
      find.byKey(const ValueKey('activity-card-available')),
    );
    final bookedBorder = bookedCard.shape! as RoundedRectangleBorder;
    final openBorder = openCard.shape! as RoundedRectangleBorder;

    expect(bookedCard.color, isNotNull);
    expect(bookedCard.color, isNot(openCard.color));
    expect(bookedBorder.side.width, 2);
    expect(openBorder.side.width, 0);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.text("You're going"), findsNothing);
    expect(find.text('Not attending'), findsNothing);
  });

  testWidgets('RSVP activities appear in Plans', (WidgetTester tester) async {
    await tester.pumpWidget(const NexusApp());

    await tester.tap(find.text('Morning gym session'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Going'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Plans'));
    await tester.pumpAndSettle();

    expect(find.text('Morning gym session'), findsOneWidget);
    expect(
      find.text('No ongoing or upcoming plans for this day.'),
      findsNothing,
    );
  });

  testWidgets(
    'Plans week view uses a full seven-day page without a horizontal week scroller',
    (WidgetTester tester) async {
      await tester.pumpWidget(const NexusApp());

      await tester.tap(find.text('Plans'));
      await tester.pumpAndSettle();

      expect(find.byType(PageView), findsOneWidget);
      expect(
        tester.getSize(find.byKey(const ValueKey('plans-day-selector'))).height,
        76,
      );
      expect(find.text('Mon'), findsOneWidget);
      expect(find.text('Tue'), findsOneWidget);
      expect(find.text('Wed'), findsOneWidget);
      expect(find.text('Thu'), findsOneWidget);
      expect(find.text('Fri'), findsOneWidget);
      expect(find.text('Sat'), findsOneWidget);
      expect(find.text('Sun'), findsOneWidget);
    },
  );

  testWidgets('Choosing a date updates the displayed plans week', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());

    await tester.tap(find.text('Plans'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.calendar_month_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    final targetDate = DateTime.now().add(const Duration(days: 10));
    final inputDate =
        '${targetDate.month}/${targetDate.day}/${targetDate.year}';
    await tester.enterText(find.byType(TextField).first, inputDate);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    final weekStart = targetDate.subtract(
      Duration(days: targetDate.weekday - 1),
    );
    final weekEnd = weekStart.add(const Duration(days: 6));
    expect(
      find.text(
        'Week of ${weekStart.month}/${weekStart.day} - ${weekEnd.month}/${weekEnd.day}',
      ),
      findsOneWidget,
    );
  });

  testWidgets('User can open People from the bottom navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());

    await tester.tap(find.text('People'));
    await tester.pumpAndSettle();

    expect(find.text('Connections'), findsOneWidget);
    expect(find.text('Updates'), findsOneWidget);
    expect(find.text('Discover'), findsOneWidget);
  });

  testWidgets('People updates show connection activity and event invitations', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());
    await tester.tap(find.text('People'));
    await tester.pumpAndSettle();

    expect(find.text('Updates'), findsOneWidget);
    expect(find.textContaining('redeclared a sunrise hike'), findsOneWidget);
    expect(find.textContaining('RSVP’d to Rooftop Yoga'), findsOneWidget);
    expect(find.textContaining('invited you to Sunday brunch'), findsOneWidget);
  });

  testWidgets('Event invitations can be accepted from People updates', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());
    await tester.tap(find.text('People'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Accept'));
    await tester.pumpAndSettle();

    expect(find.text('Accepted'), findsOneWidget);
    expect(find.text('Accept'), findsNothing);
  });

  testWidgets('Connection card opens that person profile', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());
    await tester.tap(find.text('People'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Connections'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Maya Patel').first);
    await tester.pumpAndSettle();

    expect(find.text('Chat with Maya Patel'), findsNothing);
    expect(find.text('Maya Patel'), findsOneWidget);
    expect(find.text('Mutual connections'), findsOneWidget);
  });

  testWidgets('Connection groups can be filtered and invited to an event', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());
    await tester.tap(find.text('People'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Connections'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Weekend crew'));
    await tester.pumpAndSettle();

    expect(find.text("Brendan O'Sullivan"), findsOneWidget);
    expect(find.text('Sofia Nguyen'), findsOneWidget);
    expect(find.text('Maya Patel'), findsNothing);

    await tester.tap(find.text('Invite group'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sunrise hike'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Prepared an invite to Sunrise hike for 2 people in Weekend crew.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('Connection groups can be created and assigned members', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());
    await tester.tap(find.text('People'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Connections'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Manage groups'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create group'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Book club');
    await tester.tap(find.widgetWithText(CheckboxListTile, 'Maya Patel'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(find.text('Book club'), findsOneWidget);
    await tester.tap(find.text('Book club'));
    await tester.pumpAndSettle();
    expect(find.text('Maya Patel'), findsOneWidget);
    expect(find.text("Brendan O'Sullivan"), findsNothing);
  });

  testWidgets('User can open Chats from the bottom navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());

    await tester.tap(find.text('Chats'));
    await tester.pumpAndSettle();

    expect(find.text('Your conversations'), findsOneWidget);
    expect(find.textContaining('Brendan'), findsOneWidget);
  });

  testWidgets('User can open a chat from a person card', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());

    await tester.tap(find.text('People'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Connections'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Message').first);
    await tester.pumpAndSettle();

    expect(find.text('Chat with Brendan O\'Sullivan'), findsOneWidget);
  });

  testWidgets('User can open and send a message in a chat', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());

    await tester.tap(find.text('Chats'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Brendan'));
    await tester.pumpAndSettle();

    expect(find.text('Chat with Brendan O\'Sullivan'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'See you there!');
    await tester.tap(find.byTooltip('Send message'));
    await tester.pumpAndSettle();

    expect(find.text('See you there!'), findsOneWidget);
    expect(find.text('Type a message'), findsOneWidget);
  });

  testWidgets('People discovery filter is retained when switching tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());

    await tester.tap(find.text('People'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Discover'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Past events').first);
    await tester.pumpAndSettle();
    expect(find.text('Leah Kim'), findsOneWidget);

    await tester.tap(find.text('Chats'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('People'));
    await tester.pumpAndSettle();

    expect(find.text('Leah Kim'), findsOneWidget);
    expect(find.text('Noah Romero'), findsNothing);
  });

  testWidgets(
    'User can open the profile tab and manage interests and skill levels',
    (WidgetTester tester) async {
      await tester.pumpWidget(const NexusApp());

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      expect(find.text("Brendan O'Sullivan"), findsOneWidget);
      expect(find.text('Interests'), findsOneWidget);
      expect(find.text('Add interest'), findsOneWidget);
      expect(find.text('Yoga'), findsAtLeastNWidgets(1));

      await tester.ensureVisible(find.text('Add interest'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add interest'));
      await tester.pumpAndSettle();

      expect(find.text('Search interests'), findsOneWidget);
      expect(find.text('Fitness'), findsAtLeastNWidgets(1));
    },
  );

  testWidgets('User can add more looking-for entries up to three', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Looking For'), findsOneWidget);
    expect(find.text('Add more'), findsOneWidget);

    await tester.tap(find.text('Add more'));
    await tester.pumpAndSettle();

    expect(find.text('Add more'), findsNothing);
  });

  testWidgets('User can delete a looking-for entry and clear the last one', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.close), findsAtLeastNWidgets(1));

    await tester.tap(find.byIcon(Icons.close).first);
    await tester.pumpAndSettle();

    expect(find.text('Coffee and a walk after work'), findsNothing);
    expect(find.text('Mall browse this weekend'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close).first);
    await tester.pumpAndSettle();

    final remainingField = tester.widget<TextField>(
      find.byType(TextField).at(1),
    );
    expect(remainingField.controller?.text, isEmpty);
  });

  testWidgets(
    'User can switch to profile view mode to see public summary details',
    (WidgetTester tester) async {
      await tester.pumpWidget(const NexusApp());

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Connections'), findsOneWidget);
      expect(find.text('Past Events'), findsOneWidget);
      expect(find.text('Upcoming'), findsOneWidget);
      expect(find.text('Looking For'), findsAtLeastNWidgets(1));
      expect(
        find.textContaining('Coffee and a walk after work'),
        findsOneWidget,
      );

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Looking For'), findsOneWidget);
      expect(find.text('Redeclare'), findsAtLeastNWidgets(1));
    },
  );

  testWidgets('Looking-for audience is shown and saved to the profile', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Visible to:'), findsNWidgets(2));

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Public').first);
    await tester.tap(find.text('Public').first);
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(Scaffold).first),
    );
    expect(
      container.read(profileProvider).lookingFor.first.audience.type,
      AudienceType.public,
    );
  });

  testWidgets('Another person profile hides looking-for items not shared', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ProfileScreen(isCurrentUser: false, displayName: 'Maya Patel'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sunday morning yoga partner'), findsOneWidget);
    expect(find.text('Surprise party helpers'), findsNothing);
    expect(find.textContaining('Visible to:'), findsNothing);
  });

  testWidgets('Another person profile shows mutual connections', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: ProfileScreen(isCurrentUser: false)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mutual connections'), findsOneWidget);
    expect(find.text('Your connections'), findsNothing);
    expect(find.byIcon(Icons.edit_outlined), findsNothing);
  });

  testWidgets('Edited profile bio is shown in profile view', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField).first,
      'Always up for a weekend adventure',
    );
    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();

    expect(find.text('Always up for a weekend adventure'), findsOneWidget);
  });

  testWidgets('User can add and edit a looking-for request in the profile', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Looking For'), findsOneWidget);
    expect(find.text('Redeclare'), findsAtLeastNWidgets(1));

    await tester.enterText(
      find.byType(TextField).at(1),
      'Park walk after work this week',
    );
    await tester.pumpAndSettle();

    expect(find.text('Park walk after work this week'), findsOneWidget);
  });

  testWidgets('User can add and edit an interest note from the interest tag', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    final yogaText = find.text('Yoga').first;
    await tester.ensureVisible(yogaText);
    await tester.tap(yogaText, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(yogaText, findsOneWidget);
    expect(find.text('Done'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Add context for this interest'),
      'Sunday morning flow with a beginner-friendly pace',
    );
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Yoga').first);
    await tester.pumpAndSettle();

    expect(
      find.text('Sunday morning flow with a beginner-friendly pace'),
      findsOneWidget,
    );
  });

  testWidgets(
    'User can add a custom interest that is not in the predefined list',
    (WidgetTester tester) async {
      await tester.pumpWidget(const NexusApp());

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Add interest'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add interest'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'Surfing');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add "Surfing"'));
      await tester.pumpAndSettle();

      expect(find.text('Surfing'), findsAtLeastNWidgets(1));
    },
  );

  testWidgets('User can filter discover suggestions by context', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());

    await tester.tap(find.text('People'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Discover'));
    await tester.pumpAndSettle();

    expect(find.text('All'), findsOneWidget);
    expect(find.text('Phone contacts'), findsOneWidget);
    expect(find.text('Past events'), findsAtLeastNWidgets(1));
    expect(find.text('Shared interests'), findsOneWidget);

    await tester.tap(find.text('Past events').first);
    await tester.pumpAndSettle();

    expect(find.text('Leah Kim'), findsOneWidget);

    final sharedInterestsChip = find.text('Shared interests');
    await tester.ensureVisible(sharedInterestsChip);
    await tester.tap(sharedInterestsChip, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text('Yoga, Running'), findsAtLeastNWidgets(1));
    expect(find.byIcon(Icons.favorite_outline), findsAtLeastNWidgets(1));
    expect(find.byIcon(Icons.event_outlined), findsAtLeastNWidgets(1));
    expect(find.text('Shared interests: Yoga, Running'), findsNothing);
  });

  testWidgets(
    'Discover suggestions distinguish connecting from inviting to the app',
    (WidgetTester tester) async {
      await tester.pumpWidget(const NexusApp());

      await tester.tap(find.text('People'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Discover'));
      await tester.pumpAndSettle();

      expect(find.text('Connect'), findsAtLeastNWidgets(1));
      expect(find.text('Invite to app'), findsOneWidget);
    },
  );

  testWidgets('Connect and invite actions update their local status', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NexusApp());

    await tester.tap(find.text('People'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Discover'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Connect').first);
    await tester.pumpAndSettle();
    expect(find.text('Requested'), findsOneWidget);

    await tester.tap(find.text('Invite to app'));
    await tester.pumpAndSettle();
    expect(find.text('Invite sent'), findsOneWidget);
  });

  testWidgets('Custom audience intersects filters, ORs sets, and excludes', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const NexusApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New event'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Custom'));
    await tester.tap(find.text('Custom'));
    await tester.pumpAndSettle();

    String reach() =>
        tester.widget<Text>(find.byKey(const Key('audience-reach'))).data!;

    await tester.ensureVisible(find.widgetWithText(FilterChip, 'Weekend crew'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilterChip, 'Weekend crew'));
    await tester.pumpAndSettle();
    expect(reach(), 'Reaches 2 friends');

    await tester.ensureVisible(find.widgetWithText(FilterChip, 'Photography'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilterChip, 'Photography'));
    await tester.pumpAndSettle();
    expect(reach(), 'Reaches 1 friend');

    await tester.ensureVisible(find.byKey(const Key('add-audience-set')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('add-audience-set')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.widgetWithText(FilterChip, 'Maya Patel'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilterChip, 'Maya Patel'));
    await tester.pumpAndSettle();
    expect(reach(), 'Reaches 2 friends');

    await tester.ensureVisible(find.widgetWithText(ChoiceChip, 'Set 1'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Set 1'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.widgetWithText(FilterChip, 'Sofia Nguyen'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilterChip, 'Sofia Nguyen'));
    await tester.pumpAndSettle();
    expect(reach(), 'Reaches 1 friend');
  });

  testWidgets('Audience sheet requires a selection and shows the audience', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const NexusApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New event'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Secret gig');

    await tester.ensureVisible(find.text('Custom'));
    await tester.tap(find.text('Custom'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Done'))
          .onPressed,
      isNull,
    );

    await tester.tap(find.widgetWithText(FilterChip, 'Weekend crew'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('audience-reach')), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Create event'));
    await tester.tap(find.text('Create event'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Secret gig'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('detail-audience')), findsOneWidget);
    expect(find.textContaining('Weekend crew'), findsWidgets);
  });
}
