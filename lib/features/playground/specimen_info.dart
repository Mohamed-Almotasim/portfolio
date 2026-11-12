import 'package:flutter/widgets.dart';

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

/// Arabic copy by slug; tags and techniques stay as the code spells them.
// TODO(me): review these translations.
const _ar =
    <String, ({String name, String claim, List<String> tryThis, String why})>{
      'one-codebase': (
        name: 'كود واحد، ثلاثة أجهزة',
        claim:
            'شجرة ودجات واحدة تعمل كتطبيق هاتف وتابلت وسطح مكتب، وتحتفظ بما '
            'اخترته وهي تغيّر شكلها.',
        tryThis: [
          'اسحب المقبض أو شريط التمرير من عرض الهاتف إلى عرض سطح المكتب.',
          'اختر طلبًا ثم غيّر الحجم: يبقى الاختيار كما هو.',
          'افتح طلبًا على الهاتف ثم وسّع العرض: القائمة والتفاصيل جنبًا إلى جنب.',
        ],
        why:
            'معظم التطبيقات تُبنى من جديد لكل جهاز، فيضيع الاختيار أو النموذج '
            'نصف المكتوب عند تغيّر حجم النافذة. هنا يقرأ التخطيط عرضه بنفسه '
            'والحالة محفوظة فوقه.',
      ),
      'role-based-ui': (
        name: 'واجهة حسب الدور',
        claim:
            'الشاشة نفسها تغيّر ما يراه كل دور وما يستطيع فعله، والإجراء '
            'المقفل يشرح السبب.',
        tryThis: [
          'بدّل بين المدير والموظف والعميل.',
          'اضغط إجراءً مقفلًا واقرأ سبب قفله.',
          'فعّل وضع الفحص وافتح الإجراءات: فحوص الصلاحيات مسمّاة.',
        ],
        why:
            'إخفاء الزر ليس أمانًا، والزر الذي يختفي بصمت يتحول إلى تذكرة '
            'دعم. الصلاحيات في جدول واحد، تسأله الواجهة، وعلى الخادم أن '
            'يتحقق من الجدول نفسه.',
      ),
      'data-at-scale': (
        name: 'بيانات بحجم كبير',
        claim:
            'عشرة آلاف صف تبقى سلسة مع البحث والترتيب والتصفية، لأن الصفوف '
            'الظاهرة على الشاشة فقط هي التي تُبنى.',
        tryThis: [
          'بدّل بين «بسيطة» و«افتراضية» وراقب «الصفوف المبنية».',
          'ارفع عدد الصفوف ثم مرّر بسرعة.',
          'اكتب في مربع البحث وغيّر الترتيب.',
        ],
        why:
            'القائمة التي تبني كل صف تبدو جيدة مع 50 صفًا وتتجمد مع 10,000. '
            'القائمة الافتراضية تبني الظاهر فقط، فتبقى التكلفة ثابتة مهما '
            'كبرت البيانات.',
      ),
      'offline-sync': (
        name: 'العمل دون اتصال والمزامنة',
        claim:
            'الإجراءات تعمل دون اتصال، تنتظر في طابور، تعيد المحاولة وتتطابق '
            'دون أن يضيع شيء.',
        tryThis: [
          'اقطع الاتصال، أضف مهمتين، ثم عد إلى الاتصال.',
          'ارفع نسبة الفشل وراقب إعادة المحاولات ثم مهمة فاشلة.',
          'اضغط «إعادة التحميل» وأنت غير متصل لترى حالة الخطأ.',
        ],
        why:
            'الشبكات تنقطع في منتصف الطريق. على التطبيق أن يُظهر التغيير '
            'فورًا، يتذكره، يعيد المحاولة بعقل ويقول بوضوح ما الذي لم يصل، '
            'بدل الدوران بلا نهاية أو إسقاطه بصمت.',
      ),
      'rtl-localization': (
        name: 'RTL والتعريب',
        claim:
            'شاشة واحدة تنقلب إلى العربية من اليمين إلى اليسار بتخطيط وأرقام '
            'وتواريخ وحجم نص صحيحة.',
        tryThis: [
          'بدّل من الإنجليزية إلى العربية وراقب انعكاس التخطيط.',
          'غيّر الكمية واقرأ الإجمالي المنسّق.',
          'اسحب حجم النص إلى 200%.',
        ],
        why:
            'الانعكاس أكثر من قلب النص: الحشوات والأيقونات والمحاذاة وأشكال '
            'الأرقام والتواريخ كلها تتغير. إذا بُني بودجات اتجاهية من '
            'البداية فهو مجاني، وإذا أُضيف لاحقًا فهو إعادة كتابة.',
      ),
      'motion-lab': (
        name: 'مختبر الحركة',
        claim: 'حركة قابلة للضبط، فيزيائية، وتعمل مع اللمس ومع تقليل الحركة.',
        tryThis: [
          'اطوِ الأوريغامي وافرده، ثم أبطئه.',
          'تحرّك فوق الشبكة المغناطيسية، أو اسحب على الهاتف.',
          'اسحب اللوحة واتركها: تستقر بالنابض الذي ضبطته.',
        ],
        why:
            'الحركة الجيدة فيزياء لا مدة ثابتة: تحتفظ بسرعة إصبعك. وعليها أن '
            'تتوقف حين لا ينظر أحد، وأن تحترم من يوقفون الحركة.',
      ),
    };

final _specimensAr = [
  for (final s in specimens)
    if (_ar[s.slug] case final ar?)
      SpecimenInfo(
        slug: s.slug,
        name: ar.name,
        claim: ar.claim,
        tags: s.tags,
        techniques: s.techniques,
        tryThis: ar.tryThis,
        whyHard: ar.why,
      )
    else
      s,
];

/// [specimens] in the page's language.
List<SpecimenInfo> specimensOf(BuildContext context) =>
    Localizations.localeOf(context).languageCode == 'ar'
    ? _specimensAr
    : specimens;

SpecimenInfo? specimenBySlug(String slug) =>
    specimens.where((s) => s.slug == slug).firstOrNull;
