import 'package:flutter/material.dart';
import 'package:portfolio/core/content/case_study.dart';
import 'package:portfolio/core/content/profile.dart';
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
