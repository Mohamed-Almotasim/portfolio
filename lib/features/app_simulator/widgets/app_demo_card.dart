import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/state/developer_mode_provider.dart';
import 'package:portfolio/shared/widgets/device_frame.dart';

class AppDemoCard extends ConsumerWidget {
  const AppDemoCard({
    super.key,
    required this.title,
    required this.description,
    this.demoWidget,
    this.uiPatterns,
    this.layoutStructure,
    this.widgetsUsed,
    this.isLaunchEnabled = true,
    this.launchButtonLabel = 'Launch Demo',
    this.useDeviceFrame = true,
  });

  final String title;
  final String description;
  final Widget? demoWidget;
  final String? uiPatterns;
  final String? layoutStructure;
  final String? widgetsUsed;
  final bool isLaunchEnabled;
  final String launchButtonLabel;
  final bool useDeviceFrame;

  void _launchDemo(BuildContext context) {
    if (demoWidget == null) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: Theme.of(context).textTheme.headlineSmall),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Center(
                  child: useDeviceFrame
                      ? DeviceFrame(child: demoWidget!)
                      : demoWidget!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDeveloperMode = ref.watch(developerModeProvider);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(description),
            ],
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: isLaunchEnabled && demoWidget != null
                    ? () => _launchDemo(context)
                    : null,
                child: Text(launchButtonLabel),
              ),
            ),
            if (isDeveloperMode && uiPatterns != null) ...[
              const SizedBox(height: 16),
              DeveloperInfoPanel(
                uiPatterns: uiPatterns!,
                layoutStructure: layoutStructure ?? '',
                widgetsUsed: widgetsUsed ?? '',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class DeveloperInfoPanel extends StatelessWidget {
  const DeveloperInfoPanel({
    super.key,
    required this.uiPatterns,
    required this.layoutStructure,
    required this.widgetsUsed,
  });

  final String uiPatterns;
  final String layoutStructure;
  final String widgetsUsed;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Developer Info',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildSection('UI Patterns', uiPatterns),
            const SizedBox(height: 8),
            _buildSection('Layout Structure', layoutStructure),
            const SizedBox(height: 8),
            _buildSection('Widgets Used', widgetsUsed),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(content),
      ],
    );
  }
}
