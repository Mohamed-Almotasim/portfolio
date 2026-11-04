import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';

/// A bordered card that lifts slightly and deepens its shadow on hover.
class HoverCard extends StatefulWidget {
  const HoverCard({
    super.key,
    required this.child,
    this.elevation = 1.0,
    this.hoverElevation = 4.0,
  });

  final Widget child;

  /// Kept for call-site compatibility: 0 means no resting shadow.
  final double elevation;
  final double hoverElevation;

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    final radius = BorderRadius.circular(AppRadius.lg);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        margin: const EdgeInsets.all(AppSpacing.s8),
        transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: radius,
          border: Border.all(color: deco.cardBorder),
          boxShadow: _isHovered
              ? deco.shadowElevated
              : (widget.elevation > 0 ? deco.shadowSoft : null),
        ),
        child: ClipRRect(
          borderRadius: radius,
          // Ink from buttons inside must paint above our decoration.
          child: Material(type: MaterialType.transparency, child: widget.child),
        ),
      ),
    );
  }
}
