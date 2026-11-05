String activitySubtitle(DateTime startsAt, String location) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final eventDay = DateTime(startsAt.year, startsAt.month, startsAt.day);
  final dayDifference = eventDay.difference(today).inDays;
  final dayLabel = switch (dayDifference) {
    0 => 'Today',
    1 => 'Tomorrow',
    _ => [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ][startsAt.weekday - 1],
  };
  final hour = startsAt.hour % 12 == 0 ? 12 : startsAt.hour % 12;
  final minute = startsAt.minute.toString().padLeft(2, '0');
  final meridiem = startsAt.hour < 12 ? 'AM' : 'PM';

  return '$dayLabel · $hour:$minute $meridiem · $location';
}

String guestsLabel(int count, {required bool going, int? capacity}) {
  if (capacity != null) {
    return '$count of $capacity spots taken';
  }
  final noun = count == 1 ? 'person' : 'people';
  return '$count $noun ${going ? 'going' : 'interested'}';
}
