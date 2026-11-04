import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/layout/app_page.dart';
import 'pattern_card.dart';
import 'widget_gallery_search_provider.dart';

class UIPatternsPage extends ConsumerWidget {
  const UIPatternsPage({super.key});

  static const List<Map<String, String>> _patterns = [
    {
      'name': 'Authentication Form',
      'description': 'Login & signup form with validation',
      'type': 'Form',
    },
    {
      'name': 'Dashboard Panel',
      'description': 'Stats + chart layout',
      'type': 'Dashboard',
    },
    {
      'name': 'Settings Page',
      'description': 'User preferences & toggles',
      'type': 'Settings',
    },
    {
      'name': 'Empty State',
      'description': 'No data UI with CTA',
      'type': 'Feedback',
    },
    {
      'name': 'Loading Skeleton',
      'description': 'Shimmer loading placeholder',
      'type': 'Feedback',
    },
    {
      'name': 'Profile Card',
      'description': 'User profile summary UI',
      'type': 'Card',
    },
  ];

  static const List<String> _categories = [
    'All',
    'Form',
    'Dashboard',
    'Settings',
    'Feedback',
    'Card',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(uiPatternsSearchProvider);
    final selectedCategory = ref.watch(uiPatternsCategoryProvider);

    final filteredPatterns = _patterns.where((pattern) {
      final matchesCategory =
          selectedCategory == 'All' || pattern['type'] == selectedCategory;
      final query = searchQuery.toLowerCase();
      final matchesSearch =
          pattern['name']!.toLowerCase().contains(query) ||
          pattern['description']!.toLowerCase().contains(query) ||
          pattern['type']!.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();

    return AppPage(
      title: 'UI Patterns',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Production-oriented interface patterns that reflect real product needs rather than basic widget demos.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((category) {
              return ChoiceChip(
                label: Text(category),
                selected: selectedCategory == category,
                onSelected: (_) {
                  ref.read(uiPatternsCategoryProvider.notifier).state =
                      category;
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search UI patterns (dashboard, auth, loading...)',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                ref.read(uiPatternsSearchProvider.notifier).state = value;
              },
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 16.0;
              final columnCount = constraints.maxWidth >= 560 ? 2 : 1;
              final cardWidth =
                  (constraints.maxWidth - (spacing * (columnCount - 1))) /
                  columnCount;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: filteredPatterns.map((pattern) {
                  return SizedBox(
                    width: cardWidth,
                    child: PatternCard(
                      name: pattern['name']!,
                      description: pattern['description']!,
                      category: pattern['type']!,
                      preview: _PatternPreview(
                        name: pattern['name']!,
                        type: pattern['type']!,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PatternPreview extends StatelessWidget {
  const _PatternPreview({required this.name, required this.type});

  final String name;
  final String type;

  @override
  Widget build(BuildContext context) {
    switch (name) {
      case 'Authentication Form':
        return const _AuthenticationPreview();
      case 'Dashboard Panel':
        return const _DashboardPreview();
      case 'Settings Page':
        return const _SettingsPreview();
      case 'Empty State':
        return const _EmptyStatePreview();
      case 'Loading Skeleton':
        return const _LoadingSkeletonPreview();
      case 'Profile Card':
        return const _ProfileCardPreview();
      default:
        return Text(type);
    }
  }
}

class _AuthenticationPreview extends StatelessWidget {
  const _AuthenticationPreview();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 250;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome Back",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isCompact ? 16 : 18,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  isDense: true,
                ),
                style: TextStyle(fontSize: isCompact ? 12 : 14),
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  isDense: true,
                ),
                obscureText: true,
                style: TextStyle(fontSize: isCompact ? 12 : 14),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("Login", style: TextStyle(fontSize: isCompact ? 12 : 14)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DashboardPreview extends StatelessWidget {
  const _DashboardPreview();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 300;
        final stats = [
          Flexible(child: _StatBox(compact: compact)),
          SizedBox(width: compact ? 0 : 8, height: compact ? 8 : 0),
          Flexible(child: _StatBox(compact: compact)),
        ];
        final chart = Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(5, (index) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  height: compact ? 20.0 + (index * 4) : 30.0 + (index * 6),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            );
          }),
        );

        return Column(
          children: [
            compact
                ? Column(children: stats)
                : Row(children: stats),
            SizedBox(height: 12),
            SizedBox(
              height: compact ? 60 : 90,
              child: chart,
            ),
          ],
        );
      },
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: compact ? 40 : 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '123',
            style: TextStyle(
              fontSize: compact ? 12 : 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Stats',
            style: TextStyle(
              fontSize: compact ? 10 : 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsPreview extends StatefulWidget {
  const _SettingsPreview();

  @override
  State<_SettingsPreview> createState() => _SettingsPreviewState();
}

class _SettingsPreviewState extends State<_SettingsPreview> {
  bool _darkMode = false;
  bool _pushNotifications = true;
  bool _autoSync = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 250;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: Text('Dark Mode', style: TextStyle(fontSize: isCompact ? 12 : 14)),
              value: _darkMode,
              onChanged: (value) => setState(() => _darkMode = value),
              dense: true,
            ),
            SwitchListTile(
              title: Text('Push Notifications', style: TextStyle(fontSize: isCompact ? 12 : 14)),
              value: _pushNotifications,
              onChanged: (value) => setState(() => _pushNotifications = value),
              dense: true,
            ),
            SwitchListTile(
              title: Text('Auto Sync', style: TextStyle(fontSize: isCompact ? 12 : 14)),
              value: _autoSync,
              onChanged: (value) => setState(() => _autoSync = value),
              dense: true,
            ),
          ],
        );
      },
    );
  }
}


class _EmptyStatePreview extends StatelessWidget {
  const _EmptyStatePreview();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 250;
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inbox_outlined, size: isCompact ? 32 : 40),
              SizedBox(height: 12),
              Text(
                "No Data Available",
                style: TextStyle(fontSize: isCompact ? 12 : 14),
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Refresh",
                  style: TextStyle(fontSize: isCompact ? 12 : 14),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LoadingSkeletonPreview extends StatefulWidget {
  const _LoadingSkeletonPreview();

  @override
  State<_LoadingSkeletonPreview> createState() => _LoadingSkeletonPreviewState();
}

class _LoadingSkeletonPreviewState extends State<_LoadingSkeletonPreview>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 250;
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Row(
              children: [
                Opacity(
                  opacity: _animation.value,
                  child: CircleAvatar(
                    radius: isCompact ? 16 : 20,
                    backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Opacity(
                        opacity: _animation.value,
                        child: Container(
                          width: isCompact ? 100 : 120,
                          height: isCompact ? 12 : 16,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 6),
                      Opacity(
                        opacity: _animation.value,
                        child: Container(
                          width: isCompact ? 80 : 100,
                          height: isCompact ? 10 : 12,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _ProfileCardPreview extends StatelessWidget {
  const _ProfileCardPreview();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 250;
          return Row(
            children: [
              CircleAvatar(
                radius: isCompact ? 18 : 22,
                backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.18),
                child: Icon(Icons.person_rounded, color: Theme.of(context).colorScheme.primary),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: isCompact ? 12 : 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Flutter Developer',
                      style: TextStyle(
                        fontSize: isCompact ? 10 : 12,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Chip(
                          label: Text(
                            'Flutter',
                            style: TextStyle(fontSize: isCompact ? 10 : 12),
                          ),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero,
                        ),
                        SizedBox(width: 4),
                        Chip(
                          label: Text(
                            'Dart',
                            style: TextStyle(fontSize: isCompact ? 10 : 12),
                          ),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


