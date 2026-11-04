import 'package:flutter/material.dart';

class SettingsPreview extends StatefulWidget {
  const SettingsPreview({super.key});

  @override
  State<SettingsPreview> createState() => _SettingsPreviewState();
}

class _SettingsPreviewState extends State<SettingsPreview> {
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
              title: Text(
                'Dark Mode',
                style: TextStyle(fontSize: isCompact ? 12 : 14),
              ),
              value: _darkMode,
              onChanged: (value) => setState(() => _darkMode = value),
              dense: true,
            ),
            SwitchListTile(
              title: Text(
                'Push Notifications',
                style: TextStyle(fontSize: isCompact ? 12 : 14),
              ),
              value: _pushNotifications,
              onChanged: (value) => setState(() => _pushNotifications = value),
              dense: true,
            ),
            SwitchListTile(
              title: Text(
                'Auto Sync',
                style: TextStyle(fontSize: isCompact ? 12 : 14),
              ),
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
