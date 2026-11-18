import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../models/user_profile.dart';
import '../../providers/providers.dart';

class BeaconRefreshControl extends ConsumerStatefulWidget {
  const BeaconRefreshControl({
    super.key,
    required this.entry,
    required this.onRefresh,
  });

  final LookingForEntry entry;
  final ValueChanged<BeaconDuration?>? onRefresh;

  @override
  ConsumerState<BeaconRefreshControl> createState() =>
      _BeaconRefreshControlState();
}

class _BeaconRefreshControlState extends ConsumerState<BeaconRefreshControl> {
  final _buttonKey = GlobalKey();
  final _optionKeys = {
    for (final duration in BeaconDuration.values) duration: GlobalKey(),
  };
  OverlayEntry? _popup;
  BeaconDuration? _highlighted;

  @override
  void didUpdateWidget(BeaconRefreshControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.entry, widget.entry) || widget.onRefresh == null) {
      _dismissPopup();
    }
  }

  @override
  void dispose() {
    _dismissPopup();
    super.dispose();
  }

  void _dismissPopup() {
    _popup?.remove();
    _popup?.dispose();
    _popup = null;
    _highlighted = null;
  }

  void _showPopup(LongPressStartDetails details) {
    _dismissPopup();
    final overlay = Overlay.of(context);
    final overlayBox = overlay.context.findRenderObject()! as RenderBox;
    final buttonBox =
        _buttonKey.currentContext!.findRenderObject()! as RenderBox;
    final anchor =
        buttonBox.localToGlobal(Offset.zero, ancestor: overlayBox) &
        buttonBox.size;
    final padding = MediaQuery.paddingOf(context);
    _popup = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: IgnorePointer(
          child: CustomSingleChildLayout(
            delegate: _PopupPosition(anchor: anchor, padding: padding),
            child: _buildPopup(context),
          ),
        ),
      ),
    );
    overlay.insert(_popup!);
  }

  BeaconDuration? _durationAt(Offset position) {
    for (final entry in _optionKeys.entries) {
      final box = entry.value.currentContext?.findRenderObject();
      if (box is RenderBox && box.hasSize) {
        final local = box.globalToLocal(position);
        if ((Offset.zero & box.size).contains(local)) return entry.key;
      }
    }
    return null;
  }

  void _updateHighlight(Offset position) {
    final next = _durationAt(position);
    if (_highlighted != next) {
      _highlighted = next;
      _popup?.markNeedsBuild();
    }
  }

  void _finishSelection(LongPressEndDetails details) {
    final choice = _durationAt(details.globalPosition);
    _dismissPopup();
    if (choice != null) widget.onRefresh?.call(choice);
  }

  List<(BeaconDuration, String, String)> _options(AppLocalizations l10n) => [
    (BeaconDuration.today, '<1', l10n.beaconUntilMidnight),
    (BeaconDuration.oneDay, '1', l10n.beaconDurationOption(1)),
    (BeaconDuration.sevenDays, '7', l10n.beaconDurationOption(7)),
    (BeaconDuration.thirtyDays, '30', l10n.beaconDurationOption(30)),
  ];

  Widget _buildPopup(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Material(
      key: const Key('beacon-duration-popup'),
      elevation: 6,
      color: theme.colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                l10n.beaconDurationDays,
                style: theme.textTheme.labelLarge,
              ),
            ),
            Row(
              children: [
                for (final (duration, label, semanticLabel) in _options(l10n))
                  Expanded(
                    child: Container(
                      key: _optionKeys[duration],
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                            (_highlighted ?? widget.entry.duration) == duration
                            ? theme.colorScheme.secondaryContainer
                            : null,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Semantics(
                        label: semanticLabel,
                        child: Text(
                          label,
                          key: ValueKey('beacon-duration-${duration.name}'),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(beaconClockProvider);
    final now = ref.read(clockProvider)();
    final l10n = AppLocalizations.of(context);
    final remaining = widget.entry.expiresAt.difference(now).inMicroseconds;
    final day = const Duration(days: 1).inMicroseconds;
    final label = remaining < day
        ? '<1'
        : ((remaining + day - 1) ~/ day).toString();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: l10n.beaconTimeLeft(label),
          child: Semantics(
            label: l10n.beaconTimeLeft(label),
            child: Text(label, key: const Key('beacon-days-left')),
          ),
        ),
        if (widget.onRefresh != null)
          MergeSemantics(
            child: Semantics(
              label: l10n.beaconRefresh,
              customSemanticsActions: {
                for (final (duration, _, semanticLabel) in _options(l10n))
                  CustomSemanticsAction(label: semanticLabel): () =>
                      widget.onRefresh?.call(duration),
              },
              child: Listener(
                onPointerCancel: (_) => _dismissPopup(),
                child: GestureDetector(
                  key: _buttonKey,
                  excludeFromSemantics: true,
                  onLongPressStart: _showPopup,
                  onLongPressMoveUpdate: (details) =>
                      _updateHighlight(details.globalPosition),
                  onLongPressEnd: _finishSelection,
                  onLongPressCancel: _dismissPopup,
                  child: Tooltip(
                    message: l10n.beaconRefresh,
                    triggerMode: TooltipTriggerMode.manual,
                    excludeFromSemantics: true,
                    child: IconButton(
                      key: const Key('refresh-beacon'),
                      icon: const Icon(Icons.refresh),
                      onPressed: () => widget.onRefresh?.call(null),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PopupPosition extends SingleChildLayoutDelegate {
  _PopupPosition({required this.anchor, required this.padding});

  final Rect anchor;
  final EdgeInsets padding;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      BoxConstraints(
        maxWidth: math.max(
          0,
          math.min(320, constraints.maxWidth - padding.horizontal - 16),
        ),
        maxHeight: math.max(0, constraints.maxHeight - padding.vertical),
      );

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final left = (anchor.center.dx - childSize.width / 2).clamp(
      padding.left,
      math.max(padding.left, size.width - padding.right - childSize.width),
    );
    final above = anchor.top - childSize.height - 4;
    final below = anchor.bottom + 4;
    final top = above >= padding.top
        ? above
        : below.clamp(
            padding.top,
            math.max(
              padding.top,
              size.height - padding.bottom - childSize.height,
            ),
          );
    return Offset(left.toDouble(), top.toDouble());
  }

  @override
  bool shouldRelayout(_PopupPosition oldDelegate) =>
      anchor != oldDelegate.anchor || padding != oldDelegate.padding;
}
