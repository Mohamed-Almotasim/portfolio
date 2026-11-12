// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get switchLanguage => 'English';

  @override
  String get navWork => 'الأعمال';

  @override
  String get navPlayground => 'المختبر';

  @override
  String get navAbout => 'نبذة عني';

  @override
  String get navContact => 'تواصل';

  @override
  String get home => 'الرئيسية';

  @override
  String get startProject => 'ابدأ مشروعك';

  @override
  String get hireMe => 'وظّفني';

  @override
  String get openMenu => 'فتح القائمة';

  @override
  String get inspectOn => 'الفحص: مفعّل';

  @override
  String get inspectOff => 'الفحص: متوقف';

  @override
  String get inspectTooltipOn => 'وضع الفحص مفعّل: إخفاء التخطيط والكود';

  @override
  String get inspectTooltipOff => 'وضع الفحص: إظهار التخطيط والكود خلف الموقع';

  @override
  String get inspect => 'الفحص';

  @override
  String get darkTheme => 'المظهر الداكن';

  @override
  String get themeToLight => 'التحويل إلى المظهر الفاتح';

  @override
  String get themeToDark => 'التحويل إلى المظهر الداكن';

  @override
  String get inspectorBanner =>
      'وضع الفحص مفعّل. مرّر المؤشر على أي قسم لترى الودجت وحجمها، وانقر عليه لفتح لوحة الفحص. العروض التجريبية تعرض الكود الحقيقي.';

  @override
  String get howSiteBuilt => 'كيف بُني هذا الموقع';

  @override
  String get gotIt => 'فهمت';

  @override
  String get seeTheWork => 'شاهد الأعمال';

  @override
  String get sectionSelectedWork => 'أعمال مختارة';

  @override
  String get allWork => 'كل الأعمال';

  @override
  String get sectionTryOne => 'جرّب بنفسك';

  @override
  String get sectionWhatIDo => 'ما أقدّمه';

  @override
  String get waysToWork => 'طرق العمل معي';

  @override
  String get sectionClients => 'ماذا يقول العملاء';

  @override
  String get allReviewsFiverr => 'كل التقييمات على Fiverr';

  @override
  String get sectionHowIWork => 'كيف أعمل';

  @override
  String get sectionTellMe => 'أخبرني ماذا تبني';

  @override
  String get copyEmail => 'نسخ البريد الإلكتروني';

  @override
  String get emailCopied => 'تم نسخ البريد الإلكتروني';

  @override
  String reviewLabel(String source) {
    return 'تقييم على $source';
  }

  @override
  String get colNo => 'الرقم';

  @override
  String get colProject => 'المشروع';

  @override
  String get colType => 'النوع';

  @override
  String get colYear => 'السنة';

  @override
  String get stack => 'التقنيات';

  @override
  String get role => 'الدور';

  @override
  String get openCaseStudy => 'افتح دراسة الحالة';

  @override
  String openCaseStudyOf(String title) {
    return 'افتح دراسة حالة $title';
  }

  @override
  String showOnPhone(String title) {
    return 'اعرض $title على الهاتف';
  }

  @override
  String get video => 'فيديو';

  @override
  String get videoPaused => 'فيديو · متوقف';

  @override
  String get loop => 'تكرار';

  @override
  String get playLoop => 'تشغيل العرض المتكرر';

  @override
  String get noFootage => 'لا توجد لقطات بعد';

  @override
  String figCaption(int n, String caption) {
    return 'شكل $n · $caption';
  }

  @override
  String screenCaption(int n, String caption) {
    return 'الشاشة $n: $caption';
  }

  @override
  String footageOf(String title) {
    return 'لقطات $title';
  }

  @override
  String get play => 'تشغيل';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get replay => 'إعادة التشغيل';

  @override
  String get awaitingFootage => 'بانتظار اللقطات';

  @override
  String get inspectThisPage => 'افحص هذه الصفحة';

  @override
  String get stopInspecting => 'أوقف الفحص';

  @override
  String get liveSpecimenCaption =>
      'شكل 1 · زر FilledButton حي. اسحب لتغيير الحشوة.';

  @override
  String paddingValue(int n) {
    return 'الحشوة $n';
  }

  @override
  String get footer => 'التذييل';

  @override
  String footerColophon(String year, String name) {
    return '© $year $name · مبني بـ Flutter، كل بكسل فيه ودجت.';
  }

  @override
  String get controls => 'عناصر التحكم';

  @override
  String get readouts => 'القراءات';

  @override
  String get reset => 'إعادة ضبط';

  @override
  String get hide => '− إخفاء';

  @override
  String get show => '+ إظهار';

  @override
  String get ocWidth => 'العرض';

  @override
  String get ocSizeClass => 'فئة الحجم';

  @override
  String get ocSelected => 'المحدد';

  @override
  String get ocLayout => 'التخطيط';

  @override
  String get ocNone => 'لا شيء';

  @override
  String get ocListDetail => 'قائمة + تفاصيل';

  @override
  String get ocOnePane => 'لوحة واحدة';

  @override
  String get ocPhone => 'هاتف';

  @override
  String get ocTablet => 'لوحي';

  @override
  String get ocDesktop => 'سطح المكتب';

  @override
  String get ocOrders => 'الطلبات';

  @override
  String get ocShipping => 'الشحن';

  @override
  String get ocSettings => 'الإعدادات';

  @override
  String get ocOakDesk => 'مكتب من خشب البلوط';

  @override
  String get ocWoolRug => 'سجادة صوف';

  @override
  String get ocDeskLamp => 'مصباح مكتب';

  @override
  String get ocBookshelf => 'رف كتب';

  @override
  String get ocSideTable => 'طاولة جانبية';

  @override
  String get ocFloorLamp => 'مصباح أرضي';

  @override
  String get ocShipped => 'تم الشحن';

  @override
  String get ocPacking => 'قيد التجهيز';

  @override
  String get ocPaid => 'مدفوع';

  @override
  String get ocCarrierA => 'شركة الشحن أ · يومان';

  @override
  String get ocCarrierB => 'شركة الشحن ب · 5 أيام';

  @override
  String get ocPickup => 'الاستلام من المتجر · مجانًا';

  @override
  String get ocNotifications => 'الإشعارات · مفعّلة';

  @override
  String get ocCurrency => 'العملة · USD';

  @override
  String get ocLanguage => 'اللغة · العربية';

  @override
  String get ocSelectOrder => 'اختر طلبًا';

  @override
  String get ocDetailBlurb =>
      'ودجت التفاصيل نفسها صفحة كاملة على الهاتف ولوحة على سطح المكتب. لا يتغير إلا التخطيط من حولها.';

  @override
  String get notFoundLead => 'لا توجد صفحة على هذا العنوان.';

  @override
  String get backHome => 'العودة إلى الرئيسية';

  @override
  String get name => 'الاسم';

  @override
  String get basedIn => 'المقر';

  @override
  String get availability => 'التوفّر';

  @override
  String get replies => 'الرد';

  @override
  String get pgLead =>
      'تجارب، كل واحدة تثبت شيئًا واحدًا. حرّك المفاتيح، عطّل الأشياء وراقب كيف يتصرف التطبيق.';

  @override
  String get pgColSpecimen => 'العيّنة';

  @override
  String get pgColProves => 'ما الذي تثبته';

  @override
  String get pgColTags => 'الوسوم';

  @override
  String get spTryThis => 'جرّب هذا';

  @override
  String get spWhyHard => 'لماذا هو صعب';

  @override
  String get abToolbox => 'الأدوات';

  @override
  String get abBuiltLead =>
      'تطبيق Flutter للويب من أوله إلى آخره. فعّل وضع الفحص لترى تخطيط أي صفحة.';

  @override
  String get abImportNote =>
      'اقرأ من الأعلى إلى الأسفل: ما تراه، ثم ما بُني منه، ثم ما يستند إليه.';

  @override
  String get skillLanguages => 'اللغات';

  @override
  String get skillFrameworks => 'الإطارات';

  @override
  String get skillBackend => 'الخوادم والـ API';

  @override
  String get skillState => 'إدارة الحالة';

  @override
  String get skillNavigation => 'التنقّل';

  @override
  String get ctLead =>
      'أخبرني بما تبنيه وأين توقفت. سأرد عليك بطريقة تعاملي مع المشروع وما يتطلبه.';

  @override
  String get ctQuestions => 'أسئلة';

  @override
  String ctBestFor(String what) {
    return 'الأنسب لـ: $what';
  }

  @override
  String ctFrom(String price) {
    return 'ابتداءً من $price';
  }

  @override
  String get ctWriteDirectly => 'أو راسلني مباشرة';

  @override
  String get ctEmail => 'البريد الإلكتروني';

  @override
  String get ctNameRequired => 'يرجى إدخال اسمك';

  @override
  String get ctEmailRequired => 'يرجى إدخال بريدك الإلكتروني';

  @override
  String get ctEmailInvalid => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String get ctProjectKind => 'ما نوع المشروع؟';

  @override
  String get ctBudget => 'الميزانية (اختياري)';

  @override
  String get ctBudgetHint => 'اختر نطاقًا';

  @override
  String get ctMessage => 'الرسالة';

  @override
  String get ctMessageHelper => 'Ctrl + Enter للإرسال';

  @override
  String get ctMessageRequired => 'يرجى إخباري قليلًا عن المشروع';

  @override
  String get ctSend => 'إرسال الرسالة';

  @override
  String get ctSending => 'جارٍ الإرسال…';

  @override
  String get ctOpeningEmail => 'جارٍ فتح بريدك…';

  @override
  String ctSent(String email) {
    return 'شكرًا، تم إرسال رسالتك. سأرد على $email.';
  }

  @override
  String ctSentMailto(String email) {
    return 'إن لم يُفتح تطبيق البريد، راسلني على $email';
  }

  @override
  String ctFailedForm(String error, String email) {
    return 'تعذّر إرسال رسالتك: $error يرجى مراسلتي على $email.';
  }

  @override
  String ctFailedMailto(String email) {
    return 'تعذّر فتح تطبيق البريد. يرجى مراسلتي مباشرة على $email.';
  }

  @override
  String ctServiceStatus(int code) {
    return 'ردّت خدمة النموذج بالرمز $code.';
  }

  @override
  String get ctServiceUnreachable => 'تعذّر الوصول إلى خدمة النموذج.';

  @override
  String get dsRowsBuilt => 'الصفوف المبنية';

  @override
  String get dsMatching => 'المطابِقة';

  @override
  String dsMatchingValue(String shown, String total) {
    return '$shown من $total';
  }

  @override
  String get dsFrameTime => 'زمن الإطار';

  @override
  String get dsList => 'القائمة';

  @override
  String get dsNaiveCapped => 'بسيطة، أول 10,000';

  @override
  String get dsVirtualized => 'افتراضية';

  @override
  String get dsNaive => 'بسيطة';

  @override
  String get dsRows => 'الصفوف';

  @override
  String get dsSort => 'الترتيب';

  @override
  String get dsAmount => 'المبلغ';

  @override
  String get dsStatus => 'الحالة';

  @override
  String get dsAll => 'الكل';

  @override
  String get dsOpen => 'مفتوح';

  @override
  String get dsLate => 'متأخر';

  @override
  String get dsSearch => 'بحث';

  @override
  String get dsSearchHint => 'الاسم أو المعرّف';

  @override
  String get dsNoRows => 'لا صفوف مطابقة.';

  @override
  String get osNetwork => 'الشبكة';

  @override
  String get osOnline => 'متصل';

  @override
  String get osOffline => 'غير متصل';

  @override
  String get osQueue => 'الطابور';

  @override
  String get osSent => 'المُرسَل';

  @override
  String get osRetries => 'إعادة المحاولات';

  @override
  String get osFailed => 'فشل';

  @override
  String get osLatency => 'التأخير';

  @override
  String get osFailureRate => 'نسبة الفشل';

  @override
  String get osAddTask => 'إضافة مهمة';

  @override
  String get osReload => 'إعادة التحميل';

  @override
  String get osClearAll => 'مسح الكل';

  @override
  String get osOnlineBanner => 'متصل. تُرسَل التغييرات فور إجرائها.';

  @override
  String get osOfflineBanner =>
      'غير متصل. تُحفظ التغييرات على هذا الجهاز وتُرسَل عند عودة الاتصال.';

  @override
  String get osQueueEmpty => 'الطابور: فارغ';

  @override
  String osQueueItems(String items) {
    return 'الطابور: $items';
  }

  @override
  String get osSynced => 'تمت المزامنة';

  @override
  String get osPending => 'قيد الانتظار';

  @override
  String osRetryCount(int n, int max) {
    return 'محاولة $n/$max';
  }

  @override
  String get osRetry => 'إعادة المحاولة';

  @override
  String get osReloadFailedTitle => 'تعذّرت إعادة التحميل';

  @override
  String get osReloadFailedBody =>
      'لا يوجد اتصال. نعرض ما هو محفوظ على هذا الجهاز.';

  @override
  String get osTryAgain => 'حاول مجددًا';

  @override
  String get osNoTasksTitle => 'لا مهام بعد';

  @override
  String get osNoTasksBody => 'أضف مهمة. ستُزامَن عندما يتاح ذلك.';

  @override
  String get rbRowsVisible => 'الصفوف الظاهرة';

  @override
  String get rbActionsAllowed => 'الإجراءات المسموحة';

  @override
  String get rbLastCheck => 'آخر تحقق';

  @override
  String get rbNoneYet => 'لا شيء بعد';

  @override
  String rbAllowed(String perm) {
    return 'مسموح $perm';
  }

  @override
  String rbDenied(String perm, String who) {
    return 'مرفوض $perm (يتطلب $who)';
  }

  @override
  String rbNeeds(String who) {
    return 'يتطلب $who';
  }

  @override
  String get rbAdmin => 'مدير';

  @override
  String get rbStaff => 'موظف';

  @override
  String get rbCustomer => 'عميل';

  @override
  String get rbAdminOrStaff => 'مدير أو موظف';

  @override
  String rbSignedInAsMe(String name) {
    return 'تم تسجيل الدخول باسم $name.';
  }

  @override
  String rbSignedInAsRole(String role) {
    return 'تم تسجيل الدخول بحساب $role.';
  }

  @override
  String get rbAllOrders => 'كل الطلبات';

  @override
  String get rbYourOrders => 'طلباتك';

  @override
  String get rbAdvance => 'تقديم الحالة';

  @override
  String get rbRefund => 'استرداد';

  @override
  String get rbExport => 'تصدير CSV';

  @override
  String get rbCancelMine => 'إلغاء طلبي';

  @override
  String get rbRefunded => 'مُستردّ';

  @override
  String get rbCancelled => 'ملغى';

  @override
  String get rlDirection => 'الاتجاه';

  @override
  String get rlLocale => 'اللغة والمنطقة';

  @override
  String get rlTextSize => 'حجم النص';

  @override
  String get rlSubtotal => 'المجموع الفرعي';

  @override
  String get rlDate => 'التاريخ';

  @override
  String get rlLanguage => 'اللغة';

  @override
  String get rlEasternNumerals => 'الأرقام العربية المشرقية';

  @override
  String get mlMode => 'الوضع';

  @override
  String get mlState => 'الحالة';

  @override
  String get mlMoving => 'يتحرك';

  @override
  String get mlSettled => 'مستقر';

  @override
  String get mlProgress => 'التقدّم';

  @override
  String get mlPeakSpeed => 'أقصى سرعة';

  @override
  String get mlLastSettle => 'آخر استقرار';

  @override
  String get mlStudy => 'الدراسة';

  @override
  String get mlOrigami => 'أوريغامي';

  @override
  String get mlMagnetic => 'مغناطيسي';

  @override
  String get mlSheet => 'لوحة سفلية';

  @override
  String get mlStiffness => 'الصلابة';

  @override
  String get mlDamping => 'التخميد';

  @override
  String get mlDuration => 'المدة';

  @override
  String get mlFold => 'اطوِ';

  @override
  String get mlUnfold => 'افرد';

  @override
  String get mlRepel => 'تنافر بدل الجذب';

  @override
  String get mlOpen => 'فتح';

  @override
  String get mlClose => 'إغلاق';

  @override
  String get mlSlowMotion => 'حركة بطيئة (÷4)';

  @override
  String get mlMapBlurb =>
      'عرض الخريطة\nاسحب اللوحة إلى الأعلى ثم اتركها. تحتفظ بسرعة إصبعك.';

  @override
  String mlMotionStudy(String mode) {
    return 'دراسة الحركة: $mode';
  }

  @override
  String get mlPlace1 => 'مقهى الميناء · 120 م';

  @override
  String get mlPlace2 => 'المكتبة القديمة · 300 م';

  @override
  String get mlPlace3 => 'السوق المركزي · 450 م';

  @override
  String get mlPlace4 => 'حديقة النهر · 800 م';
}
