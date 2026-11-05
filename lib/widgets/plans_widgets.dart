import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';

/// Visibility filters offered on the Plans screen.
enum PlansFilter {
  all,
  friendsOnly,
  publicEvents,
  specificGroup,
  sharedInterest;

  String label(AppLocalizations l10n) => switch (this) {
    all => l10n.plansFilterAll,
    friendsOnly => l10n.plansFilterFriendsOnly,
    publicEvents => l10n.plansFilterPublicEvents,
    specificGroup => l10n.plansFilterSpecificGroup,
    sharedInterest => l10n.plansFilterSharedInterest,
  };
}

/// Previous/next week arrows around a "Week of …" label.
class WeekNavigator extends StatelessWidget {
  const WeekNavigator({
    super.key,
    required this.weekStart,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime weekStart;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  static const _buttonSize = BoxConstraints.tightFor(width: 36, height: 36);

  @override
  Widget build(BuildContext context) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    return Row(
      children: [
        IconButton(
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left),
          visualDensity: VisualDensity.compact,
          constraints: _buttonSize,
        ),
        Expanded(
          child: Text(
            AppLocalizations.of(context).plansWeekOf(weekStart, weekEnd),
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
          visualDensity: VisualDensity.compact,
          constraints: _buttonSize,
        ),
      ],
    );
  }
}

/// Swipeable strip of seven day tiles with event-type dots.
class WeekDayStrip extends StatelessWidget {
  const WeekDayStrip({
    super.key,
    required this.controller,
    required this.pageCount,
    required this.weekStartForPage,
    required this.selectedDate,
    required this.dotColorsFor,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  final PageController controller;
  final int pageCount;
  final DateTime Function(int pageIndex) weekStartForPage;
  final DateTime selectedDate;
  final List<Color> Function(DateTime day) dotColorsFor;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<int> onPageChanged;

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dayName = DateFormat.E(Localizations.localeOf(context).toString());

    return PageView.builder(
      controller: controller,
      itemCount: pageCount,
      onPageChanged: onPageChanged,
      itemBuilder: (context, pageIndex) {
        final start = weekStartForPage(pageIndex);
        return Row(
          children: List.generate(7, (index) {
            final day = start.add(Duration(days: index));
            final isSelected = _sameDay(day, selectedDate);
            final foreground = isSelected ? scheme.onPrimary : scheme.onSurface;
            final dotColors = dotColorsFor(day);

            return Expanded(
              child: GestureDetector(
                onTap: () => onDaySelected(day),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: isSelected ? scheme.primary : scheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? scheme.primary
                          : Theme.of(context).dividerColor,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayName.format(day),
                        style: textTheme.labelLarge?.copyWith(
                          color: foreground,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${day.day}',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: foreground,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (dotColors.isEmpty)
                        const SizedBox(height: 5)
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: dotColors.take(3).map((color) {
                            return Container(
                              width: 5,
                              height: 5,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// Horizontal row of visibility filter chips.
class PlansFilterBar extends StatelessWidget {
  const PlansFilterBar({
    super.key,
    required this.filters,
    required this.selected,
    required this.onSelected,
  });

  final List<PlansFilter> filters;
  final PlansFilter selected;
  final ValueChanged<PlansFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: filters.length,
      separatorBuilder: (_, _) => const SizedBox(width: 8),
      itemBuilder: (context, index) {
        final filter = filters[index];
        return ChoiceChip(
          label: Text(filter.label(l10n)),
          selected: selected == filter,
          onSelected: (_) => onSelected(filter),
        );
      },
    );
  }
}
