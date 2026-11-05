import 'package:flutter/material.dart';

/// Grid whose cells are at least `width / childAspectRatio` tall but grow to
/// fit their content, so cards never overflow at in-between widths.
class ResponsiveGrid extends StatefulWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.childAspectRatio = 1,
    this.wideColumns,
  });

  final List<Widget> children;
  final double spacing;

  final double childAspectRatio;

  /// Column count from 900px up, e.g. 4 so four process steps share a row.
  final int? wideColumns;

  @override
  State<ResponsiveGrid> createState() => _ResponsiveGridState();
}

class _ResponsiveGridState extends State<ResponsiveGrid> {
  // RenderParagraph keeps its intrinsic-size text layout across font loads, so
  // IntrinsicHeight would keep fallback-font heights. Remount rows instead.
  var _fontGeneration = 0;

  void _fontsChanged() => setState(() => _fontGeneration++);

  @override
  void initState() {
    super.initState();
    PaintingBinding.instance.systemFonts.addListener(_fontsChanged);
  }

  @override
  void dispose() {
    PaintingBinding.instance.systemFonts.removeListener(_fontsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveGrid(:children, :spacing, :childAspectRatio, :wideColumns) =
        widget;
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        if (wideColumns != null && constraints.maxWidth >= 900) {
          crossAxisCount = wideColumns;
        } else if (constraints.maxWidth >= 1200) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth >= 900) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth >= 600) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 1;
        }
        final cellWidth =
            (constraints.maxWidth - spacing * (crossAxisCount - 1)) /
            crossAxisCount;
        final minCellHeight = cellWidth / childAspectRatio;

        return Column(
          children: [
            for (var row = 0; row < children.length; row += crossAxisCount) ...[
              if (row > 0) SizedBox(height: spacing),
              // Equal heights per row, sized to the tallest card.
              IntrinsicHeight(
                key: ValueKey((row, _fontGeneration)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = row; i < row + crossAxisCount; i++) ...[
                      if (i > row) SizedBox(width: spacing),
                      Expanded(
                        child: i < children.length
                            ? ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: minCellHeight,
                                ),
                                child: children[i],
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
