/// What the register and a specimen's header say about it. Kept apart from
/// the specimen widgets (which are deferred) so titles and links stay cheap.
class SpecimenInfo {
  const SpecimenInfo({
    required this.slug,
    required this.name,
    required this.claim,
    required this.tags,
    required this.techniques,
    required this.tryThis,
    required this.whyHard,
  });

  final String slug;
  final String name;

  /// One line: what this proves.
  final String claim;
  final List<String> tags;

  /// Widgets and techniques, shown in mono under the title.
  final String techniques;
  final List<String> tryThis;
  final String whyHard;
}

const specimens = [
  SpecimenInfo(
    slug: 'one-codebase',
    name: 'One codebase, three devices',
    claim:
        'One widget tree is a phone, a tablet and a desktop app, and keeps '
        'what you selected while it changes shape.',
    tags: ['Responsive', 'State'],
    techniques: 'LayoutBuilder · NavigationRail · NavigationBar',
    tryThis: [
      'Drag the handle, or the slider, from phone to desktop width.',
      'Select an order, then resize: the selection survives.',
      'Open an order on the phone, then widen it: list and detail sit side by side.',
    ],
    whyHard:
        'Most apps are rebuilt per device, so a selection or a half-typed '
        'form is lost when the window changes. Here the layout reads its own '
        'width and the state lives above it.',
  ),
  SpecimenInfo(
    slug: 'role-based-ui',
    name: 'Role-based UI',
    claim:
        'The same screen changes what each role can see and do, and a '
        'locked action says why.',
    tags: ['Auth', 'Admin'],
    techniques: 'Permission map · enum · disabled-with-reason',
    tryThis: [
      'Switch between Admin, Staff and Customer.',
      'Press a locked action and read why it is locked.',
      'Turn on Inspect and open the actions: the permission checks are named.',
    ],
    whyHard:
        'Hiding a button is not security, and a button that is silently '
        'missing is a support ticket. Permissions live in one table, the UI '
        'asks it, and the server must check the same table.',
  ),
  SpecimenInfo(
    slug: 'data-at-scale',
    name: 'Data at scale',
    claim:
        'Ten thousand rows stay smooth with search, sort and filter, because '
        'only the rows on screen are built.',
    tags: ['Performance', 'Lists'],
    techniques: 'ListView.builder · itemExtent · frame timings',
    tryThis: [
      'Switch between Naive and Virtualized and watch "rows built".',
      'Raise the row count, then scroll fast.',
      'Type in the search box and change the sort.',
    ],
    whyHard:
        'A list that builds every row feels fine with 50 rows and freezes '
        'with 10,000. Virtualizing builds only what is visible, so cost '
        'stays flat as the data grows.',
  ),
  SpecimenInfo(
    slug: 'offline-sync',
    name: 'Offline and sync',
    claim:
        'Actions work with no connection, queue up, retry and reconcile '
        'without losing anything.',
    tags: ['Offline', 'Reliability'],
    techniques: 'Optimistic update · queue · retry with limit',
    tryThis: [
      'Go offline, add two tasks, then go back online.',
      'Raise the failure rate and watch retries, then a failed task.',
      'Press Reload while offline to see the error state.',
    ],
    whyHard:
        'Networks fail halfway. The app has to show the change at once, '
        'remember it, retry sensibly and say plainly what did not go '
        'through, instead of spinning or silently dropping it.',
  ),
  SpecimenInfo(
    slug: 'rtl-localization',
    name: 'RTL and localization',
    claim:
        'One screen flips to right-to-left Arabic with correct layout, '
        'numbers, dates and text size.',
    tags: ['i18n', 'RTL'],
    techniques: 'Directionality · EdgeInsetsDirectional · TextScaler',
    tryThis: [
      'Switch English to Arabic and watch the layout mirror.',
      'Change the quantity and read the formatted total.',
      'Drag the text size to 200%.',
    ],
    whyHard:
        'Mirroring is more than flipping text: padding, icons, alignment, '
        'number shapes and dates all change. Built with directional '
        'widgets from the start, it is free; retrofitted, it is a rewrite.',
  ),
  SpecimenInfo(
    slug: 'motion-lab',
    name: 'Motion lab',
    claim:
        'Motion that is tunable, physical and still works on touch and with '
        'reduced motion.',
    tags: ['Animation', 'Physics'],
    techniques: 'Spring simulation · Transform · Ticker',
    tryThis: [
      'Fold and unfold the origami, then slow it down.',
      'Move across the magnetic grid, or drag on a phone.',
      'Drag the sheet and let go: it settles with the spring you set.',
    ],
    whyHard:
        'Good motion is physics, not a fixed duration: it keeps the speed '
        'of your finger. It also has to stop when nobody is looking and '
        'respect people who turn motion off.',
  ),
];

SpecimenInfo? specimenBySlug(String slug) =>
    specimens.where((s) => s.slug == slug).firstOrNull;
