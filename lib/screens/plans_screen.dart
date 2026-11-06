import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/activity_item.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/activity_card.dart';
import '../widgets/plans_widgets.dart';
import '../widgets/section_header.dart';

class PlansScreen extends ConsumerStatefulWidget {
  const PlansScreen({
    super.key,
    required this.plans,
    required this.onOpenActivity,
  });

  final List<ActivityItem> plans;
  final ValueChanged<ActivityItem> onOpenActivity;

  @override
  ConsumerState<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends ConsumerState<PlansScreen> {
  late DateTime _selectedDate;
  PlansFilter _selectedFilter = PlansFilter.all;
  static const int _pageOffset = 4000;
  static const int _pageCount = 8001;

  late final PageController _weekPageController;

  DateTime get _now => ref.read(clockProvider)();

  @override
  void initState() {
    super.initState();
    _selectedDate = _now;
    _weekPageController = PageController(initialPage: _pageOffset);
  }

  @override
  void dispose() {
    _weekPageController.dispose();
    super.dispose();
  }

  DateTime _startOfWeek(DateTime date) {
    final day = date.weekday;
    return DateTime(
      date.year,
      date.month,
      date.day,
    ).subtract(Duration(days: day - 1));
  }

  DateTime _weekStartForPage(int pageIndex) {
    final reference = _startOfWeek(_now);
    return reference.add(Duration(days: (pageIndex - _pageOffset) * 7));
  }

  bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isOngoing(ActivityItem item) {
    final now = _now;
    final startsAt = item.startsAt;
    final endsAt = item.endsAt ?? startsAt?.add(const Duration(hours: 2));
    if (startsAt == null) {
      return false;
    }
    if (endsAt == null) {
      return now.isAfter(startsAt) || now.isAtSameMomentAs(startsAt);
    }
    return now.isAfter(startsAt) && now.isBefore(endsAt);
  }

  List<ActivityItem> _eventsForDay(DateTime day) {
    final now = _now;

    final events = widget.plans.where((plan) {
      if (plan.startsAt == null) {
        return false;
      }

      final sameDay = _sameDay(plan.startsAt!, day);
      if (!sameDay) {
        return false;
      }

      final isOngoing = _isOngoing(plan);
      final isUpcoming =
          now.isBefore(plan.startsAt!) || now.isAtSameMomentAs(plan.startsAt!);
      if (!isOngoing && !isUpcoming) {
        return false;
      }

      switch (_selectedFilter) {
        case PlansFilter.friendsOnly:
          return plan.visibility == 'friends';
        case PlansFilter.publicEvents:
          return plan.visibility == 'public';
        case PlansFilter.specificGroup:
          return const {
            'group',
            'past_attendees',
            'custom',
          }.contains(plan.visibility);
        case PlansFilter.sharedInterest:
          return plan.visibility == 'shared_interest';
        case PlansFilter.all:
          return true;
      }
    }).toList();

    events.sort((a, b) {
      final aOngoing = _isOngoing(a);
      final bOngoing = _isOngoing(b);
      if (aOngoing != bOngoing) {
        return aOngoing ? -1 : 1;
      }
      final aTime = a.startsAt ?? now;
      final bTime = b.startsAt ?? now;
      return aTime.compareTo(bTime);
    });

    return events;
  }

  List<ActivityItem> _filteredDailyPlans() {
    return _eventsForDay(_selectedDate);
  }

  Color _eventTypeColor(ActivityItem item) {
    final normalizedVisibility = item.visibility.toLowerCase();
    switch (normalizedVisibility) {
      case 'friends':
        return AppColors.friends;
      case 'public':
        return AppColors.publicEvent;
      case 'group':
      case 'past_attendees':
      case 'custom':
        return AppColors.group;
      case 'shared_interest':
        return AppColors.sharedInterest;
      default:
        return item.color;
    }
  }

  List<Color> _dayEventColors(DateTime day) {
    final colors = <Color>[];
    for (final plan in _eventsForDay(day)) {
      final color = _eventTypeColor(plan);
      if (!colors.contains(color)) {
        colors.add(color);
      }
    }
    return colors;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (picked != null && mounted) {
      final weekOffset =
          _startOfWeek(picked).difference(_startOfWeek(_now)).inDays ~/ 7;
      final pageIndex = _pageOffset + weekOffset;
      final targetPage = pageIndex < 0
          ? 0
          : pageIndex >= _pageCount
          ? _pageCount - 1
          : pageIndex;
      setState(() {
        _selectedDate = picked;
      });
      await _weekPageController.animateToPage(
        targetPage,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _goToWeek(int delta) async {
    final currentPage = (_weekPageController.page ?? _currentWeekPageValue)
        .round();
    final nextPage = currentPage + delta;
    if (nextPage < 0 || nextPage >= _pageCount) {
      return;
    }

    await _weekPageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
    );
  }

  int get _currentWeekPageValue => _pageOffset;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dailyPlans = _filteredDailyPlans();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: ScreenTitle(l10n.navPlans)),
                IconButton(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_month_outlined),
                  tooltip: l10n.plansChooseWeek,
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints.tightFor(
                    width: 40,
                    height: 40,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            WeekNavigator(
              weekStart: _startOfWeek(_selectedDate),
              onPrevious: () => _goToWeek(-1),
              onNext: () => _goToWeek(1),
            ),
            const SizedBox(height: 6),
            SizedBox(
              key: const ValueKey('plans-day-selector'),
              height: 76,
              child: WeekDayStrip(
                controller: _weekPageController,
                pageCount: _pageCount,
                weekStartForPage: _weekStartForPage,
                selectedDate: _selectedDate,
                dotColorsFor: _dayEventColors,
                onDaySelected: (day) => setState(() => _selectedDate = day),
                onPageChanged: (pageIndex) {
                  final weekStart = _weekStartForPage(pageIndex);
                  setState(() {
                    _selectedDate = weekStart.add(
                      Duration(days: _selectedDate.weekday - 1),
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 36,
              child: PlansFilterBar(
                filters: PlansFilter.values,
                selected: _selectedFilter,
                onSelected: (filter) =>
                    setState(() => _selectedFilter = filter),
              ),
            ),
            const SizedBox(height: 16),
            if (dailyPlans.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    l10n.plansEmptyDay,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: dailyPlans.length,
                  itemBuilder: (context, index) {
                    final item = dailyPlans[index];
                    return ActivityCard(
                      item: item,
                      onTap: () => widget.onOpenActivity(item),
                      showAttendanceStatus: true,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
