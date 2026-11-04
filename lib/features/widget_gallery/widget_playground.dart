import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WidgetPlayground extends ConsumerStatefulWidget {
  const WidgetPlayground({super.key});

  @override
  ConsumerState<WidgetPlayground> createState() => _WidgetPlaygroundState();
}

class _WidgetPlaygroundState extends ConsumerState<WidgetPlayground> {
  double _padding = 16.0;
  double _borderRadius = 8.0;
  Color _color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Controls
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Widget Controls',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Padding slider
                Row(
                  children: [
                    const Text('Padding:'),
                    Expanded(
                      child: Slider(
                        value: _padding,
                        min: 0,
                        max: 50,
                        divisions: 50,
                        label: _padding.round().toString(),
                        onChanged: (value) => setState(() => _padding = value),
                      ),
                    ),
                    Text('${_padding.round()}'),
                  ],
                ),
                // Border radius slider
                Row(
                  children: [
                    const Text('Border Radius:'),
                    Expanded(
                      child: Slider(
                        value: _borderRadius,
                        min: 0,
                        max: 25,
                        divisions: 25,
                        label: _borderRadius.round().toString(),
                        onChanged: (value) =>
                            setState(() => _borderRadius = value),
                      ),
                    ),
                    Text('${_borderRadius.round()}'),
                  ],
                ),
                // Color selector
                const SizedBox(height: 16),
                const Text('Color:'),
                Row(
                  children: [
                    _colorButton(Colors.blue),
                    _colorButton(Colors.red),
                    _colorButton(Colors.green),
                    _colorButton(Colors.yellow),
                    _colorButton(Colors.purple),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Live preview
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Live Preview',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(_padding),
                    decoration: BoxDecoration(
                      color: _color,
                      borderRadius: BorderRadius.circular(_borderRadius),
                    ),
                    child: const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _colorButton(Color color) {
    return GestureDetector(
      onTap: () => setState(() => _color = color),
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: _color == color
              ? Border.all(color: Colors.black, width: 2)
              : null,
        ),
      ),
    );
  }
}
