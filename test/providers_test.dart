import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nexus/models/activity_item.dart';
import 'package:nexus/models/audience.dart';
import 'package:nexus/providers/providers.dart';

void main() {
  test('audience visibility checks the viewer against the audience', () {
    const directory = AudienceDirectory(
      groups: {
        'Crew': ['Maya Patel'],
      },
    );
    expect(Audience.public.isVisibleTo('Anyone', directory), isTrue);
    expect(Audience.friends.isVisibleTo('Maya Patel', directory), isTrue);
    expect(Audience.friends.isVisibleTo('Stranger', directory), isFalse);
    const crew = Audience(AudienceType.groups, groups: ['Crew']);
    expect(crew.isVisibleTo('Maya Patel', directory), isTrue);
    expect(crew.isVisibleTo('Jordan Lee', directory), isFalse);
  });

  test('another profile only lists looking-for items the viewer can see', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final maya = container.read(otherProfileProvider('Maya Patel'));
    final texts = maya.lookingFor.map((e) => e.text);
    expect(texts, contains('Sunday morning yoga partner'));
    expect(texts, contains('Brunch crew this weekend'));
    expect(texts, isNot(contains('Surprise party helpers')));
  });

  test('profile notifier edits entries and keeps at most three', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(profileProvider.notifier);

    notifier.addLookingFor();
    notifier.addLookingFor();
    expect(container.read(profileProvider).lookingFor.length, 3);

    notifier.setLookingForAudience(0, Audience.public);
    expect(
      container.read(profileProvider).lookingFor.first.audience.type,
      AudienceType.public,
    );

    notifier.toggleInterest('Surfing', isPredefined: false);
    expect(container.read(profileProvider).customInterests, {'Surfing'});
    notifier.toggleInterest('Surfing', isPredefined: false);
    expect(
      container.read(profileProvider).selectedInterests,
      isNot(contains('Surfing')),
    );
  });

  test('groups can be saved, renamed and removed; directory follows', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(groupsProvider.notifier).save('Climbers', ['Maya Patel']);
    expect(container.read(audienceDirectoryProvider).groups['Climbers'], [
      'Maya Patel',
    ]);

    container.read(groupsProvider.notifier).save('Boulderers', [
      'Maya Patel',
    ], previousName: 'Climbers');
    final groups = container.read(groupsProvider);
    expect(groups.containsKey('Climbers'), isFalse);
    expect(groups.containsKey('Boulderers'), isTrue);

    container.read(groupsProvider.notifier).remove('Boulderers');
    expect(container.read(groupsProvider).containsKey('Boulderers'), isFalse);
  });

  test('a sent message moves its chat to the top without duplicating', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(chatsProvider.notifier);
    final before = container.read(chatsProvider).length;

    notifier.recordSentMessage(['Maya Patel'], 'Hi');
    var chats = container.read(chatsProvider);
    expect(chats.length, before);
    expect(chats.first.participants, ['Maya Patel']);
    expect(chats.first.lastMessage, 'Hi');

    notifier.recordSentMessage(['Nobody New'], 'Hello');
    chats = container.read(chatsProvider);
    expect(chats.length, before + 1);
  });

  test('enrolling and unlinking a linked event adjusts RSVPs', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(activitiesProvider.notifier);

    final activity = ActivityItem(
      id: 'hike',
      title: 'Hike',
      subtitle: '',
      guests: '',
      attendeeCount: 3,
      icon: Icons.hiking,
      color: Colors.green,
      isGoing: false,
      linkedEventId: 'movie-night',
    );
    notifier.add(activity);
    final eventBefore = container
        .read(eventsProvider)
        .firstWhere((e) => e.id == 'movie-night');

    final enrolled = notifier.enrollLinkedEvent(activity);
    expect(enrolled.enrolled, 3);
    expect(enrolled.activity.linkedEventEnrolled, isTrue);
    final eventAfter = container
        .read(eventsProvider)
        .firstWhere((e) => e.id == 'movie-night');
    expect(eventAfter.attendeeCount, eventBefore.attendeeCount + 3);

    final unlinked = notifier.changeLinkedEvent(enrolled.activity, null);
    expect(unlinked.cancelledCount, 3);
    expect(unlinked.activity.linkedEventId, isNull);
    final eventFinal = container
        .read(eventsProvider)
        .firstWhere((e) => e.id == 'movie-night');
    expect(eventFinal.attendeeCount, eventBefore.attendeeCount);
  });
}
