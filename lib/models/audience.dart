import '../l10n/app_localizations.dart';
import 'interest_catalog.dart';
import 'sample_contacts.dart';

enum AudienceType {
  public('public'),
  friends('friends'),
  groups('group'),
  pastAttendees('past_attendees'),
  interests('shared_interest'),
  custom('custom');

  const AudienceType(this.visibilityKey);

  final String visibilityKey;

  String label(AppLocalizations l10n) => switch (this) {
    public => l10n.audienceTypePublic,
    friends => l10n.audienceTypeFriends,
    groups => l10n.audienceTypeGroups,
    pastAttendees => l10n.audienceTypePastAttendees,
    interests => l10n.audienceTypeInterests,
    custom => l10n.audienceTypeCustom,
  };

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

  String description(AppLocalizations l10n) {
    final parts = [
      if (groups.isNotEmpty) l10n.audienceRuleGroups(groups.join(', ')),
      if (pastEvents.isNotEmpty) l10n.audienceRuleEvents(pastEvents.join(', ')),
      if (interests.isNotEmpty)
        l10n.audienceRuleInterests(
          interests.map((i) => interestLabel(l10n, i)).join(', '),
        ),
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

  String summary(AppLocalizations l10n) {
    switch (type) {
      case AudienceType.public:
        return l10n.audienceSummaryPublic;
      case AudienceType.friends:
        return l10n.audienceSummaryFriends;
      case AudienceType.custom:
        final parts = [
          for (final rule in rules)
            if (!rule.isEmpty) rule.description(l10n),
        ];
        if (parts.isEmpty) return l10n.audienceSummaryNobody;
        final text = parts.join(l10n.audienceRuleOrSeparator);
        return excluded.isEmpty
            ? text
            : l10n.audienceSummaryExcluding(text, excluded.length);
      default:
        return selections.isEmpty
            ? l10n.audienceSummaryNobody
            : [
                ...groups,
                ...pastEvents,
                ...interests.map((i) => interestLabel(l10n, i)),
              ].join(', ');
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
