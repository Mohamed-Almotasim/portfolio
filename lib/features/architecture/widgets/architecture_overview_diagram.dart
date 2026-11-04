import 'package:flutter/material.dart';

class ArchitectureOverviewDiagram extends StatelessWidget {
  const ArchitectureOverviewDiagram({super.key});

  static const _layers = [
    _ArchitectureLayer(
      title: 'UI Layer',
      subtitle:
          'Screens, widgets, demo surfaces, and reusable presentation logic.',
      icon: Icons.layers_rounded,
    ),
    _ArchitectureLayer(
      title: 'State (Riverpod)',
      subtitle:
          'Reactive state coordination, rebuild boundaries, and predictable updates.',
      icon: Icons.bolt_rounded,
    ),
    _ArchitectureLayer(
      title: 'Services',
      subtitle:
          'Feature-specific orchestration, external integrations, and domain actions.',
      icon: Icons.settings_input_component_rounded,
    ),
    _ArchitectureLayer(
      title: 'Firebase / API',
      subtitle:
          'Remote systems, persistence, and external platform capabilities.',
      icon: Icons.cloud_queue_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('System Overview', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'A high-level view of how presentation, state, service orchestration, and backend integrations align across the app.',
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 720;

                if (isCompact) {
                  return Column(
                    children: [
                      for (var index = 0; index < _layers.length; index++) ...[
                        _OverviewLayerCard(layer: _layers[index]),
                        if (index < _layers.length - 1) ...[
                          const SizedBox(height: 12),
                          Icon(
                            Icons.arrow_downward_rounded,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 12),
                        ],
                      ],
                    ],
                  );
                }

                return Row(
                  children: [
                    for (var index = 0; index < _layers.length; index++) ...[
                      Expanded(
                        child: _OverviewLayerCard(layer: _layers[index]),
                      ),
                      if (index < _layers.length - 1) ...[
                        const SizedBox(width: 12),
                        Icon(
                          Icons.arrow_downward_rounded,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                      ],
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _OverviewLayerCard extends StatefulWidget {
  const _OverviewLayerCard({required this.layer});

  final _ArchitectureLayer layer;

  @override
  State<_OverviewLayerCard> createState() => _OverviewLayerCardState();
}

class _OverviewLayerCardState extends State<_OverviewLayerCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? theme.colorScheme.primary
                : Colors.grey.shade300,
          ),
          color: _isHovered
              ? theme.colorScheme.primary.withValues(alpha: 0.05)
              : theme.colorScheme.surface,
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.10),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(widget.layer.icon, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              widget.layer.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(widget.layer.subtitle, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _ArchitectureLayer {
  const _ArchitectureLayer({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}
