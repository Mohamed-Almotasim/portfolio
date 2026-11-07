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
  name: 'Mohamed Almotasim Salih',
  title: 'Flutter Developer',
  // Hero statement: keep it under ~32 characters so it holds two lines.
  tagline: 'Flutter apps, taken to release.',
  shortBio:
      'Freelance Flutter developer since 2020. I build data-heavy, role-based '
      'apps and take over unfinished codebases to get them released. '
      'Switch on Inspect to see how this site is put together.',
  location: 'Khartoum, Sudan',
  email: 'moalmotasim98@yahoo.com',
  availability: 'Open to freelance projects',
  responseTime: 'Usually within one business day', // TODO(me): confirm
  socials: [
    SocialLink(
      label: 'GitHub',
      url: 'https://github.com/Mohamed-Almotasim',
      icon: Icons.code,
    ),
    SocialLink(
      label: 'LinkedIn',
      url: 'https://www.linkedin.com/in/mohamed-almotasim-meshal-3a712b28',
      icon: Icons.business_center,
    ),
    SocialLink(
      label: 'Fiverr',
      url:
          'https://www.fiverr.com/mohamedalmotasi/create-a-simple-flutter-app-for-you',
      icon: Icons.storefront,
    ),
  ],
  // TODO(me): resumeUrl: 'https://…/resume.pdf',
);

/// Where the inspector's "View source" links point: `<repo>/blob/<branch>/`
/// plus the file path and `#L<line>`.
// TODO(me): confirm the public repository URL and branch.
const sourceRepoUrl = 'https://github.com/Mohamed-Almotasim/portfolio';
const sourceBranch = 'main';

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
    name: 'REST APIs',
    category: SkillCategory.backend,
    icon: Icons.api,
    color: Colors.green,
  ),
  Skill(
    name: 'Firebase',
    category: SkillCategory.backend,
    icon: Icons.cloud,
    color: Colors.orange,
  ),
  Skill(
    name: 'Riverpod',
    category: SkillCategory.stateManagement,
    icon: Icons.data_object,
    color: Colors.purple,
  ),
  Skill(
    name: 'BLoC',
    category: SkillCategory.stateManagement,
    icon: Icons.account_tree,
    color: Colors.indigo,
  ),
  Skill(
    name: 'GoRouter',
    category: SkillCategory.navigation,
    icon: Icons.route,
    color: Colors.teal,
  ),
];

// TODO(me): add the Attendance App (GPS + ML) once its details are final,
// and real screenshots for each gallery.
const caseStudies = [
  CaseStudy(
    slug: 'al-risala-academy',
    title: 'Al-Risala Academy',
    type: 'Education platform',
    outcome: 'One app for ~3,200 students, teachers and admins.',
    gallery: [
      CaseStudyFigure(caption: 'Role-based home screens'),
      CaseStudyFigure(caption: 'Data table with smart search'),
    ],
    tagline:
        'The mobile app for a private school platform, built solo in about a year.',
    problem:
        'A private school needed one mobile app for students, teachers and '
        'admins, covering classes, tests, grading, study materials, '
        'permissions, payments and scholarships.',
    solution:
        'Integrated ~150 REST endpoints behind a reusable API service layer '
        'with server-side authentication and encrypted data exchange. Built a '
        'reusable table component with pagination, caching and smart search '
        'for dozens of data-heavy screens.',
    result:
        'Serves ~3,200 users across three roles and is featured on the '
        "school's own website. Caching and search cut unnecessary API calls.",
    techStack: ['Flutter', 'Riverpod', 'REST APIs'],
    role: 'Sole Flutter Developer',
    year: 2024,
    links: [],
    featured: true,
  ),
  CaseStudy(
    slug: 'ma7aal',
    title: 'Ma7aal',
    type: 'E-commerce app',
    outcome: 'An unfinished app, completed and prepared for release.',
    gallery: [
      CaseStudyFigure(caption: 'Arabic RTL storefront'),
      CaseStudyFigure(caption: 'Splash screen and icons'),
    ],
    tagline: 'Joining an existing e-commerce app in its final stage.',
    problem:
        'The app was close to launch, with its APIs unconnected, features '
        'unfinished and no Arabic support.',
    solution:
        'Learned the unfamiliar codebase, connected the APIs, finished the '
        'remaining features and enabled localization with Arabic RTL.',
    result:
        'Icons, splash screen, UI polish and release preparation completed, '
        'leaving the app ready to ship.',
    techStack: ['Flutter', 'REST APIs', 'Arabic RTL'],
    role: 'Flutter Developer',
    year: 2023,
    links: [],
    featured: true,
  ),
  CaseStudy(
    slug: 'al-husnaa',
    title: 'Al-Husnaa',
    type: 'E-commerce app',
    outcome: 'A mobile design turned into accurate, reusable Flutter UI.',
    gallery: [
      CaseStudyFigure(caption: 'Design next to the build'),
      CaseStudyFigure(caption: 'Reusable widgets'),
    ],
    tagline: 'UI implementation for a team working in BLoC.',
    problem:
        'The team had a finished mobile design and a BLoC architecture, and '
        'needed the UI built to match both.',
    solution:
        'Built the UI from the design with responsive layouts and reusable '
        "widgets, structured to plug into the team's BLoC architecture.",
    result:
        'Screens that match the design closely and slot into the existing '
        'state management without rework.',
    techStack: ['Flutter', 'BLoC'],
    role: 'Flutter UI Developer',
    year: 2022,
    links: [],
    featured: true,
  ),
];

const serviceOfferings = [
  ServiceOffering(
    title: 'Flutter App Development',
    description:
        'Custom apps, from single-purpose tools to multi-role, data-heavy '
        'systems.',
    deliverables: ['Production app', 'Source code', 'Google Play release'],
    icon: Icons.phone_android,
  ),
  ServiceOffering(
    title: 'Finish an Existing App',
    description:
        'I take over unfinished Flutter projects, learn the codebase and get '
        'them released.',
    deliverables: ['Completed features', 'API integration', 'Release prep'],
    icon: Icons.build_circle_outlined,
  ),
  ServiceOffering(
    title: 'UI Implementation',
    description:
        'Accurate, responsive Flutter UI from your designs, Arabic RTL '
        'included.',
    deliverables: ['Reusable widgets', 'Responsive layouts', 'RTL support'],
    icon: Icons.design_services,
  ),
];

// Proof strip on the landing page. Stats with a null value are hidden, so
// nothing is shown until you fill in a real number. Case-study and demo
// counts are added automatically from the content above.
const proofStats = [
  ProofStat(label: 'Years building with Flutter', value: '6+'),
  ProofStat(label: 'Five-star Fiverr reviews', value: '9'),
  ProofStat(label: 'Apps shipped to production'), // TODO(me): e.g. value: '12'
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
        'Android is my focus, with releases to Google Play. Flutter web works '
        'from the same codebase; my iOS experience is limited.',
  ),
  FaqItem(
    question: 'Can you work with my existing app?',
    answer:
        'Yes, that is a large part of my work. I learn the codebase, finish '
        'what is missing and prepare it for release, without a rewrite '
        'unless one is clearly cheaper.',
  ),
  FaqItem(
    question: 'What happens after handover?',
    answer:
        'I keep supporting the app after delivery. Fast delivery, clear '
        'communication and that ongoing support are what client reviews '
        'mention most.',
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

/// Choices on the contact form.
const contactProjectTypes = [
  'New app',
  'Finish an existing app',
  'UI implementation',
  'Something else',
];

// TODO(me): set ranges in your currency, or delete them all to hide the field.
const contactBudgets = [
  'Not sure yet',
  'Small (a few weeks)',
  'Medium (1–3 months)',
  'Large (3+ months)',
];

/// Formspree form URL, e.g. 'https://formspree.io/f/abcdwxyz'. While null the
/// contact form opens a prefilled email instead.
// TODO(me): create a form at formspree.io and paste its endpoint here.
const String? contactFormEndpoint = null;

/// About › How this site is built: the layers, top (what you see) to bottom.
const siteLayers = [
  (
    'features/',
    'One folder per page: Work, Playground, About, Contact. Each owns its '
        'widgets and any page-local state.',
  ),
  (
    'shared/',
    'Layout and widgets every page uses: the shell, the page frame, the '
        'specimen frame, Inspectable and the spec-sheet marks.',
  ),
  (
    'core/',
    'Theme tokens, routing, app-wide state and all copy as const models, '
        'read by widgets only through Riverpod providers.',
  ),
];

/// About › How this site is built: decisions worth knowing.
const siteNotes = [
  (
    'Inspector mode is real',
    'Inspect draws outlines, padding and sizes from the live render tree, in '
        'release builds. When it is off, it costs one render object and no '
        'layer.',
  ),
  (
    'Code you see is code that runs',
    'Specimen source is read from the bundled source files between '
        '"#region snippet" markers; a test fails if a marker goes missing.',
  ),
  (
    'One shell, many pages',
    'GoRouter with a ShellRoute keeps the navbar alive across pages, with '
        'path URLs, redirects for old links and a 404 inside the shell.',
  ),
  (
    'Fonts before the first frame',
    'The three faces are bundled, never fetched. The HTML splash stays up '
        'until they load, so nothing reflows on arrival.',
  ),
];
