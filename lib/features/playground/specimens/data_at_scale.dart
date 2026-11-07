import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/shared/demo/specimen_frame.dart';
import 'package:portfolio/shared/layout/inspectable.dart';

typedef _Row = ({int id, String name, int amount, String status});

enum _Sort { id, name, amount }

const _first = [
  'Maya',
  'Omar',
  'Lena',
  'Sami',
  'Nora',
  'Yusuf',
  'Hana',
  'Idris',
];
const _last = ['Lin', 'Haddad', 'Park', 'Khan', 'Diaz', 'Aziz', 'Berg', 'Noor'];
const _states = ['Open', 'Paid', 'Late'];

/// Fake but stable: the same index is always the same row.
List<_Row> _generate(int n) => [
  for (var i = 1; i <= n; i++)
    (
      id: 10000 + i,
      name: '${_first[i * 7 % 8]} ${_last[i * 13 % 8]}',
      amount: 20 + (i * 7919) % 4980,
      status: _states[i * 31 % 3],
    ),
];

/// Specimen 03: ten thousand rows with search, sort and filter. A switch
/// compares building every row with building only the visible ones.
class DataAtScaleSpecimen extends StatefulWidget {
  const DataAtScaleSpecimen({super.key});

  @override
  State<DataAtScaleSpecimen> createState() => _DataAtScaleSpecimenState();
}

class _DataAtScaleSpecimenState extends State<DataAtScaleSpecimen> {
  static const _naiveCap = 10000;
  static const _rowHeight = 36.0;

  final _search = TextEditingController();
  final _frames = <double>[];
  Timer? _tick;
  int _count = 10000;
  bool _virtual = true;
  _Sort _sort = _Sort.id;
  String _status = 'All';
  late List<_Row> _all = _generate(_count);
  late List<_Row> _shown;
  late Widget _list;
  // Rows currently built, counted by the rows themselves.
  int _built = 0;
  double _ms = 0;

  @override
  void initState() {
    super.initState();
    _apply();
    SchedulerBinding.instance.addTimingsCallback(_onTimings);
    // Readouts refresh twice a second; the list widget itself is cached, so
    // this never rebuilds the rows.
    _tick = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _tick?.cancel();
    SchedulerBinding.instance.removeTimingsCallback(_onTimings);
    _search.dispose();
    super.dispose();
  }

  void _onTimings(List<FrameTiming> timings) {
    for (final t in timings) {
      _frames.add(t.totalSpan.inMicroseconds / 1000);
    }
    if (_frames.length > 30) _frames.removeRange(0, _frames.length - 30);
    _ms = _frames.reduce((a, b) => a + b) / _frames.length;
  }

  void _countRow(int delta) => _built += delta;

  /// Recomputes the rows and the cached list widget.
  void _apply() {
    final q = _search.text.trim().toLowerCase();
    final rows = _all
        .where(
          (r) =>
              (_status == 'All' || r.status == _status) &&
              (q.isEmpty ||
                  r.name.toLowerCase().contains(q) ||
                  '${r.id}'.contains(q)),
        )
        .toList();
    switch (_sort) {
      case _Sort.id:
        break;
      case _Sort.name:
        rows.sort((a, b) => a.name.compareTo(b.name));
      case _Sort.amount:
        rows.sort((a, b) => b.amount.compareTo(a.amount));
    }
    _shown = rows;
    // _built needs no reset: old rows count themselves out, new ones in.
    _list = _RowList(
      // A new key remounts the list, so the built-rows counter restarts.
      key: ValueKey((_virtual, _count, _search.text, _sort, _status)),
      rows: _virtual ? rows : rows.take(_naiveCap).toList(),
      virtual: _virtual,
      height: _rowHeight,
      onCount: _countRow,
    );
  }

  void _change(VoidCallback f) => setState(() {
    f();
    _apply();
  });

  void _reset() {
    _search.clear();
    _change(() {
      _count = 10000;
      _virtual = true;
      _sort = _Sort.id;
      _status = 'All';
      _all = _generate(_count);
    });
  }

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    final mute = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(color: deco.inkMute);
    final capped = !_virtual && _shown.length > _naiveCap;

    return SpecimenFrame(
      label: 'Specimen · Data at scale',
      onReset: _reset,
      readouts: [
        (
          'rows built',
          '${groupDigits(_built)} / ${groupDigits(_shown.length)}',
        ),
        ('matching', '${groupDigits(_shown.length)} of ${groupDigits(_count)}'),
        ('frame time', _ms == 0 ? '—' : '${_ms.toStringAsFixed(1)} ms'),
        (
          'list',
          capped
              ? 'naive, first 10,000'
              : _virtual
              ? 'virtualized'
              : 'naive',
        ),
      ],
      controls: [
        SpecChoice<bool>(
          label: 'LIST',
          value: _virtual,
          options: const [(false, 'Naive'), (true, 'Virtualized')],
          onChanged: (v) => _change(() => _virtual = v),
        ),
        SpecChoice<int>(
          label: 'ROWS',
          value: _count,
          options: [
            for (final n in [1000, 10000, 50000]) (n, groupDigits(n)),
          ],
          onChanged: (n) => _change(() {
            _count = n;
            _all = _generate(n);
          }),
        ),
        SpecChoice<_Sort>(
          label: 'SORT',
          value: _sort,
          options: const [
            (_Sort.id, 'ID'),
            (_Sort.name, 'Name'),
            (_Sort.amount, 'Amount'),
          ],
          onChanged: (s) => _change(() => _sort = s),
        ),
        SpecChoice<String>(
          label: 'STATUS',
          value: _status,
          options: [
            for (final s in ['All', ..._states]) (s, s),
          ],
          onChanged: (s) => _change(() => _status = s),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SEARCH', style: mute),
            const SizedBox(height: AppSpacing.s8),
            TextField(
              controller: _search,
              onChanged: (_) => _change(() {}),
              decoration: const InputDecoration(hintText: 'Name or ID'),
            ),
          ],
        ),
      ],
      demo: Inspectable(
        label: 'RowList',
        note:
            'Virtualized: ListView.builder with a fixed itemExtent builds '
            'only what is on screen. Naive: every row is built up front.',
        source: 'lib/features/playground/specimens/data_at_scale.dart:220',
        child: _shown.isEmpty
            ? Center(child: Text('No rows match.', style: mute))
            : _list,
      ),
    );
  }
}

class _RowList extends StatelessWidget {
  const _RowList({
    super.key,
    required this.rows,
    required this.virtual,
    required this.height,
    required this.onCount,
  });

  final List<_Row> rows;
  final bool virtual;
  final double height;
  final void Function(int delta) onCount;

  @override
  Widget build(BuildContext context) {
    Widget row(_Row r) => _Cell(row: r, height: height, onCount: onCount);
    if (virtual) {
      return ListView.builder(
        itemCount: rows.length,
        itemExtent: height,
        itemBuilder: (_, i) => row(rows[i]),
      );
    }
    return SingleChildScrollView(
      child: Column(children: [for (final r in rows) row(r)]),
    );
  }
}

/// One row. Reports when it is built and when it is dropped.
class _Cell extends StatefulWidget {
  const _Cell({required this.row, required this.height, required this.onCount});

  final _Row row;
  final double height;
  final void Function(int delta) onCount;

  @override
  State<_Cell> createState() => _CellState();
}

class _CellState extends State<_Cell> {
  @override
  void initState() {
    super.initState();
    widget.onCount(1);
  }

  @override
  void dispose() {
    widget.onCount(-1);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.row;
    final mono = Theme.of(context).textTheme.labelMedium;
    final deco = AppDecorations.of(context);
    return Container(
      height: widget.height,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: deco.rule)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: Text('${r.id}', style: mono?.copyWith(color: deco.inkMute)),
          ),
          Expanded(child: Text(r.name, overflow: TextOverflow.ellipsis)),
          SizedBox(
            width: 72,
            child: Text(
              '\$${groupDigits(r.amount)}',
              style: mono,
              textAlign: TextAlign.end,
            ),
          ),
          SizedBox(
            width: 52,
            child: Text(r.status, style: mono, textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}
