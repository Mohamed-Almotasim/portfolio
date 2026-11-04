import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/content/portfolio_content.dart' as content;
import 'package:portfolio/core/content/skill.dart';

final skillsProvider = Provider<List<Skill>>((ref) => content.skills);
