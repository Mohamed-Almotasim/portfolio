import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

typedef LinkLauncher = Future<bool> Function(Uri uri);

/// Overridden in tests; the real one opens web links in a new tab.
final linkLauncherProvider = Provider<LinkLauncher>(
  (ref) =>
      (uri) => launchUrl(
        uri,
        webOnlyWindowName: uri.scheme.startsWith('http') ? '_blank' : '_self',
      ),
);

/// Opens [uri]; on failure tells the visitor instead of failing silently.
Future<bool> openLink(BuildContext context, WidgetRef ref, Uri uri) async {
  final messenger = ScaffoldMessenger.maybeOf(context);
  bool ok;
  try {
    ok = await ref.read(linkLauncherProvider)(uri);
  } on Exception {
    ok = false;
  }
  if (!ok) {
    messenger?.showSnackBar(
      SnackBar(
        content: Text(
          "Couldn't open ${uri.scheme == 'mailto' ? uri.path : uri}",
        ),
      ),
    );
  }
  return ok;
}
