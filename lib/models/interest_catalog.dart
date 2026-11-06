import '../l10n/app_localizations.dart';

/// Predefined interest categories offered by the interest picker.
///
/// The English strings are stable keys: they are what profiles and audiences
/// store. Show them with [interestLabel] / [interestCategoryLabel]. Custom
/// interests are free text and are displayed as typed.
const interestGroups = <String, List<String>>{
  'Fitness': ['Yoga', 'Running', 'Hiking', 'Cycling', 'Pilates'],
  'Creative': ['Photography', 'Cooking', 'Dancing', 'Drawing', 'Pottery'],
  'Social': ['Board games', 'Travel', 'Brunch', 'Volunteering', 'Live music'],
  'Outdoors': [
    'Camping',
    'Kayaking',
    'Beach days',
    'Bird watching',
    'Gardening',
  ],
  'Learning': ['Language exchange', 'Reading circles', 'Coding', 'Workshops'],
};

bool isPredefinedInterest(String interest) =>
    interestGroups.values.any((group) => group.contains(interest));

String interestCategoryLabel(AppLocalizations l10n, String category) =>
    switch (category) {
      'Fitness' => l10n.interestCategoryFitness,
      'Creative' => l10n.interestCategoryCreative,
      'Social' => l10n.interestCategorySocial,
      'Outdoors' => l10n.interestCategoryOutdoors,
      'Learning' => l10n.interestCategoryLearning,
      _ => category,
    };

String interestLabel(AppLocalizations l10n, String interest) =>
    switch (interest) {
      'Yoga' => l10n.interestYoga,
      'Running' => l10n.interestRunning,
      'Hiking' => l10n.interestHiking,
      'Cycling' => l10n.interestCycling,
      'Pilates' => l10n.interestPilates,
      'Photography' => l10n.interestPhotography,
      'Cooking' => l10n.interestCooking,
      'Dancing' => l10n.interestDancing,
      'Drawing' => l10n.interestDrawing,
      'Pottery' => l10n.interestPottery,
      'Board games' => l10n.interestBoardGames,
      'Travel' => l10n.interestTravel,
      'Brunch' => l10n.interestBrunch,
      'Volunteering' => l10n.interestVolunteering,
      'Live music' => l10n.interestLiveMusic,
      'Camping' => l10n.interestCamping,
      'Kayaking' => l10n.interestKayaking,
      'Beach days' => l10n.interestBeachDays,
      'Bird watching' => l10n.interestBirdWatching,
      'Gardening' => l10n.interestGardening,
      'Language exchange' => l10n.interestLanguageExchange,
      'Reading circles' => l10n.interestReadingCircles,
      'Coding' => l10n.interestCoding,
      'Workshops' => l10n.interestWorkshops,
      _ => interest,
    };
