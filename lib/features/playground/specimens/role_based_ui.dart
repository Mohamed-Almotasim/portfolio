import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/shared/demo/specimen_frame.dart';
import 'package:portfolio/shared/layout/inspectable.dart';

enum _Role { admin, staff, customer }

/// Every permission the screen asks about, with its public name.
enum _Perm {
  viewAll('orders.view_all'),
  edit('orders.edit'),
  refund('orders.refund'),
  export('orders.export'),
  cancelOwn('orders.cancel_own');

  const _Perm(this.key);
  final String key;

  /// Who holds it, in words.
  String needs(AppLocalizations l10n) => switch (this) {
    viewAll || edit => l10n.rbAdminOrStaff,
    refund || export => l10n.rbAdmin,
    cancelOwn => l10n.rbCustomer,
  };
}

String _roleLabel(AppLocalizations l10n, _Role role) => switch (role) {
  _Role.admin => l10n.rbAdmin,
  _Role.staff => l10n.rbStaff,
  _Role.customer => l10n.rbCustomer,
};

/// Orders keep English items and statuses as data; this is what is shown.
String _shown(AppLocalizations l10n, String value) => switch (value) {
  'Oak desk' => l10n.ocOakDesk,
  'Wool rug' => l10n.ocWoolRug,
  'Desk lamp' => l10n.ocDeskLamp,
  'Bookshelf' => l10n.ocBookshelf,
  'Side table' => l10n.ocSideTable,
  'Floor lamp' => l10n.ocFloorLamp,
  'Paid' => l10n.ocPaid,
  'Packing' => l10n.ocPacking,
  'Shipped' => l10n.ocShipped,
  'Refunded' => l10n.rbRefunded,
  'Cancelled' => l10n.rbCancelled,
  _ => value,
};

/// One table decides everything. The UI only ever asks `_can`.
const _grants = {
  _Role.admin: {_Perm.viewAll, _Perm.edit, _Perm.refund, _Perm.export},
  _Role.staff: {_Perm.viewAll, _Perm.edit},
  _Role.customer: {_Perm.cancelOwn},
};

bool _can(_Role role, _Perm perm) => _grants[role]!.contains(perm);

const _statuses = ['Paid', 'Packing', 'Shipped'];
const _me = 'Maya Lin';

class _Order {
  _Order(this.id, this.owner, this.item, this.amount, this.status);
  final String id, owner, item;
  final int amount;
  String status;
}

List<_Order> _seed() => [
  _Order('#2001', 'Maya Lin', 'Oak desk', 1240, 'Paid'),
  _Order('#2002', 'Omar Haddad', 'Wool rug', 680, 'Packing'),
  _Order('#2003', 'Maya Lin', 'Desk lamp', 95, 'Shipped'),
  _Order('#2004', 'Lena Park', 'Bookshelf', 2150, 'Paid'),
  _Order('#2005', 'Omar Haddad', 'Side table', 310, 'Shipped'),
  _Order('#2006', 'Lena Park', 'Floor lamp', 140, 'Packing'),
];

/// Specimen 02: one orders screen; the role decides what is visible and
/// what can be done, and every locked action says why.
class RoleBasedUiSpecimen extends StatefulWidget {
  const RoleBasedUiSpecimen({super.key});

  @override
  State<RoleBasedUiSpecimen> createState() => _RoleBasedUiSpecimenState();
}

class _RoleBasedUiSpecimenState extends State<RoleBasedUiSpecimen> {
  _Role _role = _Role.admin;
  var _orders = _seed();
  int _selected = 0;
  // The last permission asked and its answer, worded at build time so it
  // follows the language.
  (_Perm, bool)? _last;

  List<_Order> get _visible => _can(_role, _Perm.viewAll)
      ? _orders
      : _orders.where((o) => o.owner == _me).toList();

  void _reset() => setState(() {
    _role = _Role.admin;
    _orders = _seed();
    _selected = 0;
    _last = null;
  });

  /// Runs [action] if the role may, otherwise records why not.
  void _try(_Perm perm, void Function(_Order o) action) {
    final order = _visible[_selected.clamp(0, _visible.length - 1)];
    setState(() {
      final ok = _can(_role, perm);
      if (ok) action(order);
      _last = (perm, ok);
    });
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
    final allowed = _Perm.values.where((p) => _can(_role, p)).length;
    final deco = AppDecorations.of(context);
    final text = Theme.of(context).textTheme;
    final mute = text.labelMedium?.copyWith(color: deco.inkMute);
    final sel = visible[_selected.clamp(0, visible.length - 1)];
    final l10n = AppLocalizations.of(context);

    Widget action(String label, _Perm perm, void Function(_Order) run) {
      final ok = _can(_role, perm);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Locked buttons stay pressable: pressing one explains itself.
          OutlinedButton.icon(
            onPressed: () => _try(perm, run),
            icon: Icon(ok ? Icons.check : Icons.lock_outline, size: 16),
            label: Text(label),
            style: ok
                ? null
                : OutlinedButton.styleFrom(
                    foregroundColor: deco.inkMute,
                    side: BorderSide(color: deco.rule),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.s4),
            child: Text(
              ok ? perm.key : l10n.rbNeeds(perm.needs(l10n)),
              style: mute,
            ),
          ),
        ],
      );
    }

    return SpecimenFrame(
      label: 'Specimen · Role-based UI',
      onReset: _reset,
      readouts: [
        (l10n.role.toLowerCase(), _roleLabel(l10n, _role).toLowerCase()),
        (l10n.rbRowsVisible, '${visible.length} / ${_orders.length}'),
        (l10n.rbActionsAllowed, '$allowed / ${_Perm.values.length}'),
        (
          l10n.rbLastCheck,
          switch (_last) {
            null => l10n.rbNoneYet,
            (final p, true) => l10n.rbAllowed(p.key),
            (final p, false) => l10n.rbDenied(p.key, p.needs(l10n)),
          },
        ),
      ],
      controls: [
        SpecChoice<_Role>(
          label: l10n.role.toUpperCase(),
          value: _role,
          options: [for (final r in _Role.values) (r, _roleLabel(l10n, r))],
          onChanged: (r) => setState(() {
            _role = r;
            _selected = 0;
          }),
        ),
        Text(
          _role == _Role.customer
              ? l10n.rbSignedInAsMe(_me)
              : l10n.rbSignedInAsRole(_roleLabel(l10n, _role).toLowerCase()),
          style: mute,
        ),
      ],
      demo: Padding(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _can(_role, _Perm.viewAll) ? l10n.rbAllOrders : l10n.rbYourOrders,
              style: text.titleMedium,
            ),
            const SizedBox(height: AppSpacing.s8),
            Expanded(
              child: Inspectable(
                label: 'OrdersList',
                note:
                    'Customers get a filtered list (owner == me), not the '
                    'full list with rows hidden. Data they may not see never '
                    'reaches the widget.',
                source:
                    'lib/features/playground/specimens/role_based_ui.dart:199',
                child: ListView.builder(
                  itemCount: visible.length,
                  itemBuilder: (context, i) {
                    final o = visible[i];
                    final on = i == _selected;
                    return InkWell(
                      onTap: () => setState(() => _selected = i),
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 48),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s8,
                          vertical: AppSpacing.s8,
                        ),
                        decoration: BoxDecoration(
                          color: on
                              ? Theme.of(context).colorScheme.surfaceContainer
                              : null,
                          border: BorderDirectional(
                            bottom: BorderSide(color: deco.rule),
                            start: BorderSide(
                              color: on ? deco.accent : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 56, child: Text(o.id, style: mute)),
                            Expanded(
                              child: Text(
                                '${_shown(l10n, o.item)} · ${o.owner}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '\$${groupDigits(o.amount)}  '
                              '${_shown(l10n, o.status)}',
                              style: text.labelMedium,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            Text('${sel.id} · ${_shown(l10n, sel.item)}', style: mute),
            const SizedBox(height: AppSpacing.s8),
            Inspectable(
              label: 'ActionBar',
              note:
                  'Each button asks _can(role, permission). Locked ones stay '
                  'visible, say what they need, and explain when pressed.',
              source:
                  'lib/features/playground/specimens/role_based_ui.dart:257',
              child: Wrap(
                spacing: AppSpacing.s16,
                runSpacing: AppSpacing.s12,
                children: [
                  action(l10n.rbAdvance, _Perm.edit, (o) {
                    final next =
                        (_statuses.indexOf(o.status) + 1) % _statuses.length;
                    o.status = _statuses[next];
                  }),
                  action(
                    l10n.rbRefund,
                    _Perm.refund,
                    (o) => o.status = 'Refunded',
                  ),
                  action(l10n.rbExport, _Perm.export, (_) {}),
                  action(
                    l10n.rbCancelMine,
                    _Perm.cancelOwn,
                    (o) => o.status = 'Cancelled',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
