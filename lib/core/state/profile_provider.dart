import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/content/portfolio_content.dart' as content;
import 'package:portfolio/core/content/profile.dart';

final profileProvider = Provider<Profile>((ref) => content.profile);

/// GitHub URL for `lib/…/file.dart:42`, as the inspector's "View source".
final sourceUrlProvider = Provider<String Function(String path, int line)>(
  (ref) =>
      (path, line) =>
          '${content.sourceRepoUrl}/blob/${content.sourceBranch}/$path#L$line',
);
