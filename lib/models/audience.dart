import 'sample_contacts.dart';

enum AudienceType {
  public('Public', 'public'),
  friends('Friends', 'friends'),
  groups('Groups', 'group'),
  pastAttendees('Past attendees', 'past_attendees'),
  interests('Friends with interests', 'shared_interest'),
  custom('Custom', 'custom');

  const AudienceType(this.label, this.visibilityKey);

  final String label;
  final String visibilityKey;

  bool get needsSelection => index >= AudienceType.groups.index;
}

const sampleFriendInterests = <String, List<String>>{
  "Brendan O'Sullivan": ['Hiking', 'Running'],
  'Maya Patel': ['Yoga', 'Brunch'],
  'Jordan Lee': ['Live music', 'Board games'],
  'Sofia Nguyen': ['Hiking', 'Photography'],
};

const samplePastEventAttendees = <String, List<String>>{
  'City Run': ["Brendan O'Sullivan", 'Sofia Nguyen'],
  'Rooftop Yoga': ['Maya Patel', 'Jordan Lee'],
  'Sunday brunch': ['Maya Patel', 'Jordan Lee', 'Sofia Nguyen'],
};

class AudienceDirectory {
  const AudienceDirectory({
    required this.groups,
    this.pastEventAttendees = samplePastEventAttendees,
    this.friendInterests = sampleFriendInterests,
  });

  final Map<String, List<String>> groups;
  final Map<String, List<String>> pastEventAttendees;
  final Map<String, List<String>> friendInterests;

  List<String> get friends => sampleContacts;

  List<String> get interests =>
      (friendInterests.values.expand((items) => items).toSet().toList()
        ..sort());
}

/// One set of criteria in a custom audience. Categories are intersected;
/// choices within a category are unioned. [people] are always included.
class AudienceRule {
  const AudienceRule({
    this.groups = const [],
    this.pastEvents = const [],
    this.interests = const [],
    this.people = const [],
  });

  final List<String> groups;
  final List<String> pastEvents;
  final List<String> interests;
  final List<String> people;

  bool get hasCriteria =>
      groups.isNotEmpty || pastEvents.isNotEmpty || interests.isNotEmpty;

  bool get isEmpty => !hasCriteria && people.isEmpty;

  /// Friends matching the criteria (before exclusions and explicit people).
  Set<String> matches(AudienceDirectory directory) {
    if (!hasCriteria) return {};
    Set<String>? result;
    void narrow(Set<String> found) {
      result = result == null ? found : result!.intersection(found);
    }

    if (groups.isNotEmpty) {
      narrow({for (final g in groups) ...?directory.groups[g]});
    }
    if (pastEvents.isNotEmpty) {
      narrow({for (final e in pastEvents) ...?directory.pastEventAttendees[e]});
    }
    if (interests.isNotEmpty) {
      narrow({
        for (final entry in directory.friendInterests.entries)
          if (entry.value.any(interests.contains)) entry.key,
      });
    }
    return result ?? {};
  }

  Set<String> resolve(AudienceDirectory directory) => {
    ...matches(directory),
    ...people,
  };

  String get description {
    final parts = [
      if (groups.isNotEmpty) 'Groups: ${groups.join(', ')}',
      if (pastEvents.isNotEmpty) 'Events: ${pastEvents.join(', ')}',
      if (interests.isNotEmpty) 'Interests: ${interests.join(', ')}',
      if (people.isNotEmpty) people.join(', '),
    ];
    return parts.join(' + ');
  }
}

class Audience {
  const Audience(
    this.type, {
    this.groups = const [],
    this.pastEvents = const [],
    this.interests = const [],
    this.rules = const [],
    this.excluded = const [],
  });

  static const public = Audience(AudienceType.public);
  static const friends = Audience(AudienceType.friends);

  final AudienceType type;
  final List<String> groups;
  final List<String> pastEvents;
  final List<String> interests;

  /// Custom audiences only: the union of these sets, minus [excluded].
  final List<AudienceRule> rules;
  final List<String> excluded;

  String get visibilityKey => type.visibilityKey;

  List<String> get selections => [...groups, ...pastEvents, ...interests];

  bool get isEmpty => switch (type) {
    AudienceType.custom => rules.every((rule) => rule.isEmpty),
    _ => type.needsSelection && selections.isEmpty,
  };

  String get summary {
    switch (type) {
      case AudienceType.public:
        return 'Anyone on Nexus can see this';
      case AudienceType.friends:
        return 'All of your friends';
      case AudienceType.custom:
        final parts = [
          for (final rule in rules)
            if (!rule.isEmpty) rule.description,
        ];
        if (parts.isEmpty) return 'Nobody selected yet';
        final text = parts.join(' OR ');
        return excluded.isEmpty ? text : '$text (excluding ${excluded.length})';
      default:
        return selections.isEmpty
            ? 'Nobody selected yet'
            : selections.join(', ');
    }
  }

  /// Whether [viewer] may see content shared with this audience.
  bool isVisibleTo(String viewer, AudienceDirectory directory) {
    final reach = resolve(directory);
    return reach == null || reach.contains(viewer);
  }

  /// Friends who can see this, or null when it is open to everyone.
  Set<String>? resolve(AudienceDirectory directory) {
    switch (type) {
      case AudienceType.public:
        return null;
      case AudienceType.friends:
        return directory.friends.toSet();
      case AudienceType.custom:
        return {for (final rule in rules) ...rule.resolve(directory)}
          ..removeAll(excluded);
      default:
        final reached = <String>{
          for (final name in groups) ...?directory.groups[name],
          for (final name in pastEvents) ...?directory.pastEventAttendees[name],
        };
        if (interests.isNotEmpty) {
          directory.friendInterests.forEach((friend, theirs) {
            if (theirs.any(interests.contains)) {
              reached.add(friend);
            }
          });
        }
        return reached;
    }
  }
}
