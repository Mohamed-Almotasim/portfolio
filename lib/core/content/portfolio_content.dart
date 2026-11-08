import 'package:flutter/material.dart';
import 'package:portfolio/core/content/case_study.dart';
import 'package:portfolio/core/content/engagement_model.dart';
import 'package:portfolio/core/content/faq_item.dart';
import 'package:portfolio/core/content/process_step.dart';
import 'package:portfolio/core/content/profile.dart';
import 'package:portfolio/core/content/project_media.dart';
import 'package:portfolio/core/content/proof_stat.dart';
import 'package:portfolio/core/content/service_offering.dart';
import 'package:portfolio/core/content/skill.dart';
import 'package:portfolio/core/content/testimonial.dart';

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
  photo: 'assets/images/profile.jpg',
  email: 'moalmotasim98@yahoo.com',
  availability: 'Open to freelance projects',
  responseTime: 'Usually within 1–2 hours',
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

// Footage for the bench goes in assets/projects/ (docs/MEDIA.md). Order here
// is the order on /work and on the landing-page bench.
const caseStudies = [
  // From github.com/Mohamed-Almotasim/dukkan (README).
  CaseStudy(
    slug: 'dukkan',
    title: 'Dukkan',
    type: 'Point of sale',
    outcome: 'Sales keep working offline and sync when the network returns.',
    tagline:
        'An offline-first inventory and point-of-sale app for small shops, in '
        'Arabic and English.',
    problem:
        'Small shops lose sales when the connection drops, and owners need to '
        'trust that a cashier cannot change prices, stock or reports. The app '
        'had to work on a cheap phone, in Arabic and English.',
    solution:
        'Every sale is one database transaction: it saves the sale, decrements '
        'stock after a guarded check, writes a stock movement per line and '
        'queues the sync in a transactional outbox. A sync engine pushes the '
        'queue with exponential backoff and resolves conflicts last-write-wins '
        'with an audit entry. Owner and cashier permissions are enforced in '
        'the application layer by one PermissionPolicy that the router guards '
        'and the UI also use.',
    result:
        'Two roles in one app with an audited stock log, a live owner '
        'dashboard and full RTL. A hidden network lab simulates going offline, '
        'latency and failures, and the whole flow is covered by tests that '
        'run headlessly in CI.',
    techStack: ['Flutter', 'Riverpod 3', 'Sembast', 'GoRouter', 'Arabic RTL'],
    role: 'Solo developer',
    year: 2026,
    links: [
      CaseStudyLink(
        label: 'GitHub',
        url: 'https://github.com/Mohamed-Almotasim/dukkan',
        icon: Icons.code,
      ),
    ],
    media: ProjectMedia(
      prefix: 'Dukkan',
      captions: [
        'Sign in as the owner or the cashier',
        'Stock log: every sale, restock and adjustment',
        'Products with search and stock filters',
        "Owner overview: today's revenue and best sellers",
        'Sell: product grid and cart',
      ],
      notes: [
        InspectNote(2, 'Revenue chart: CustomPainter'),
        InspectNote(5, 'POS tiles rebuild via select()'),
        InspectNote(8, 'Stock log: live database query'),
        InspectNote(12, 'Roles: one PermissionPolicy'),
        InspectNote(16, 'Cashier: view-only products'),
      ],
    ),
    featured: true,
  ),
  // From github.com/Mohamed-Almotasim/recall (README).
  CaseStudy(
    slug: 'recall',
    title: 'Recall',
    type: 'Learning app',
    outcome: 'Cards graded by swipe, scheduled by a fully tested SM-2.',
    tagline:
        'A spaced-repetition flashcard app with physics-based swipe grading, '
        'hand-painted stats and full Arabic support.',
    problem:
        'Flashcard apps live or die on two things: a scheduler you can trust '
        'and a study loop that feels good enough to come back to every day.',
    solution:
        'The SM-2 scheduler is a pure Dart module behind a Clock interface, '
        'with table-driven tests that assert exact intervals. Study sessions '
        'are a Notifier with sealed states. Cards flip in 3D and are graded '
        'by swiping, driven by a SpringSimulation so release velocity carries '
        'into the throw. Stats are computed from review logs and drawn with '
        'CustomPainter.',
    result:
        'A yearly heatmap, retention curve and maturity breakdown with no '
        'chart package, CSV/TSV import and JSON export, keyboard shortcuts on '
        'larger screens, reduced-motion support and full RTL in both '
        'directions per card.',
    techStack: ['Flutter', 'Riverpod 3', 'drift (SQLite)', 'CustomPainter'],
    role: 'Solo developer',
    year: 2026,
    links: [
      CaseStudyLink(
        label: 'GitHub',
        url: 'https://github.com/Mohamed-Almotasim/recall',
        icon: Icons.code,
      ),
    ],
    media: ProjectMedia(
      prefix: 'Recall',
      captions: [
        'Animated splash, one CustomPainter',
        'Decks: three seeded demo decks',
        "Deck detail: cards and what's due",
        'Study: tap to flip, swipe to grade',
        'Progress: streak, maturity and heatmap',
      ],
      notes: [
        InspectNote(1, 'Splash: one CustomPainter'),
        InspectNote(7, 'Heatmap repaints only on new data'),
        InspectNote(21, 'Arabic: full RTL'),
        InspectNote(31, 'Session: sealed-state Notifier'),
        InspectNote(35, 'Swipe: SpringSimulation'),
      ],
    ),
    featured: true,
  ),
  // From github.com/Mohamed-Almotasim/attend (README).
  CaseStudy(
    slug: 'attend',
    title: 'Attend',
    type: 'Attendance tracker',
    outcome: 'Check-ins that only count within 30 m of the classroom.',
    tagline:
        'A GPS-verified attendance tracker that helps teachers and college '
        'staff track attendance and spot at-risk students early.',
    problem:
        'College attendance has to show a student was actually in the room, '
        'and teachers need to see who is at risk of failing before final '
        'grades are in.',
    solution:
        'Students check in from their phone and the app checks their GPS '
        "position against the classroom's: within 30 m, widened by the "
        'reported accuracy (up to 20 m), with a second high-accuracy reading '
        'before rejecting. Teachers manage subjects, schedules, students and '
        'grades, and Firestore security rules enforce role-based access.',
    result:
        'Two roles in one app, grade export to PDF and CSV, and per-student '
        'risk predictions built on transparent rules, so a teacher can see '
        'why a student was flagged.',
    techStack: ['Flutter', 'Firebase', 'Riverpod', 'GoRouter'],
    role: 'Flutter developer',
    year: 2026,
    links: [
      CaseStudyLink(
        label: 'GitHub',
        url: 'https://github.com/Mohamed-Almotasim/attend',
        icon: Icons.code,
      ),
    ],
    media: ProjectMedia(
      prefix: 'Attend',
      captions: [
        'Sign-in, with "Remember me"',
        'Risk predictions with filters',
        'Classes by day',
        'Teacher dashboard',
      ],
    ),
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
  ProofStat(label: 'Apps published to Google Play', value: '5'),
];

/// Where "All reviews on Fiverr" leads.
const fiverrProfileUrl = 'https://www.fiverr.com/seller/mohamedalmotasi';

// Quoted as written on Fiverr; "…" marks a cut, nothing is reworded.
const testimonials = [
  Testimonial(
    quote:
        'Brilliant seller, app is perfectly as I described and the seller '
        'understood my idea. Would definitely recommend and use this seller '
        'again.',
    author: 'jord_ob',
    country: 'Ireland',
  ),
  Testimonial(
    quote:
        'Within about 15 minutes of a short conversation mohamedalmotasi gave '
        'me a small series of instructions to follow and I solved the task '
        '… saved me about 10 hours of searching around on Google and Youtube '
        'trying to solve the problem myself. … Easy to work with and '
        'communicate with. A+++',
    author: 'garyjames88',
    country: 'Australia',
  ),
  Testimonial(
    quote:
        'Great experience, it helped me a lot and it was extremely fast, I '
        'recommend it with confidence.',
    author: 'noraur',
    country: 'Romania',
  ),
  Testimonial(
    quote: 'Great support! Helped me even though it was not in the order.',
    author: 'timuruckun',
    country: 'Turkey',
  ),
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

/// Formspree form URL the contact form posts to. The provider is nullable:
/// overriding it with null switches the form to a prefilled email instead.
const contactFormEndpoint = 'https://formspree.io/f/xzeeqoow';

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
