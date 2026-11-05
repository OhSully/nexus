import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Nexus'**
  String get appTitle;

  /// Bottom navigation label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navPlans.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get navPlans;

  /// No description provided for @navPeople.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get navPeople;

  /// No description provided for @navChats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get navChats;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @commonYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get commonYou;

  /// No description provided for @commonAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get commonLocation;

  /// No description provided for @commonLocationTbd.
  ///
  /// In en, this message translates to:
  /// **'Location TBD'**
  String get commonLocationTbd;

  /// No description provided for @dayToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dayToday;

  /// No description provided for @dayTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get dayTomorrow;

  /// Subtitle of an activity card: weekday or Today/Tomorrow, start time, and place
  ///
  /// In en, this message translates to:
  /// **'{day} · {time} · {location}'**
  String activitySubtitle(String day, String time, String location);

  /// Capacity progress for an event with limited spots
  ///
  /// In en, this message translates to:
  /// **'{count} of {capacity} spots taken'**
  String guestsSpotsTaken(int count, int capacity);

  /// Number of people going to an activity or event
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 person going} other{{count} people going}}'**
  String guestsGoing(int count);

  /// Number of people interested in an activity
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 person interested} other{{count} people interested}}'**
  String guestsInterested(int count);

  /// No description provided for @activityCardAttending.
  ///
  /// In en, this message translates to:
  /// **'You are attending'**
  String get activityCardAttending;

  /// No description provided for @activityDetailTitleEvent.
  ///
  /// In en, this message translates to:
  /// **'Event details'**
  String get activityDetailTitleEvent;

  /// No description provided for @activityDetailTitleActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity details'**
  String get activityDetailTitleActivity;

  /// No description provided for @activityDetailChooseEvent.
  ///
  /// In en, this message translates to:
  /// **'Choose an event'**
  String get activityDetailChooseEvent;

  /// No description provided for @activityDetailCancelLinkedTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel linked RSVPs?'**
  String get activityDetailCancelLinkedTitle;

  /// Confirmation body when unlinking an activity from an event
  ///
  /// In en, this message translates to:
  /// **'This will cancel your {count} RSVPs for {eventTitle}.'**
  String activityDetailCancelLinkedBody(int count, String eventTitle);

  /// No description provided for @activityDetailLinkedEventFallback.
  ///
  /// In en, this message translates to:
  /// **'the linked event'**
  String get activityDetailLinkedEventFallback;

  /// No description provided for @activityDetailKeepLink.
  ///
  /// In en, this message translates to:
  /// **'Keep link'**
  String get activityDetailKeepLink;

  /// No description provided for @activityDetailCancelRsvps.
  ///
  /// In en, this message translates to:
  /// **'Cancel RSVPs'**
  String get activityDetailCancelRsvps;

  /// No description provided for @activityDetailNoRsvp.
  ///
  /// In en, this message translates to:
  /// **'No RSVP needed'**
  String get activityDetailNoRsvp;

  /// No description provided for @activityDetailEventFull.
  ///
  /// In en, this message translates to:
  /// **'Event full'**
  String get activityDetailEventFull;

  /// No description provided for @activityDetailYouAreGoing.
  ///
  /// In en, this message translates to:
  /// **'You are going'**
  String get activityDetailYouAreGoing;

  /// No description provided for @activityDetailGoing.
  ///
  /// In en, this message translates to:
  /// **'Going'**
  String get activityDetailGoing;

  /// No description provided for @activityDetailLinkedEvent.
  ///
  /// In en, this message translates to:
  /// **'Linked event: {title}'**
  String activityDetailLinkedEvent(String title);

  /// No description provided for @activityDetailEnrolledNote.
  ///
  /// In en, this message translates to:
  /// **'Everyone interested has been enrolled in this event.'**
  String get activityDetailEnrolledNote;

  /// No description provided for @activityDetailEnrollPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enroll the people going in the linked event.'**
  String get activityDetailEnrollPrompt;

  /// No description provided for @activityDetailEnrollAll.
  ///
  /// In en, this message translates to:
  /// **'Enroll everyone in event'**
  String get activityDetailEnrollAll;

  /// No description provided for @activityDetailChangeEvent.
  ///
  /// In en, this message translates to:
  /// **'Change event'**
  String get activityDetailChangeEvent;

  /// No description provided for @activityDetailUnlink.
  ///
  /// In en, this message translates to:
  /// **'Unlink'**
  String get activityDetailUnlink;

  /// No description provided for @activityDetailHostedBy.
  ///
  /// In en, this message translates to:
  /// **'Hosted by {hosts}'**
  String activityDetailHostedBy(String hosts);

  /// No description provided for @activityDetailVisibleTo.
  ///
  /// In en, this message translates to:
  /// **'Visible to: {summary}'**
  String activityDetailVisibleTo(String summary);

  /// No description provided for @activityDetailHappeningRegardless.
  ///
  /// In en, this message translates to:
  /// **'Happening regardless'**
  String get activityDetailHappeningRegardless;

  /// No description provided for @activityDetailLinkToEvent.
  ///
  /// In en, this message translates to:
  /// **'Link to an event'**
  String get activityDetailLinkToEvent;

  /// No description provided for @homeNewMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'New message'**
  String get homeNewMessageTitle;

  /// No description provided for @homeStartChat.
  ///
  /// In en, this message translates to:
  /// **'Start chat'**
  String get homeStartChat;

  /// No description provided for @homeEnrolledPartial.
  ///
  /// In en, this message translates to:
  /// **'Enrolled {enrolled} in {title}; {skipped} skipped'**
  String homeEnrolledPartial(int enrolled, String title, int skipped);

  /// No description provided for @homeEnrolledAll.
  ///
  /// In en, this message translates to:
  /// **'Enrolled everyone in {title}'**
  String homeEnrolledAll(String title);

  /// No description provided for @homeCancelledRsvps.
  ///
  /// In en, this message translates to:
  /// **'Cancelled {count} RSVPs for {title}'**
  String homeCancelledRsvps(int count, String title);

  /// No description provided for @homeCreateTooltip.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get homeCreateTooltip;

  /// No description provided for @chatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chatsTitle;

  /// No description provided for @chatsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your conversations'**
  String get chatsSubtitle;

  /// No description provided for @chatsTimeNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get chatsTimeNow;

  /// No description provided for @chatDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat with {name}'**
  String chatDetailTitle(String name);

  /// No description provided for @chatDetailHint.
  ///
  /// In en, this message translates to:
  /// **'Type a message'**
  String get chatDetailHint;

  /// No description provided for @chatDetailSend.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get chatDetailSend;

  /// No description provided for @createActivityTitleError.
  ///
  /// In en, this message translates to:
  /// **'Enter an activity title'**
  String get createActivityTitleError;

  /// No description provided for @createEndTimeError.
  ///
  /// In en, this message translates to:
  /// **'End time must be after the start time'**
  String get createEndTimeError;

  /// No description provided for @createActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'New activity'**
  String get createActivityTitle;

  /// No description provided for @createActivityIntro.
  ///
  /// In en, this message translates to:
  /// **'Share something casual you would like to do.'**
  String get createActivityIntro;

  /// No description provided for @createActivityTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'What do you want to do?'**
  String get createActivityTitleLabel;

  /// No description provided for @createActivityTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Coffee and a walk'**
  String get createActivityTitleHint;

  /// No description provided for @createActivityLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Where?'**
  String get createActivityLocationHint;

  /// No description provided for @createActivityNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get createActivityNotesLabel;

  /// No description provided for @createActivityRegardlessOn.
  ///
  /// In en, this message translates to:
  /// **'The activity will happen whether or not anyone joins.'**
  String get createActivityRegardlessOn;

  /// No description provided for @createActivityRegardlessOff.
  ///
  /// In en, this message translates to:
  /// **'The activity may be cancelled if nobody joins.'**
  String get createActivityRegardlessOff;

  /// No description provided for @createActivityLinkLabel.
  ///
  /// In en, this message translates to:
  /// **'Link to an event'**
  String get createActivityLinkLabel;

  /// No description provided for @createActivityLinkHelper.
  ///
  /// In en, this message translates to:
  /// **'People going will be enrolled in the event.'**
  String get createActivityLinkHelper;

  /// No description provided for @createActivityNoLinkedEvent.
  ///
  /// In en, this message translates to:
  /// **'No linked event'**
  String get createActivityNoLinkedEvent;

  /// No description provided for @createActivityButton.
  ///
  /// In en, this message translates to:
  /// **'Create activity'**
  String get createActivityButton;

  /// No description provided for @createEventAddCoHosts.
  ///
  /// In en, this message translates to:
  /// **'Add co-hosts'**
  String get createEventAddCoHosts;

  /// No description provided for @createEventTitleError.
  ///
  /// In en, this message translates to:
  /// **'Enter an event title'**
  String get createEventTitleError;

  /// No description provided for @createEventCapacityError.
  ///
  /// In en, this message translates to:
  /// **'Enter a limit of at least 1'**
  String get createEventCapacityError;

  /// No description provided for @createEventTitle.
  ///
  /// In en, this message translates to:
  /// **'New event'**
  String get createEventTitle;

  /// No description provided for @createEventTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Event title'**
  String get createEventTitleLabel;

  /// No description provided for @createEventTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Sunday brunch'**
  String get createEventTitleHint;

  /// No description provided for @createEventDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get createEventDescriptionLabel;

  /// No description provided for @createEventLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Where is it?'**
  String get createEventLocationHint;

  /// No description provided for @createEventHosts.
  ///
  /// In en, this message translates to:
  /// **'Hosts'**
  String get createEventHosts;

  /// No description provided for @createEventAllowRsvps.
  ///
  /// In en, this message translates to:
  /// **'Allow RSVPs'**
  String get createEventAllowRsvps;

  /// No description provided for @createEventRsvpOn.
  ///
  /// In en, this message translates to:
  /// **'People can RSVP'**
  String get createEventRsvpOn;

  /// No description provided for @createEventRsvpOff.
  ///
  /// In en, this message translates to:
  /// **'RSVPs are turned off'**
  String get createEventRsvpOff;

  /// No description provided for @createEventLimitAttendance.
  ///
  /// In en, this message translates to:
  /// **'Limit attendance'**
  String get createEventLimitAttendance;

  /// No description provided for @createEventMaxAttendees.
  ///
  /// In en, this message translates to:
  /// **'Maximum attendees'**
  String get createEventMaxAttendees;

  /// No description provided for @createEventButton.
  ///
  /// In en, this message translates to:
  /// **'Create event'**
  String get createEventButton;

  /// No description provided for @createMenuNewMessage.
  ///
  /// In en, this message translates to:
  /// **'New message'**
  String get createMenuNewMessage;

  /// No description provided for @createMenuNewMessageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start a conversation'**
  String get createMenuNewMessageSubtitle;

  /// No description provided for @createMenuNewActivity.
  ///
  /// In en, this message translates to:
  /// **'New activity'**
  String get createMenuNewActivity;

  /// No description provided for @createMenuNewActivitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Something casual to do'**
  String get createMenuNewActivitySubtitle;

  /// No description provided for @createMenuNewEvent.
  ///
  /// In en, this message translates to:
  /// **'New event'**
  String get createMenuNewEvent;

  /// No description provided for @createMenuNewEventSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Plan something with details'**
  String get createMenuNewEventSubtitle;

  /// No description provided for @discoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming activities'**
  String get discoverTitle;

  /// No description provided for @plansChooseWeek.
  ///
  /// In en, this message translates to:
  /// **'Choose week'**
  String get plansChooseWeek;

  /// No description provided for @plansEmptyDay.
  ///
  /// In en, this message translates to:
  /// **'No ongoing or upcoming plans for this day.'**
  String get plansEmptyDay;

  /// No description provided for @plansFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get plansFilterAll;

  /// No description provided for @plansFilterFriendsOnly.
  ///
  /// In en, this message translates to:
  /// **'Friends only'**
  String get plansFilterFriendsOnly;

  /// No description provided for @plansFilterPublicEvents.
  ///
  /// In en, this message translates to:
  /// **'Public events'**
  String get plansFilterPublicEvents;

  /// No description provided for @plansFilterSpecificGroup.
  ///
  /// In en, this message translates to:
  /// **'Specific group'**
  String get plansFilterSpecificGroup;

  /// No description provided for @plansFilterSharedInterest.
  ///
  /// In en, this message translates to:
  /// **'Shared interest'**
  String get plansFilterSharedInterest;

  /// Date range of the displayed week
  ///
  /// In en, this message translates to:
  /// **'Week of {weekStart} - {weekEnd}'**
  String plansWeekOf(DateTime weekStart, DateTime weekEnd);

  /// No description provided for @whenPickerStarts.
  ///
  /// In en, this message translates to:
  /// **'Starts {time}'**
  String whenPickerStarts(String time);

  /// No description provided for @whenPickerEnds.
  ///
  /// In en, this message translates to:
  /// **'Ends {time}'**
  String whenPickerEnds(String time);

  /// No description provided for @peopleManageGroups.
  ///
  /// In en, this message translates to:
  /// **'Manage groups'**
  String get peopleManageGroups;

  /// No description provided for @peopleManageGroupsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Create a group to organize your connections.'**
  String get peopleManageGroupsEmpty;

  /// No description provided for @peopleConnectionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 connection} other{{count} connections}}'**
  String peopleConnectionsCount(int count);

  /// No description provided for @peopleEditGroup.
  ///
  /// In en, this message translates to:
  /// **'Edit {name}'**
  String peopleEditGroup(String name);

  /// No description provided for @peopleDeleteGroup.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}'**
  String peopleDeleteGroup(String name);

  /// No description provided for @peopleCreateGroup.
  ///
  /// In en, this message translates to:
  /// **'Create group'**
  String get peopleCreateGroup;

  /// No description provided for @peopleInviteTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite {group}'**
  String peopleInviteTitle(String group);

  /// No description provided for @peopleInviteBody.
  ///
  /// In en, this message translates to:
  /// **'Choose an event to invite this group to.'**
  String get peopleInviteBody;

  /// No description provided for @peopleInvitePrepared.
  ///
  /// In en, this message translates to:
  /// **'Prepared an invite to {event} for {count, plural, =1{1 person} other{{count} people}} in {group}.'**
  String peopleInvitePrepared(String event, int count, String group);

  /// No description provided for @peopleSectionUpdates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get peopleSectionUpdates;

  /// No description provided for @peopleSectionConnections.
  ///
  /// In en, this message translates to:
  /// **'Connections'**
  String get peopleSectionConnections;

  /// No description provided for @peopleSectionDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get peopleSectionDiscover;

  /// No description provided for @peopleInviteGroup.
  ///
  /// In en, this message translates to:
  /// **'Invite group'**
  String get peopleInviteGroup;

  /// No description provided for @peopleNoConnectionsInGroup.
  ///
  /// In en, this message translates to:
  /// **'No connections in this group yet.'**
  String get peopleNoConnectionsInGroup;

  /// No description provided for @peopleMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get peopleMessage;

  /// No description provided for @discoverFilterPhoneContacts.
  ///
  /// In en, this message translates to:
  /// **'Phone contacts'**
  String get discoverFilterPhoneContacts;

  /// No description provided for @discoverFilterPastEvents.
  ///
  /// In en, this message translates to:
  /// **'Past events'**
  String get discoverFilterPastEvents;

  /// No description provided for @discoverFilterFriendsOfFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends of friends'**
  String get discoverFilterFriendsOfFriends;

  /// No description provided for @discoverFilterSharedInterests.
  ///
  /// In en, this message translates to:
  /// **'Shared interests'**
  String get discoverFilterSharedInterests;

  /// No description provided for @discoverInviteSent.
  ///
  /// In en, this message translates to:
  /// **'Invite sent'**
  String get discoverInviteSent;

  /// No description provided for @discoverInviteToApp.
  ///
  /// In en, this message translates to:
  /// **'Invite to app'**
  String get discoverInviteToApp;

  /// No description provided for @discoverRequested.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get discoverRequested;

  /// No description provided for @discoverConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get discoverConnect;

  /// No description provided for @groupEditorNameError.
  ///
  /// In en, this message translates to:
  /// **'Enter a group name'**
  String get groupEditorNameError;

  /// No description provided for @groupEditorEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit group'**
  String get groupEditorEditTitle;

  /// No description provided for @groupEditorNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Group name'**
  String get groupEditorNameLabel;

  /// No description provided for @updatesSampleNotice.
  ///
  /// In en, this message translates to:
  /// **'This is sample data for now.'**
  String get updatesSampleNotice;

  /// No description provided for @updatesViewEvent.
  ///
  /// In en, this message translates to:
  /// **'View event'**
  String get updatesViewEvent;

  /// No description provided for @updatesAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get updatesAccepted;

  /// No description provided for @updatesDeclined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get updatesDeclined;

  /// No description provided for @updatesAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get updatesAccept;

  /// No description provided for @updatesDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get updatesDecline;

  /// No description provided for @profileConnections.
  ///
  /// In en, this message translates to:
  /// **'Connections'**
  String get profileConnections;

  /// No description provided for @profileMutualConnections.
  ///
  /// In en, this message translates to:
  /// **'Mutual connections'**
  String get profileMutualConnections;

  /// No description provided for @profilePastEvents.
  ///
  /// In en, this message translates to:
  /// **'Past Events'**
  String get profilePastEvents;

  /// No description provided for @profileUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get profileUpcoming;

  /// No description provided for @profileLookingFor.
  ///
  /// In en, this message translates to:
  /// **'Looking For'**
  String get profileLookingFor;

  /// No description provided for @profileInterests.
  ///
  /// In en, this message translates to:
  /// **'Interests'**
  String get profileInterests;

  /// No description provided for @profileDeclared.
  ///
  /// In en, this message translates to:
  /// **'Declared {date}'**
  String profileDeclared(DateTime date);

  /// No description provided for @profileBioHint.
  ///
  /// In en, this message translates to:
  /// **'Add a short bio'**
  String get profileBioHint;

  /// No description provided for @interestsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add interest'**
  String get interestsAdd;

  /// No description provided for @interestsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Choose a few interests to help people discover shared strengths.'**
  String get interestsEmpty;

  /// No description provided for @interestsNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Add context for this interest'**
  String get interestsNoteHint;

  /// No description provided for @interestsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search interests'**
  String get interestsSearchHint;

  /// No description provided for @interestsCategoryCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get interestsCategoryCustom;

  /// No description provided for @interestsAddQuery.
  ///
  /// In en, this message translates to:
  /// **'Add \"{query}\"'**
  String interestsAddQuery(String query);

  /// No description provided for @lookingForAddMore.
  ///
  /// In en, this message translates to:
  /// **'Add more'**
  String get lookingForAddMore;

  /// No description provided for @lookingForRedeclare.
  ///
  /// In en, this message translates to:
  /// **'Redeclare'**
  String get lookingForRedeclare;

  /// No description provided for @lookingForHint1.
  ///
  /// In en, this message translates to:
  /// **'Grab a drink after work'**
  String get lookingForHint1;

  /// No description provided for @lookingForHint2.
  ///
  /// In en, this message translates to:
  /// **'Go for a walk this weekend'**
  String get lookingForHint2;

  /// No description provided for @lookingForHint3.
  ///
  /// In en, this message translates to:
  /// **'Something spontaneous this week'**
  String get lookingForHint3;

  /// No description provided for @lookingForLastDeclared.
  ///
  /// In en, this message translates to:
  /// **'Last declared {lastDeclared}'**
  String lookingForLastDeclared(DateTime lastDeclared);

  /// No description provided for @audienceTypePublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get audienceTypePublic;

  /// No description provided for @audienceTypeFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get audienceTypeFriends;

  /// No description provided for @audienceTypeGroups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get audienceTypeGroups;

  /// No description provided for @audienceTypePastAttendees.
  ///
  /// In en, this message translates to:
  /// **'Past attendees'**
  String get audienceTypePastAttendees;

  /// No description provided for @audienceTypeInterests.
  ///
  /// In en, this message translates to:
  /// **'Shared interests'**
  String get audienceTypeInterests;

  /// No description provided for @audienceTypeCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get audienceTypeCustom;

  /// No description provided for @audienceRuleGroups.
  ///
  /// In en, this message translates to:
  /// **'Groups: {groups}'**
  String audienceRuleGroups(String groups);

  /// No description provided for @audienceRuleEvents.
  ///
  /// In en, this message translates to:
  /// **'Past events: {events}'**
  String audienceRuleEvents(String events);

  /// No description provided for @audienceRuleInterests.
  ///
  /// In en, this message translates to:
  /// **'Interests: {interests}'**
  String audienceRuleInterests(String interests);

  /// No description provided for @audienceRuleOrSeparator.
  ///
  /// In en, this message translates to:
  /// **' or '**
  String get audienceRuleOrSeparator;

  /// No description provided for @audienceSummaryPublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get audienceSummaryPublic;

  /// No description provided for @audienceSummaryFriends.
  ///
  /// In en, this message translates to:
  /// **'All friends'**
  String get audienceSummaryFriends;

  /// No description provided for @audienceSummaryNobody.
  ///
  /// In en, this message translates to:
  /// **'Nobody yet'**
  String get audienceSummaryNobody;

  /// No description provided for @audienceSummaryExcluding.
  ///
  /// In en, this message translates to:
  /// **'{text}, excluding {count}'**
  String audienceSummaryExcluding(String text, int count);

  /// No description provided for @audienceSummaryWithReach.
  ///
  /// In en, this message translates to:
  /// **'{summary} · {reach, plural, =1{1 friend} other{{reach} friends}}'**
  String audienceSummaryWithReach(String summary, int reach);

  /// No description provided for @audiencePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Who can see this'**
  String get audiencePickerTitle;

  /// No description provided for @audienceSetN.
  ///
  /// In en, this message translates to:
  /// **'Set {number}'**
  String audienceSetN(int number);

  /// No description provided for @audienceSetAnother.
  ///
  /// In en, this message translates to:
  /// **'Or another set'**
  String get audienceSetAnother;

  /// No description provided for @audienceSetRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove this set'**
  String get audienceSetRemove;

  /// No description provided for @audiencePeopleTitle.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get audiencePeopleTitle;

  /// No description provided for @audiencePeopleFilteredHint.
  ///
  /// In en, this message translates to:
  /// **'Everyone matching this set. Untick to exclude someone.'**
  String get audiencePeopleFilteredHint;

  /// No description provided for @audiencePeopleUnfilteredHint.
  ///
  /// In en, this message translates to:
  /// **'Pick filters above, or add specific people here.'**
  String get audiencePeopleUnfilteredHint;

  /// No description provided for @audiencePeopleNone.
  ///
  /// In en, this message translates to:
  /// **'Nobody matches these filters'**
  String get audiencePeopleNone;

  /// No description provided for @audienceNothingToChoose.
  ///
  /// In en, this message translates to:
  /// **'Nothing to choose yet'**
  String get audienceNothingToChoose;

  /// No description provided for @audienceCustomTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom audience'**
  String get audienceCustomTitle;

  /// No description provided for @audienceCustomHint.
  ///
  /// In en, this message translates to:
  /// **'People must match every filter in a set; sets are combined.'**
  String get audienceCustomHint;

  /// No description provided for @audienceGroupsTitle.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get audienceGroupsTitle;

  /// No description provided for @audienceNoGroups.
  ///
  /// In en, this message translates to:
  /// **'No groups yet. Create one from the People tab.'**
  String get audienceNoGroups;

  /// No description provided for @audiencePastEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Attendees of past events'**
  String get audiencePastEventsTitle;

  /// No description provided for @audienceInterestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Friends with interests'**
  String get audienceInterestsTitle;

  /// No description provided for @audienceInterestsHint.
  ///
  /// In en, this message translates to:
  /// **'Friends who share any of these.'**
  String get audienceInterestsHint;

  /// No description provided for @audienceReaches.
  ///
  /// In en, this message translates to:
  /// **'Reaches {reach, plural, =1{1 friend} other{{reach} friends}}'**
  String audienceReaches(int reach);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
