import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/content/portfolio_content.dart' as content;
import 'package:portfolio/core/content/profile.dart';

final profileProvider = Provider<Profile>((ref) => content.profile);
