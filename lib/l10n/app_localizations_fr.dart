// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Nexus';

  @override
  String get navHome => 'Accueil';

  @override
  String get navPlans => 'Plans';

  @override
  String get navPeople => 'Contacts';

  @override
  String get navChats => 'Discussions';

  @override
  String get navProfile => 'Profil';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsTooltip => 'Paramètres';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageSystem => 'Langue du système';

  @override
  String get settingsLanguageSystemSubtitle =>
      'Suivre la langue de votre appareil';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsNotificationsNote =>
      'Les notifications ne sont pas encore actives. Vos choix s\'appliqueront dès qu\'elles le seront.';

  @override
  String get settingsNotifMessages => 'Messages';

  @override
  String get settingsNotifRequests => 'Demandes de connexion';

  @override
  String get settingsNotifInvitations => 'Invitations';

  @override
  String get settingsNotifEventChanges => 'Modifications d\'événements';

  @override
  String get settingsPrivacy => 'Confidentialité';

  @override
  String get settingsCrashReportingNote =>
      'Rapports d’erreur : lorsque la fonction est configurée, Nexus envoie à Sentry des données techniques anonymisées pour corriger les bogues et améliorer l’application pour vous. Les identifiants personnels, les données de requête et le texte libre des erreurs sont supprimés. Sentry peut traiter ces données à l’extérieur du Canada; l’hébergement au Canada est un objectif futur.';

  @override
  String get settingsDefaultAudience =>
      'Public par défaut pour les nouvelles activités et événements';

  @override
  String get settingsDefaultAudienceHelp =>
      'Vous pouvez toujours changer le public à chaque création.';

  @override
  String get settingsAccount => 'Compte';

  @override
  String get settingsExportData => 'Exporter mes données';

  @override
  String get settingsDeleteAccount => 'Supprimer le compte';

  @override
  String get settingsUnavailableYet =>
      'Pas encore disponible. Cela arrivera avec les comptes.';

  @override
  String get settingsAbout => 'À propos de Nexus';

  @override
  String get commonYou => 'Vous';

  @override
  String get commonAll => 'Tous';

  @override
  String get commonDone => 'Terminé';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonEdit => 'Modifier';

  @override
  String get commonLocation => 'Lieu';

  @override
  String get commonLocationTbd => 'Lieu à confirmer';

  @override
  String get dayToday => 'Aujourd’hui';

  @override
  String get dayTomorrow => 'Demain';

  @override
  String activitySubtitle(String day, String time, String location) {
    return '$day · $time · $location';
  }

  @override
  String guestsSpotsTaken(int count, int capacity) {
    return '$count places sur $capacity réservées';
  }

  @override
  String guestsGoing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count personnes y vont',
      one: '$count personne y va',
    );
    return '$_temp0';
  }

  @override
  String guestsInterested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count personnes intéressées',
      one: '$count personne intéressée',
    );
    return '$_temp0';
  }

  @override
  String get activityCardAttending => 'Tu y participes';

  @override
  String get activityDetailTitleEvent => 'Détails de l’événement';

  @override
  String get activityDetailTitleActivity => 'Détails de l’activité';

  @override
  String get activityDetailChooseEvent => 'Choisir un événement';

  @override
  String get activityDetailCancelLinkedTitle => 'Annuler les réponses liées?';

  @override
  String activityDetailCancelLinkedBody(int count, String eventTitle) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tes $count réponses',
      one: 'Ta réponse',
    );
    return '$_temp0 pour $eventTitle seront annulées.';
  }

  @override
  String get activityDetailLinkedEventFallback => 'l’événement lié';

  @override
  String get activityDetailKeepLink => 'Garder le lien';

  @override
  String get activityDetailCancelRsvps => 'Annuler les réponses';

  @override
  String get activityDetailNoRsvp => 'Aucune réponse requise';

  @override
  String get activityDetailEventFull => 'Événement complet';

  @override
  String get activityDetailYouAreGoing => 'Tu y vas';

  @override
  String get activityDetailGoing => 'J’y vais';

  @override
  String activityDetailLinkedEvent(String title) {
    return 'Événement lié : $title';
  }

  @override
  String get activityDetailEnrolledNote =>
      'Toutes les personnes intéressées sont inscrites à cet événement.';

  @override
  String get activityDetailEnrollPrompt =>
      'Inscrire les personnes qui y vont à l’événement lié.';

  @override
  String get activityDetailEnrollAll => 'Inscrire tout le monde à l’événement';

  @override
  String get activityDetailChangeEvent => 'Changer d’événement';

  @override
  String get activityDetailUnlink => 'Dissocier';

  @override
  String activityDetailHostedBy(String hosts) {
    return 'Organisé par $hosts';
  }

  @override
  String activityDetailVisibleTo(String summary) {
    return 'Visible par : $summary';
  }

  @override
  String get activityDetailHappeningRegardless => 'A lieu quoi qu’il arrive';

  @override
  String get activityDetailLinkToEvent => 'Lier à un événement';

  @override
  String get homeNewMessageTitle => 'Nouveau message';

  @override
  String get homeStartChat => 'Démarrer une discussion';

  @override
  String homeEnrolledPartial(int enrolled, String title, int skipped) {
    String _temp0 = intl.Intl.pluralLogic(
      enrolled,
      locale: localeName,
      other: '$enrolled personnes inscrites',
      one: '$enrolled personne inscrite',
    );
    String _temp1 = intl.Intl.pluralLogic(
      skipped,
      locale: localeName,
      other: '$skipped ignorées',
      one: '$skipped ignorée',
    );
    return '$_temp0 à $title; $_temp1';
  }

  @override
  String homeEnrolledAll(String title) {
    return 'Tout le monde est inscrit à $title';
  }

  @override
  String homeCancelledRsvps(int count, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count réponses annulées',
      one: '$count réponse annulée',
    );
    return '$_temp0 pour $title';
  }

  @override
  String get homeCreateTooltip => 'Créer';

  @override
  String get chatsTitle => 'Discussions';

  @override
  String get chatsSubtitle => 'Tes conversations';

  @override
  String get chatsTimeNow => 'À l’instant';

  @override
  String chatDetailTitle(String name) {
    return 'Discussion avec $name';
  }

  @override
  String get chatDetailHint => 'Écris un message';

  @override
  String get chatDetailSend => 'Envoyer le message';

  @override
  String get createActivityTitleError => 'Saisis un titre d’activité';

  @override
  String get createEndTimeError =>
      'L’heure de fin doit être après l’heure de début';

  @override
  String get createActivityTitle => 'Nouvelle activité';

  @override
  String get createActivityIntro => 'Propose quelque chose de simple à faire.';

  @override
  String get createActivityTitleLabel => 'Qu’as-tu envie de faire?';

  @override
  String get createActivityTitleHint => 'Un café et une marche';

  @override
  String get createActivityLocationHint => 'Où?';

  @override
  String get createActivityNotesLabel => 'Notes';

  @override
  String get createActivityRegardlessOn =>
      'L’activité aura lieu que quelqu’un se joigne ou non.';

  @override
  String get createActivityRegardlessOff =>
      'L’activité pourrait être annulée si personne ne se joint.';

  @override
  String get createActivityLinkLabel => 'Lier à un événement';

  @override
  String get createActivityLinkHelper =>
      'Les personnes qui y vont seront inscrites à l’événement.';

  @override
  String get createActivityNoLinkedEvent => 'Aucun événement lié';

  @override
  String get createActivityButton => 'Créer l’activité';

  @override
  String get createEventAddCoHosts => 'Ajouter des coorganisateurs';

  @override
  String get createEventTitleError => 'Saisis un titre d’événement';

  @override
  String get createEventCapacityError => 'Saisis une limite d’au moins 1';

  @override
  String get createEventTitle => 'Nouvel événement';

  @override
  String get createEventTitleLabel => 'Titre de l’événement';

  @override
  String get createEventTitleHint => 'Brunch du dimanche';

  @override
  String get createEventDescriptionLabel => 'Description';

  @override
  String get createEventLocationHint => 'C’est où?';

  @override
  String get createEventHosts => 'Organisateurs';

  @override
  String get createEventAllowRsvps => 'Autoriser les réponses';

  @override
  String get createEventRsvpOn => 'Les gens peuvent répondre';

  @override
  String get createEventRsvpOff => 'Les réponses sont désactivées';

  @override
  String get createEventLimitAttendance => 'Limiter la participation';

  @override
  String get createEventMaxAttendees => 'Nombre maximal de participants';

  @override
  String get createEventButton => 'Créer l’événement';

  @override
  String get createMenuNewMessage => 'Nouveau message';

  @override
  String get createMenuNewMessageSubtitle => 'Démarrer une conversation';

  @override
  String get createMenuNewActivity => 'Nouvelle activité';

  @override
  String get createMenuNewActivitySubtitle => 'Quelque chose de simple à faire';

  @override
  String get createMenuNewEvent => 'Nouvel événement';

  @override
  String get createMenuNewEventSubtitle =>
      'Planifier quelque chose avec les détails';

  @override
  String get discoverTitle => 'Activités à venir';

  @override
  String get plansChooseWeek => 'Choisir la semaine';

  @override
  String get plansEmptyDay =>
      'Aucun plan en cours ou à venir pour cette journée.';

  @override
  String get plansFilterAll => 'Tous';

  @override
  String get plansFilterFriendsOnly => 'Amis seulement';

  @override
  String get plansFilterPublicEvents => 'Événements publics';

  @override
  String get plansFilterSpecificGroup => 'Groupe précis';

  @override
  String get plansFilterSharedInterest => 'Intérêt commun';

  @override
  String plansWeekOf(DateTime weekStart, DateTime weekEnd) {
    final intl.DateFormat weekStartDateFormat = intl.DateFormat.Md(localeName);
    final String weekStartString = weekStartDateFormat.format(weekStart);
    final intl.DateFormat weekEndDateFormat = intl.DateFormat.Md(localeName);
    final String weekEndString = weekEndDateFormat.format(weekEnd);

    return 'Semaine du $weekStartString au $weekEndString';
  }

  @override
  String whenPickerStarts(String time) {
    return 'Début : $time';
  }

  @override
  String whenPickerEnds(String time) {
    return 'Fin : $time';
  }

  @override
  String get peopleManageGroups => 'Gérer les groupes';

  @override
  String get peopleManageGroupsEmpty =>
      'Crée un groupe pour organiser tes contacts.';

  @override
  String peopleConnectionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contacts',
      one: '$count contact',
    );
    return '$_temp0';
  }

  @override
  String peopleEditGroup(String name) {
    return 'Modifier $name';
  }

  @override
  String peopleDeleteGroup(String name) {
    return 'Supprimer $name';
  }

  @override
  String get peopleCreateGroup => 'Créer un groupe';

  @override
  String peopleInviteTitle(String group) {
    return 'Inviter $group';
  }

  @override
  String get peopleInviteBody =>
      'Choisis un événement auquel inviter ce groupe.';

  @override
  String peopleInvitePrepared(String event, int count, String group) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count personnes',
      one: '$count personne',
    );
    return 'Invitation à $event préparée pour $_temp0 de $group.';
  }

  @override
  String get peopleSectionUpdates => 'Nouveautés';

  @override
  String get peopleSectionConnections => 'Contacts';

  @override
  String get peopleSectionDiscover => 'Découvrir';

  @override
  String get peopleInviteGroup => 'Inviter le groupe';

  @override
  String get peopleNoConnectionsInGroup =>
      'Aucun contact dans ce groupe pour l’instant.';

  @override
  String get peopleMessage => 'Message';

  @override
  String get discoverFilterPhoneContacts => 'Contacts du téléphone';

  @override
  String get discoverFilterPastEvents => 'Événements passés';

  @override
  String get discoverFilterFriendsOfFriends => 'Amis d’amis';

  @override
  String get discoverFilterSharedInterests => 'Intérêts communs';

  @override
  String get discoverInviteSent => 'Invitation envoyée';

  @override
  String get discoverInviteToApp => 'Inviter dans l’appli';

  @override
  String get discoverRequested => 'Demande envoyée';

  @override
  String get discoverConnect => 'Se connecter';

  @override
  String get groupEditorNameError => 'Saisis un nom de groupe';

  @override
  String get groupEditorEditTitle => 'Modifier le groupe';

  @override
  String get groupEditorNameLabel => 'Nom du groupe';

  @override
  String get updatesSampleNotice =>
      'Ce sont des données d’exemple pour l’instant.';

  @override
  String get updatesViewEvent => 'Voir l’événement';

  @override
  String get updatesAccepted => 'Accepté';

  @override
  String get updatesDeclined => 'Refusé';

  @override
  String get updatesAccept => 'Accepter';

  @override
  String get updatesDecline => 'Refuser';

  @override
  String get profileConnections => 'Contacts';

  @override
  String get profileMutualConnections => 'Contacts en commun';

  @override
  String get profilePastEvents => 'Événements passés';

  @override
  String get profileUpcoming => 'À venir';

  @override
  String get profileLookingFor => 'Je cherche';

  @override
  String get profileInterests => 'Intérêts';

  @override
  String profileDeclared(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.Md(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Déclaré le $dateString';
  }

  @override
  String get profileBioHint => 'Ajoute une courte bio';

  @override
  String get interestsAdd => 'Ajouter un intérêt';

  @override
  String get interestsEmpty =>
      'Choisis quelques intérêts pour aider les gens à découvrir ce que vous avez en commun.';

  @override
  String get interestsNoteHint => 'Ajoute du contexte pour cet intérêt';

  @override
  String get interestsSearchHint => 'Rechercher des intérêts';

  @override
  String get interestsCategoryCustom => 'Personnalisé';

  @override
  String interestsAddQuery(String query) {
    return 'Ajouter « $query »';
  }

  @override
  String get lookingForAddMore => 'En ajouter';

  @override
  String get lookingForRedeclare => 'Redéclarer';

  @override
  String get lookingForHint1 => 'Prendre un verre après le travail';

  @override
  String get lookingForHint2 => 'Aller marcher cette fin de semaine';

  @override
  String get lookingForHint3 => 'Quelque chose de spontané cette semaine';

  @override
  String lookingForLastDeclared(DateTime lastDeclared) {
    final intl.DateFormat lastDeclaredDateFormat = intl.DateFormat.Md(
      localeName,
    );
    final String lastDeclaredString = lastDeclaredDateFormat.format(
      lastDeclared,
    );

    return 'Dernière déclaration : $lastDeclaredString';
  }

  @override
  String get audienceTypePublic => 'Public';

  @override
  String get audienceTypeFriends => 'Amis';

  @override
  String get audienceTypeGroups => 'Groupes';

  @override
  String get audienceTypePastAttendees => 'Participants passés';

  @override
  String get audienceTypeInterests => 'Intérêts communs';

  @override
  String get audienceTypeCustom => 'Personnalisé';

  @override
  String audienceRuleGroups(String groups) {
    return 'Groupes : $groups';
  }

  @override
  String audienceRuleEvents(String events) {
    return 'Événements passés : $events';
  }

  @override
  String audienceRuleInterests(String interests) {
    return 'Intérêts : $interests';
  }

  @override
  String get audienceRuleOrSeparator => ' ou ';

  @override
  String get audienceSummaryPublic => 'Public';

  @override
  String get audienceSummaryFriends => 'Tous les amis';

  @override
  String get audienceSummaryNobody => 'Personne pour l’instant';

  @override
  String audienceSummaryExcluding(String text, int count) {
    return '$text, sauf $count';
  }

  @override
  String audienceSummaryWithReach(String summary, int reach) {
    String _temp0 = intl.Intl.pluralLogic(
      reach,
      locale: localeName,
      other: '$reach amis',
      one: '$reach ami',
    );
    return '$summary · $_temp0';
  }

  @override
  String get audiencePickerTitle => 'Qui peut voir ceci';

  @override
  String audienceSetN(int number) {
    return 'Ensemble $number';
  }

  @override
  String get audienceSetAnother => 'Ou un autre ensemble';

  @override
  String get audienceSetRemove => 'Retirer cet ensemble';

  @override
  String get audiencePeopleTitle => 'Personnes';

  @override
  String get audiencePeopleFilteredHint =>
      'Toutes les personnes qui correspondent à cet ensemble. Décoche pour exclure quelqu’un.';

  @override
  String get audiencePeopleUnfilteredHint =>
      'Choisis des filtres ci-dessus, ou ajoute des personnes précises ici.';

  @override
  String get audiencePeopleNone => 'Personne ne correspond à ces filtres';

  @override
  String get audienceNothingToChoose => 'Rien à choisir pour l’instant';

  @override
  String get audienceCustomTitle => 'Public personnalisé';

  @override
  String get audienceCustomHint =>
      'Les personnes doivent correspondre à tous les filtres d’un ensemble; les ensembles sont combinés.';

  @override
  String get audienceGroupsTitle => 'Groupes';

  @override
  String get audienceNoGroups =>
      'Aucun groupe pour l’instant. Crées-en un depuis l’onglet Contacts.';

  @override
  String get audiencePastEventsTitle => 'Participants à des événements passés';

  @override
  String get audienceInterestsTitle => 'Amis ayant des intérêts';

  @override
  String get audienceInterestsHint =>
      'Amis qui partagent l’un de ces intérêts.';

  @override
  String audienceReaches(int reach) {
    String _temp0 = intl.Intl.pluralLogic(
      reach,
      locale: localeName,
      other: '$reach amis',
      one: '$reach ami',
    );
    return 'Rejoint $_temp0';
  }

  @override
  String get interestCategoryFitness => 'Forme';

  @override
  String get interestCategoryCreative => 'Créativité';

  @override
  String get interestCategorySocial => 'Social';

  @override
  String get interestCategoryOutdoors => 'Plein air';

  @override
  String get interestCategoryLearning => 'Apprentissage';

  @override
  String get interestYoga => 'Yoga';

  @override
  String get interestRunning => 'Course à pied';

  @override
  String get interestHiking => 'Randonnée';

  @override
  String get interestCycling => 'Vélo';

  @override
  String get interestPilates => 'Pilates';

  @override
  String get interestPhotography => 'Photographie';

  @override
  String get interestCooking => 'Cuisine';

  @override
  String get interestDancing => 'Danse';

  @override
  String get interestDrawing => 'Dessin';

  @override
  String get interestPottery => 'Poterie';

  @override
  String get interestBoardGames => 'Jeux de société';

  @override
  String get interestTravel => 'Voyage';

  @override
  String get interestBrunch => 'Brunch';

  @override
  String get interestVolunteering => 'Bénévolat';

  @override
  String get interestLiveMusic => 'Musique live';

  @override
  String get interestCamping => 'Camping';

  @override
  String get interestKayaking => 'Kayak';

  @override
  String get interestBeachDays => 'Journées à la plage';

  @override
  String get interestBirdWatching => 'Observation des oiseaux';

  @override
  String get interestGardening => 'Jardinage';

  @override
  String get interestLanguageExchange => 'Échange linguistique';

  @override
  String get interestReadingCircles => 'Cercles de lecture';

  @override
  String get interestCoding => 'Programmation';

  @override
  String get interestWorkshops => 'Ateliers';

  @override
  String get signInTagline =>
      'Organisez des activités avec les gens qui comptent pour vous.';

  @override
  String get signInContinue => 'Continuer';
}
