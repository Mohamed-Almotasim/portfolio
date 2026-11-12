import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/shared/demo/specimen_frame.dart';
import 'package:portfolio/shared/layout/inspectable.dart';

enum _SizeClass { phone, tablet, desktop }

_SizeClass _classOf(double w) => w < 600
    ? _SizeClass.phone
    : w < 1024
    ? _SizeClass.tablet
    : _SizeClass.desktop;

/// Specimen 01: one widget tree that is a phone, tablet and desktop app,
/// resized live with a drag handle. Selection survives every switch.
class OneCodebaseSpecimen extends StatefulWidget {
  const OneCodebaseSpecimen({super.key});

  @override
  State<OneCodebaseSpecimen> createState() => _OneCodebaseSpecimenState();
}

class _OneCodebaseSpecimenState extends State<OneCodebaseSpecimen> {
  static const _min = 320.0, _max = 1280.0;
  static const _presets = {
    _SizeClass.phone: 390.0,
    _SizeClass.tablet: 820.0,
    _SizeClass.desktop: 1200.0,
  };
  double _width = 390;
  // App state lives above the layout switch, so it survives it.
  int _tab = 0;
  int? _selected = 1;
  bool _detailOpen = false;

  void _reset() => setState(() {
    _width = 390;
    _tab = 0;
    _selected = 1;
    _detailOpen = false;
  });

  @override
  Widget build(BuildContext context) {
    final cls = _classOf(_width);
    final l10n = AppLocalizations.of(context);
    String className(_SizeClass c) => switch (c) {
      _SizeClass.phone => l10n.ocPhone,
      _SizeClass.tablet => l10n.ocTablet,
      _SizeClass.desktop => l10n.ocDesktop,
    };
    return SpecimenFrame(
      label: 'Specimen · One codebase',
      onReset: _reset,
      readouts: [
        (l10n.ocWidth, '${_width.round()} px'),
        (l10n.ocSizeClass, className(cls)),
        (
          l10n.ocSelected,
          _selected == null ? l10n.ocNone : _orders(l10n)[_selected!].$1,
        ),
        (
          l10n.ocLayout,
          cls == _SizeClass.desktop ? l10n.ocListDetail : l10n.ocOnePane,
        ),
      ],
      controls: [
        SpecChoice<_SizeClass>(
          label: l10n.ocSizeClass.toUpperCase(),
          value: cls,
          options: [
            for (final c in _SizeClass.values)
              (c, className(c)[0].toUpperCase() + className(c).substring(1)),
          ],
          onChanged: (c) => setState(() => _width = _presets[c]!),
        ),
        SpecSlider(
          label: l10n.ocWidth.toUpperCase(),
          value: _width,
          min: _min,
          max: _max,
          onChanged: (v) => setState(() => _width = v),
        ),
      ],
      demo: LayoutBuilder(
        builder: (context, c) {
          // Render at the real width, scaled down when the well is narrower.
          const handle = 20.0;
          final scale = math.min(1.0, (c.maxWidth - 32) / (_width + handle));
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.s16),
            child: Align(
              alignment: AlignmentDirectional.topStart,
              // FittedBox, not Transform.scale: the child must lay out at its
              // real width, which Transform would clamp to the well (overflow).
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.topStart,
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
                          detailOpen: _detailOpen,
                          onTab: (t) => setState(() => _tab = t),
                          onSelect: (i) => setState(() {
                            _selected = i;
                            _detailOpen = true;
                          }),
                          onBack: () => setState(() => _detailOpen = false),
                        ),
                      ),
                      _Handle(
                        onDrag: (dx) => setState(
                          // The handle is on the app's end edge: left in RTL.
                          () => _width =
                              (_width +
                                      (Directionality.of(context) ==
                                                  TextDirection.rtl
                                              ? -dx
                                              : dx) /
                                          scale)
                                  .clamp(_min, _max),
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
    );
  }
}

/// The drag handle on the app's right edge: a thin line with a small grip,
/// accent only while hovered or dragged. Keyboard users use the slider.
class _Handle extends StatefulWidget {
  const _Handle({required this.onDrag});

  final ValueChanged<double> onDrag;

  @override
  State<_Handle> createState() => _HandleState();
}

class _HandleState extends State<_Handle> {
  bool _hot = false, _drag = false;

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    final color = _hot || _drag ? deco.accent : deco.ruleStrong;
    return ExcludeSemantics(
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeLeftRight,
        onEnter: (_) => setState(() => _hot = true),
        onExit: (_) => setState(() => _hot = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: (_) => setState(() => _drag = true),
          onHorizontalDragEnd: (_) => setState(() => _drag = false),
          onHorizontalDragCancel: () => setState(() => _drag = false),
          onHorizontalDragUpdate: (d) => widget.onDrag(d.delta.dx),
          child: SizedBox(
            width: 20,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(width: 3, color: color),
                  Container(
                    width: 10,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(color: color),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < 2; i++)
                          Container(
                            width: 1,
                            height: 14,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            color: color,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The demo app. Its layout is chosen from its own width, never the
/// screen's, and its state comes from above, so resizing never loses it.
class _MiniApp extends StatelessWidget {
  const _MiniApp({
    required this.tab,
    required this.selected,
    required this.detailOpen,
    required this.onTab,
    required this.onSelect,
    required this.onBack,
  });

  final int tab;
  final int? selected;
  final bool detailOpen;
  final ValueChanged<int> onTab;
  final ValueChanged<int> onSelect;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final tabs = [
      (Icons.inbox_outlined, l10n.ocOrders),
      (Icons.local_shipping_outlined, l10n.ocShipping),
      (Icons.settings_outlined, l10n.ocSettings),
    ];
    return LayoutBuilder(
      builder: (context, c) {
        final wide = c.maxWidth >= 1024;
        final list = _OrderList(selected: selected, onSelect: onSelect);
        final detail = _OrderDetail(
          index: selected,
          onBack: wide ? null : onBack,
        );
        final Widget body;
        if (tab != 0) {
          body = _OtherTab(name: tabs[tab].$2, shipping: tab == 1);
        } else if (wide) {
          body = Row(
            children: [
              SizedBox(width: 300, child: list),
              const VerticalDivider(width: 1),
              Expanded(child: detail),
            ],
          );
        } else {
          body = detailOpen && selected != null ? detail : list;
        }

        if (c.maxWidth < 600) {
          return Inspectable(
            label: 'MiniApp · phone',
            note:
                'Under 600 px: one pane and a bottom NavigationBar. The same '
                'list and detail widgets as on desktop.',
            source: 'lib/features/playground/specimens/one_codebase.dart:265',
            child: Material(
              color: scheme.surface,
              child: Column(
                children: [
                  Expanded(child: body),
                  NavigationBar(
                    height: 64,
                    selectedIndex: tab,
                    onDestinationSelected: onTab,
                    destinations: [
                      for (final (icon, label) in tabs)
                        NavigationDestination(icon: Icon(icon), label: label),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        return Inspectable(
          label: wide ? 'MiniApp · desktop' : 'MiniApp · tablet',
          note: wide
              ? 'From 1024 px: a NavigationRail, and the list and the detail '
                    'side by side.'
              : '600 to 1023 px: a NavigationRail and one pane at a time.',
          source: 'lib/features/playground/specimens/one_codebase.dart:290',
          child: Material(
            color: scheme.surface,
            child: Row(
              children: [
                NavigationRail(
                  selectedIndex: tab,
                  onDestinationSelected: onTab,
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    for (final (icon, label) in tabs)
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
          ),
        );
      },
    );
  }
}

List<(String, String, String)> _orders(AppLocalizations l10n) => [
  ('#1042', l10n.ocOakDesk, l10n.ocShipped),
  ('#1043', l10n.ocWoolRug, l10n.ocPacking),
  ('#1044', l10n.ocDeskLamp, l10n.ocPaid),
  ('#1045', l10n.ocBookshelf, l10n.ocShipped),
  ('#1046', l10n.ocSideTable, l10n.ocPaid),
  ('#1047', l10n.ocFloorLamp, l10n.ocPacking),
];

class _OtherTab extends StatelessWidget {
  const _OtherTab({required this.name, required this.shipping});

  final String name;
  final bool shipping;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final mute = text.labelMedium?.copyWith(
      color: AppDecorations.of(context).inkMute,
    );
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: text.headlineSmall),
          const SizedBox(height: AppSpacing.s12),
          for (final line
              in shipping
                  ? [l10n.ocCarrierA, l10n.ocCarrierB, l10n.ocPickup]
                  : [l10n.ocNotifications, l10n.ocCurrency, l10n.ocLanguage])
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.s8),
              child: Text(line, style: mute),
            ),
        ],
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  const _OrderList({required this.selected, required this.onSelect});

  final int? selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final mono = Theme.of(context).textTheme.labelSmall;
    final orders = _orders(AppLocalizations.of(context));
    return ListView.separated(
      itemCount: orders.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final (id, item, status) = orders[i];
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
    final l10n = AppLocalizations.of(context);
    if (index == null) {
      return Center(child: Text(l10n.ocSelectOrder, style: text.bodyMedium));
    }
    final (id, item, status) = _orders(l10n)[index!];
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.s24),
      children: [
        if (onBack != null)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              onPressed: onBack,
              // Back points against the reading direction.
              child: Text(
                '${Directionality.of(context) == TextDirection.rtl ? '→' : '←'} '
                '${l10n.ocOrders}',
              ),
            ),
          ),
        Text(item, style: text.headlineSmall),
        const SizedBox(height: AppSpacing.s8),
        Text('$id · $status', style: text.labelMedium),
        const SizedBox(height: AppSpacing.s24),
        Text(l10n.ocDetailBlurb, style: text.bodyMedium),
      ],
    );
  }
}
