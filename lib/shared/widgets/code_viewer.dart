import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/core/theme/app_decorations.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_typography.dart';
import 'package:portfolio/core/theme/code_syntax.dart';
import 'package:portfolio/shared/widgets/dart_highlighter.dart';

/// Read-only code block: filename header, copy button, line numbers and
/// Dart syntax highlighting.
class CodeViewer extends StatefulWidget {
  const CodeViewer({
    super.key,
    required this.code,
    this.filename,
    this.firstLine = 1,
  });

  final String code;
  final String? filename;

  /// Number shown on the first line, for excerpts from the middle of a file.
  final int firstLine;

  @override
  State<CodeViewer> createState() => _CodeViewerState();
}

class _CodeViewerState extends State<CodeViewer> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (!mounted) return;
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    const syntax = CodeSyntax.standard;
    final deco = AppDecorations.of(context);
    final style = AppTypography.code(syntax.plain);
    final lineCount = '\n'.allMatches(widget.code).length + 1;
    final header = Color.alphaBlend(
      syntax.plain.withValues(alpha: 0.06),
      deco.codeBackground,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: ColoredBox(
        color: deco.codeBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: header,
              padding: const EdgeInsets.only(left: AppSpacing.s16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.filename ?? 'snippet.dart',
                      overflow: TextOverflow.ellipsis,
                      style: style.copyWith(color: syntax.comment),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _copy,
                    style: TextButton.styleFrom(
                      foregroundColor: _copied ? deco.success : syntax.plain,
                    ),
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      child: Icon(
                        _copied ? Icons.check : Icons.copy,
                        key: ValueKey(_copied),
                        size: 16,
                      ),
                    ),
                    label: Text(_copied ? 'Copied' : 'Copy'),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 360),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExcludeSemantics(
                      child: Text(
                        [
                          for (var i = 0; i < lineCount; i++)
                            '${widget.firstLine + i}',
                        ].join('\n'),
                        textAlign: TextAlign.right,
                        style: style.copyWith(color: syntax.lineNumber),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s16),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SelectableText.rich(
                          TextSpan(
                            style: style,
                            children: highlightDart(widget.code, syntax),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
