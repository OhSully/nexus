import 'audience.dart';

enum BeaconDuration {
  today,
  oneDay,
  sevenDays,
  thirtyDays;

  DateTime expiryFrom(DateTime now) {
    if (this == today) {
      final local = now.toLocal();
      return DateTime(local.year, local.month, local.day + 1);
    }
    return now.add(
      Duration(
        days: switch (this) {
          today => 0,
          oneDay => 1,
          sevenDays => 7,
          thirtyDays => 30,
        },
      ),
    );
  }
}

class LookingForEntry {
  const LookingForEntry({
    required this.text,
    required this.declaredAt,
    this.audience = Audience.empty,
    this.duration = BeaconDuration.sevenDays,
  });

  final String text;
  final DateTime declaredAt;
  final Audience audience;
  final BeaconDuration duration;

  DateTime get expiresAt => duration.expiryFrom(declaredAt);
  bool isExpired(DateTime now) => !expiresAt.isAfter(now);

  LookingForEntry copyWith({
    String? text,
    DateTime? declaredAt,
    Audience? audience,
    BeaconDuration? duration,
  }) => LookingForEntry(
    text: text ?? this.text,
    declaredAt: declaredAt ?? this.declaredAt,
    audience: audience ?? this.audience,
    duration: duration ?? this.duration,
  );
}

class UserProfile {
  const UserProfile({
    required this.bio,
    required this.lookingFor,
    required this.selectedInterests,
    required this.customInterests,
    required this.interestNotes,
  });

  const UserProfile.empty()
    : bio = '',
      lookingFor = const [],
      selectedInterests = const {},
      customInterests = const {},
      interestNotes = const {};

  final String bio;
  final List<LookingForEntry> lookingFor;
  final Set<String> selectedInterests;
  final Set<String> customInterests;
  final Map<String, String> interestNotes;

  UserProfile copyWith({
    String? bio,
    List<LookingForEntry>? lookingFor,
    Set<String>? selectedInterests,
    Set<String>? customInterests,
    Map<String, String>? interestNotes,
  }) => UserProfile(
    bio: bio ?? this.bio,
    lookingFor: lookingFor ?? this.lookingFor,
    selectedInterests: selectedInterests ?? this.selectedInterests,
    customInterests: customInterests ?? this.customInterests,
    interestNotes: interestNotes ?? this.interestNotes,
  );
}
