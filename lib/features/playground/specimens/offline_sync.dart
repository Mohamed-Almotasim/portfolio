import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/shared/demo/specimen_frame.dart';
import 'package:portfolio/shared/layout/inspectable.dart';

enum _Sync { synced, pending, failed }

class _Task {
  _Task(this.id, this.title, {this.done = false});
  final int id;
  final String title;
  bool done;
  _Sync sync = _Sync.synced;
  int tries = 0;
}

const _titles = [
  'Pack order #2041',
  'Call supplier',
  'Print labels',
  'Restock shelf B',
  'Refund order #2037',
  'Book courier',
];

List<_Task> _seed() => [
  _Task(1, 'Check inventory', done: true),
  _Task(2, 'Pack order #2040'),
  _Task(3, 'Email the courier'),
];

/// Specimen 04: tasks that work offline. Changes show at once (optimistic),
/// join a queue, and are sent when the network allows, with retries. The
/// network is simulated: latency and failures come from the controls.
class OfflineSyncSpecimen extends StatefulWidget {
  const OfflineSyncSpecimen({super.key});

  @override
  State<OfflineSyncSpecimen> createState() => _OfflineSyncSpecimenState();
}

class _OfflineSyncSpecimenState extends State<OfflineSyncSpecimen> {
  static const _maxTries = 3;

  var _tasks = _seed();
  final _queue = <_Task>[];
  // Seeded, so the same settings always fail in the same places.
  var _rng = math.Random(7);
  Timer? _flight;
  Timer? _load;
  bool _online = true;
  bool _busy = false;
  bool _loading = false;
  bool _error = false;
  double _latency = 600;
  double _failPct = 20;
  int _nextId = 4;
  int _retries = 0;
  int _sent = 0;

  @override
  void dispose() {
    _flight?.cancel();
    _load?.cancel();
    super.dispose();
  }

  void _reset() {
    _flight?.cancel();
    _load?.cancel();
    setState(() {
      _tasks = _seed();
      _queue.clear();
      _rng = math.Random(7);
      _online = true;
      _busy = false;
      _loading = false;
      _error = false;
      _latency = 600;
      _failPct = 20;
      _nextId = 4;
      _retries = 0;
      _sent = 0;
    });
  }

  /// Sends the first queued change. One at a time, in order; a failure is
  /// retried up to three times, then the task is marked failed.
  void _pump() {
    if (_busy || !_online || _queue.isEmpty) return;
    _busy = true;
    final task = _queue.first;
    _flight = Timer(Duration(milliseconds: _latency.round()), () {
      _busy = false;
      if (!mounted) return;
      setState(() {
        if (!_online) return; // dropped mid-flight: stays queued
        if (_rng.nextInt(100) < _failPct) {
          task.tries++;
          _retries++;
          if (task.tries >= _maxTries) {
            _queue.remove(task);
            task.sync = _Sync.failed;
          }
        } else {
          _queue.remove(task);
          task.sync = _Sync.synced;
          task.tries = 0;
          _sent++;
        }
      });
      _pump();
    });
  }

  void _enqueue(_Task t) {
    t.sync = _Sync.pending;
    t.tries = 0;
    if (!_queue.contains(t)) _queue.add(t);
    _pump();
  }

  void _add() => setState(() {
    final t = _Task(_nextId, _titles[_nextId % _titles.length]);
    _nextId++;
    _tasks.add(t);
    _enqueue(t);
  });

  void _toggle(_Task t) => setState(() {
    t.done = !t.done;
    _enqueue(t);
  });

  void _reload() {
    _load?.cancel();
    setState(() {
      _loading = true;
      _error = false;
    });
    _load = Timer(Duration(milliseconds: _latency.round()), () {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = !_online;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    final text = Theme.of(context).textTheme;
    final mute = text.labelMedium?.copyWith(color: deco.inkMute);
    final failed = _tasks.where((t) => t.sync == _Sync.failed).length;

    Widget body;
    if (_loading) {
      body = Column(
        children: [
          for (var i = 0; i < 3; i++)
            Container(
              height: 48,
              margin: const EdgeInsets.only(bottom: AppSpacing.s8),
              decoration: BoxDecoration(border: Border.all(color: deco.rule)),
            ),
        ],
      );
    } else if (_error) {
      body = _Notice(
        title: "Couldn't reload",
        body: 'No connection. Showing what is saved on this device.',
        action: 'Try again',
        onAction: _reload,
      );
    } else if (_tasks.isEmpty) {
      body = _Notice(
        title: 'No tasks yet',
        body: 'Add one. It will sync when it can.',
        action: 'Add task',
        onAction: _add,
      );
    } else {
      body = Column(
        children: [
          for (final t in _tasks)
            _TaskRow(
              task: t,
              maxTries: _maxTries,
              onToggle: () => _toggle(t),
              onRetry: () => setState(() => _enqueue(t)),
            ),
        ],
      );
    }

    return SpecimenFrame(
      label: 'Specimen · Offline and sync',
      onReset: _reset,
      readouts: [
        ('network', _online ? 'online' : 'offline'),
        ('queue', '${_queue.length}'),
        ('sent', '$_sent'),
        ('retries', '$_retries'),
        ('failed', '$failed'),
      ],
      controls: [
        SpecChoice<bool>(
          label: 'NETWORK',
          value: _online,
          options: const [(true, 'Online'), (false, 'Offline')],
          onChanged: (v) {
            setState(() => _online = v);
            _pump();
          },
        ),
        SpecSlider(
          label: 'LATENCY',
          value: _latency,
          min: 100,
          max: 2000,
          divisions: 19,
          format: (v) => '${v.round()} ms',
          onChanged: (v) => setState(() => _latency = v),
        ),
        SpecSlider(
          label: 'FAILURE RATE',
          value: _failPct,
          min: 0,
          max: 100,
          divisions: 20,
          format: (v) => '${v.round()}%',
          onChanged: (v) => setState(() => _failPct = v),
        ),
        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: [
            OutlinedButton(onPressed: _add, child: const Text('Add task')),
            OutlinedButton(onPressed: _reload, child: const Text('Reload')),
            OutlinedButton(
              onPressed: () => setState(() {
                _tasks.clear();
                _queue.clear();
              }),
              child: const Text('Clear all'),
            ),
          ],
        ),
      ],
      demo: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.s12),
              decoration: BoxDecoration(
                border: Border.all(color: _online ? deco.rule : deco.warning),
              ),
              child: Text(
                _online
                    ? 'Online. Changes are sent as you make them.'
                    : 'Offline. Changes are kept on this device and sent '
                          'when you reconnect.',
                style: text.bodyMedium,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            Inspectable(
              label: 'TaskList',
              note:
                  'Optimistic: a change shows at once and is marked pending '
                  'until the queue confirms it. Empty, loading and error '
                  'each have their own state.',
              source: 'lib/features/playground/specimens/offline_sync.dart:274',
              child: body,
            ),
            const SizedBox(height: AppSpacing.s16),
            Inspectable(
              label: 'SyncQueue',
              note:
                  'One change at a time, in order. A failure retries up to '
                  '3 times, then the task is marked failed and offers Retry.',
              source: 'lib/features/playground/specimens/offline_sync.dart:284',
              child: Text(
                _queue.isEmpty
                    ? 'queue: empty'
                    : 'queue: ${_queue.map((t) => '#${t.id}').join('  ')}',
                style: mute,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({
    required this.task,
    required this.maxTries,
    required this.onToggle,
    required this.onRetry,
  });

  final _Task task;
  final int maxTries;
  final VoidCallback onToggle;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final deco = AppDecorations.of(context);
    final text = Theme.of(context).textTheme;
    final label = switch (task.sync) {
      _Sync.synced => 'synced',
      _Sync.pending =>
        task.tries == 0 ? 'pending' : 'retry ${task.tries}/$maxTries',
      _Sync.failed => 'failed',
    };
    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: deco.rule)),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
                child: Row(
                  children: [
                    Icon(
                      task.done
                          ? Icons.check_box_outlined
                          : Icons.check_box_outline_blank,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.s12),
                    Expanded(
                      child: Text(
                        task.title,
                        style: text.bodyMedium?.copyWith(
                          decoration: task.done
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Text(
            label,
            style: text.labelMedium?.copyWith(
              color: task.sync == _Sync.failed
                  ? Theme.of(context).colorScheme.error
                  : deco.inkMute,
            ),
          ),
          if (task.sync == _Sync.failed)
            TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({
    required this.title,
    required this.body,
    required this.action,
    required this.onAction,
  });

  final String title, body, action;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: text.titleMedium),
          const SizedBox(height: AppSpacing.s4),
          Text(body, style: text.bodyMedium),
          const SizedBox(height: AppSpacing.s12),
          OutlinedButton(onPressed: onAction, child: Text(action)),
        ],
      ),
    );
  }
}
