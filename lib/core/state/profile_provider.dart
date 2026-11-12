import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/content/portfolio_content.dart' as content;
import 'package:portfolio/core/content/portfolio_content_ar.dart' as ar;
import 'package:portfolio/core/content/profile.dart';
import 'package:portfolio/core/state/locale_provider.dart';

final profileProvider = Provider<Profile>(
  (ref) => ref.watch(isArabicProvider) ? ar.profile : content.profile,
);

/// GitHub URL for `lib/…/file.dart:42`, as the inspector's "View source".
final sourceUrlProvider = Provider<String Function(String path, int line)>(
  (ref) =>
      (path, line) =>
          '${content.sourceRepoUrl}/blob/${content.sourceBranch}/$path#L$line',
);
