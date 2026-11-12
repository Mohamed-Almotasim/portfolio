// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get switchLanguage => 'العربية';

  @override
  String get navWork => 'Work';

  @override
  String get navPlayground => 'Playground';

  @override
  String get navAbout => 'About';

  @override
  String get navContact => 'Contact';

  @override
  String get home => 'Home';

  @override
  String get startProject => 'Start a project';

  @override
  String get hireMe => 'Hire me';

  @override
  String get openMenu => 'Open menu';

  @override
  String get inspectOn => 'Inspect: on';

  @override
  String get inspectOff => 'Inspect: off';

  @override
  String get inspectTooltipOn => 'Inspector mode on: hide layout and code';

  @override
  String get inspectTooltipOff =>
      'Inspector mode: show the layout and code behind the site';

  @override
  String get inspect => 'Inspect';

  @override
  String get darkTheme => 'Dark theme';

  @override
  String get themeToLight => 'Switch to light theme';

  @override
  String get themeToDark => 'Switch to dark theme';

  @override
  String get inspectorBanner =>
      'Inspector mode is on. Hover a section for its widget and size; click one to open the inspector. Demos show the real source.';

  @override
  String get howSiteBuilt => 'How this site is built';

  @override
  String get gotIt => 'Got it';

  @override
  String get seeTheWork => 'See the work';

  @override
  String get sectionSelectedWork => 'Selected work';

  @override
  String get allWork => 'All work';

  @override
  String get sectionTryOne => 'Try one';

  @override
  String get sectionWhatIDo => 'What I do';

  @override
  String get waysToWork => 'Ways to work together';

  @override
  String get sectionClients => 'What clients say';

  @override
  String get allReviewsFiverr => 'All reviews on Fiverr';

  @override
  String get sectionHowIWork => 'How I work';

  @override
  String get sectionTellMe => 'Tell me what you\'re building';

  @override
  String get copyEmail => 'Copy email address';

  @override
  String get emailCopied => 'Email address copied';

  @override
  String reviewLabel(String source) {
    return '$source review';
  }

  @override
  String get colNo => 'No.';

  @override
  String get colProject => 'Project';

  @override
  String get colType => 'Type';

  @override
  String get colYear => 'Year';

  @override
  String get stack => 'Stack';

  @override
  String get role => 'Role';

  @override
  String get openCaseStudy => 'Open case study';

  @override
  String openCaseStudyOf(String title) {
    return 'Open the $title case study';
  }

  @override
  String showOnPhone(String title) {
    return 'Show $title on the phone';
  }

  @override
  String get video => 'Video';

  @override
  String get videoPaused => 'Video · paused';

  @override
  String get loop => 'Loop';

  @override
  String get playLoop => 'Play the loop';

  @override
  String get noFootage => 'No footage yet';

  @override
  String figCaption(int n, String caption) {
    return 'Fig. $n · $caption';
  }

  @override
  String screenCaption(int n, String caption) {
    return 'Screen $n: $caption';
  }

  @override
  String footageOf(String title) {
    return '$title footage';
  }

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get replay => 'Replay';

  @override
  String get awaitingFootage => 'Awaiting footage';

  @override
  String get inspectThisPage => 'Inspect this page';

  @override
  String get stopInspecting => 'Stop inspecting';

  @override
  String get liveSpecimenCaption =>
      'Fig. 1 · A live FilledButton. Drag to change its padding.';

  @override
  String paddingValue(int n) {
    return 'Padding $n';
  }

  @override
  String get footer => 'Footer';

  @override
  String footerColophon(String year, String name) {
    return '© $year $name · Built in Flutter, every pixel a widget.';
  }

  @override
  String get controls => 'CONTROLS';

  @override
  String get readouts => 'READOUTS';

  @override
  String get reset => 'Reset';

  @override
  String get hide => '− hide';

  @override
  String get show => '+ show';

  @override
  String get ocWidth => 'width';

  @override
  String get ocSizeClass => 'size class';

  @override
  String get ocSelected => 'selected';

  @override
  String get ocLayout => 'layout';

  @override
  String get ocNone => 'none';

  @override
  String get ocListDetail => 'list + detail';

  @override
  String get ocOnePane => 'one pane';

  @override
  String get ocPhone => 'phone';

  @override
  String get ocTablet => 'tablet';

  @override
  String get ocDesktop => 'desktop';

  @override
  String get ocOrders => 'Orders';

  @override
  String get ocShipping => 'Shipping';

  @override
  String get ocSettings => 'Settings';

  @override
  String get ocOakDesk => 'Oak desk';

  @override
  String get ocWoolRug => 'Wool rug';

  @override
  String get ocDeskLamp => 'Desk lamp';

  @override
  String get ocBookshelf => 'Bookshelf';

  @override
  String get ocSideTable => 'Side table';

  @override
  String get ocFloorLamp => 'Floor lamp';

  @override
  String get ocShipped => 'Shipped';

  @override
  String get ocPacking => 'Packing';

  @override
  String get ocPaid => 'Paid';

  @override
  String get ocCarrierA => 'Carrier A · 2 days';

  @override
  String get ocCarrierB => 'Carrier B · 5 days';

  @override
  String get ocPickup => 'Pickup · free';

  @override
  String get ocNotifications => 'Notifications · on';

  @override
  String get ocCurrency => 'Currency · USD';

  @override
  String get ocLanguage => 'Language · English';

  @override
  String get ocSelectOrder => 'Select an order';

  @override
  String get ocDetailBlurb =>
      'The same detail widget is a full page on a phone and a pane on a desktop. Only the layout around it changes.';

  @override
  String get notFoundLead => 'There is no sheet at this address.';

  @override
  String get backHome => 'Back home';

  @override
  String get name => 'Name';

  @override
  String get basedIn => 'Based in';

  @override
  String get availability => 'Availability';

  @override
  String get replies => 'Replies';

  @override
  String get pgLead =>
      'Experiments, each proving one thing. Turn the knobs, break things and watch the app cope.';

  @override
  String get pgColSpecimen => 'Specimen';

  @override
  String get pgColProves => 'What it proves';

  @override
  String get pgColTags => 'Tags';

  @override
  String get spTryThis => 'TRY THIS';

  @override
  String get spWhyHard => 'WHY IT\'S HARD';

  @override
  String get abToolbox => 'Toolbox';

  @override
  String get abBuiltLead =>
      'A Flutter web app, top to bottom. Switch on Inspect to see the layout of any page.';

  @override
  String get abImportNote =>
      'Read top to bottom: what you see, what it is built from, what it stands on.';

  @override
  String get skillLanguages => 'Languages';

  @override
  String get skillFrameworks => 'Frameworks';

  @override
  String get skillBackend => 'Backend & APIs';

  @override
  String get skillState => 'State management';

  @override
  String get skillNavigation => 'Navigation';

  @override
  String get ctLead =>
      'Tell me what you\'re building and where you\'re stuck. I\'ll reply with how I\'d approach it and what it would take.';

  @override
  String get ctQuestions => 'Questions';

  @override
  String ctBestFor(String what) {
    return 'Best for: $what';
  }

  @override
  String ctFrom(String price) {
    return 'From $price';
  }

  @override
  String get ctWriteDirectly => 'Or write directly';

  @override
  String get ctEmail => 'Email';

  @override
  String get ctNameRequired => 'Please enter your name';

  @override
  String get ctEmailRequired => 'Please enter your email';

  @override
  String get ctEmailInvalid => 'Please enter a valid email';

  @override
  String get ctProjectKind => 'What kind of project?';

  @override
  String get ctBudget => 'Budget (optional)';

  @override
  String get ctBudgetHint => 'Select a range';

  @override
  String get ctMessage => 'Message';

  @override
  String get ctMessageHelper => 'Ctrl + Enter to send';

  @override
  String get ctMessageRequired => 'Please tell me a little about the project';

  @override
  String get ctSend => 'Send message';

  @override
  String get ctSending => 'Sending…';

  @override
  String get ctOpeningEmail => 'Opening your email…';

  @override
  String ctSent(String email) {
    return 'Thanks, your message was sent. I\'ll reply to $email.';
  }

  @override
  String ctSentMailto(String email) {
    return 'If no email app opened, email me at $email';
  }

  @override
  String ctFailedForm(String error, String email) {
    return 'Couldn\'t send your message: $error Please email me at $email instead.';
  }

  @override
  String ctFailedMailto(String email) {
    return 'Couldn\'t open your email app. Please write to $email directly.';
  }

  @override
  String ctServiceStatus(int code) {
    return 'The form service answered $code.';
  }

  @override
  String get ctServiceUnreachable => 'Couldn\'t reach the form service.';

  @override
  String get dsRowsBuilt => 'rows built';

  @override
  String get dsMatching => 'matching';

  @override
  String dsMatchingValue(String shown, String total) {
    return '$shown of $total';
  }

  @override
  String get dsFrameTime => 'frame time';

  @override
  String get dsList => 'list';

  @override
  String get dsNaiveCapped => 'naive, first 10,000';

  @override
  String get dsVirtualized => 'virtualized';

  @override
  String get dsNaive => 'naive';

  @override
  String get dsRows => 'rows';

  @override
  String get dsSort => 'sort';

  @override
  String get dsAmount => 'Amount';

  @override
  String get dsStatus => 'status';

  @override
  String get dsAll => 'All';

  @override
  String get dsOpen => 'Open';

  @override
  String get dsLate => 'Late';

  @override
  String get dsSearch => 'search';

  @override
  String get dsSearchHint => 'Name or ID';

  @override
  String get dsNoRows => 'No rows match.';

  @override
  String get osNetwork => 'network';

  @override
  String get osOnline => 'online';

  @override
  String get osOffline => 'offline';

  @override
  String get osQueue => 'queue';

  @override
  String get osSent => 'sent';

  @override
  String get osRetries => 'retries';

  @override
  String get osFailed => 'failed';

  @override
  String get osLatency => 'latency';

  @override
  String get osFailureRate => 'failure rate';

  @override
  String get osAddTask => 'Add task';

  @override
  String get osReload => 'Reload';

  @override
  String get osClearAll => 'Clear all';

  @override
  String get osOnlineBanner => 'Online. Changes are sent as you make them.';

  @override
  String get osOfflineBanner =>
      'Offline. Changes are kept on this device and sent when you reconnect.';

  @override
  String get osQueueEmpty => 'queue: empty';

  @override
  String osQueueItems(String items) {
    return 'queue: $items';
  }

  @override
  String get osSynced => 'synced';

  @override
  String get osPending => 'pending';

  @override
  String osRetryCount(int n, int max) {
    return 'retry $n/$max';
  }

  @override
  String get osRetry => 'Retry';

  @override
  String get osReloadFailedTitle => 'Couldn\'t reload';

  @override
  String get osReloadFailedBody =>
      'No connection. Showing what is saved on this device.';

  @override
  String get osTryAgain => 'Try again';

  @override
  String get osNoTasksTitle => 'No tasks yet';

  @override
  String get osNoTasksBody => 'Add one. It will sync when it can.';

  @override
  String get rbRowsVisible => 'rows visible';

  @override
  String get rbActionsAllowed => 'actions allowed';

  @override
  String get rbLastCheck => 'last check';

  @override
  String get rbNoneYet => 'none yet';

  @override
  String rbAllowed(String perm) {
    return 'allowed $perm';
  }

  @override
  String rbDenied(String perm, String who) {
    return 'denied $perm (needs $who)';
  }

  @override
  String rbNeeds(String who) {
    return 'Needs $who';
  }

  @override
  String get rbAdmin => 'Admin';

  @override
  String get rbStaff => 'Staff';

  @override
  String get rbCustomer => 'Customer';

  @override
  String get rbAdminOrStaff => 'Admin or Staff';

  @override
  String rbSignedInAsMe(String name) {
    return 'Signed in as $name.';
  }

  @override
  String rbSignedInAsRole(String role) {
    return 'Signed in as a $role account.';
  }

  @override
  String get rbAllOrders => 'All orders';

  @override
  String get rbYourOrders => 'Your orders';

  @override
  String get rbAdvance => 'Advance status';

  @override
  String get rbRefund => 'Refund';

  @override
  String get rbExport => 'Export CSV';

  @override
  String get rbCancelMine => 'Cancel mine';

  @override
  String get rbRefunded => 'Refunded';

  @override
  String get rbCancelled => 'Cancelled';

  @override
  String get rlDirection => 'direction';

  @override
  String get rlLocale => 'locale';

  @override
  String get rlTextSize => 'text size';

  @override
  String get rlSubtotal => 'subtotal';

  @override
  String get rlDate => 'date';

  @override
  String get rlLanguage => 'language';

  @override
  String get rlEasternNumerals => 'Eastern Arabic numerals';

  @override
  String get mlMode => 'mode';

  @override
  String get mlState => 'state';

  @override
  String get mlMoving => 'moving';

  @override
  String get mlSettled => 'settled';

  @override
  String get mlProgress => 'progress';

  @override
  String get mlPeakSpeed => 'peak speed';

  @override
  String get mlLastSettle => 'last settle';

  @override
  String get mlStudy => 'study';

  @override
  String get mlOrigami => 'Origami';

  @override
  String get mlMagnetic => 'Magnetic';

  @override
  String get mlSheet => 'Sheet';

  @override
  String get mlStiffness => 'stiffness';

  @override
  String get mlDamping => 'damping';

  @override
  String get mlDuration => 'duration';

  @override
  String get mlFold => 'Fold';

  @override
  String get mlUnfold => 'Unfold';

  @override
  String get mlRepel => 'repel instead of pull';

  @override
  String get mlOpen => 'Open';

  @override
  String get mlClose => 'Close';

  @override
  String get mlSlowMotion => 'slow motion (÷4)';

  @override
  String get mlMapBlurb =>
      'Map view\nDrag the sheet up and let go. It keeps the speed of your finger.';

  @override
  String mlMotionStudy(String mode) {
    return 'Motion study: $mode';
  }

  @override
  String get mlPlace1 => 'Harbour Cafe · 120 m';

  @override
  String get mlPlace2 => 'Old Library · 300 m';

  @override
  String get mlPlace3 => 'Central Market · 450 m';

  @override
  String get mlPlace4 => 'Riverside Park · 800 m';
}
