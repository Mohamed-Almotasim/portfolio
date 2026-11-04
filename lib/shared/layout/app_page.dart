import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/shared/widgets/app_footer.dart';
import 'package:portfolio/shared/widgets/app_navbar.dart';
import 'package:portfolio/shared/widgets/scroll_to_top_button.dart';

/// Page content wrapper: own scroll view (so every page opens at the top),
/// max width, padding, optional title, footer and a back-to-top button.
/// The navbar and drawer live in AppShell.
class AppPage extends StatefulWidget {
  const AppPage({super.key, required this.child, this.title});

  final Widget child;
  final String? title;

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          // Content starts below the overlaid navbar and scrolls under it.
          padding: const EdgeInsets.only(top: AppNavbar.height),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.maxContentWidth,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectionArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.title != null) ...[
                            Text(
                              widget.title!,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: AppSpacing.s24),
                          ],
                          widget.child,
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s64),
                    const AppFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
        ScrollToTopButton(scrollController: _scrollController),
      ],
    );
  }
}
