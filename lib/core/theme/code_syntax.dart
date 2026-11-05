import 'package:flutter/painting.dart';
import 'package:portfolio/core/theme/app_colors.dart';

/// Syntax colours for code blocks. Code backgrounds are dark in both themes
/// (AppDecorations.codeBackground), so one palette tuned for dark serves both.
class CodeSyntax {
  const CodeSyntax({
    required this.plain,
    required this.keyword,
    required this.type,
    required this.string,
    required this.number,
    required this.comment,
    required this.lineNumber,
  });

  final Color plain;
  final Color keyword;
  final Color type;
  final Color string;
  final Color number;
  final Color comment;
  final Color lineNumber;

  static const standard = CodeSyntax(
    plain: AppColors.slate200,
    keyword: AppColors.indigo400,
    type: AppColors.cyan400,
    string: AppColors.successDark,
    number: AppColors.warningDark,
    comment: AppColors.slate400,
    lineNumber: AppColors.slate600,
  );
}
