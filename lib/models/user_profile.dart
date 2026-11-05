import 'audience.dart';

class LookingForEntry {
  const LookingForEntry({
    required this.text,
    required this.declaredAt,
    this.audience = Audience.friends,
  });

  final String text;
  final DateTime declaredAt;
  final Audience audience;
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
