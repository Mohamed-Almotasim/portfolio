import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/shared/demo/specimen_frame.dart';
import 'package:portfolio/shared/layout/inspectable.dart';

enum _Lang { en, ar }

class _Strings {
  const _Strings({
    required this.title,
    required this.subtotal,
    required this.delivery,
    required this.total,
    required this.checkout,
    required this.items,
    required this.months,
    required this.currency,
    required this.qty,
  });

  final String title, subtotal, delivery, total, checkout, currency, qty;
  final List<String> items;
  final List<String> months;
}

const _en = _Strings(
  title: 'Your cart',
  subtotal: 'Subtotal',
  delivery: 'Delivery by',
  total: 'Total',
  checkout: 'Checkout',
  currency: 'SAR',
  qty: 'Qty',
  items: ['Oak desk', 'Wool rug', 'Desk lamp'],
  months: [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', //
  ],
);

const _ar = _Strings(
  title: 'سلة التسوق',
  subtotal: 'المجموع الفرعي',
  delivery: 'التسليم بحلول',
  total: 'الإجمالي',
  checkout: 'إتمام الشراء',
  currency: 'ر.س',
  qty: 'الكمية',
  items: ['مكتب من خشب البلوط', 'سجادة صوف', 'مصباح مكتب'],
  months: [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر', //
  ],
);

const _prices = [1240, 680, 95];

/// 12345 → `12,345`, or `١٢٬٣٤٥` with Eastern Arabic numerals.
String formatNumber(int n, {required bool eastern}) {
  final g = groupDigits(n);
  if (!eastern) return g;
  const digits = '٠١٢٣٤٥٦٧٨٩';
  return g.split('').map((c) {
    final d = int.tryParse(c);
    return d != null ? digits[d] : (c == ',' ? '٬' : c);
  }).join();
}

String _formatDate(DateTime d, _Strings s, {required bool eastern}) =>
    '${formatNumber(d.day, eastern: eastern).replaceAll(RegExp('[,٬]'), '')} '
    '${s.months[d.month - 1]} '
    '${formatNumber(d.year, eastern: eastern).replaceAll(RegExp('[,٬]'), '')}';

/// Specimen 05: a cart that mirrors between English and Arabic: layout,
/// icons, numerals and dates, at any text size.
class RtlLocalizationSpecimen extends StatefulWidget {
  const RtlLocalizationSpecimen({super.key});

  @override
  State<RtlLocalizationSpecimen> createState() =>
      _RtlLocalizationSpecimenState();
}

class _RtlLocalizationSpecimenState extends State<RtlLocalizationSpecimen> {
  _Lang _lang = _Lang.en;
  bool _eastern = false;
  double _scale = 1;
  var _qty = [1, 1, 2];

  void _reset() => setState(() {
    _lang = _Lang.en;
    _eastern = false;
    _scale = 1;
    _qty = [1, 1, 2];
  });

  @override
  Widget build(BuildContext context) {
    final ar = _lang == _Lang.ar;
    final s = ar ? _ar : _en;
    final subtotal = [
      for (var i = 0; i < 3; i++) _prices[i] * _qty[i],
    ].reduce((a, b) => a + b);
    final delivery = DateTime(2026, 12, 3);
    String n(int v) => formatNumber(v, eastern: _eastern);

    return SpecimenFrame(
      label: 'Specimen · RTL and localization',
      onReset: _reset,
      readouts: [
        ('direction', ar ? 'rtl' : 'ltr'),
        ('locale', ar ? 'ar-SA' : 'en-US'),
        ('text size', '${(_scale * 100).round()}%'),
        ('subtotal', '${n(subtotal)} ${s.currency}'),
        ('date', _formatDate(delivery, s, eastern: _eastern)),
      ],
      controls: [
        SpecChoice<_Lang>(
          label: 'LANGUAGE',
          value: _lang,
          options: const [(_Lang.en, 'English'), (_Lang.ar, 'العربية')],
          onChanged: (l) => setState(() {
            _lang = l;
            _eastern = l == _Lang.ar;
          }),
        ),
        SpecSwitch(
          label: 'EASTERN ARABIC NUMERALS',
          value: _eastern,
          onChanged: (v) => setState(() => _eastern = v),
        ),
        SpecSlider(
          label: 'TEXT SIZE',
          value: _scale,
          min: 0.8,
          max: 2,
          divisions: 12,
          format: (v) => '${(v * 100).round()}%',
          onChanged: (v) => setState(() => _scale = v),
        ),
      ],
      demo: MediaQuery.withClampedTextScaling(
        minScaleFactor: _scale,
        maxScaleFactor: _scale,
        child: Directionality(
          textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
          child: Inspectable(
            label: 'Cart · ${ar ? 'rtl' : 'ltr'}',
            note:
                'Directionality flips the whole subtree. Padding and '
                'alignment use the Directional variants, so nothing is '
                'hard-coded left or right.',
            source:
                'lib/features/playground/specimens/rtl_localization.dart:148',
            child: _Cart(
              s: s,
              qty: _qty,
              n: n,
              subtotal: subtotal,
              date: _formatDate(delivery, s, eastern: _eastern),
              onQty: (i, d) =>
                  setState(() => _qty[i] = (_qty[i] + d).clamp(1, 99)),
            ),
          ),
        ),
      ),
    );
  }
}

class _Cart extends StatelessWidget {
  const _Cart({
    required this.s,
    required this.qty,
    required this.n,
    required this.subtotal,
    required this.date,
    required this.onQty,
  });

  final _Strings s;
  final List<int> qty;
  final String Function(int) n;
  final int subtotal;
  final String date;
  final void Function(int index, int delta) onQty;

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    final text = Theme.of(context).textTheme;
    final mute = text.labelMedium?.copyWith(color: deco.inkMute);

    Widget line(String a, String b, {TextStyle? style}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
      child: Row(
        children: [
          Expanded(child: Text(a, style: style ?? mute)),
          Text(b, style: style ?? text.labelMedium),
        ],
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.only(
        start: AppSpacing.s16,
        end: AppSpacing.s24,
        top: AppSpacing.s16,
        bottom: AppSpacing.s16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // arrow_back is a directional icon: it mirrors in RTL.
              const Icon(Icons.arrow_back, size: 20),
              const SizedBox(width: AppSpacing.s8),
              Text(s.title, style: text.titleLarge),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),
          for (var i = 0; i < 3; i++)
            Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: deco.rule)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsetsDirectional.only(
                      end: AppSpacing.s12,
                    ),
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.items[i], style: text.bodyMedium),
                        Text('${n(_prices[i])} ${s.currency}', style: mute),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: '-',
                    onPressed: () => onQty(i, -1),
                    icon: const Icon(Icons.remove, size: 18),
                  ),
                  Text(n(qty[i]), style: text.labelMedium),
                  IconButton(
                    tooltip: '+',
                    onPressed: () => onQty(i, 1),
                    icon: const Icon(Icons.add, size: 18),
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.s12),
          line(s.subtotal, '${n(subtotal)} ${s.currency}'),
          line(s.delivery, date),
          line(
            s.total,
            '${n(subtotal + 25)} ${s.currency}',
            style: text.titleMedium,
          ),
          const SizedBox(height: AppSpacing.s12),
          FilledButton(
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(s.checkout),
                const SizedBox(width: AppSpacing.s8),
                // chevron_right is a directional icon: it mirrors in RTL.
                const Icon(Icons.chevron_right, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
