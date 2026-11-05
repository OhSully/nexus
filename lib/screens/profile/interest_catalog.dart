/// Predefined interest categories offered by the interest picker.
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
