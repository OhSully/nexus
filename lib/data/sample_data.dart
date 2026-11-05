import 'package:flutter/material.dart';

import '../models/activity_item.dart';
import '../models/sample_contacts.dart';
import '../models/audience.dart';
import '../models/people.dart';
import '../models/user_profile.dart';

List<Connection> buildSampleConnections() => const [
  Connection(
    name: "Brendan O'Sullivan",
    latestUpdate: 'Redeclared a sunrise hike for Saturday',
    updateTime: '10m ago',
    initials: 'B',
  ),
  Connection(
    name: 'Maya Patel',
    latestUpdate: 'Joined a rooftop yoga class',
    updateTime: '1h ago',
    initials: 'M',
  ),
  Connection(
    name: 'Jordan Lee',
    latestUpdate: 'RSVP’d to Sunday brunch',
    updateTime: '3h ago',
    initials: 'J',
  ),
  Connection(
    name: 'Sofia Nguyen',
    latestUpdate: 'Looking for a hiking partner',
    updateTime: 'Yesterday',
    initials: 'S',
  ),
];

List<PeopleUpdate> buildSampleUpdates() => const [
  PeopleUpdate(
    person: "Brendan O'Sullivan",
    description: 'redeclared a sunrise hike for Saturday.',
    time: '10m ago',
    icon: Icons.refresh,
  ),
  PeopleUpdate(
    person: 'Maya Patel',
    description: 'RSVP’d to Rooftop Yoga, an event you can join.',
    time: '1h ago',
    icon: Icons.event_available_outlined,
    action: 'View event',
  ),
  PeopleUpdate(
    person: 'Jordan Lee',
    description: 'invited you to Sunday brunch.',
    time: '3h ago',
    icon: Icons.mail_outline,
    action: 'Respond',
  ),
  PeopleUpdate(
    person: 'Sofia Nguyen',
    description: 'posted that she’s looking for a hiking partner.',
    time: 'Yesterday',
    icon: Icons.campaign_outlined,
  ),
];

List<DiscoverPerson> buildSampleDiscoverPeople() => const [
  DiscoverPerson(
    name: 'Leah Kim',
    matchCategories: ['Past events', 'Phone contacts', 'Shared interests'],
    tags: [
      DiscoveryTag(
        label: 'City Run',
        icon: Icons.event_outlined,
        meaning: 'Met at event',
      ),
      DiscoveryTag(
        label: 'Contacts',
        icon: Icons.contacts_outlined,
        meaning: 'Phone contact',
      ),
      DiscoveryTag(
        label: 'Yoga, Running',
        icon: Icons.favorite_outline,
        meaning: 'Shared interests',
      ),
    ],
  ),
  DiscoverPerson(
    name: 'Noah Romero',
    matchCategories: ['Friends of friends', 'Shared interests'],
    tags: [
      DiscoveryTag(
        label: 'Maya, Ben + 3',
        icon: Icons.people_outline,
        meaning: 'Friends of friends',
      ),
      DiscoveryTag(
        label: 'Hiking, Trail running',
        icon: Icons.favorite_outline,
        meaning: 'Shared interests',
      ),
    ],
    isInvite: true,
  ),
  DiscoverPerson(
    name: 'Priya Shah',
    matchCategories: ['Past events', 'Shared interests'],
    tags: [
      DiscoveryTag(
        label: 'Rooftop Yoga',
        icon: Icons.event_outlined,
        meaning: 'Met at event',
      ),
      DiscoveryTag(
        label: 'Yoga, Running',
        icon: Icons.favorite_outline,
        meaning: 'Shared interests',
      ),
    ],
  ),
  DiscoverPerson(
    name: 'Sam Lee',
    matchCategories: ['Phone contacts', 'Past events'],
    tags: [
      DiscoveryTag(
        label: 'Contacts',
        icon: Icons.contacts_outlined,
        meaning: 'Phone contact',
      ),
      DiscoveryTag(
        label: 'City Run',
        icon: Icons.event_outlined,
        meaning: 'Met at event',
      ),
    ],
  ),
];

Map<String, UserProfile> buildSampleOtherProfiles() {
  final now = DateTime.now();
  return {
    'Maya Patel': UserProfile(
      bio: 'Yoga teacher and brunch enthusiast',
      lookingFor: [
        LookingForEntry(
          text: 'Sunday morning yoga partner',
          declaredAt: now.subtract(const Duration(days: 1)),
          audience: Audience.public,
        ),
        LookingForEntry(
          text: 'Brunch crew this weekend',
          declaredAt: now.subtract(const Duration(days: 2)),
          audience: Audience.friends,
        ),
        // Only Sofia can see this one, so it stays hidden from other viewers.
        LookingForEntry(
          text: 'Surprise party helpers',
          declaredAt: now.subtract(const Duration(days: 2)),
          audience: const Audience(
            AudienceType.custom,
            rules: [
              AudienceRule(people: ['Sofia Nguyen']),
            ],
          ),
        ),
      ],
      selectedInterests: {'Yoga', 'Brunch'},
      customInterests: {},
      interestNotes: {'Yoga': 'Teaching Sunday flows in the park.'},
    ),
    'Sofia Nguyen': UserProfile(
      bio: 'Photographer who loves a good trail',
      lookingFor: [
        LookingForEntry(
          text: 'Hiking partner for sunrise trails',
          declaredAt: now.subtract(const Duration(days: 1)),
          audience: Audience.friends,
        ),
      ],
      selectedInterests: {'Hiking', 'Photography'},
      customInterests: {},
      interestNotes: {},
    ),
  };
}

UserProfile buildSampleProfile() {
  final now = DateTime.now();
  return UserProfile(
    bio: 'Outdoorsy, social, and always planning the next meetup',
    lookingFor: [
      LookingForEntry(
        text: 'Coffee and a walk after work',
        declaredAt: now.subtract(const Duration(days: 1)),
        audience: Audience.friends,
      ),
      LookingForEntry(
        text: 'Mall browse this weekend',
        declaredAt: now.subtract(const Duration(days: 3)),
        audience: Audience.friends,
      ),
    ],
    selectedInterests: {'Yoga', 'Running', 'Hiking'},
    customInterests: {},
    interestNotes: {
      'Yoga': 'I like Sunday morning flows and beginner-friendly sessions.',
      'Running': 'Open to casual weekday runs with a similar pace.',
      'Hiking': 'Best for scenic routes and easy group outings.',
    },
  );
}

List<ActivityItem> buildSampleActivities() {
  final now = DateTime.now();
  final gymStartsAt = now.subtract(const Duration(hours: 1));
  final dogWalkStartsAt = now.add(const Duration(hours: 3));
  final movieStartsAt = now.add(const Duration(days: 1, hours: 5));
  final coffeeStartsAt = now.add(const Duration(days: 2, hours: 2));

  return [
    ActivityItem(
      id: 'morning-gym',
      title: 'Morning gym session',
      subtitle: 'Riverside Gym',
      guests: '5 people going',
      location: 'Riverside Gym',
      attendeeCount: 5,
      icon: Icons.fitness_center,
      color: const Color(0xFF4F46E5),
      isGoing: false,
      startsAt: gymStartsAt,
      endsAt: now.add(const Duration(hours: 1)),
      eventType: 'Workout',
      visibility: 'friends',
    ),
    ActivityItem(
      id: 'dog-walk',
      title: 'Dog walk in the park',
      subtitle: 'Central Park',
      guests: '3 people interested',
      guestsGoing: false,
      location: 'Central Park',
      attendeeCount: 3,
      icon: Icons.pets,
      color: const Color(0xFF10B981),
      isGoing: false,
      startsAt: dogWalkStartsAt,
      endsAt: now.add(const Duration(hours: 5)),
      eventType: 'Outdoors',
      visibility: 'public',
    ),
    ActivityItem(
      id: 'movie-night',
      title: 'Movie night',
      subtitle: 'Regal Cinema',
      guests: '8 people attending',
      attendeeCount: 8,
      icon: Icons.movie,
      color: const Color(0xFFF59E0B),
      isGoing: false,
      startsAt: movieStartsAt,
      endsAt: now.add(const Duration(days: 1, hours: 8)),
      eventType: 'Social',
      visibility: 'public',
      kind: ActivityKind.event,
      location: 'Regal Cinema',
      hosts: const ['Jordan Lee'],
    ),
    ActivityItem(
      id: 'coffee-catch-up',
      title: 'Coffee and catch-up',
      subtitle: 'The Corner Café',
      guests: '2 people confirmed',
      location: 'The Corner Café',
      attendeeCount: 2,
      icon: Icons.coffee,
      color: const Color(0xFFEC4899),
      isGoing: false,
      startsAt: coffeeStartsAt,
      endsAt: now.add(const Duration(days: 2, hours: 3)),
      eventType: 'Social',
      visibility: 'friends',
    ),
  ];
}

Map<String, List<String>> buildSampleGroups() => {
  'Weekend crew': ["Brendan O'Sullivan", 'Sofia Nguyen'],
  'Yoga friends': ['Maya Patel'],
};

List<ChatSummary> buildSampleChats() => const [
  ChatSummary(
    participants: ["Brendan O'Sullivan"],
    lastMessage: 'Are you still up for the hike?',
    time: '2m ago',
    unread: true,
  ),
  ChatSummary(
    participants: ['Maya Patel'],
    lastMessage: 'I can host brunch this weekend.',
    time: '18m ago',
  ),
  ChatSummary(
    participants: ['Jordan Lee'],
    lastMessage: 'Let’s grab coffee before the movie.',
    time: '1h ago',
    unread: true,
  ),
  ChatSummary(
    participants: ['Sofia Nguyen'],
    lastMessage: 'Sent you the event details.',
    time: '3h ago',
  ),
];
