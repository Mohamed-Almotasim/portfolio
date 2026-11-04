import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 64),
      constraints: const BoxConstraints(minHeight: 400),
      child: Stack(
        children: [
          // Background accent
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.centerLeft,
                  radius: 0.8,
                  colors: [
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.05),
                    Theme.of(
                      context,
                    ).colorScheme.secondary.withValues(alpha: 0.03),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 800;

              if (isDesktop) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(flex: 2, child: _buildContent(context)),
                    Expanded(child: _buildAvatar(context)),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildContent(context),
                    const SizedBox(height: 32),
                    _buildAvatar(context),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Your Name', // Replace with actual developer name
          style: Theme.of(
            context,
          ).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          'Flutter Developer',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 24),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: _buildDescription(context),
        ),
        const SizedBox(height: 48),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => context.go('/app-demos'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('View Projects'),
            ),
            const SizedBox(width: 16),
            OutlinedButton(
              onPressed: () => context.go('/contact'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Contact Me'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyLarge,
        children: [
          const TextSpan(text: 'Passionate '),
          TextSpan(
            text: 'Flutter',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          const TextSpan(
            text:
                ' developer specializing in creating beautiful, performant, and user-friendly ',
          ),
          TextSpan(
            text: 'Mobile Apps',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          const TextSpan(
            text:
                '. With expertise in modern Flutter development practices and a keen eye for ',
          ),
          TextSpan(
            text: 'UI Development',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(seconds: 2),
        builder: (context, double value, child) {
          return Transform.translate(
            offset: Offset(0, 10 * (1 - value)),
            child: Opacity(
              opacity: value,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.shadow.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.white,
                ), // Placeholder avatar
              ),
            ),
          );
        },
      ),
    );
  }
}
