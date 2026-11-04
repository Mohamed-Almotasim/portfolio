import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/demo/demo_component.dart';

class SmartSearchDemo extends ConsumerStatefulWidget {
  const SmartSearchDemo({super.key});

  @override
  ConsumerState<SmartSearchDemo> createState() => _SmartSearchDemoState();
}

class _SmartSearchDemoState extends ConsumerState<SmartSearchDemo>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _dropdownAnimation;

  final List<String> _suggestions = [
    'UI Components',
    'Dashboard Layout',
    'Auth System',
    'Responsive Navbar',
    'Data Visualization',
    'Form Validation',
    'State Management',
    'API Integration',
  ];

  List<String> _filteredSuggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _dropdownAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _controller.addListener(_onSearchChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _controller.text.toLowerCase();
    setState(() {
      _filteredSuggestions = _suggestions
          .where((suggestion) => suggestion.toLowerCase().contains(query))
          .toList();
    });
  }

  void _onFocusChanged() {
    setState(() {
      _showSuggestions = _focusNode.hasFocus && _controller.text.isNotEmpty;
      if (_showSuggestions) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _selectSuggestion(String suggestion) {
    _controller.text = suggestion;
    _focusNode.unfocus();
    setState(() {
      _showSuggestions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DemoComponent(
      title: "Smart Search UI",
      description:
          "An intelligent search interface with animated dropdown suggestions. Features smooth transitions, filtering, and selection animations for a modern search experience.",
      label: "Interaction Demo",
      demoWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Quick suggestion chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                label: const Text("UI Components"),
                onPressed: () => _controller.text = "UI Components",
              ),
              ActionChip(
                label: const Text("Dashboard Layout"),
                onPressed: () => _controller.text = "Dashboard Layout",
              ),
              ActionChip(
                label: const Text("Authentication"),
                onPressed: () => _controller.text = "Authentication",
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Search input
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Search components (UI, dashboard, auth...)',
                prefixIcon: const Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),

          // Animated suggestions dropdown
          AnimatedBuilder(
            animation: _dropdownAnimation,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _dropdownAnimation.value,
                  child: child,
                ),
              );
            },
            child: _showSuggestions && _filteredSuggestions.isNotEmpty
                ? Container(
                    margin: const EdgeInsets.only(top: 4),
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredSuggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = _filteredSuggestions[index];
                        return InkWell(
                          onTap: () => _selectSuggestion(suggestion),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: index < _filteredSuggestions.length - 1
                                  ? Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade100,
                                      ),
                                    )
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    suggestion,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      codeSnippet: '''
class SmartSearchDemo extends ConsumerStatefulWidget {
  // Intelligent search with animated suggestions
  // Features filtering, selection, and smooth transitions
  // Demonstrates advanced text input interactions
}''',
    );
  }
}
