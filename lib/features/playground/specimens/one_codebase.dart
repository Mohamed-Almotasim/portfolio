import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/shared/demo/specimen_frame.dart';

/// Specimen: one widget tree that is a phone, tablet and desktop app,
/// resized live with a drag handle. Selection survives every switch.
class OneCodebaseSpecimen extends StatefulWidget {
  const OneCodebaseSpecimen({super.key});

  static const sourcePath =
      'lib/features/playground/specimens/one_codebase.dart';

  @override
  State<OneCodebaseSpecimen> createState() => _OneCodebaseSpecimenState();
}

class _OneCodebaseSpecimenState extends State<OneCodebaseSpecimen> {
  static const _min = 320.0, _max = 1280.0;
  double _width = 390;
  // App state lives above the layout switch, so it survives it.
  int _tab = 0;
  int? _selected = 1;

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    final label = Theme.of(
      context,
    ).textTheme.labelSmall?.copyWith(color: deco.inkMute);
    final mode = _width < 600
        ? 'phone'
        : _width < 1024
        ? 'tablet'
        : 'desktop';

    return SpecimenFrame(
      title: 'One codebase',
      why:
          'One widget tree has to be a phone, a tablet and a desktop app, and '
          'keep what you selected while it changes shape.',
      sourcePath: OneCodebaseSpecimen.sourcePath,
      demoHeight: 440,
      demo: LayoutBuilder(
        builder: (context, c) {
          // Render at the real width, scaled down when the well is narrower.
          const handle = 20.0;
          final scale = math.min(1.0, (c.maxWidth - 32) / (_width + handle));
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.s16),
            child: Align(
              alignment: Alignment.topLeft,
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: _width + handle,
                  height: (c.maxHeight - 32) / scale,
                  child: Row(
                    children: [
                      SizedBox(
                        width: _width,
                        child: _MiniApp(
                          tab: _tab,
                          selected: _selected,
                          onTab: (t) => setState(() => _tab = t),
                          onSelect: (i) => setState(() => _selected = i),
                        ),
                      ),
                      _Handle(
                        onDrag: (dx) => setState(
                          () =>
                              _width = (_width + dx / scale).clamp(_min, _max),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      controls: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('w = ${_width.round()} → $mode', style: label),
          SpecSlider(
            label: 'width',
            value: _width,
            min: _min,
            max: _max,
            onChanged: (v) => setState(() => _width = v),
          ),
          Wrap(
            spacing: AppSpacing.s4,
            children: [
              for (final (name, w) in [
                ('Phone', 390.0),
                ('Tablet', 820.0),
                ('Desktop', 1200.0),
              ])
                TextButton(
                  onPressed: () => setState(() => _width = w),
                  child: Text(name),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.s8),
          Text('Breakpoints at 600 and 1024.', style: label),
        ],
      ),
    );
  }
}

/// The drag handle on the app's right edge. Keyboard users use the slider.
class _Handle extends StatelessWidget {
  const _Handle({required this.onDrag});

  final ValueChanged<double> onDrag;

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    return ExcludeSemantics(
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeLeftRight,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragUpdate: (d) => onDrag(d.delta.dx),
          child: Container(
            width: 20,
            color: deco.accent,
            alignment: Alignment.center,
            child: Container(width: 2, height: 32, color: deco.onAccent),
          ),
        ),
      ),
    );
  }
}

// #region snippet
/// The demo app. Its layout is chosen from its own width, never the
/// screen's, and its state comes from above, so resizing never loses it.
class _MiniApp extends StatelessWidget {
  const _MiniApp({
    required this.tab,
    required this.selected,
    required this.onTab,
    required this.onSelect,
  });

  final int tab;
  final int? selected;
  final ValueChanged<int> onTab;
  final ValueChanged<int?> onSelect;

  static const _tabs = [
    (Icons.inbox_outlined, 'Orders'),
    (Icons.local_shipping_outlined, 'Shipping'),
    (Icons.settings_outlined, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, c) {
        final list = _OrderList(selected: selected, onSelect: onSelect);
        final detail = _OrderDetail(
          index: selected,
          onBack: c.maxWidth < 1024 ? () => onSelect(null) : null,
        );
        final Widget body;
        if (c.maxWidth >= 1024) {
          body = Row(
            children: [
              SizedBox(width: 300, child: list),
              const VerticalDivider(width: 1),
              Expanded(child: detail),
            ],
          );
        } else {
          body = selected == null ? list : detail;
        }

        if (c.maxWidth < 600) {
          return Material(
            color: scheme.surface,
            child: Column(
              children: [
                Expanded(child: body),
                NavigationBar(
                  height: 64,
                  selectedIndex: tab,
                  onDestinationSelected: onTab,
                  destinations: [
                    for (final (icon, label) in _tabs)
                      NavigationDestination(icon: Icon(icon), label: label),
                  ],
                ),
              ],
            ),
          );
        }
        return Material(
          color: scheme.surface,
          child: Row(
            children: [
              NavigationRail(
                selectedIndex: tab,
                onDestinationSelected: onTab,
                labelType: NavigationRailLabelType.all,
                destinations: [
                  for (final (icon, label) in _tabs)
                    NavigationRailDestination(
                      icon: Icon(icon),
                      label: Text(label),
                    ),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(child: body),
            ],
          ),
        );
      },
    );
  }
}
// #endregion

const _orders = [
  ('#1042', 'Oak desk', 'Shipped'),
  ('#1043', 'Wool rug', 'Packing'),
  ('#1044', 'Desk lamp', 'Paid'),
  ('#1045', 'Bookshelf', 'Shipped'),
  ('#1046', 'Side table', 'Paid'),
  ('#1047', 'Floor lamp', 'Packing'),
];

class _OrderList extends StatelessWidget {
  const _OrderList({required this.selected, required this.onSelect});

  final int? selected;
  final ValueChanged<int?> onSelect;

  @override
  Widget build(BuildContext context) {
    final mono = Theme.of(context).textTheme.labelSmall;
    return ListView.separated(
      itemCount: _orders.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final (id, item, status) = _orders[i];
        return ListTile(
          selected: selected == i,
          title: Text(item),
          subtitle: Text(id, style: mono),
          trailing: Text(status, style: mono),
          onTap: () => onSelect(i),
        );
      },
    );
  }
}

class _OrderDetail extends StatelessWidget {
  const _OrderDetail({required this.index, this.onBack});

  final int? index;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    if (index == null) {
      return Center(child: Text('Select an order', style: text.bodyMedium));
    }
    final (id, item, status) = _orders[index!];
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.s24),
      children: [
        if (onBack != null)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(onPressed: onBack, child: const Text('← Orders')),
          ),
        Text(item, style: text.headlineSmall),
        const SizedBox(height: AppSpacing.s8),
        Text('$id · $status', style: text.labelMedium),
        const SizedBox(height: AppSpacing.s24),
        Text(
          'The same detail widget is a full page on a phone and a pane on '
          'a desktop. Only the layout around it changes.',
          style: text.bodyMedium,
        ),
      ],
    );
  }
}
