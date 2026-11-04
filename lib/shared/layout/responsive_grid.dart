import 'package:flutter/material.dart';

/// Grid whose cells are at least `width / childAspectRatio` tall but grow to
/// fit their content, so cards never overflow at in-between widths.
class ResponsiveGrid extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        if (wideColumns != null && constraints.maxWidth >= 900) {
          crossAxisCount = wideColumns!;
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
