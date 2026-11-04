import 'package:flutter/material.dart';
import 'package:portfolio/core/content/case_study.dart';
import 'package:portfolio/core/content/engagement_model.dart';
import 'package:portfolio/core/content/faq_item.dart';
import 'package:portfolio/core/content/process_step.dart';
import 'package:portfolio/core/content/profile.dart';
import 'package:portfolio/core/content/proof_stat.dart';
import 'package:portfolio/core/content/service_offering.dart';
import 'package:portfolio/core/content/skill.dart';

// All site copy lives here. Widgets read it through Riverpod providers.

const profile = Profile(
  name: 'Your Name', // TODO(me): real name
  title: 'Flutter Developer',
  tagline:
      'Flutter developer building polished mobile and web apps.', // TODO(me)
  shortBio:
      'Passionate *Flutter* developer specializing in creating beautiful, '
      'performant, and user-friendly *Mobile Apps*. With expertise in modern '
      'Flutter development practices and a keen eye for *UI Development*.',
  location: 'Your City, Country', // TODO(me): real location
  email: 'example@email.com', // TODO(me): real email
  availability: 'Open to freelance projects', // TODO(me): real availability
  socials: [
    // TODO(me): real GitHub profile URL
    SocialLink(label: 'GitHub', url: 'https://github.com', icon: Icons.code),
    // TODO(me): real LinkedIn profile URL
    SocialLink(
      label: 'LinkedIn',
      url: 'https://linkedin.com',
      icon: Icons.business_center,
    ),
  ],
  // TODO(me): resumeUrl: 'https://…/resume.pdf',
);

const skills = [
  Skill(
    name: 'Flutter',
    category: SkillCategory.framework,
    icon: Icons.flutter_dash,
    color: Colors.blue,
  ),
  Skill(
    name: 'Dart',
    category: SkillCategory.language,
    icon: Icons.code,
    color: Colors.cyan,
  ),
  Skill(
    name: 'Firebase',
    category: SkillCategory.backend,
    icon: Icons.cloud,
    color: Colors.orange,
  ),
  Skill(
    name: 'REST APIs',
    category: SkillCategory.backend,
    icon: Icons.api,
    color: Colors.green,
  ),
  Skill(
    name: 'Riverpod',
    category: SkillCategory.stateManagement,
    icon: Icons.data_object,
    color: Colors.purple,
  ),
  Skill(
    name: 'GoRouter',
    category: SkillCategory.navigation,
    icon: Icons.route,
    color: Colors.teal,
  ),
];

// TODO(me): replace these placeholder case studies with real projects
// (role, year, links and images included).
const caseStudies = [
  CaseStudy(
    slug: 'student-management-system',
    title: 'Student Management System',
    tagline:
        'A cross-platform student portal built for dependable academic operations.',
    problem:
        'Teachers needed a way to capture grades and attendance without relying on a stable internet connection.',
    solution:
        'Built a Flutter app with Firebase sync so staff could work offline first and sync updates once connected.',
    result:
        'Real-time sync, offline support, and a cleaner workflow for school staff.',
    techStack: ['Flutter', 'Firebase', 'Riverpod'],
    role: 'Flutter Developer',
    year: 2024,
    links: [
      CaseStudyLink(
        label: 'Live Demo',
        url: 'https://demo.example.com/student-management',
        icon: Icons.launch,
      ),
      CaseStudyLink(
        label: 'GitHub',
        url: 'https://github.com/example/student-management-system',
        icon: Icons.code,
      ),
    ],
    featured: true,
  ),
  CaseStudy(
    slug: 'portfolio-web-app',
    title: 'Portfolio Web App',
    tagline:
        'A polished developer portfolio designed to present product thinking and frontend craft.',
    problem:
        'A generic portfolio did not communicate engineering depth, interaction quality, or architecture decisions.',
    solution:
        'Built a responsive Flutter web app with structured sections, reusable UI patterns, and route-based navigation.',
    result:
        'Fast navigation, scalable UI sections, and a more credible presentation of work.',
    techStack: ['Flutter Web', 'GoRouter', 'Material 3'],
    role: 'Flutter Developer',
    year: 2024,
    links: [
      CaseStudyLink(
        label: 'Live Demo',
        url: 'https://demo.example.com/portfolio-web-app',
        icon: Icons.launch,
      ),
      CaseStudyLink(
        label: 'GitHub',
        url: 'https://github.com/example/portfolio-web-app',
        icon: Icons.code,
      ),
    ],
    featured: true,
  ),
  CaseStudy(
    slug: 'inventory-operations-dashboard',
    title: 'Inventory Operations Dashboard',
    tagline:
        'A dashboard for tracking stock levels, purchase flow, and warehouse visibility.',
    problem:
        'Operations teams were managing stock updates in spreadsheets, which caused delays and duplicate entries.',
    solution:
        'Delivered a Flutter dashboard with role-based views, reusable state handling, and focused reporting widgets.',
    result:
        'Improved reporting speed, clearer stock visibility, and cleaner internal architecture.',
    techStack: ['Flutter', 'Dart', 'Riverpod', 'REST API'],
    role: 'Flutter Developer',
    year: 2024,
    links: [
      CaseStudyLink(
        label: 'Live Demo',
        url: 'https://demo.example.com/inventory-dashboard',
        icon: Icons.launch,
      ),
      CaseStudyLink(
        label: 'GitHub',
        url: 'https://github.com/example/inventory-operations-dashboard',
        icon: Icons.code,
      ),
    ],
    featured: true,
  ),
  CaseStudy(
    slug: 'telehealth-booking-platform',
    title: 'Telehealth Booking Platform',
    tagline:
        'A scheduling experience that reduces friction for remote consultations.',
    problem:
        'Patients needed a simple booking flow while clinics needed a maintainable system for appointment handling.',
    solution:
        'Created a Flutter booking interface backed by modular scheduling logic and provider-friendly time slot management.',
    result:
        'Smoother booking journeys, scalable backend workflows, and easier feature expansion.',
    techStack: ['Flutter', 'Riverpod', 'Firebase', 'Cloud Functions'],
    role: 'Flutter Developer',
    year: 2024,
    links: [
      CaseStudyLink(
        label: 'Live Demo',
        url: 'https://demo.example.com/telehealth-booking',
        icon: Icons.launch,
      ),
      CaseStudyLink(
        label: 'GitHub',
        url: 'https://github.com/example/telehealth-booking-platform',
        icon: Icons.code,
      ),
    ],
  ),
];

// TODO(me): replace with the services you actually offer.
const serviceOfferings = [
  ServiceOffering(
    title: 'Flutter App Development',
    description: 'Cross-platform mobile and web apps from idea to release.',
    deliverables: ['Production app', 'Source code', 'Release support'],
    icon: Icons.phone_android,
  ),
  ServiceOffering(
    title: 'UI Implementation',
    description: 'Pixel-accurate, responsive Flutter UIs from your designs.',
    deliverables: ['Reusable widgets', 'Responsive layouts', 'Animations'],
    icon: Icons.design_services,
  ),
  ServiceOffering(
    title: 'Architecture Review',
    description: 'Audit and restructure existing Flutter codebases.',
    deliverables: ['Written report', 'Refactor plan', 'Pairing sessions'],
    icon: Icons.account_tree,
  ),
];

// Proof strip on the landing page. Stats with a null value are hidden, so
// nothing is shown until you fill in a real number. Case-study and demo
// counts are added automatically from the content above.
const proofStats = [
  ProofStat(label: 'Years building with Flutter'), // TODO(me): e.g. value: '4+'
  ProofStat(label: 'Apps shipped to production'), // TODO(me): e.g. value: '12'
  // TODO(me): confirm the platforms you actually ship to.
  ProofStat(label: 'Platforms from one codebase', value: 'iOS · Android · Web'),
];

const processSteps = [
  ProcessStep(
    title: 'Discover',
    description:
        'We pin down the problem, the users and what "done" means before any code is written.',
    icon: Icons.travel_explore,
  ),
  ProcessStep(
    title: 'Design',
    description:
        'Flows and screens are prototyped and agreed, so the build has no surprises.',
    icon: Icons.design_services_outlined,
  ),
  ProcessStep(
    title: 'Build',
    description:
        'Iterative delivery with a working build you can try every week, tests included.',
    icon: Icons.construction,
  ),
  ProcessStep(
    title: 'Ship',
    description:
        'Store release or web deploy, monitoring, and a clean handover of the codebase.',
    icon: Icons.rocket_launch_outlined,
  ),
];

// TODO(me): adjust to how you actually like to work. Prices stay hidden
// unless you add `price:`.
const engagementModels = [
  EngagementModel(
    title: 'Fixed scope',
    description:
        'An agreed set of screens and features, delivered for a fixed quote.',
    bestFor: 'MVPs and well-defined features',
    icon: Icons.inventory_2_outlined,
  ),
  EngagementModel(
    title: 'Hourly',
    description:
        'Flexible time for fixes, reviews or work whose shape is still moving.',
    bestFor: 'Audits, bug fixing, short spikes',
    icon: Icons.schedule,
  ),
  EngagementModel(
    title: 'Retainer',
    description:
        'A reserved block of time each month for ongoing product development.',
    bestFor: 'Teams that ship continuously',
    icon: Icons.autorenew,
  ),
];

// TODO(me): rewrite in your own words; keep only what is true for you.
const faqs = [
  FaqItem(
    question: 'Which platforms can you deliver?',
    answer:
        'One Flutter codebase for iOS, Android and the web. Desktop is possible when a project needs it.',
  ),
  FaqItem(
    question: 'Can you work with my existing app?',
    answer:
        'Yes. I start with a short architecture review, then fix or extend the codebase without a rewrite unless one is clearly cheaper.',
  ),
  FaqItem(
    question: 'Who owns the code?',
    answer:
        'You do. The repository, assets and accounts are yours from day one.',
  ),
  FaqItem(
    question: 'How do we stay in touch during a project?',
    answer:
        'A weekly demo of a working build, plus a shared channel for questions in between.',
  ),
];
