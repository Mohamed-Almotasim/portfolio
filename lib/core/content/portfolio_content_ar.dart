import 'package:flutter/material.dart';
import 'package:portfolio/core/content/case_study.dart';
import 'package:portfolio/core/content/engagement_model.dart';
import 'package:portfolio/core/content/faq_item.dart';
import 'package:portfolio/core/content/portfolio_content.dart' as en;
import 'package:portfolio/core/content/process_step.dart';
import 'package:portfolio/core/content/profile.dart';
import 'package:portfolio/core/content/project_media.dart';
import 'package:portfolio/core/content/proof_stat.dart';
import 'package:portfolio/core/content/service_offering.dart';

// Arabic copy for the landing, About and Contact pages. Providers pick it when the locale is
// Arabic; links, slugs, media and anything not listed here come from the
// English file. Client reviews stay as written on Fiverr.

// TODO(me): review every translation here.
final profile = Profile(
  name: 'محمد المعتصم صالح',
  title: 'مطوّر Flutter',
  tagline: 'تطبيقات Flutter جاهزة للنشر.',
  shortBio:
      'مطوّر Flutter مستقل منذ 2020. أبني تطبيقات غنية بالبيانات ومتعددة '
      'الأدوار، وأستلم المشاريع غير المكتملة لأوصلها إلى النشر. '
      'فعّل وضع الفحص لترى كيف بُني هذا الموقع.',
  location: 'الخرطوم، السودان',
  photo: en.profile.photo,
  email: en.profile.email,
  availability: 'متاح لمشاريع العمل الحر',
  responseTime: 'عادةً خلال ساعة إلى ساعتين',
  socials: en.profile.socials,
  resumeUrl: en.profile.resumeUrl,
);

/// What the landing page shows of a case study, by slug.
const _studies =
    <
      String,
      ({
        String type,
        String outcome,
        String role,
        String tagline,
        String problem,
        String solution,
        String result,
        List<String> captions,
        List<String> notes,
      })
    >{
      'dukkan': (
        type: 'نقطة بيع',
        outcome: 'المبيعات تستمر دون اتصال وتُزامَن عند عودة الشبكة.',
        role: 'مطوّر منفرد',
        tagline:
            'تطبيق مخزون ونقطة بيع للمتاجر الصغيرة يعمل دون اتصال أولًا، '
            'بالعربية والإنجليزية.',
        problem:
            'المتاجر الصغيرة تخسر مبيعاتها عند انقطاع الاتصال، ويحتاج المالك '
            'إلى الثقة بأن الكاشير لا يستطيع تغيير الأسعار أو المخزون أو '
            'التقارير. كان على التطبيق أن يعمل على هاتف رخيص، بالعربية '
            'والإنجليزية.',
        solution:
            'كل عملية بيع معاملة قاعدة بيانات واحدة: تحفظ البيع، وتخصم المخزون '
            'بعد فحص محكوم، وتكتب حركة مخزون لكل بند، وتضع المزامنة في طابور '
            'صادر معاملاتي. يدفع محرّك المزامنة الطابور مع تراجع أُسّي '
            'ويحلّ التعارض بقاعدة «آخر كتابة تفوز» مع سجل تدقيق. تُفرَض '
            'صلاحيات المالك والكاشير في طبقة التطبيق عبر PermissionPolicy '
            'واحدة يستخدمها الموجّه وتستخدمها الواجهة أيضًا.',
        result:
            'دوران في تطبيق واحد مع سجل مخزون مدقَّق، ولوحة مالك حيّة، ودعم '
            'كامل لـ RTL. مختبر شبكة مخفي يحاكي انقطاع الاتصال وزمن '
            'الاستجابة والأعطال، وتغطي الاختبارات التدفق كله وتعمل دون واجهة '
            'في CI.',
        notes: [
          'مخطط الإيرادات: CustomPainter',
          'مربعات نقطة البيع تُعاد عبر select()',
          'سجل المخزون: استعلام حي على قاعدة البيانات',
          'الأدوار: PermissionPolicy واحدة',
          'الكاشير: المنتجات للعرض فقط',
        ],
        captions: [
          'تسجيل الدخول كمالك أو كاشير',
          'سجل المخزون: كل عملية بيع وتوريد وتعديل',
          'المنتجات مع البحث وفلاتر المخزون',
          'نظرة المالك: إيرادات اليوم والأكثر مبيعًا',
          'البيع: شبكة المنتجات والسلة',
        ],
      ),
      'recall': (
        type: 'تطبيق تعليمي',
        outcome:
            'بطاقات تُقيَّم بالسحب وتُجدوَل بخوارزمية SM-2 مختبَرة بالكامل.',
        role: 'مطوّر منفرد',
        tagline:
            'تطبيق بطاقات تعليمية بالتكرار المتباعد، بتقييم بالسحب يحاكي '
            'الفيزياء، وإحصاءات مرسومة يدويًا ودعم كامل للعربية.',
        problem:
            'تطبيقات البطاقات تنجح أو تفشل بأمرين: جدولة يمكنك الوثوق بها، '
            'وحلقة مذاكرة ممتعة تعود إليها كل يوم.',
        solution:
            'جدولة SM-2 وحدة Dart نقية خلف واجهة Clock، باختبارات جدولية '
            'تتحقق من الفواصل بدقة. جلسات المذاكرة Notifier بحالات مغلقة '
            '(sealed). تنقلب البطاقات بثلاثية الأبعاد وتُقيَّم بالسحب، '
            'بمحاكاة SpringSimulation تنقل سرعة الإفلات إلى الرمية. تُحسب '
            'الإحصاءات من سجلات المراجعة وتُرسم بـ CustomPainter.',
        result:
            'خريطة حرارية سنوية ومنحنى احتفاظ وتوزيع للنضج دون أي حزمة '
            'رسوم، واستيراد CSV/TSV وتصدير JSON، واختصارات لوحة المفاتيح '
            'على الشاشات الكبيرة، ودعم تقليل الحركة، وRTL كامل باتجاهين '
            'لكل بطاقة.',
        notes: [
          'شاشة البداية: CustomPainter واحد',
          'الخريطة الحرارية تُعاد رسمها عند بيانات جديدة فقط',
          'العربية: RTL كامل',
          'الجلسة: Notifier بحالات مغلقة',
          'السحب: SpringSimulation',
        ],
        captions: [
          'شاشة بداية متحركة برسّام CustomPainter واحد',
          'المجموعات: ثلاث مجموعات تجريبية جاهزة',
          'تفاصيل المجموعة: البطاقات والمستحق منها',
          'المذاكرة: انقر للقلب واسحب للتقييم',
          'التقدّم: السلسلة والنضج والخريطة الحرارية',
        ],
      ),
      'attend': (
        type: 'متابعة الحضور',
        outcome: 'تسجيل حضور لا يُحتسب إلا ضمن 30 مترًا من القاعة.',
        role: 'مطوّر Flutter',
        tagline:
            'متتبّع حضور يتحقق بنظام GPS، يساعد المعلّمين وموظفي الكلية على '
            'متابعة الحضور واكتشاف الطلاب المعرّضين للخطر مبكرًا.',
        problem:
            'الحضور الجامعي يجب أن يثبت أن الطالب كان في القاعة فعلًا، '
            'ويحتاج المعلمون إلى معرفة من هو معرّض للرسوب قبل صدور الدرجات '
            'النهائية.',
        solution:
            'يسجّل الطلاب حضورهم من هواتفهم ويقارن التطبيق موقعهم بموقع '
            'القاعة: ضمن 30 مترًا، تُوسَّع بدقة القراءة المُبلَّغ عنها (حتى '
            '20 مترًا)، مع قراءة ثانية عالية الدقة قبل الرفض. يدير المعلمون '
            'المواد والجداول والطلاب والدرجات، وقواعد أمان Firestore تفرض '
            'الوصول حسب الدور.',
        result:
            'دوران في تطبيق واحد، وتصدير الدرجات إلى PDF وCSV، وتوقعات '
            'مخاطر لكل طالب مبنية على قواعد شفافة، فيرى المعلّم سبب تعليم '
            'الطالب.',
        notes: [],
        captions: [
          'تسجيل الدخول مع خيار «تذكّرني»',
          'توقعات المخاطر مع الفلاتر',
          'الحصص حسب اليوم',
          'لوحة المعلّم',
        ],
      ),
    };

/// A study without an entry above stays in English. Titles are project names.
final caseStudies = [
  for (final e in en.caseStudies)
    if (_studies[e.slug] case final ar?)
      CaseStudy(
        slug: e.slug,
        title: e.title,
        type: ar.type,
        tagline: ar.tagline,
        outcome: ar.outcome,
        problem: ar.problem,
        solution: ar.solution,
        result: ar.result,
        techStack: e.techStack,
        role: ar.role,
        year: e.year,
        links: e.links,
        media: e.media == null
            ? null
            : ProjectMedia(
                prefix: e.media!.prefix,
                captions: ar.captions,
                notes: [
                  for (final (i, n) in e.media!.notes.indexed)
                    InspectNote(n.seconds, ar.notes[i]),
                ],
              ),
        gallery: e.gallery,
        imagePath: e.imagePath,
        featured: e.featured,
      )
    else
      e,
];

const serviceOfferings = [
  ServiceOffering(
    title: 'تطوير تطبيقات Flutter',
    description:
        'تطبيقات مخصّصة، من الأدوات البسيطة إلى الأنظمة متعددة الأدوار '
        'والغنية بالبيانات.',
    deliverables: [
      'تطبيق جاهز للإنتاج',
      'الكود المصدري',
      'النشر على Google Play',
    ],
    icon: Icons.phone_android,
  ),
  ServiceOffering(
    title: 'إكمال تطبيق قائم',
    description:
        'أستلم مشاريع Flutter غير المكتملة، أفهم الكود وأوصلها إلى النشر.',
    deliverables: ['ميزات مكتملة', 'ربط الـ API', 'تجهيز الإصدار'],
    icon: Icons.build_circle_outlined,
  ),
  ServiceOffering(
    title: 'تنفيذ الواجهات',
    description:
        'واجهات Flutter دقيقة ومتجاوبة من تصاميمك، مع دعم العربية والاتجاه '
        'من اليمين إلى اليسار.',
    deliverables: [
      'ودجات قابلة لإعادة الاستخدام',
      'تخطيطات متجاوبة',
      'دعم RTL',
    ],
    icon: Icons.design_services,
  ),
];

const processSteps = [
  ProcessStep(
    title: 'الاستكشاف',
    description: 'نحدّد المشكلة والمستخدمين ومعنى «الإنجاز» قبل كتابة أي كود.',
    icon: Icons.travel_explore,
  ),
  ProcessStep(
    title: 'التصميم',
    description:
        'نُعدّ نماذج للمسارات والشاشات ونتفق عليها، فلا مفاجآت أثناء البناء.',
    icon: Icons.design_services_outlined,
  ),
  ProcessStep(
    title: 'البناء',
    description: 'تسليم تدريجي مع نسخة عاملة تجرّبها كل أسبوع، مع الاختبارات.',
    icon: Icons.construction,
  ),
  ProcessStep(
    title: 'الإطلاق',
    description: 'نشر على المتجر أو الويب، مع المراقبة وتسليم نظيف للكود.',
    icon: Icons.rocket_launch_outlined,
  ),
];

const proofStats = [
  ProofStat(label: 'سنوات من البناء بـ Flutter', value: '6+'),
  ProofStat(label: 'تقييمات خمس نجوم على Fiverr', value: '9'),
  ProofStat(label: 'تطبيقات منشورة على Google Play', value: '5'),
];

const engagementModels = [
  EngagementModel(
    title: 'نطاق ثابت',
    description: 'مجموعة متفق عليها من الشاشات والميزات، تُسلَّم بسعر ثابت.',
    bestFor: 'النماذج الأولية (MVP) والميزات المحددة بوضوح',
    icon: Icons.inventory_2_outlined,
  ),
  EngagementModel(
    title: 'بالساعة',
    description:
        'وقت مرن للإصلاحات والمراجعات أو للعمل الذي لم تتضح ملامحه بعد.',
    bestFor: 'التدقيق، إصلاح الأخطاء، المهام القصيرة',
    icon: Icons.schedule,
  ),
  EngagementModel(
    title: 'تعاقد شهري',
    description: 'حصة محجوزة من الوقت كل شهر لتطوير المنتج باستمرار.',
    bestFor: 'الفرق التي تُصدر تحديثات باستمرار',
    icon: Icons.autorenew,
  ),
];

const faqs = [
  FaqItem(
    question: 'ما المنصات التي تستطيع التسليم عليها؟',
    answer:
        'تركيزي على أندرويد، مع النشر على Google Play. يعمل Flutter للويب من '
        'الكود نفسه، أما خبرتي في iOS فمحدودة.',
  ),
  FaqItem(
    question: 'هل تستطيع العمل على تطبيقي الحالي؟',
    answer:
        'نعم، وهذا جزء كبير من عملي. أفهم الكود، أكمل ما ينقصه وأجهّزه '
        'للنشر، دون إعادة كتابته إلا إذا كانت أقل تكلفة بوضوح.',
  ),
  FaqItem(
    question: 'ماذا يحدث بعد التسليم؟',
    answer:
        'أواصل دعم التطبيق بعد التسليم. سرعة التسليم ووضوح التواصل وهذا '
        'الدعم المستمر هي أكثر ما تذكره تقييمات العملاء.',
  ),
  FaqItem(
    question: 'من يملك الكود؟',
    answer: 'أنت. المستودع والأصول والحسابات ملكك من اليوم الأول.',
  ),
  FaqItem(
    question: 'كيف نبقى على تواصل أثناء المشروع؟',
    answer: 'عرض أسبوعي لنسخة عاملة، مع قناة مشتركة للأسئلة بين العروض.',
  ),
];

// Same order as the English lists: the form keeps the picked index.
const contactProjectTypes = [
  'تطبيق جديد',
  'إكمال تطبيق قائم',
  'تنفيذ واجهات',
  'شيء آخر',
];

const contactBudgets = [
  'لست متأكدًا بعد',
  'صغير (بضعة أسابيع)',
  'متوسط (1–3 أشهر)',
  'كبير (أكثر من 3 أشهر)',
];

const siteLayers = [
  (
    'features/',
    'مجلد لكل صفحة: الأعمال، المختبر، نبذة، تواصل. كل مجلد يملك ودجاته '
        'وحالته الخاصة بالصفحة.',
  ),
  (
    'shared/',
    'التخطيط والودجات التي تستخدمها كل الصفحات: الهيكل، إطار الصفحة، إطار '
        'العيّنة، Inspectable وعلامات ورقة المواصفات.',
  ),
  (
    'core/',
    'رموز التصميم، التوجيه، حالة التطبيق وكل النصوص كنماذج ثابتة، تقرؤها '
        'الودجات عبر مزوّدات Riverpod فقط.',
  ),
];

const siteNotes = [
  (
    'وضع الفحص حقيقي',
    'يرسم الفحص الحدود والحشوات والمقاسات من شجرة العرض الحية، حتى في نسخ '
        'الإصدار. وعند إيقافه لا يكلّف سوى كائن عرض واحد دون أي طبقة.',
  ),
  (
    'الكود الذي تراه هو الكود الذي يعمل',
    'يُقرأ كود العيّنات من ملفات المصدر المضمّنة بين علامات '
        '\u2066"#region snippet"\u2069، ويفشل اختبار إذا اختفت علامة.',
  ),
  (
    'هيكل واحد وصفحات كثيرة',
    'GoRouter مع ShellRoute يبقي شريط التنقل حيًا بين الصفحات، مع روابط '
        'بمسارات واضحة، وتحويلات للروابط القديمة، وصفحة 404 داخل الهيكل.',
  ),
  (
    'الخطوط قبل أول إطار',
    'الخطوط مضمّنة في التطبيق ولا تُجلب من الشبكة. تبقى شاشة البداية حتى '
        'تُحمَّل، فلا يتحرك شيء عند الوصول.',
  ),
];
