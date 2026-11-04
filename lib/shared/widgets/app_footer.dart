import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Container(
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              // Top section
              if (isDesktop) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Portfolio description
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Portfolio',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'A showcase of Flutter development skills, featuring UI components, '
                            'widget galleries, app demos, and architectural patterns. '
                            'Built with modern Flutter practices and responsive design.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                    // Navigation links
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Navigation',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 16),
                          _FooterNavLink(
                            label: 'Home',
                            route: '/',
                            onPressed: () => context.go('/'),
                          ),
                          _FooterNavLink(
                            label: 'UI Showcase',
                            route: '/ui-showcase',
                            onPressed: () => context.go('/ui-showcase'),
                          ),
                          _FooterNavLink(
                            label: 'UI Patterns',
                            route: '/widget-gallery',
                            onPressed: () => context.go('/widget-gallery'),
                          ),
                          _FooterNavLink(
                            label: 'App Demos',
                            route: '/app-demos',
                            onPressed: () => context.go('/app-demos'),
                          ),
                          _FooterNavLink(
                            label: 'Architecture',
                            route: '/architecture',
                            onPressed: () => context.go('/architecture'),
                          ),
                          _FooterNavLink(
                            label: 'Services',
                            route: '/services',
                            onPressed: () => context.go('/services'),
                          ),
                          _FooterNavLink(
                            label: 'Contact',
                            route: '/contact',
                            onPressed: () => context.go('/contact'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                    // Social links
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Connect',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 16),
                          const _SocialLink(
                            icon: Icons.code,
                            label: 'GitHub',
                            url: 'https://github.com',
                          ),
                          const SizedBox(height: 12),
                          const _SocialLink(
                            icon: Icons.business_center,
                            label: 'LinkedIn',
                            url: 'https://linkedin.com',
                          ),
                          const SizedBox(height: 12),
                          const _SocialLink(
                            icon: Icons.email,
                            label: 'Email',
                            url: 'mailto:example@email.com',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ] else ...[
                // Mobile layout
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Portfolio description
                    Text(
                      'Portfolio',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'A showcase of Flutter development skills, featuring UI components, '
                      'UI patterns, app demos, and architectural patterns. '
                      'Built with modern Flutter practices and responsive design.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 32),
                    // Navigation links
                    Text(
                      'Navigation',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 24,
                      runSpacing: 8,
                      children: [
                        _FooterNavLink(
                          label: 'Home',
                          route: '/',
                          onPressed: () => context.go('/'),
                        ),
                        _FooterNavLink(
                          label: 'UI Showcase',
                          route: '/ui-showcase',
                          onPressed: () => context.go('/ui-showcase'),
                        ),
                        _FooterNavLink(
                          label: 'UI Patterns',
                          route: '/widget-gallery',
                          onPressed: () => context.go('/widget-gallery'),
                        ),
                        _FooterNavLink(
                          label: 'App Demos',
                          route: '/app-demos',
                          onPressed: () => context.go('/app-demos'),
                        ),
                        _FooterNavLink(
                          label: 'Architecture',
                          route: '/architecture',
                          onPressed: () => context.go('/architecture'),
                        ),
                        _FooterNavLink(
                          label: 'Services',
                          route: '/services',
                          onPressed: () => context.go('/services'),
                        ),
                        _FooterNavLink(
                          label: 'Contact',
                          route: '/contact',
                          onPressed: () => context.go('/contact'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Social links
                    Text(
                      'Connect',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Wrap(
                      spacing: 24,
                      runSpacing: 8,
                      children: [
                        _SocialLink(
                          icon: Icons.code,
                          label: 'GitHub',
                          url: 'https://github.com',
                        ),
                        _SocialLink(
                          icon: Icons.business_center,
                          label: 'LinkedIn',
                          url: 'https://linkedin.com',
                        ),
                        _SocialLink(
                          icon: Icons.email,
                          label: 'Email',
                          url: 'mailto:example@email.com',
                        ),
                      ],
                    ),
                  ],
                ),
              ],

              // Divider
              const SizedBox(height: 48),
              const Divider(),
              const SizedBox(height: 24),

              // Bottom section - Copyright
              Text(
                '© 2024 Portfolio. All rights reserved.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterNavLink extends StatelessWidget {
  const _FooterNavLink({
    required this.label,
    required this.route,
    required this.onPressed,
  });

  final String label;
  final String route;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.centerLeft,
      ),
      child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class _SocialLink extends StatefulWidget {
  const _SocialLink({
    required this.icon,
    required this.label,
    required this.url,
  });

  final IconData icon;
  final String label;
  final String url;

  @override
  State<_SocialLink> createState() => _SocialLinkState();
}

class _SocialLinkState extends State<_SocialLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(widget.url)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: _isHovered
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 20,
                color: _isHovered
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _isHovered
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
