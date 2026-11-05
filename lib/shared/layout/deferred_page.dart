import 'package:flutter/material.dart';
import 'package:portfolio/shared/widgets/app_navbar.dart';

/// Loads a `deferred as` library, then builds its page. Keeps heavy demo
/// pages out of the initial JS bundle so the landing page loads faster.
class DeferredPage extends StatefulWidget {
  const DeferredPage({super.key, required this.load, required this.builder});

  final Future<void> Function() load;
  final WidgetBuilder builder;

  @override
  State<DeferredPage> createState() => _DeferredPageState();
}

class _DeferredPageState extends State<DeferredPage> {
  late final Future<void> _loaded = widget.load();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loaded,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done && !snap.hasError) {
          return widget.builder(context);
        }
        return Padding(
          padding: const EdgeInsets.only(top: AppNavbar.height),
          child: Center(
            child: snap.hasError
                ? const Text("This page couldn't load. Please refresh.")
                : const CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
