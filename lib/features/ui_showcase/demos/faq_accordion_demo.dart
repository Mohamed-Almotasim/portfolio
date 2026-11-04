import 'package:flutter/material.dart';
import 'package:portfolio/core/content/faq_item.dart';
import 'package:portfolio/shared/demo/demo_component.dart';
import 'package:portfolio/shared/widgets/faq_accordion.dart';

class FaqAccordionDemo extends StatelessWidget {
  const FaqAccordionDemo({super.key});

  static const _faqs = [
    FaqItem(
      question: 'What technologies do you use?',
      answer:
          'I primarily work with Flutter for cross-platform mobile development, React for web applications, and Node.js for backend services. I also have experience with various databases, cloud platforms, and modern development tools.',
    ),
    FaqItem(
      question: 'How long does a project take?',
      answer:
          'Project timelines vary depending on complexity and scope. A simple mobile app might take 4-6 weeks, while a full-featured application with backend integration could take 3-6 months. I provide detailed timelines during the planning phase.',
    ),
    FaqItem(
      question: 'Do you build full applications?',
      answer:
          'Yes, I develop complete applications from concept to deployment. This includes UI/UX design, frontend development, backend integration, database design, testing, and deployment to app stores or web hosting platforms.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const DemoComponent(
      title: 'Expandable FAQ Component',
      description:
          'An accordion-style FAQ component with smooth expand/collapse animations. Features staggered animations and clean typography for an elegant user experience.',
      label: 'UI Pattern',
      demoWidget: FaqAccordion(items: _faqs),
      codeSnippet: '''
class FaqAccordionDemo extends ConsumerStatefulWidget {
  // Expandable FAQ accordion with smooth animations
  // Features staggered expansion and clean interactions
  // Demonstrates list-based UI patterns
}''',
    );
  }
}
