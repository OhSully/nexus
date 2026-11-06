// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Nexus';

  @override
  String get navHome => 'Home';

  @override
  String get navPlans => 'Plans';

  @override
  String get navPeople => 'People';

  @override
  String get navChats => 'Chats';

  @override
  String get navProfile => 'Profile';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'System default';

  @override
  String get settingsLanguageSystemSubtitle => 'Follow your device language';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsNotificationsNote =>
      'Notifications aren\'t active yet. Your choices will apply once they are.';

  @override
  String get settingsNotifMessages => 'Messages';

  @override
  String get settingsNotifRequests => 'Connection requests';

  @override
  String get settingsNotifInvitations => 'Invitations';

  @override
  String get settingsNotifEventChanges => 'Event changes';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsCrashReportingNote =>
      'Crash reports: When configured, Nexus sends anonymized technical error details to Sentry to fix bugs and improve the app for you. Personal identifiers, request data, and free-text error details are removed. Sentry may process data outside Canada; hosting in Canada is a future goal.';

  @override
  String get settingsDefaultAudience =>
      'Default audience for new activities and events';

  @override
  String get settingsDefaultAudienceHelp =>
      'You can still change the audience each time you create one.';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsExportData => 'Export my data';

  @override
  String get settingsDeleteAccount => 'Delete account';

  @override
  String get settingsUnavailableYet =>
      'Not available yet. This will arrive with accounts.';

  @override
  String get settingsAbout => 'About Nexus';

  @override
  String get commonYou => 'You';

  @override
  String get commonAll => 'All';

  @override
  String get commonDone => 'Done';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonLocation => 'Location';

  @override
  String get commonLocationTbd => 'Location TBD';

  @override
  String get dayToday => 'Today';

  @override
  String get dayTomorrow => 'Tomorrow';

  @override
  String activitySubtitle(String day, String time, String location) {
    return '$day · $time · $location';
  }

  @override
  String guestsSpotsTaken(int count, int capacity) {
    return '$count of $capacity spots taken';
  }

  @override
  String guestsGoing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people going',
      one: '1 person going',
    );
    return '$_temp0';
  }

  @override
  String guestsInterested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people interested',
      one: '1 person interested',
    );
    return '$_temp0';
  }

  @override
  String get activityCardAttending => 'You are attending';

  @override
  String get activityDetailTitleEvent => 'Event details';

  @override
  String get activityDetailTitleActivity => 'Activity details';

  @override
  String get activityDetailChooseEvent => 'Choose an event';

  @override
  String get activityDetailCancelLinkedTitle => 'Cancel linked RSVPs?';

  @override
  String activityDetailCancelLinkedBody(int count, String eventTitle) {
    return 'This will cancel your $count RSVPs for $eventTitle.';
  }

  @override
  String get activityDetailLinkedEventFallback => 'the linked event';

  @override
  String get activityDetailKeepLink => 'Keep link';

  @override
  String get activityDetailCancelRsvps => 'Cancel RSVPs';

  @override
  String get activityDetailNoRsvp => 'No RSVP needed';

  @override
  String get activityDetailEventFull => 'Event full';

  @override
  String get activityDetailYouAreGoing => 'You are going';

  @override
  String get activityDetailGoing => 'Going';

  @override
  String activityDetailLinkedEvent(String title) {
    return 'Linked event: $title';
  }

  @override
  String get activityDetailEnrolledNote =>
      'Everyone interested has been enrolled in this event.';

  @override
  String get activityDetailEnrollPrompt =>
      'Enroll the people going in the linked event.';

  @override
  String get activityDetailEnrollAll => 'Enroll everyone in event';

  @override
  String get activityDetailChangeEvent => 'Change event';

  @override
  String get activityDetailUnlink => 'Unlink';

  @override
  String activityDetailHostedBy(String hosts) {
    return 'Hosted by $hosts';
  }

  @override
  String activityDetailVisibleTo(String summary) {
    return 'Visible to: $summary';
  }

  @override
  String get activityDetailHappeningRegardless => 'Happening regardless';

  @override
  String get activityDetailLinkToEvent => 'Link to an event';

  @override
  String get homeNewMessageTitle => 'New message';

  @override
  String get homeStartChat => 'Start chat';

  @override
  String homeEnrolledPartial(int enrolled, String title, int skipped) {
    return 'Enrolled $enrolled in $title; $skipped skipped';
  }

  @override
  String homeEnrolledAll(String title) {
    return 'Enrolled everyone in $title';
  }

  @override
  String homeCancelledRsvps(int count, String title) {
    return 'Cancelled $count RSVPs for $title';
  }

  @override
  String get homeCreateTooltip => 'Create';

  @override
  String get chatsTitle => 'Chats';

  @override
  String get chatsSubtitle => 'Your conversations';

  @override
  String get chatsTimeNow => 'Now';

  @override
  String chatDetailTitle(String name) {
    return 'Chat with $name';
  }

  @override
  String get chatDetailHint => 'Type a message';

  @override
  String get chatDetailSend => 'Send message';

  @override
  String get createActivityTitleError => 'Enter an activity title';

  @override
  String get createEndTimeError => 'End time must be after the start time';

  @override
  String get createActivityTitle => 'New activity';

  @override
  String get createActivityIntro =>
      'Share something casual you would like to do.';

  @override
  String get createActivityTitleLabel => 'What do you want to do?';

  @override
  String get createActivityTitleHint => 'Coffee and a walk';

  @override
  String get createActivityLocationHint => 'Where?';

  @override
  String get createActivityNotesLabel => 'Notes';

  @override
  String get createActivityRegardlessOn =>
      'The activity will happen whether or not anyone joins.';

  @override
  String get createActivityRegardlessOff =>
      'The activity may be cancelled if nobody joins.';

  @override
  String get createActivityLinkLabel => 'Link to an event';

  @override
  String get createActivityLinkHelper =>
      'People going will be enrolled in the event.';

  @override
  String get createActivityNoLinkedEvent => 'No linked event';

  @override
  String get createActivityButton => 'Create activity';

  @override
  String get createEventAddCoHosts => 'Add co-hosts';

  @override
  String get createEventTitleError => 'Enter an event title';

  @override
  String get createEventCapacityError => 'Enter a limit of at least 1';

  @override
  String get createEventTitle => 'New event';

  @override
  String get createEventTitleLabel => 'Event title';

  @override
  String get createEventTitleHint => 'Sunday brunch';

  @override
  String get createEventDescriptionLabel => 'Description';

  @override
  String get createEventLocationHint => 'Where is it?';

  @override
  String get createEventHosts => 'Hosts';

  @override
  String get createEventAllowRsvps => 'Allow RSVPs';

  @override
  String get createEventRsvpOn => 'People can RSVP';

  @override
  String get createEventRsvpOff => 'RSVPs are turned off';

  @override
  String get createEventLimitAttendance => 'Limit attendance';

  @override
  String get createEventMaxAttendees => 'Maximum attendees';

  @override
  String get createEventButton => 'Create event';

  @override
  String get createMenuNewMessage => 'New message';

  @override
  String get createMenuNewMessageSubtitle => 'Start a conversation';

  @override
  String get createMenuNewActivity => 'New activity';

  @override
  String get createMenuNewActivitySubtitle => 'Something casual to do';

  @override
  String get createMenuNewEvent => 'New event';

  @override
  String get createMenuNewEventSubtitle => 'Plan something with details';

  @override
  String get discoverTitle => 'Upcoming activities';

  @override
  String get plansChooseWeek => 'Choose week';

  @override
  String get plansEmptyDay => 'No ongoing or upcoming plans for this day.';

  @override
  String get plansFilterAll => 'All';

  @override
  String get plansFilterFriendsOnly => 'Friends only';

  @override
  String get plansFilterPublicEvents => 'Public events';

  @override
  String get plansFilterSpecificGroup => 'Specific group';

  @override
  String get plansFilterSharedInterest => 'Shared interest';

  @override
  String plansWeekOf(DateTime weekStart, DateTime weekEnd) {
    final intl.DateFormat weekStartDateFormat = intl.DateFormat.Md(localeName);
    final String weekStartString = weekStartDateFormat.format(weekStart);
    final intl.DateFormat weekEndDateFormat = intl.DateFormat.Md(localeName);
    final String weekEndString = weekEndDateFormat.format(weekEnd);

    return 'Week of $weekStartString - $weekEndString';
  }

  @override
  String whenPickerStarts(String time) {
    return 'Starts $time';
  }

  @override
  String whenPickerEnds(String time) {
    return 'Ends $time';
  }

  @override
  String get peopleManageGroups => 'Manage groups';

  @override
  String get peopleManageGroupsEmpty =>
      'Create a group to organize your connections.';

  @override
  String peopleConnectionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count connections',
      one: '1 connection',
    );
    return '$_temp0';
  }

  @override
  String peopleEditGroup(String name) {
    return 'Edit $name';
  }

  @override
  String peopleDeleteGroup(String name) {
    return 'Delete $name';
  }

  @override
  String get peopleCreateGroup => 'Create group';

  @override
  String peopleInviteTitle(String group) {
    return 'Invite $group';
  }

  @override
  String get peopleInviteBody => 'Choose an event to invite this group to.';

  @override
  String peopleInvitePrepared(String event, int count, String group) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '1 person',
    );
    return 'Prepared an invite to $event for $_temp0 in $group.';
  }

  @override
  String get peopleSectionUpdates => 'Updates';

  @override
  String get peopleSectionConnections => 'Connections';

  @override
  String get peopleSectionDiscover => 'Discover';

  @override
  String get peopleInviteGroup => 'Invite group';

  @override
  String get peopleNoConnectionsInGroup => 'No connections in this group yet.';

  @override
  String get peopleMessage => 'Message';

  @override
  String get discoverFilterPhoneContacts => 'Phone contacts';

  @override
  String get discoverFilterPastEvents => 'Past events';

  @override
  String get discoverFilterFriendsOfFriends => 'Friends of friends';

  @override
  String get discoverFilterSharedInterests => 'Shared interests';

  @override
  String get discoverInviteSent => 'Invite sent';

  @override
  String get discoverInviteToApp => 'Invite to app';

  @override
  String get discoverRequested => 'Requested';

  @override
  String get discoverConnect => 'Connect';

  @override
  String get groupEditorNameError => 'Enter a group name';

  @override
  String get groupEditorEditTitle => 'Edit group';

  @override
  String get groupEditorNameLabel => 'Group name';

  @override
  String get updatesSampleNotice => 'This is sample data for now.';

  @override
  String get updatesViewEvent => 'View event';

  @override
  String get updatesAccepted => 'Accepted';

  @override
  String get updatesDeclined => 'Declined';

  @override
  String get updatesAccept => 'Accept';

  @override
  String get updatesDecline => 'Decline';

  @override
  String get profileConnections => 'Connections';

  @override
  String get profileMutualConnections => 'Mutual connections';

  @override
  String get profilePastEvents => 'Past Events';

  @override
  String get profileUpcoming => 'Upcoming';

  @override
  String get profileLookingFor => 'Looking For';

  @override
  String get profileInterests => 'Interests';

  @override
  String profileDeclared(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.Md(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Declared $dateString';
  }

  @override
  String get profileBioHint => 'Add a short bio';

  @override
  String get interestsAdd => 'Add interest';

  @override
  String get interestsEmpty =>
      'Choose a few interests to help people discover shared strengths.';

  @override
  String get interestsNoteHint => 'Add context for this interest';

  @override
  String get interestsSearchHint => 'Search interests';

  @override
  String get interestsCategoryCustom => 'Custom';

  @override
  String interestsAddQuery(String query) {
    return 'Add \"$query\"';
  }

  @override
  String get lookingForAddMore => 'Add more';

  @override
  String get lookingForRedeclare => 'Redeclare';

  @override
  String get lookingForHint1 => 'Grab a drink after work';

  @override
  String get lookingForHint2 => 'Go for a walk this weekend';

  @override
  String get lookingForHint3 => 'Something spontaneous this week';

  @override
  String lookingForLastDeclared(DateTime lastDeclared) {
    final intl.DateFormat lastDeclaredDateFormat = intl.DateFormat.Md(
      localeName,
    );
    final String lastDeclaredString = lastDeclaredDateFormat.format(
      lastDeclared,
    );

    return 'Last declared $lastDeclaredString';
  }

  @override
  String get audienceTypePublic => 'Public';

  @override
  String get audienceTypeFriends => 'Friends';

  @override
  String get audienceTypeGroups => 'Groups';

  @override
  String get audienceTypePastAttendees => 'Past attendees';

  @override
  String get audienceTypeInterests => 'Shared interests';

  @override
  String get audienceTypeCustom => 'Custom';

  @override
  String audienceRuleGroups(String groups) {
    return 'Groups: $groups';
  }

  @override
  String audienceRuleEvents(String events) {
    return 'Past events: $events';
  }

  @override
  String audienceRuleInterests(String interests) {
    return 'Interests: $interests';
  }

  @override
  String get audienceRuleOrSeparator => ' or ';

  @override
  String get audienceSummaryPublic => 'Public';

  @override
  String get audienceSummaryFriends => 'All friends';

  @override
  String get audienceSummaryNobody => 'Nobody yet';

  @override
  String audienceSummaryExcluding(String text, int count) {
    return '$text, excluding $count';
  }

  @override
  String audienceSummaryWithReach(String summary, int reach) {
    String _temp0 = intl.Intl.pluralLogic(
      reach,
      locale: localeName,
      other: '$reach friends',
      one: '1 friend',
    );
    return '$summary · $_temp0';
  }

  @override
  String get audiencePickerTitle => 'Who can see this';

  @override
  String audienceSetN(int number) {
    return 'Set $number';
  }

  @override
  String get audienceSetAnother => 'Or another set';

  @override
  String get audienceSetRemove => 'Remove this set';

  @override
  String get audiencePeopleTitle => 'People';

  @override
  String get audiencePeopleFilteredHint =>
      'Everyone matching this set. Untick to exclude someone.';

  @override
  String get audiencePeopleUnfilteredHint =>
      'Pick filters above, or add specific people here.';

  @override
  String get audiencePeopleNone => 'Nobody matches these filters';

  @override
  String get audienceNothingToChoose => 'Nothing to choose yet';

  @override
  String get audienceCustomTitle => 'Custom audience';

  @override
  String get audienceCustomHint =>
      'People must match every filter in a set; sets are combined.';

  @override
  String get audienceGroupsTitle => 'Groups';

  @override
  String get audienceNoGroups =>
      'No groups yet. Create one from the People tab.';

  @override
  String get audiencePastEventsTitle => 'Attendees of past events';

  @override
  String get audienceInterestsTitle => 'Friends with interests';

  @override
  String get audienceInterestsHint => 'Friends who share any of these.';

  @override
  String audienceReaches(int reach) {
    String _temp0 = intl.Intl.pluralLogic(
      reach,
      locale: localeName,
      other: '$reach friends',
      one: '1 friend',
    );
    return 'Reaches $_temp0';
  }

  @override
  String get interestCategoryFitness => 'Fitness';

  @override
  String get interestCategoryCreative => 'Creative';

  @override
  String get interestCategorySocial => 'Social';

  @override
  String get interestCategoryOutdoors => 'Outdoors';

  @override
  String get interestCategoryLearning => 'Learning';

  @override
  String get interestYoga => 'Yoga';

  @override
  String get interestRunning => 'Running';

  @override
  String get interestHiking => 'Hiking';

  @override
  String get interestCycling => 'Cycling';

  @override
  String get interestPilates => 'Pilates';

  @override
  String get interestPhotography => 'Photography';

  @override
  String get interestCooking => 'Cooking';

  @override
  String get interestDancing => 'Dancing';

  @override
  String get interestDrawing => 'Drawing';

  @override
  String get interestPottery => 'Pottery';

  @override
  String get interestBoardGames => 'Board games';

  @override
  String get interestTravel => 'Travel';

  @override
  String get interestBrunch => 'Brunch';

  @override
  String get interestVolunteering => 'Volunteering';

  @override
  String get interestLiveMusic => 'Live music';

  @override
  String get interestCamping => 'Camping';

  @override
  String get interestKayaking => 'Kayaking';

  @override
  String get interestBeachDays => 'Beach days';

  @override
  String get interestBirdWatching => 'Bird watching';

  @override
  String get interestGardening => 'Gardening';

  @override
  String get interestLanguageExchange => 'Language exchange';

  @override
  String get interestReadingCircles => 'Reading circles';

  @override
  String get interestCoding => 'Coding';

  @override
  String get interestWorkshops => 'Workshops';

  @override
  String get signInTagline => 'Plan things with the people you care about.';

  @override
  String get signInContinue => 'Continue';
}
