import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/shared/demo/specimen_frame.dart';
import 'package:portfolio/shared/layout/inspectable.dart';

enum _Role { admin, staff, customer }

/// Every permission the screen asks about, with its public name.
enum _Perm {
  viewAll('orders.view_all', 'Admin or Staff'),
  edit('orders.edit', 'Admin or Staff'),
  refund('orders.refund', 'Admin'),
  export('orders.export', 'Admin'),
  cancelOwn('orders.cancel_own', 'Customer');

  const _Perm(this.key, this.needs);
  final String key;
  final String needs;
}

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
  String _last = 'none yet';

  List<_Order> get _visible => _can(_role, _Perm.viewAll)
      ? _orders
      : _orders.where((o) => o.owner == _me).toList();

  void _reset() => setState(() {
    _role = _Role.admin;
    _orders = _seed();
    _selected = 0;
    _last = 'none yet';
  });

  /// Runs [action] if the role may, otherwise records why not.
  void _try(_Perm perm, void Function(_Order o) action) {
    final order = _visible[_selected.clamp(0, _visible.length - 1)];
    setState(() {
      if (_can(_role, perm)) {
        action(order);
        _last = 'allowed ${perm.key}';
      } else {
        _last = 'denied ${perm.key} (needs ${perm.needs})';
      }
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
            child: Text(ok ? perm.key : 'Needs ${perm.needs}', style: mute),
          ),
        ],
      );
    }

    return SpecimenFrame(
      label: 'Specimen · Role-based UI',
      onReset: _reset,
      readouts: [
        ('role', _role.name),
        ('rows visible', '${visible.length} / ${_orders.length}'),
        ('actions allowed', '$allowed / ${_Perm.values.length}'),
        ('last check', _last),
      ],
      controls: [
        SpecChoice<_Role>(
          label: 'ROLE',
          value: _role,
          options: [
            for (final r in _Role.values)
              (r, r.name[0].toUpperCase() + r.name.substring(1)),
          ],
          onChanged: (r) => setState(() {
            _role = r;
            _selected = 0;
          }),
        ),
        Text(
          _role == _Role.customer
              ? 'Signed in as $_me.'
              : 'Signed in as a ${_role.name} account.',
          style: mute,
        ),
      ],
      demo: Padding(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _can(_role, _Perm.viewAll) ? 'All orders' : 'Your orders',
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
                    'lib/features/playground/specimens/role_based_ui.dart:163',
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
                          border: Border(
                            bottom: BorderSide(color: deco.rule),
                            left: BorderSide(
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
                                '${o.item} · ${o.owner}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '\$${groupDigits(o.amount)}  ${o.status}',
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
            Text('${sel.id} · ${sel.item}', style: mute),
            const SizedBox(height: AppSpacing.s8),
            Inspectable(
              label: 'ActionBar',
              note:
                  'Each button asks _can(role, permission). Locked ones stay '
                  'visible, say what they need, and explain when pressed.',
              source:
                  'lib/features/playground/specimens/role_based_ui.dart:220',
              child: Wrap(
                spacing: AppSpacing.s16,
                runSpacing: AppSpacing.s12,
                children: [
                  action('Advance status', _Perm.edit, (o) {
                    final next =
                        (_statuses.indexOf(o.status) + 1) % _statuses.length;
                    o.status = _statuses[next];
                  }),
                  action('Refund', _Perm.refund, (o) => o.status = 'Refunded'),
                  action('Export CSV', _Perm.export, (_) {}),
                  action(
                    'Cancel mine',
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
