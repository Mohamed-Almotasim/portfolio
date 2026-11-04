import 'package:flutter/material.dart';

class EmptyStatePreview extends StatelessWidget {
  const EmptyStatePreview({super.key});

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
              const SizedBox(height: 12),
              Text(
                'No Data Available',
                style: TextStyle(fontSize: isCompact ? 12 : 14),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Refresh',
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
