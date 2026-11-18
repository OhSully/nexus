import '../l10n/app_localizations.dart';
import 'sample_contacts.dart';

enum AudienceType {
  connections('connections'),
  events('events'),
  // Retained only for existing prototype sample content.
  public('public'),
  friends('friends');

  const AudienceType(this.visibilityKey);
  final String visibilityKey;

  String label(AppLocalizations l10n) => switch (this) {
    connections => l10n.audienceTypeConnections,
    events => l10n.audienceTypeEvents,
    public => l10n.audienceTypePublic,
    friends => l10n.audienceTypeFriends,
  };

  bool get needsSelection =>
      this == AudienceType.connections || this == AudienceType.events;
}

const sampleFriendInterests = <String, List<String>>{
  "Brendan O'Sullivan": ['Hiking', 'Running'],
  'Maya Patel': ['Yoga', 'Brunch'],
  'Jordan Lee': ['Live music', 'Board games'],
  'Sofia Nguyen': ['Hiking', 'Photography'],
};

// Prototype events are listed most recent first.
const samplePastEventAttendees = <String, List<String>>{
  'City Run': [
    "Brendan O'Sullivan",
    'Sofia Nguyen',
    'Alex Morgan',
    'Taylor Chen',
  ],
  'Rooftop Yoga': ['Maya Patel', 'Jordan Lee'],
  'Sunday brunch': ['Maya Patel', 'Jordan Lee', 'Sofia Nguyen'],
};

class AudiencePersonDetails {
  const AudiencePersonDetails({this.hasAccount = true, this.avatarUrl});

  final bool hasAccount;
  final String? avatarUrl;
}

const sampleAudiencePersonDetails = <String, AudiencePersonDetails>{
  'Alex Morgan': AudiencePersonDetails(hasAccount: false),
  'Taylor Chen': AudiencePersonDetails(),
};

class AudienceDirectory {
  const AudienceDirectory({
    required this.groups,
    this.pastEventAttendees = samplePastEventAttendees,
    this.friendInterests = sampleFriendInterests,
    this.personDetails = const {},
  });

  final Map<String, List<String>> groups;
  final Map<String, List<String>> pastEventAttendees;
  final Map<String, List<String>> friendInterests;
  final Map<String, AudiencePersonDetails> personDetails;

  List<String> get friends => sampleContacts;

  List<String> get interests =>
      (friendInterests.values.expand((items) => items).toSet().toList()
        ..sort());
}

class Audience {
  const Audience(this.type, {this.people = const []});

  static const empty = Audience(AudienceType.connections);
  static const public = Audience(AudienceType.public);
  static const friends = Audience(AudienceType.friends);

  final AudienceType type;
  final List<String> people;

  String get visibilityKey => type.visibilityKey;
  bool get isEmpty => type.needsSelection && people.isEmpty;

  String summary(AppLocalizations l10n) => switch (type) {
    AudienceType.public => l10n.audienceSummaryPublic,
    AudienceType.friends => l10n.audienceSummaryFriends,
    _ => people.isEmpty ? l10n.audienceSummaryNobody : people.join(', '),
  };

  bool isVisibleTo(String viewer, AudienceDirectory directory) {
    final reach = resolve(directory);
    return reach == null || reach.contains(viewer);
  }

  Set<String>? resolve(AudienceDirectory directory) => switch (type) {
    AudienceType.public => null,
    AudienceType.friends => directory.friends.toSet(),
    _ => people.toSet(),
  };
}
