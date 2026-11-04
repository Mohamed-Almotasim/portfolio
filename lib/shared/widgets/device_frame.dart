import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_decorations.dart';

class DeviceFrame extends StatelessWidget {
  const DeviceFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 600,
      decoration: BoxDecoration(
        color: AppDecorations.of(context).deviceBezel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppDecorations.of(context).deviceBezel,
          width: 8,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          child: SizedBox(width: double.infinity, height: 600, child: child),
        ),
      ),
    );
  }
}
