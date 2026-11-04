import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';

/// A bordered card that lifts on hover, trading its hairline for a shadow.
class HoverCard extends StatefulWidget {
  const HoverCard({
    super.key,
    required this.child,
    this.elevation = 1.0,
    this.hoverElevation = 4.0,
    this.hoverScale = 1.0,
  });

  final Widget child;

  /// Kept for call-site compatibility; resting cards are flat.
  final double elevation;
  final double hoverElevation;

  /// Grow slightly on hover, e.g. 1.02 for featured cards.
  final double hoverScale;

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
        transformAlignment: Alignment.center,
        transform: _isHovered
            ? (Matrix4.translationValues(0, -3, 0)
                ..scaleByDouble(widget.hoverScale, widget.hoverScale, 1, 1))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: radius,
          // Elevation is declared once: a hairline at rest, a shadow on hover.
          border: Border.all(
            color: _isHovered
                ? deco.cardBorder.withValues(alpha: 0)
                : deco.cardBorder,
          ),
          boxShadow: _isHovered ? deco.shadowElevated : null,
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
