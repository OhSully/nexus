import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/activity_item.dart';

/// Identity value for the current user in host lists.
const currentUserHost = 'You';

/// Display name for a host: the current user's sentinel is localized.
String hostLabel(AppLocalizations l10n, String host) =>
    host == currentUserHost ? l10n.commonYou : host;

String activitySubtitle(
  AppLocalizations l10n,
  DateTime startsAt,
  String location,
  DateTime now,
) {
  final today = DateTime(now.year, now.month, now.day);
  final eventDay = DateTime(startsAt.year, startsAt.month, startsAt.day);
  final dayDifference = eventDay.difference(today).inDays;
  final dayLabel = switch (dayDifference) {
    0 => l10n.dayToday,
    1 => l10n.dayTomorrow,
    _ => DateFormat.E(l10n.localeName).format(startsAt),
  };
  final time = DateFormat.jm(l10n.localeName).format(startsAt);

  return l10n.activitySubtitle(dayLabel, time, location);
}

String guestsLabel(
  AppLocalizations l10n,
  int count, {
  required bool going,
  int? capacity,
}) {
  if (capacity != null) {
    return l10n.guestsSpotsTaken(count, capacity);
  }
  return going ? l10n.guestsGoing(count) : l10n.guestsInterested(count);
}

/// Subtitle shown for [item], localized when its start time is known.
String itemSubtitle(AppLocalizations l10n, ActivityItem item, DateTime now) {
  final startsAt = item.startsAt;
  if (startsAt == null) return item.subtitle;
  return activitySubtitle(
    l10n,
    startsAt,
    item.location.isEmpty ? l10n.commonLocationTbd : item.location,
    now,
  );
}

String itemGuests(AppLocalizations l10n, ActivityItem item) => guestsLabel(
  l10n,
  item.attendeeCount,
  going: item.guestsGoing,
  capacity: item.capacity,
);
